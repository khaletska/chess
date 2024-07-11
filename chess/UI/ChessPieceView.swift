//
//  ChessPieceView.swift
//  Chess
//
//  Created by Andrius Shiaulis on 11.07.2024.
//

import SwiftUI

struct ChessPieceView: View {

    fileprivate static let defaultSize: CGFloat = 50

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

#Preview(traits: .fixedLayout(width: 400, height: 200)) {
    VStack {
        HStack {
            ChessPieceView(piece: ChessPiece(kind: .king, color: .black), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .queen, color: .black), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .bishop, color: .black), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .knight, color: .black), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .rook, color: .black), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .pawn, color: .black), imageSize: ChessPieceView.defaultSize)
        }
        .background(Color.white)
        HStack {
            ChessPieceView(piece: ChessPiece(kind: .king, color: .white), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .queen, color: .white), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .bishop, color: .white), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .knight, color: .white), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .rook, color: .white), imageSize: ChessPieceView.defaultSize)
            ChessPieceView(piece: ChessPiece(kind: .pawn, color: .white), imageSize: ChessPieceView.defaultSize)
        }
        .background(Color.black)
    }
}
