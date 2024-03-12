package com.example.chess

data class ChessPiece(
    var col: Int,
    var row: Int,
    val player: ChessPlayer,
    val rank: ChessRank,
    val iconID: Int
) {


}