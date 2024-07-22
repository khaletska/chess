//
//  ChessGameViewModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 12.07.2024.
//

import SwiftUI
import Foundation
import Combine
import OSLog

final class ChessGameViewModel: ObservableObject {

    @Published var selectedPieceAddress: Coordinate?
    @Published var error: Error?
    var disposables: Set<AnyCancellable> = []

    @Published private var model = ChessGameModel()
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "ViewModel")

    func gameAppeared() {
        makeNewGame()
    }

    func cellTapped(at cellAddress: Coordinate) {
        do {
            switch (self.model.board[cellAddress.row][cellAddress.col] == nil, self.selectedPieceAddress == nil) {
            case (true, false):
                self.logger.log("empty cell tapped and we have selected piece")
                try self.model.intentionToMovePiece(from: self.selectedPieceAddress!, to: cellAddress)
                self.selectedPieceAddress = nil
            case (false, true):
                self.logger.log("non-empty cell tapped and we don't have selected piece")
                self.selectedPieceAddress = cellAddress
            case (false, false):
                self.logger.log("non-empty cell tapped and we have selected piece")
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
                self.logger.log("empty cell tapped and we don't have selected piece")
                return
            }
        }
        catch {
            self.logger.error("Error: \(error.localizedDescription)")
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
