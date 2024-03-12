package com.example.chess

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.view.View
import androidx.core.content.ContextCompat

class ChessView(context: Context?, attrs: AttributeSet?) : View(context, attrs) {
    private val originX = 20f
    private val originY = 200f
    private val cellSide: Float = 130f
    private val iconsIDs = setOf(
        R.drawable.rw,
        R.drawable.nw,
        R.drawable.bw,
        R.drawable.qw,
        R.drawable.kw,
        R.drawable.pw,
        R.drawable.rb,
        R.drawable.nb,
        R.drawable.bb,
        R.drawable.qb,
        R.drawable.kb,
        R.drawable.pb
    )
    private val icons = mutableMapOf<Int, Drawable?>()
    private val paint = Paint()

    private val colorDark = Color.rgb(135,166,103)
    private val colorLight = Color.rgb(254,255,220)

    init {
        loadIcons()
    }

    @SuppressLint("DrawAllocation")
    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        drawBoard(canvas)

        drawPieces(canvas)
    }

    private fun loadIcons() {
        iconsIDs.forEach {
            icons[it] = ContextCompat.getDrawable(context!!, it)
        }
    }

    private fun drawPieceAt(canvas: Canvas, col: Int, row: Int, pieceID: Int) {
        val qw: Drawable? = icons[pieceID]
        print(qw)
        qw?.let {
            it.setBounds(
                (originX + col * cellSide).toInt(),
                (originY + row * cellSide).toInt(),
                (originX + (col + 1) * cellSide).toInt(),
                (originY + (row + 1) * cellSide).toInt()
            )
            it.draw(canvas)
        }
    }

    private fun drawPieces(canvas: Canvas) {
        val chessModel = ChessModel()
        chessModel.reset()

        for (row in 0..7) {
            for (col in 0..7) {
                chessModel.pieceAt(col, row)?.let { drawPieceAt(canvas, col, row, it.iconID) }
            }
        }
    }

    private fun drawBoard(canvas: Canvas) {
        for (col in 0..7) {
            for (row in 0..7) {
                drawCellAt(canvas, col, row, (col + row) % 2 == 0)
            }
        }
    }

    private fun drawCellAt(canvas: Canvas, col: Int, row: Int, isLight: Boolean) {
        paint.color = if (isLight) colorLight else colorDark
        canvas.drawRect(
            originX + col * cellSide,
            originY + row * cellSide,
            originX + (col + 1) * cellSide,
            originY + (row + 1) * cellSide,
            paint
        )
    }
}