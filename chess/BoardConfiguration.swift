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
        for col in 0...7 {
            board[1][col] = ChessPiece(kind: .pawn, color: .black)
            board[6][col] = ChessPiece(kind: .pawn, color: .white)
        }

        // rooks
        board[0][0] = ChessPiece(kind: .rook, color: .black)
        board[0][7] = ChessPiece(kind: .rook, color: .black)
        board[7][0] = ChessPiece(kind: .rook, color: .white)
        board[7][7] = ChessPiece(kind: .rook, color: .white)

        // knights
        board[0][1] = ChessPiece(kind: .knight, color: .black)
        board[0][6] = ChessPiece(kind: .knight, color: .black)
        board[7][1] = ChessPiece(kind: .knight, color: .white)
        board[7][6] = ChessPiece(kind: .knight, color: .white)

        // bishops
        board[0][2] = ChessPiece(kind: .bishop, color: .black)
        board[0][5] = ChessPiece(kind: .bishop, color: .black)
        board[7][2] = ChessPiece(kind: .bishop, color: .white)
        board[7][5] = ChessPiece(kind: .bishop, color: .white)

        // queens
        board[0][3] = ChessPiece(kind: .queen, color: .black)
        board[7][3] = ChessPiece(kind: .queen, color: .white)

        // kings
        board[0][4] = ChessPiece(kind: .king, color: .black)
        board[7][4] = ChessPiece(kind: .king, color: .white)

        return board
    }

}
