//
//  ChessPlayer.swift
//  Chess
//
//  Created by Yeliena Khaletska on 20.07.2024.
//

import Foundation


final class ChessPlayer {

    let color: ChessPiece.Color
    var isUnderCheckmate = false

    init(color: ChessPiece.Color) {
        self.color = color
    }

}
