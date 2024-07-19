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

    private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8) 
    
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "GameModel")

    func createNewGameBoard(configuration: BoardConfiguration) {
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
