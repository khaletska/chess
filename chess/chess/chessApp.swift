//
//  chessApp.swift
//  chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

@main
struct chessApp: App {
    @StateObject var chessModel = ChessModel()

    var body: some Scene {
        WindowGroup {
            ContentView(chessModel: chessModel)
        }
    }
}
