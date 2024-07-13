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
        self.model.createNewGameBoard(configuration: .full)
    }

    func cellTapped(at cellAddress: Coordinate) {
        switch (self.model.board[cellAddress.row][cellAddress.col] == nil, self.selectedPieceAddress == nil) {
        case (true, false):
            print("empty cell tapped and we have selected piece")
            self.model.move(from: self.selectedPieceAddress!, to: cellAddress)
            self.selectedPieceAddress = nil
        case (false, true):
            print("non-empty cell tapped and we don't have selected piece")
            self.selectedPieceAddress = cellAddress
        case (false, false):
            print("non-empty cell tapped and we have selected piece")
            self.selectedPieceAddress = cellAddress
        case (true, true):
            print("empty cell tapped and we don't have selected piece")
            return
        }
    }

    func getPiece(for cellAddress: Coordinate) -> ChessPiece? {
        self.model.board[cellAddress.row][cellAddress.col]
    }

    func getBorderColor(for cellAddress: Coordinate) -> Color {
        guard let selectedPieceAddress = self.selectedPieceAddress else {
            return .clear
        }

        return selectedPieceAddress == cellAddress ? .orange : .clear
    }

    func getCellColor(for cellAddress: Coordinate) -> Color {
        (cellAddress.row + cellAddress.col).isMultiple(of: 2) ? .white : .black
    }

}
