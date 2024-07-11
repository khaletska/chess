//
//  DeskView.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct DeskView: View {

    @ObservedObject var chessModel: ChessModel

    var body: some View {
        ChessBoardView(chessModel: self.chessModel)
            .onAppear(perform: {
                self.chessModel.createNewGameBoard()
            })
    }

}

#Preview {
    DeskView(chessModel: ChessModel())
}
