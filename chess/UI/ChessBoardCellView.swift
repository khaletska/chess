//
//  ChessBoardCellView.swift
//  Chess
//
//  Created by Yeliena Khaletska on 12.07.2024.
//

import SwiftUI

struct ChessBoardCellView: View {

    private let strokeColor: Color
    private let cellColor: Color
    private let cellWidth: CGFloat

    init(strokeColor: Color, cellColor: Color, cellWidth: CGFloat) {
        self.strokeColor = strokeColor
        self.cellColor = cellColor
        self.cellWidth = cellWidth
    }

    var body: some View {
        Rectangle()
            .strokeBorder(self.strokeColor, lineWidth: 4)
            .background(Rectangle().fill(self.cellColor))
            .frame(width: self.cellWidth, height: self.cellWidth)
    }

}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        HStack {
            ChessBoardCellView(
                strokeColor: .clear,
                cellColor: .black,
                cellWidth: 50
            )
            ChessBoardCellView(
                strokeColor: .orange,
                cellColor: .black,
                cellWidth: 50
            )
        }
        HStack {
            ChessBoardCellView(
                strokeColor: .clear,
                cellColor: .white,
                cellWidth: 50
            )
            ChessBoardCellView(
                strokeColor: .orange,
                cellColor: .white,
                cellWidth: 50
            )
        }
    }
    .padding()
    .background(.green)
}
