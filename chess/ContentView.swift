//
//  ContentView.swift
//  chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var chessModel: ChessModel

    var body: some View {
        ChessBoardView(chessModel: self.chessModel)
            .onAppear(perform: {
                self.chessModel.createNewGameBoard()
            })
    }

}

struct ChessBoardView: View {

    @ObservedObject var chessModel: ChessModel
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)

    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width, geometry.size.height) / 8

            LazyVGrid(columns: self.columns, spacing: 0) {
                ForEach(0..<64) { index in
                    let row = index / 8
                    let col = index % 8
                    ZStack {
                        Rectangle()
                            .strokeBorder(getBorderColorForSquare(row: row, col: col), lineWidth: 4)
                            .background(Rectangle().fill(getColorForSquare(row: row, col: col)))
                            .frame(width: cellSize)
                            .aspectRatio(1, contentMode: .fit)
                        ChessPieceView(piece: self.chessModel.board[row][col], imageSize: cellSize * 0.9)
                            .onTapGesture {
                                self.chessModel.selectPieceAt(row: row, col: col)
                            }
                    }
                }
            }
            .frame(width: min(geometry.size.width, geometry.size.height))
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }

    func getBorderColorForSquare(row: Int, col: Int) -> Color {
        guard let selectedPieceAddress = self.chessModel.selectedPieceAddress else {
            return .clear
        }

        return selectedPieceAddress == (row, col) ? .orange : .clear
    }

    func getColorForSquare(row: Int, col: Int) -> Color {
        return (row + col).isMultiple(of: 2) ? .white : .black
    }

}

struct ChessPieceView: View {

    let piece: ChessPiece?
    let imageSize: CGFloat

    var body: some View {
        if let piece = self.piece {
            Image(piece.color.rawValue + piece.kind.rawValue)
                .resizable()
                .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
        }
    }

}

#Preview {
    ContentView(chessModel: ChessModel())
}
