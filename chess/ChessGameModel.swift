//
//  ChessGameModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation
import Combine
import OSLog

final class ChessGameModel: ObservableObject {

    enum GameMode {
        case full
        case pawn
    }

    private var webSocketManager: WebSocketManager?
    private(set) var player: ChessPlayer?
    @Published private(set) var gameStatus: String = ""
    @Published private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)
    private var previousBoardState: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    private let logger = Logger(subsystem: "com.khaletska.chess", category: "GameModel")
    private var cancellable: AnyCancellable?

    func setup() {
        self.webSocketManager = WebSocketManager()
        self.cancellable = self.webSocketManager?.status
            .sink { [weak self] (status: WebSocketManager.Status) in
                guard let self else { return }
                handleStatusChange(status)
                self.logger.log("Received status from websocket: \(status)")
            }
    }

    func intentionToMovePiece(from source: Coordinate, to destination: Coordinate) throws {
        guard let pieceToMove = self.board[source.row][source.col] else {
            throw ChessGameModelError.missingPiece
        }

        let pieceToEat = self.board[destination.row][destination.col]
        if let pieceToEat, pieceToEat.color == pieceToMove.color {
            throw ChessGameModelError.invalidMove
        }

        // remember board state before move
        self.previousBoardState = board
        if isPawnPromotionMove(piece: pieceToMove, to: destination) {
            // replace an existing pawn with queen and move afterwards
            try promotePawn(from: source, to: destination)

            if let pieceToEat {
                self.logger.log("Pawn \(pieceToMove) ate \(pieceToEat) from \(source) to \(destination) and promoted to \(ChessPiece(kind: .queen, color: pieceToMove.color))")
            }
            else {
                self.logger.log("Pawn \(pieceToMove) moved from \(source) to \(destination) and promoted to \(ChessPiece(kind: .queen, color: pieceToMove.color))")
            }
        }
        else {
            if let pieceToEat {
                self.logger.log("Piece \(pieceToMove) ate \(pieceToEat) from \(source) to \(destination)")
            }
            else {
                self.logger.log("Piece \(pieceToMove) moved from \(source) to \(destination)")
            }
        }
        let isTakeMove = pieceToEat != nil
        let notation = convertCoordinatesToNotation(from: source, to: destination, isTake: isTakeMove)
        self.webSocketManager?.send(notation)
        movePiece(from: source, to: destination)
        self.player?.isMyTurn.toggle()
        updateTurnStatus()
    }

    // MARK: - Actions -

    private func movePiece(from source: Coordinate, to destination: Coordinate) {
        self.board[destination.row][destination.col] = self.board[source.row][source.col]
        self.board[source.row][source.col] = nil
    }

    private func promotePawn(from source: Coordinate, to destination: Coordinate) throws {
        guard let piece = self.board[source.row][source.col] else {
            throw ChessGameModelError.missingPiece
        }

        guard case .pawn = piece.kind else {
            throw ChessGameModelError.invalidPromotion
        }

        guard (piece.color == .white && destination.row == 0) || (piece.color == .black && destination.row == 7) else {
            throw ChessGameModelError.invalidPromotion
        }

        self.board[source.row][source.col] = ChessPiece(kind: .queen, color: piece.color)
    }

    // MARK: - Conditions -

    private func isPawnPromotionMove(piece: ChessPiece, to: Coordinate) -> Bool {
        guard piece.kind == .pawn else {
            return false
        }

        guard (piece.color == .white && to.row == 0) || (piece.color == .black && to.row == 7) else {
            return false
        }

        return true
    }

}

extension ChessGameModel {

    private func handleStatusChange(_ status: WebSocketManager.Status) {
        switch status {
        case .message(let message):
            handle(message)
        case .connectingToPool:
            self.gameStatus = "Connecting…"
        case .connectingToGame:
            self.gameStatus = "Connecting…"
        case .waitingForPlayers:
            self.gameStatus = "Waiting for opponent to join…"
        case .makingRoom:
            self.gameStatus = "Starting a game…"
        case .noConnection:
            self.gameStatus = "Connected"
        case .closed:
            if self.player != nil {
                self.gameStatus = "Connection lost"
            }
        }
    }

    private func handle(_ message: String) {
        guard isValidLAN(message) || isValidColor(message) else {
            self.logger.error("Received invalid message in Model: \(message)")
            self.gameStatus = "Invalid move"
            self.board = previousBoardState
            self.player?.isMyTurn.toggle()
            return
        }

        if self.player == nil, let color = ChessPiece.Color(rawValue: message) {
            let player = ChessPlayer(color: color, isMyTurn: color == .black ? false : true)
            self.board = BoardConfiguration.full.generateBoard()
            self.player = player
            updateTurnStatus()
            self.logger.log("Created new player with \(color.rawValue) color")
            return
        }
        self.logger.log("Received message in Model: \(message)")
        handleMove(message)
        self.player?.isMyTurn.toggle()
        updateTurnStatus()
    }

    private func updateTurnStatus() {
        if self.player?.isMyTurn == true {
            self.gameStatus = "Your turn to make a move…"
        } else {
            self.gameStatus = "Waiting for opponent to make a move…"
        }
    }

    private func handleMove(_ message: String) {
        let (source, destination) = convertNotationToCoordinates(message)
        movePiece(from: source, to: destination)
    }

}

extension ChessGameModel {

    private func convertCoordinatesToNotation(from source: Coordinate, to destination: Coordinate, isTake: Bool) -> String {
        guard let piece = self.board[source.row][source.col] else { return "" }
        return "\(piece.notation)\(source.description)\(isTake ? "x" : "")\(destination.description)"
    }

    private func convertNotationToCoordinates(_ notation: String) -> (Coordinate, Coordinate) {
        let parts = parseNotation(notation)

        let source = Coordinate(row: 8 - Int(String(parts[2]))!, col: Int(parts[1].first!.asciiValue!) - 97)
        let destination = Coordinate(row: 8 - Int(String(parts[5]))!, col: Int(parts[4].first!.asciiValue!) - 97)

        return (source, destination)
    }

    private func parseNotation(_ s: String) -> [String] {
//        Parsed components: piece, fromRow, fromCol, capture, toRow, toCol, promotes, castles
        let pgnRegex = try! NSRegularExpression(pattern: "^(?:([RNBQKP]?)([abcdefgh]?)(\\d?)(x?)([abcdefgh])(\\d)(=[QRBN])?|(O-O(?:-O)?))([+#!?]|e\\.p\\.)*$", options: [])
        let nsrange = NSRange(s.startIndex..<s.endIndex, in: s)
        guard let match = pgnRegex.firstMatch(in: s, options: [], range: nsrange) else {
            return []
        }

        var parts = [String]()
        for i in 1..<match.numberOfRanges {
            if let range = Range(match.range(at: i), in: s) {
                parts.append(String(s[range]))
            } else {
                parts.append("")
            }
        }

        while parts.count < 8 {
            parts.append("")
        }

        return parts
    }

    // Validate LAN
    private func isValidLAN(_ notation: String) -> Bool {
        let lanRegex = "^(?:([RNBQKP]?)([abcdefgh]?)(\\d?)(x?)([abcdefgh])(\\d)(=[QRBN])?|(O-O(?:-O)?))([+#!?]|e\\.p\\.)*$"
        let lanPredicate = NSPredicate(format: "SELF MATCHES %@", lanRegex)
        return lanPredicate.evaluate(with: notation)
    }

    // Validate Color
    private func isValidColor(_ message: String) -> Bool {
        let colorRegex = "^(white|black)$"
        let colorPredicate = NSPredicate(format: "SELF MATCHES %@", colorRegex)
        return colorPredicate.evaluate(with: message)
    }

}

struct Coordinate: Equatable, CustomStringConvertible {

    let row: Int
    let col: Int

    var description: String {
        let row = 8 - self.row
        let col = String(UnicodeScalar(97 + self.col)!)
        return "\(col)\(row)"
    }

}

enum ChessGameModelError: LocalizedError {
    case missingPiece
    case invalidPromotion
    case invalidMove

    var errorDescription: String? {
        switch self {
        case .missingPiece: return "There is no piece to move"
        case .invalidPromotion: return "Invalid promotion"
        case .invalidMove: return "Invalid move"
        }
    }
}
