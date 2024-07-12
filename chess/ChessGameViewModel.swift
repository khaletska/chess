//
//  ChessGameViewModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 12.07.2024.
//

import SwiftUI

final class ChessGameViewModel: ObservableObject {

    @Published var selectedPieceAddress: (row: Int, col: Int)?
    @Published private var model = ChessGameModel()

    func gameAppeared() {
        self.model.createNewGameBoard()
    }

    func selectPieceAt(row: Int, col: Int) {
        guard let selectedPieceAddress = self.selectedPieceAddress else {
            self.selectedPieceAddress = (row, col)
            return
        }

        if selectedPieceAddress == (row, col) {
            self.selectedPieceAddress = nil
        }
        else {
            self.selectedPieceAddress = (row, col)
        }
    }

    func getPieceForCell(row: Int, col: Int) -> ChessPiece? {
        self.model.board[row][col]
    }

    func getBorderColorForSquare(row: Int, col: Int) -> Color {
        guard let selectedPieceAddress = self.selectedPieceAddress else {
            return .clear
        }

        return selectedPieceAddress == (row, col) ? .orange : .clear
    }

    func getColorForSquare(row: Int, col: Int) -> Color {
        (row + col).isMultiple(of: 2) ? .white : .black
    }

}
