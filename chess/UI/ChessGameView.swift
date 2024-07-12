//
//  ChessGameView.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct ChessGameView: View {

    @ObservedObject var chessModel: ChessGameModel

    var body: some View {
        ChessBoardView(chessModel: self.chessModel)
            .onAppear(perform: {
                self.chessModel.createNewGameBoard()
            })
    }

}

#Preview {
    ChessGameView(chessModel: ChessGameModel())
}
