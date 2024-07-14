//
//  ChessGameModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation
import OSLog

struct ChessGameModel {

    enum GameMode {
        case full
        case pawn
    }

    private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "GameModel")

    mutating func createNewGameBoard(configuration: BoardConfiguration) {
        self.board = configuration.generateBoard()
    }

    mutating func pieceMoved(from source: Coordinate, to destination: Coordinate) throws {
        guard let piece = self.board[source.row][source.col] else {
            throw ChessGameModelError.missingPiece
        }

        if isPawnPromotionMove(piece: piece, to: destination) {
            try self.promotePawn(from: source, to: destination)
            self.logger.log("Pawn \(piece) moved from \(source) to \(destination) and promoted to \(ChessPiece(kind: .queen, color: piece.color))")
        }
        else {
            movePiece(from: source, to: destination)
            self.logger.log("Piece \(piece) moved from \(source) to \(destination)")
        }
    }

    // MARK: - Actions -

    private mutating func movePiece(from source: Coordinate, to destination: Coordinate) {
        self.board[destination.row][destination.col] = self.board[source.row][source.col]
        self.board[source.row][source.col] = nil
    }

    private mutating func promotePawn(from source: Coordinate, to destination: Coordinate) throws {
        guard let piece = self.board[source.row][source.col] else {
            throw ChessGameModelError.missingPiece
        }

        guard case .pawn = piece.kind else {
            throw ChessGameModelError.invalidPromotion
        }

        guard (piece.color == .white && destination.row == 0) || (piece.color == .black && destination.row == 7) else {
            throw ChessGameModelError.invalidPromotion
        }

        self.board[destination.row][destination.col] = ChessPiece(kind: .queen, color: piece.color)
        self.board[source.row][source.col] = nil
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

    var errorDescription: String? {
        switch self {
        case .missingPiece: return "There is no piece to move"
        case .invalidPromotion: return "Invalid promotion"
        }
    }
}
