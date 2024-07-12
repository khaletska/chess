//
//  ChessGameViewModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 12.07.2024.
//

import SwiftUI

final class ChessGameViewModel: ObservableObject {

    @Published var selectedPieceAddress: Coordinate?
    @Published private var model = ChessGameModel()

    func gameAppeared() {
        self.model.createNewGameBoard()
    }

    func cellTappedAt(row: Int, col: Int) {
        switch (self.model.board[row][col] == nil, self.selectedPieceAddress == nil) {
        case (true, false):
            print("empty cell tapped and we have selected piece")
            self.model.move(from: self.selectedPieceAddress!, to: .init(row: row, col: col))
            self.selectedPieceAddress = nil
        case (false, true):
            print("non-empty cell tapped and we don't have selected piece")
            self.selectedPieceAddress = .init(row: row, col: col)
        case (false, false):
            print("non-empty cell tapped and we have selected piece")
            self.selectedPieceAddress = .init(row: row, col: col)
        case (true, true):
            print("empty cell tapped and we don't have selected piece")
            return
        }
    }

    func getPieceForCell(row: Int, col: Int) -> ChessPiece? {
        self.model.board[row][col]
    }

    func getBorderColorForSquare(row: Int, col: Int) -> Color {
        guard let selectedPieceAddress = self.selectedPieceAddress else {
            return .clear
        }

        return selectedPieceAddress == .init(row: row, col: col) ? .orange : .clear
    }

    func getColorForSquare(row: Int, col: Int) -> Color {
        (row + col).isMultiple(of: 2) ? .white : .black
    }

}
