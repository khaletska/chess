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
    @Published var gameStatus: String?
    var disposables: Set<AnyCancellable> = []

    @Published private(set) var whoseTurn: ChessPiece.Color?
    @Published private var model = ChessGameModel()
    private let logger = Logger(subsystem: "com.khaletska.chess", category: "ViewModel")

    func gameAppeared() {
        makeNewGame()
    }

    func cellTapped(at cellAddress: Coordinate) {
        guard self.model.player?.color == self.whoseTurn else {
            self.logger.log("Cell tapped: it's not my turn")
            return
        }

        do {
            switch (self.model.board[cellAddress.row][cellAddress.col] == nil, self.selectedPieceAddress == nil) {
            case (true, false):
                self.logger.log("Cell tapped: empty cell tapped and we have selected piece")
                try self.model.intentionToMovePiece(from: self.selectedPieceAddress!, to: cellAddress)
                self.selectedPieceAddress = nil
            case (false, true):
                self.logger.log("Cell tapped: non-empty cell tapped and we don't have selected piece")
                let piece = self.getPiece(for: cellAddress)!
                if piece.color == self.getPlayerColor() {
                    self.selectedPieceAddress = cellAddress
                }
                else {
                    return
                }
            case (false, false):
                self.logger.log("Cell tapped: non-empty cell tapped and we have selected piece")
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
                self.logger.log("Cell tapped: empty cell tapped and we don't have selected piece")
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
        if gameStatus?.starts(with: "Checkmate") == true {
            if let piece = self.getPiece(for: cellAddress), piece.kind == .king, piece.color != self.whoseTurn {
                return .red
            }
        }

        let selectedPieceAddress = self.selectedPieceAddress
        return selectedPieceAddress == cellAddress ? .orange : .clear
    }

    func getCellColor(for cellAddress: Coordinate) -> Color {
        (cellAddress.row + cellAddress.col).isMultiple(of: 2) ? .white : .black
    }

    func getPlayerColor() -> ChessPiece.Color {
        self.model.player?.color ?? .white
    }

    private func makeNewGame() {
        self.model.setup()

        self.model.$board
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &disposables)

        self.model.$gameStatus
            .receive(on: DispatchQueue.main)
            .sink { status in
                self.gameStatus = status
            }
            .store(in: &disposables)

        self.model.$whoseTurn
            .receive(on: DispatchQueue.main)
            .sink { whoseTurn in
                self.whoseTurn = whoseTurn
            }
            .store(in: &disposables)
    }

}
