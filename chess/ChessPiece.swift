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
        case white
        case black

        var shorthand: String {
            switch self {
            case .white:
                return "W"
            case .black:
                return "B"
            }
        }
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

    var notation: String {
        switch self.kind {
        case .pawn: return ""
        case .rook: return "R"
        case .knight: return "N"
        case .bishop: return "B"
        case .queen: return "Q"
        case .king: return "K"
        }
    }

}
