//
//  ChessApp.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

@main
struct ChessApp: App {
    private let chessViewModel = ChessGameViewModel()

    var body: some Scene {
        WindowGroup {
            ChessGameView(chessViewModel: self.chessViewModel)
        }
    }
}
