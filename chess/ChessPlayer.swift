//
//  ChessPlayer.swift
//  Chess
//
//  Created by Yeliena Khaletska on 20.07.2024.
//

import Foundation


final class ChessPlayer {

    let color: ChessPiece.Color
    var isMyTurn: Bool

    init(color: ChessPiece.Color, isMyTurn: Bool) {
        self.color = color
        self.isMyTurn = isMyTurn
    }

}
