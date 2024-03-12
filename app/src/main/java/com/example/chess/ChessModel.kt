package com.example.chess

class ChessModel {
    private var piecesBox = mutableSetOf<ChessPiece>()

    init {
        reset()
    }

    fun movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        if (fromCol == toCol && fromRow == toRow) return
        val movingPiece = pieceAt(fromCol, fromRow) ?: return

        pieceAt(toCol, toRow)?.let {
            if (it.player == movingPiece.player) return
            piecesBox.remove(it)
        }

        piecesBox.remove(movingPiece)
        piecesBox.add(
            ChessPiece(
                toCol,
                toRow,
                movingPiece.player,
                movingPiece.rank,
                movingPiece.iconID
            )
        )
//        movingPiece.col = toCol
//        movingPiece.row = toRow

    }

    fun reset() {
        piecesBox.removeAll(piecesBox)
        for (i in 0..1) {
            piecesBox.add(
                ChessPiece(
                    0 + i * 7, 0, ChessPlayer.WHITE, ChessRank.ROOK, R.drawable.rw
                )
            )
            piecesBox.add(
                ChessPiece(
                    0 + i * 7, 7, ChessPlayer.BLACK, ChessRank.ROOK, R.drawable.rb
                )
            )
            piecesBox.add(
                ChessPiece(
                    1 + i * 5, 0, ChessPlayer.WHITE, ChessRank.KNIGHT, R.drawable.nw
                )
            )
            piecesBox.add(
                ChessPiece(
                    1 + i * 5, 7, ChessPlayer.BLACK, ChessRank.KNIGHT, R.drawable.nb
                )
            )
            piecesBox.add(
                ChessPiece(
                    2 + i * 3, 0, ChessPlayer.WHITE, ChessRank.BISHOP, R.drawable.bw
                )
            )
            piecesBox.add(
                ChessPiece(
                    2 + i * 3, 7, ChessPlayer.BLACK, ChessRank.BISHOP, R.drawable.bb
                )
            )
        }

        for (i in 0..7) {
            piecesBox.add(ChessPiece(i, 1, ChessPlayer.WHITE, ChessRank.PAWN, R.drawable.pw))
            piecesBox.add(ChessPiece(i, 6, ChessPlayer.BLACK, ChessRank.PAWN, R.drawable.pb))
        }
        piecesBox.add(ChessPiece(3, 0, ChessPlayer.WHITE, ChessRank.QUEEN, R.drawable.qw))
        piecesBox.add(ChessPiece(3, 7, ChessPlayer.BLACK, ChessRank.QUEEN, R.drawable.qb))
        piecesBox.add(ChessPiece(4, 0, ChessPlayer.WHITE, ChessRank.KING, R.drawable.kw))
        piecesBox.add(ChessPiece(4, 7, ChessPlayer.BLACK, ChessRank.KING, R.drawable.kb))
    }

    fun pieceAt(col: Int, row: Int): ChessPiece? {
        for (piece in piecesBox) {
            if (col == piece.col && row == piece.row) {
                return piece
            }
        }
        return null
    }

    override fun toString(): String {
        var desc = " \n"
        for (row in 7 downTo 0) {
            desc += "$row"
            for (col in 0..7) {
                val piece = pieceAt(col, row)
                if (piece == null) {
                    desc += " ."

                } else {
                    val white = piece.player == ChessPlayer.WHITE
                    desc += " "
                    when (piece.rank) {
                        ChessRank.KING -> {
                            desc += if (white) "k" else "K"
                        }

                        ChessRank.QUEEN -> {
                            desc += if (white) "q" else "Q"
                        }

                        ChessRank.ROOK -> {
                            desc += if (white) "r" else "R"
                        }

                        ChessRank.BISHOP -> {
                            desc += if (white) "b" else "B"
                        }

                        ChessRank.KNIGHT -> {
                            desc += if (white) "n" else "N"
                        }

                        ChessRank.PAWN -> {
                            desc += if (white) "p" else "P"
                        }
                    }
                }
            }
            desc += "\n"
        }

        desc += " 0 1 2 3 4 5 6 7"

        return desc
    }
}