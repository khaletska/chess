//
//  WebSocketManager.swift
//  Chess
//
//  Created by Yeliena Khaletska on 18.07.2024.
//

import Foundation

final class WebSocketManager: NSObject, URLSessionWebSocketDelegate {

    var completion: ((String) -> Void)?
    private var webSocket: URLSessionWebSocketTask?
    private var haveGameID = false

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
                print("Ping error: \(error)")
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
                    print("Send error: \(error)")
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
                    print("Received data: \(data)")
                case .string(let message):
                    print("Received string: \(message)")
                    self?.close()
                    self?.haveGameID = true
                    self?.setupSocketForGame(with: message)
                default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }
        })
    }

    private func receiveMoves() {
        self.webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data)")
                case .string(let message):
                    print("Received string: \(message)")
                    self?.completion?(message)
                default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }

            self?.receiveMoves()
        })
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to socket.")
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection.")
    }

}
