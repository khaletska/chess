//
//  Piece.swift
//  chess
//
//  Created by Yeliena Khaletska on 28.06.2024.
//

import Foundation

enum PieceType: String {
    case pawn = "P"
    case rook = "R"
    case knight = "N"
    case bishop = "B"
    case queen = "Q"
    case king = "K"
}

enum PieceColor: String {
    case white = "W"
    case black = "B"
}

struct ChessPiece {
    let type: PieceType
    let color: PieceColor
}

