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

    var messages: AnyPublisher<String, Never>! {
        self.subject.eraseToAnyPublisher()
    }

    private var webSocket: URLSessionWebSocketTask?
    private let subject: PassthroughSubject<String, Never> = .init()
    private var haveGameID = false
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "WebSocketManager")

    override init() {
        super.init()
        setupSocket()
    }

    private func setupSocket() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let roomsURL = URL(string: "ws://localhost:8080/rooms")
        self.webSocket = session.webSocketTask(with: roomsURL!)
        self.webSocket?.resume()
    }

    private func setupSocketForGame(with id: String) {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let gameURL = URL(string: "ws://localhost:8080/rooms/\(id)")
        self.webSocket = session.webSocketTask(with: gameURL!)
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
        self.webSocket?.cancel(with: .goingAway, reason: "Connection ended".data(using: .utf8))
    }

    private func send() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.send()
            self.webSocket?.send(.string("e2e4"), completionHandler: { error in
                if let error = error {
                    self.logger.error("Send error: \(error)")
                }
            })
        }
    }

    private func receive() {
        if !haveGameID {
            receiveGameID()
        } else {
            receiveMoves()
        }
    }

    private func receiveGameID() {
        self.webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.logger.log("Received data: \(data)")
                case .string(let message):
                    self?.logger.log("Received string: \(message)")
                    self?.close()
                    self?.haveGameID = true
                    self?.setupSocketForGame(with: message)
                default:
                    break
                }
            case .failure(let error):
                self?.logger.error("Receive error: \(error)")
            }
        })
    }

    private func receiveMoves() {
        self.webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.logger.log("Received data: \(data)")
                case .string(let message):
                    self?.logger.log("Received string: \(message)")
                    self?.subject.send(message)
                default:
                    break
                }
            case .failure(let error):
                self?.logger.error("Receive error: \(error)")
            }

            self?.receiveMoves()
        })
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.logger.log("Did open socket.")
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.logger.log("Did close connection.")
    }

}
