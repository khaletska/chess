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
        drawPieceAt(canvas, 0, 0, R.drawable.rb)
        drawPieceAt(canvas, 1, 0, R.drawable.nb)
        drawPieceAt(canvas, 2, 0, R.drawable.bb)
        drawPieceAt(canvas, 3, 0, R.drawable.qb)
        drawPieceAt(canvas, 4, 0, R.drawable.kb)
        drawPieceAt(canvas, 5, 0, R.drawable.bb)
        drawPieceAt(canvas, 6, 0, R.drawable.nb)
        drawPieceAt(canvas, 7, 0, R.drawable.rb)
        drawPieceAt(canvas, 0, 1, R.drawable.pb)
        drawPieceAt(canvas, 1, 1, R.drawable.pb)
        drawPieceAt(canvas, 2, 1, R.drawable.pb)
        drawPieceAt(canvas, 3, 1, R.drawable.pb)
        drawPieceAt(canvas, 4, 1, R.drawable.pb)
        drawPieceAt(canvas, 5, 1, R.drawable.pb)
        drawPieceAt(canvas, 6, 1, R.drawable.pb)
        drawPieceAt(canvas, 7, 1, R.drawable.pb)
    }

    private fun drawBoard(canvas: Canvas) {
        for (i in 0..7) {
            for (j in 0..7) {
                paint.color = if ((i + j) % 2 == 0) Color.LTGRAY else Color.DKGRAY
                canvas.drawRect(
                    originX + i * cellSide,
                    originY + j * cellSide,
                    originX + (i + 1) * cellSide,
                    originY + (j + 1) * cellSide,
                    paint
                )
            }
        }
    }
}