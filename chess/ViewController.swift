//
//  ViewController.swift
//  chess
//
//  Created by Yeliena Khaletska on 21.06.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardView: BoardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        boardView.generateBoard()
    }


}
