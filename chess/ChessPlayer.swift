//
//  ChessPlayer.swift
//  Chess
//
//  Created by Yeliena Khaletska on 20.07.2024.
//

import Foundation

enum ChessColor: String {
    case black
    case white
}

final class ChessPlayer {

    let color: ChessColor
    var isMyTurn: Bool

    init(color: ChessColor, isMyTurn: Bool) {
        self.color = color
        self.isMyTurn = isMyTurn
    }

}
