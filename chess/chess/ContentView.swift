//
//  ContentView.swift
//  chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChessBoard()
    }
}

struct ChessBoard: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<64) { index in
                Rectangle()
                    .foregroundColor(colorForSquare(at: index))
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }

    func colorForSquare(at index: Int) -> Color {
        let row = index / 8
        let column = index % 8
        return (row + column).isMultiple(of: 2) ? .white : .black
    }
}

#Preview {
    ContentView()
}
