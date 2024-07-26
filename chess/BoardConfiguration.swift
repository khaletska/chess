//
//  BoardConfiguration.swift
//  Chess
//
//  Created by Andrius Shiaulis on 13.07.2024.
//

import Foundation

enum BoardConfiguration {

    // MARK: - Cases -

    case minimal
    case full

    // MARK: - Public Methods -

    func generateBoard() -> [[ChessPiece?]] {
        switch self {
        case .minimal: return generateMinimalBoard()
        case .full: return generateFullBoard()
        }
    }

    // MARK: - Private Methods -

    private func generateMinimalBoard() -> [[ChessPiece?]] {
        var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)
        board[2][4] = ChessPiece(kind: .pawn, color: .white)
        return board
    }

    private func generateFullBoard() -> [[ChessPiece?]] {
        var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

        // Place pawns
        for col in 0...7 {
            board[1][col] = ChessPiece(kind: .pawn, color: .black)
            board[6][col] = ChessPiece(kind: .pawn, color: .white)
        }

        let pieceOrder: [ChessPiece.Kind] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]

        // Place other pieces
        for col in 0...7 {
            board[0][col] = ChessPiece(kind: pieceOrder[col], color: .black)
            board[7][col] = ChessPiece(kind: pieceOrder[col], color: .white)
        }

        return board
    }


}
