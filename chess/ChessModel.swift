//
//  ChessModel.swift
//  chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation

final class ChessModel: ObservableObject {

    @Published var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)
    @Published var selectedPieceAddress: (row: Int, col: Int)?

    func createNewGameBoard() {
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

    func selectPieceAt(row: Int, col: Int) {
        guard let selectedPieceAddress = self.selectedPieceAddress else {
            self.selectedPieceAddress = (row, col)
            return
        }

        if selectedPieceAddress == (row, col) {
            self.selectedPieceAddress = nil
        } else {
            self.selectedPieceAddress = (row, col)
        }
    }

}
