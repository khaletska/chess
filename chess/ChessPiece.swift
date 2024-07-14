//
//  ChessPiece.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import Foundation

struct ChessPiece: Equatable, CustomStringConvertible {

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

    var description: String {
        switch self.kind {
        case .pawn:
            return self.color == .white ? "♙" : "♟"
        case .rook:
            return self.color == .white ? "♖" : "♜"
        case .knight:
            return self.color == .white ? "♘" : "♞"
        case .bishop:
            return self.color == .white ? "♗" : "♝"
        case .queen:
            return self.color == .white ? "♕" : "♛"
        case .king:
            return self.color == .white ? "♔" : "♚"
        }
    }

}
