//
//  ChessApp.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

@main
struct ChessApp: App {
    @StateObject var chessModel = ChessGameModel()

    var body: some Scene {
        WindowGroup {
            ChessGameView(chessModel: self.chessModel)
        }
    }
}
