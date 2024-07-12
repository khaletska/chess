//
//  ChessGameView.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct ChessGameView: View {

    @ObservedObject var chessViewModel: ChessGameViewModel

    var body: some View {
        ChessBoardView(chessViewModel: self.chessViewModel)
            .padding()
            .onAppear {
                self.chessViewModel.gameAppeared()
            }
    }

}

#Preview {
    ChessGameView(chessViewModel: ChessGameViewModel())
}
