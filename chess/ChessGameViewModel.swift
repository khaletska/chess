//
//  ChessGameViewModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 12.07.2024.
//

import SwiftUI
import Foundation
import Combine

final class ChessGameViewModel: ObservableObject {

    @Published var selectedPieceAddress: Coordinate?
    @Published private var model = ChessGameModel()
    @Published var error: Error?
    var disposables: Set<AnyCancellable> = []

    func gameAppeared() {
        makeNewGame()
    }

    func cellTapped(at cellAddress: Coordinate) {
        do {
            switch (self.model.board[cellAddress.row][cellAddress.col] == nil, self.selectedPieceAddress == nil) {
            case (true, false):
                print("empty cell tapped and we have selected piece")
                try self.model.intentionToMovePiece(from: self.selectedPieceAddress!, to: cellAddress)
                self.selectedPieceAddress = nil
            case (false, true):
                print("non-empty cell tapped and we don't have selected piece")
                self.selectedPieceAddress = cellAddress
            case (false, false):
                print("non-empty cell tapped and we have selected piece")
                // if cell tapped has piece of different color, eat it
                if self.getPiece(for: self.selectedPieceAddress!)?.color != self.getPiece(for: cellAddress)?.color {
                    try self.model.intentionToMovePiece(from: self.selectedPieceAddress!, to: cellAddress)
                    self.selectedPieceAddress = nil
                }
                // else just select different
                else {
                    self.selectedPieceAddress = cellAddress
                }
            case (true, true):
                print("empty cell tapped and we don't have selected piece")
                return
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
            self.error = error
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

    private func makeNewGame() {
        self.model.createNewGameBoard(configuration: .full)

        self.model.$board
            .receive(on: DispatchQueue.main)
            .sink { _ in
            self.objectWillChange.send()
        }
        .store(in: &disposables)
    }

}
