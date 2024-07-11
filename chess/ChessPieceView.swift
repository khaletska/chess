//
//  ChessPieceView.swift
//  chess
//
//  Created by Yeliena Khaletska on 11.07.2024.
//

import SwiftUI

struct ChessPieceView: View {

    private let piece: ChessPiece
    private let imageSize: CGFloat

    init(piece: ChessPiece, imageSize: CGFloat) {
        self.piece = piece
        self.imageSize = imageSize
    }

    var body: some View {
        Image(piece.color.rawValue + piece.kind.rawValue)
            .resizable()
            .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
    }

}

#Preview("Pieces Preview", traits: .sizeThatFitsLayout) {
    Group {
        ChessPieceView(piece: .init(kind: .queen, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .king, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .rook, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .knight, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .bishop, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .pawn, color: .white), imageSize: 45)
        ChessPieceView(piece: .init(kind: .queen, color: .black), imageSize: 45)
        ChessPieceView(piece: .init(kind: .king, color: .black), imageSize: 45)
        ChessPieceView(piece: .init(kind: .rook, color: .black), imageSize: 45)
        ChessPieceView(piece: .init(kind: .knight, color: .black), imageSize: 45)
        ChessPieceView(piece: .init(kind: .bishop, color: .black), imageSize: 45)
        ChessPieceView(piece: .init(kind: .pawn, color: .black), imageSize: 45)
    }
}
