//
//  Piece.swift
//  chess
//
//  Created by Yeliena Khaletska on 28.06.2024.
//

import Foundation

struct ChessPiece {

    enum Kind: String {
        case pawn = "P"
        case rook = "R"
        case knight = "N"
        case bishop = "B"
        case queen = "Q"
        case king = "K"
    }

    enum Color: String {
        case white = "W"
        case black = "B"
    }

    let kind: Kind
    let color: Color

}
