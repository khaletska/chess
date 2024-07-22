//
//  ChessGameModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation
import OSLog

final class ChessGameModel: ObservableObject {

    enum GameMode {
        case full
        case pawn
    }
    
    private var networkClient: NetworkClient?
    @Published private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    private var player: ChessPlayer?
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "GameModel")

    func createNewGameBoard(configuration: BoardConfiguration) {
        self.networkClient = WebSocketManager()
        self.networkClient?.completion = { [weak self] message in
            self?.handle(message)
        }

        self.board = configuration.generateBoard()
    }

    func intentionToMovePiece(from source: Coordinate, to destination: Coordinate) throws {
        guard let pieceToMove = self.board[source.row][source.col] else {
            throw ChessGameModelError.missingPiece
        }

        let pieceToEat = self.board[destination.row][destination.col]
        if let pieceToEat, pieceToEat.color == pieceToMove.color {
            throw ChessGameModelError.invalidMove
        }

        if isPawnPromotionMove(piece: pieceToMove, to: destination) {
            // replace an existing pawn with queen and move afterwards
            try promotePawn(from: source, to: destination)
            movePiece(from: source, to: destination)
            if let pieceToEat {
                self.logger.log("Pawn \(pieceToMove) ate \(pieceToEat) from \(source) to \(destination) and promoted to \(ChessPiece(kind: .queen, color: pieceToMove.color))")
            }
            else {
                self.logger.log("Pawn \(pieceToMove) moved from \(source) to \(destination) and promoted to \(ChessPiece(kind: .queen, color: pieceToMove.color))")
            }
        }
        else {
            movePiece(from: source, to: destination)
            if let pieceToEat {
                self.logger.log("Piece \(pieceToMove) ate \(pieceToEat) from \(source) to \(destination)")
            }
            else {
                self.logger.log("Piece \(pieceToMove) moved from \(source) to \(destination)")
            }
        }
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

    private func handle(_ message: String) {
        if self.player == nil, let color = ChessColor.init(rawValue: message) {
            self.player = ChessPlayer(color: color)
            self.logger.log("Created new player with \(color.rawValue) color")
            return
        }

        self.logger.log("Received message in Model: \(message)")
        handleMove(message)
    }

    private func handleMove(_ message: String) {
        let parts = parseNotation(message)

        let source = Coordinate(row: 8 - Int(String(parts[2]))!, col: Int(parts[1].first!.asciiValue!) - 97)
        let destination = Coordinate(row: 8 - Int(String(parts[5]))!, col: Int(parts[4].first!.asciiValue!) - 97)
        movePiece(from: source, to: destination)
    }

    private func parseNotation(_ s: String) -> [String] {
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
