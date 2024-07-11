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
