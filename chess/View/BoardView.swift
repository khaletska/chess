//
//  BoardView.swift
//  chess
//
//  Created by Yeliena Khaletska on 28.06.2024.
//

import UIKit

final class BoardView: UIView {

    private static let boardSideCellLength = 8
    private static let boardCellCount = BoardView.boardSideCellLength * BoardView.boardSideCellLength

    var gridCalculator = Grid(layout: .dimensions(rowCount: BoardView.boardSideCellLength, columnCount: BoardView.boardSideCellLength))

    func drawLayout(board: [[ChessPiece?]]) {
        self.gridCalculator.cellCount = BoardView.boardCellCount
        self.gridCalculator.frame = self.bounds

        for row in 0..<board.count {
            for col in 0..<board[row].count {
                guard let frame = self.gridCalculator[row, col] else {
                    continue
                }

                let cell = UIView(frame: frame)
                if (row + col) % 2 == 0 {
                    cell.backgroundColor = UIColor.systemGray2
                } 
                else {
                    cell.backgroundColor = UIColor.black
                }

                if let image = board[row][col]?.getImage() {
                    let pieceImageView = UIImageView(image: image)
                    pieceImageView.contentMode = .scaleAspectFit
                    cell.addSubview(pieceImageView)

                    pieceImageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        pieceImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                        pieceImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                        pieceImageView.topAnchor.constraint(equalTo: cell.topAnchor),
                        pieceImageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
                    ])
                }
                addSubview(cell)
            }
        }
    }

}

private extension ChessPiece {

    func getImage() -> UIImage? {
        let imageName: String = color.rawValue + kind.rawValue
        return UIImage(named: imageName)
    }

}
