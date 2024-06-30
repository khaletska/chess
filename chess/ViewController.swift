//
//  ViewController.swift
//  chess
//
//  Created by Yeliena Khaletska on 21.06.2024.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var boardView: BoardView!
    private let chessGame: BoardModel = BoardModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.chessGame.createNewGameBoard()
        self.boardView.drawLayout(board: self.chessGame.board)
    }


}
