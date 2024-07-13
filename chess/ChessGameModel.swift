//
//  ChessGameModel.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation

struct ChessGameModel {

    enum GameMode {
        case full
        case pawn
    }

    private(set) var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    mutating func createNewGameBoard(configuration: BoardConfiguration) {
        self.board = configuration.generateBoard()
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
