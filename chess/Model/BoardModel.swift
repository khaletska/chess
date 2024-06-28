//
//  BoardModel.swift
//  chess
//
//  Created by Yeliena Khaletska on 28.06.2024.
//

import Foundation

final class BoardModel {

    var board: [[ChessPiece?]] = .init(repeating: .init(repeating: nil, count: 8), count: 8)

    func generateBoard() {
        for col in 0...7 {
            board[1][col] = ChessPiece(type: .pawn, color: .black)
            board[6][col] = ChessPiece(type: .pawn, color: .white)
        }

        // rooks
        board[0][0] = ChessPiece(type: .rook, color: .black)
        board[0][7] = ChessPiece(type: .rook, color: .black)
        board[7][0] = ChessPiece(type: .rook, color: .white)
        board[7][7] = ChessPiece(type: .rook, color: .white)

        // knights
        board[0][1] = ChessPiece(type: .knight, color: .black)
        board[0][6] = ChessPiece(type: .knight, color: .black)
        board[7][1] = ChessPiece(type: .knight, color: .white)
        board[7][6] = ChessPiece(type: .knight, color: .white)

        // bishops
        board[0][2] = ChessPiece(type: .bishop, color: .black)
        board[0][5] = ChessPiece(type: .bishop, color: .black)
        board[7][2] = ChessPiece(type: .bishop, color: .white)
        board[7][5] = ChessPiece(type: .bishop, color: .white)

        // queens
        board[0][3] = ChessPiece(type: .queen, color: .black)
        board[7][3] = ChessPiece(type: .queen, color: .white)

        // kings
        board[0][4] = ChessPiece(type: .king, color: .black)
        board[7][4] = ChessPiece(type: .king, color: .white)
    }

    func movePiece(from current: (Int, Int), to destination: (Int, Int)) {
        guard let piece = self.board[current.0][current.1] else {
            return
        }

        let possibleMoves = piece.getPossibleMoves(position: current, board: self.board)
        if possibleMoves.contains(where: { $0 == destination }) {
            board[destination.0][destination.1] = piece
            board[current.0][current.1] = nil
        }
    }

}

private extension ChessPiece {

    func getPossibleMoves(position: (Int, Int), board: [[ChessPiece?]]) -> [(Int, Int)] {
        let directions: [(Int, Int)] = {
            switch type {
            case .pawn:
                return color == .white ? [(1, 0)] : [(-1, 0)]
            case .rook:
                return [(1, 0), (-1, 0), (0, 1), (0, -1)]
            case .knight:
                return [(2, 1), (2, -1), (-2, 1), (-2, -1), (1, 2), (1, -2), (-1, 2), (-1, -2)]
            case .bishop:
                return [(1, 1), (1, -1), (-1, 1), (-1, -1)]
            case .queen:
                return [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)]
            case .king:
                return [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)]
            }
        }()

        var possibleMoves: [(Int, Int)] = []
        for direction in directions {
            var nextPosition = (position.0 + direction.0, position.1 + direction.1)
            while nextPosition.0 >= 0 && nextPosition.0 < 8 && nextPosition.1 >= 0 && nextPosition.1 < 8 {
                if let piece = board[nextPosition.0][nextPosition.1] {
                    if piece.color != color {
                        possibleMoves.append(nextPosition)
                    }
                    break
                }
                possibleMoves.append(nextPosition)
                if type == .knight || type == .king || type == .pawn {
                    break
                }
                nextPosition = (nextPosition.0 + direction.0, nextPosition.1 + direction.1)
            }
        }

        return possibleMoves
    }

}
