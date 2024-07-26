//
//  WebSocketManager.swift
//  Chess
//
//  Created by Yeliena Khaletska on 18.07.2024.
//

import Foundation
import OSLog
import Combine

final class WebSocketManager: NSObject, URLSessionWebSocketDelegate {

    enum Status: CustomStringConvertible {
        var description: String {
            switch self {
            case .noConnection:
                return "No connection"
            case .connectingToPool:
                return "Connecting to pool…"
            case .waitingForPlayers:
                return "Waiting for players…"
            case .connectingToGame:
                return "Connecting to game…"
            case .makingRoom:
                return "Creating room…"
            case .message(let message):
                return "Message: \(message)"
            case .closed:
                return "Connection closed."
            }
        }

        case noConnection
        case connectingToPool
        case waitingForPlayers
        case connectingToGame
        case makingRoom
        case message(String)
        case closed
    }

    var status: AnyPublisher<Status, Never>! {
        self.subject.eraseToAnyPublisher()
    }

    private var webSocket: URLSessionWebSocketTask?
    private var haveGameID = false
    private let subject: CurrentValueSubject<Status, Never> = .init(.noConnection)
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "WebSocketManager")

    override init() {
        super.init()
        setupSocket()
    }

    private func setupSocket() {
        close()
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let roomsURL = URL(string: "ws://localhost:8080/rooms")
        self.webSocket = session.webSocketTask(with: roomsURL!)
        self.subject.send(.connectingToPool)
        self.webSocket?.resume()
    }

    private func setupSocketForGame(with id: String) {
        close()
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let gameURL = URL(string: "ws://localhost:8080/rooms/\(id)")
        self.webSocket = session.webSocketTask(with: gameURL!)
        self.subject.send(.connectingToGame)
        self.webSocket?.resume()
    }

    private func ping() {
        self.webSocket?.sendPing { error in
            if let error = error {
                self.logger.error("Ping error: \(error)")
            }
        }
    }

    private func close() {
        guard self.webSocket != nil else { return }
        self.webSocket?.cancel(with: .goingAway, reason: "Connection ended".data(using: .utf8))
    }

    func send(_ message: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.webSocket?.send(.string(message), completionHandler: { error in
                if let error = error {
                    self.logger.error("Send error: \(error)")
                }
            })
        }
    }

    private func receiveGameID() {
        self.webSocket?.receive(completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.logger.log("Received data: \(data)")
                case .string(let message):
                    self.subject.send(.makingRoom)
                    self.close()
                    self.haveGameID = true
                    self.setupSocketForGame(with: message)
                default:
                    break
                }
            case .failure(let error):
                self.logger.error("Receive error: \(error)")
            }
        })
    }

    private func receiveMoves() {
        self.webSocket?.receive(completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.logger.log("Received data: \(data)")
                case .string(let message):
                    self.subject.send(.message(message))
                default:
                    break
                }
            case .failure(let error):
                self.logger.error("Receive error: \(error)")
            }

            self.receiveMoves()
        })
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        if !self.haveGameID {
            self.subject.send(.waitingForPlayers)
            receiveGameID()
        }
        else {
            receiveMoves()
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.subject.send(.closed)
    }

}
