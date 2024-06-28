//
//  BoardModel.swift
//  chess
//
//  Created by Yeliena Khaletska on 28.06.2024.
//

import Foundation

final class BoardModel {

    var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    func createNewGameBoard() {
        for col in 0...7 {
            self.board[1][col] = ChessPiece(pieceType: .pawn, color: .black)
            self.board[6][col] = ChessPiece(pieceType: .pawn, color: .white)
        }

        // rooks
        self.board[0][0] = ChessPiece(pieceType: .rook, color: .black)
        self.board[0][7] = ChessPiece(pieceType: .rook, color: .black)
        self.board[7][0] = ChessPiece(pieceType: .rook, color: .white)
        self.board[7][7] = ChessPiece(pieceType: .rook, color: .white)

        // knights
        self.board[0][1] = ChessPiece(pieceType: .knight, color: .black)
        self.board[0][6] = ChessPiece(pieceType: .knight, color: .black)
        self.board[7][1] = ChessPiece(pieceType: .knight, color: .white)
        self.board[7][6] = ChessPiece(pieceType: .knight, color: .white)

        // bishops
        self.board[0][2] = ChessPiece(pieceType: .bishop, color: .black)
        self.board[0][5] = ChessPiece(pieceType: .bishop, color: .black)
        self.board[7][2] = ChessPiece(pieceType: .bishop, color: .white)
        self.board[7][5] = ChessPiece(pieceType: .bishop, color: .white)

        // queens
        self.board[0][3] = ChessPiece(pieceType: .queen, color: .black)
        self.board[7][3] = ChessPiece(pieceType: .queen, color: .white)

        // kings
        self.board[0][4] = ChessPiece(pieceType: .king, color: .black)
        self.board[7][4] = ChessPiece(pieceType: .king, color: .white)
    }

}
