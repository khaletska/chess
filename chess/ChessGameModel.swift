//
//  ChessGameModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation

struct ChessGameModel {

    private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    mutating func createNewGameBoard() {
        for col in 0...7 {
            self.board[1][col] = ChessPiece(kind: .pawn, color: .black)
            self.board[6][col] = ChessPiece(kind: .pawn, color: .white)
        }

        // rooks
        self.board[0][0] = ChessPiece(kind: .rook, color: .black)
        self.board[0][7] = ChessPiece(kind: .rook, color: .black)
        self.board[7][0] = ChessPiece(kind: .rook, color: .white)
        self.board[7][7] = ChessPiece(kind: .rook, color: .white)

        // knights
        self.board[0][1] = ChessPiece(kind: .knight, color: .black)
        self.board[0][6] = ChessPiece(kind: .knight, color: .black)
        self.board[7][1] = ChessPiece(kind: .knight, color: .white)
        self.board[7][6] = ChessPiece(kind: .knight, color: .white)

        // bishops
        self.board[0][2] = ChessPiece(kind: .bishop, color: .black)
        self.board[0][5] = ChessPiece(kind: .bishop, color: .black)
        self.board[7][2] = ChessPiece(kind: .bishop, color: .white)
        self.board[7][5] = ChessPiece(kind: .bishop, color: .white)

        // queens
        self.board[0][3] = ChessPiece(kind: .queen, color: .black)
        self.board[7][3] = ChessPiece(kind: .queen, color: .white)

        // kings
        self.board[0][4] = ChessPiece(kind: .king, color: .black)
        self.board[7][4] = ChessPiece(kind: .king, color: .white)
    }

    mutating func move(from: Coordinate, to: Coordinate) {
        let piece = self.board[from.row][from.col]
        self.board[to.row][to.col] = piece
        self.board[from.row][from.col] = nil
    }

}

struct Coordinate: Equatable {

    let row: Int
    let col: Int

}
