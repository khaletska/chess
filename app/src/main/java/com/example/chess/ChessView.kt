package com.example.chess

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import androidx.core.content.ContextCompat
import kotlin.math.min

class ChessView(context: Context?, attrs: AttributeSet?) : View(context, attrs) {
    private val scaleFactor = .9f
    private var cellSide: Float = 0.0f
    private var originX: Float = 0.0f
    private var originY: Float = 0.0f
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

    private var movingPieceIcon: Drawable? = null

    private var movingPiece: ChessPiece? = null
    private val colorDark = Color.rgb(135, 166, 103)
    private val colorLight = Color.rgb(254, 255, 220)

    var chessDelegate: ChessDelegate? = null

    private var fromCol: Int = -1
    private var fromRow: Int = -1

    private var movingPieceX = -1f
    private var movingPieceY = -1f

    init {
        loadIcons()
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        val smaller = min(widthMeasureSpec, heightMeasureSpec)
        setMeasuredDimension(smaller, smaller)
    }

    @SuppressLint("DrawAllocation")
    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val boardSide = min(width, height) * scaleFactor
        cellSide = boardSide / 8f
        originX = (width - boardSide) / 2f
        originY = (height - boardSide) / 2f
        drawBoard(canvas)
        drawPieces(canvas)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent?): Boolean {
        event ?: return false
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                fromCol = ((event.x - originX) / cellSide).toInt()
                fromRow = 7 - ((event.y - originY) / cellSide).toInt()

                chessDelegate?.pieceAt(fromCol, fromRow)?.let {
                    movingPiece = it
                    movingPieceIcon = icons[it.iconID]
                }
            }

            MotionEvent.ACTION_MOVE -> {
                movingPieceX = event.x
                movingPieceY = event.y
                invalidate()
            }

            MotionEvent.ACTION_UP -> {
                val col = ((event.x - originX) / cellSide).toInt()
                val row = 7 - ((event.y - originY) / cellSide).toInt()
                chessDelegate?.movePiece(fromCol, fromRow, col, row)
                movingPiece = null
                movingPieceIcon = null
                invalidate()
            }
        }
        return true
    }

    private fun loadIcons() {
        iconsIDs.forEach {
            icons[it] = ContextCompat.getDrawable(context!!, it)
        }
    }

    private fun drawPieceAt(canvas: Canvas, col: Int, row: Int, pieceID: Int) {
        val qw: Drawable? = icons[pieceID]
        qw?.let {
            it.setBounds(
                (originX + col * cellSide).toInt(),
                (originY + (7 - row) * cellSide).toInt(),
                (originX + (col + 1) * cellSide).toInt(),
                (originY + ((7 - row) + 1) * cellSide).toInt()
            )
            it.draw(canvas)
        }
    }

    private fun drawPieces(canvas: Canvas) {
        for (row in 0..7) {
            for (col in 0..7) {
                if (row != fromRow || col != fromCol) {
                    chessDelegate?.pieceAt(col, row)
                        ?.let { drawPieceAt(canvas, col, row, it.iconID) }
                }

                chessDelegate?.pieceAt(col, row)
                    ?.let {
                        if (it != movingPiece) {
                            drawPieceAt(canvas, col, row, it.iconID)
                        }
                    }
            }
        }


        movingPieceIcon?.let {
            it.setBounds(
                (movingPieceX - cellSide / 2).toInt(),
                (movingPieceY - cellSide / 2).toInt(),
                (movingPieceX + cellSide / 2).toInt(),
                (movingPieceY + cellSide / 2).toInt()
            )
            it.draw(canvas)
        }

//        chessDelegate?.pieceAt(fromCol, fromRow)?.let { piece ->
//            val qw: Drawable? = icons[piece.iconID]
//            qw?.let {
//                it.setBounds(
//                    (movingPieceX - cellSide / 2).toInt(),
//                    (movingPieceY - cellSide / 2).toInt(),
//                    (movingPieceX + cellSide / 2).toInt(),
//                    (movingPieceY + cellSide / 2).toInt()
//                )
//                it.draw(canvas)
//            }
//        }
    }

    private fun drawBoard(canvas: Canvas) {
        for (row in 0..7) {
            for (col in 0..7) {
                drawCellAt(canvas, col, row, (col + row) % 2 == 1)
            }
        }
    }

    private fun drawCellAt(canvas: Canvas, col: Int, row: Int, isDark: Boolean) {
        paint.color = if (isDark) colorDark else colorLight
        canvas.drawRect(
            originX + col * cellSide,
            originY + row * cellSide,
            originX + (col + 1) * cellSide,
            originY + (row + 1) * cellSide,
            paint
        )
    }
}