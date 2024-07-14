//
//  ChessBoardView.swift
//  Chess
//
//  Created by Andrius Shiaulis on 11.07.2024.
//

import SwiftUI

struct ChessBoardView: View {

    @ObservedObject var chessViewModel: ChessGameViewModel
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)

    var body: some View {
        GeometryReader { geometry in
            let borderSize: CGFloat = 8
            let cellWidth = (min(geometry.size.width, geometry.size.height) - borderSize * 2) / 8

            ZStack {
                Rectangle()
                    .strokeBorder(.brown, lineWidth: borderSize)
                    .frame(width: min(geometry.size.width, geometry.size.height))
                    .aspectRatio(1, contentMode: .fit)
                LazyVGrid(columns: self.columns, spacing: 0) {
                    ForEach(0..<64) { index in
                        let row = index / 8
                        let col = index % 8
                        let cellAddress = Coordinate(row: row, col: col)
                        ZStack {
                            ChessBoardCellView(
                                strokeColor: self.chessViewModel.getBorderColor(for: cellAddress),
                                cellColor: self.chessViewModel.getCellColor(for: cellAddress),
                                cellWidth: cellWidth
                            )
                            if let piece = self.chessViewModel.getPiece(for: cellAddress) {
                                ChessPieceView(piece: piece, imageSize: cellWidth * 0.9)
                            }
                        }
                        .onTapGesture {
                            self.chessViewModel.cellTapped(at: cellAddress)
                        }
                    }
                }
                .padding(borderSize)
                .frame(width: min(geometry.size.width, geometry.size.height))
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            }
        }
    }

}

#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    ChessBoardView(chessViewModel: .init())
}
