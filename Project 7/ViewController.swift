//
//  ViewController.swift
//  Project 7
//
//  Created by Amanda Ong on 11/29/15.
//  Copyright © 2015 Amanda Ong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var BOARD_SIZE:Int = 8
    var board:Board
    var squareButtons:[SquareButton] = []
    var oneSecondTimer:NSTimer?
    var emptySquares:Int = 0
    
    //LEFT OFF HERE. N2FIGURE OUT H2 CHANGE BOARD SIZE
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            BOARD_SIZE = 8
        case 1:
            BOARD_SIZE = 10
        case 2:
            BOARD_SIZE = 12
        default:
            break;
        }
    }
    
    //INTIALIZATION
     required init?(coder aDecoder: NSCoder)
    {
        self.board = Board(size: BOARD_SIZE)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeBoard()
        self.startNewGame()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeBoard() {
        for row in 0 ..< board.size {
            for col in 0 ..< board.size {
                let square = board.squares[row][col]
                let squareSize:CGFloat = self.boardView.frame.width / CGFloat(BOARD_SIZE)
                let squareButton = SquareButton(squareModel: square, squareSize: squareSize);
                squareButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                squareButton.addTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
                self.boardView.addSubview(squareButton)
                self.squareButtons.append(squareButton)
            }
        }
    }
    
    //IF SQUARE IS PRESSED
    func squareButtonPressed(sender: SquareButton) {
        //print("Row: \((sender.square.row))");
        //print("Col: \((sender.square.col))");
        //sender.setTitle("", forState: .Normal);
        
        if(!sender.square.isRevealed) {
            sender.square.isRevealed = true
            sender.setTitle("\(sender.getLabelText())", forState: .Normal)
            
            //Update # of moves
            self.moves++
            
            //Update # of non-mine squares pressed
            self.emptySquares++
        }
        
        if sender.square.isMineLocation {
            self.minePressed()
        }
        
    }
    
    //RESET GAME
    func minePressed() {
        self.endCurrentGame()
        
        // show an alert when you tap on a mine
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "GAME OVER", message: "Whoops, you hit a mine!", preferredStyle: .ActionSheet)
        
        //Create and add first option action
        let newGameAction: UIAlertAction = UIAlertAction(title: "New Game", style: .Default) { action -> Void in
            self.startNewGame()
        }
        
        actionSheetController.addAction(newGameAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    /*func noMinesPressed() {
        if
    }*/
    
    @IBAction func newGamePressed() {
        self.endCurrentGame()
        print("new game");
        self.startNewGame()
    }
    
    func resetBoard() {
        // resets the board with new mine locations & sets isRevealed to false for each square
        self.board.resetBoard()
        // iterates through each button and resets the text to the default value
        for squareButton in self.squareButtons {
            squareButton.setTitle("[x]", forState: .Normal)
            //squareButton.setImage(UIImage(named: "BlueButton"), forState: .Normal)
        }
    }
    
    func startNewGame() {
        //start new game
        self.resetBoard()
        
        //set moves & time to 0
        self.moves = 0
        self.timeTaken = 0
        
        //set timer. Calls method "oneSecond" every 1 second
        self.oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
        
    }
    
    func oneSecond() {
        self.timeTaken++
    }
    
    //Deletes current timer when current game ends. Prevents timer from speeding up.
    func endCurrentGame() {
        self.oneSecondTimer!.invalidate()
        self.oneSecondTimer = nil
    }
    
    //COUNTING MOVES & TIME
         //didSet method is called when value moves & timeTaken are changed
    var moves:Int = 0 {
        didSet {
            self.movesLabel.text = "Moves: \(moves)"
            self.movesLabel.sizeToFit()
        }
    }
    var timeTaken:Int = 0  {
        didSet {
            self.timeLabel.text = "Time: \(timeTaken)"
            self.timeLabel.sizeToFit()
        }
    }
    
    
    
    
}

