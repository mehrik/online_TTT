//
//  GameViewController.swift
//  online-TTT
//
//  Created by Maric Sobreo on 1/16/16.
//  Copyright © 2016 Maric Sobreo (Coding Dojo). All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    weak var exitDelegate: exitProtocol?
    var socket: SocketIOClient?
    var myName: String?
    var myTurn = false
    var gameOver = false
    
    
    @IBOutlet weak var newName: UITextField!
    
    @IBOutlet weak var player1Label: UILabel!
    
    
    @IBOutlet weak var player2Label: UILabel!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    
  
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    
    
    @IBOutlet weak var btn5: UIButton!
    
    
    @IBOutlet weak var btn6: UIButton!
    
    
    @IBOutlet weak var btn7: UIButton!
    
    
    @IBOutlet weak var btn8: UIButton!
    
    
    @IBOutlet weak var btn9: UIButton!
    
    
    @IBAction func joinBtnPressed(sender: UIButton) {
        guard newName.text! != "" else { return }
        print(newName.text!)
        myName = newName.text!
        socket!.emit("addPlayer", myName!)
    }
    
    @IBAction func exitButtonPressed(sender: UIButton) {
        socket!.emit("exitGame", myName!)
        exitDelegate?.exitGame(self)
    }
    
    
    @IBAction func boardBtnPressed(sender: UIButton) {
        print("\(myName) button clicked!!!")
        if !gameOver && myTurn {
            print("button clicked!!!")
            socket!.emit("played", ["name": myName!, "place": sender.tag-1])
        }
    }
            
    @IBAction func playAgainBtnPressed(sender: UIButton) {
        socket!.emit("playAgain")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = SocketIOClient(socketURL: "http://localhost:5000")
        if let _ = socket{
            socketHandler()
        }else{
            print("fail to connect to the socket!")
        }
    }
    
    func socketHandler(){
        
        
        socket!.connect()
        socket!.on("connect") { data, ack
            in print("Using Sockets in SignInViewController")
        }
        
        socket!.on("showPlayer1") { data, ack
            in print("Player1 joined the game", data[0])
            let name = data[0] as! String
            self.player1Label.text = name
            
        }
        
        socket!.on("showPlayer2") { data, ack
            in print("Player2 joined the game", data[0])
            let name = data[0] as! String
            self.player2Label.text = name
        }

        socket!.on("gameStart"){ data, ack in
            print("game Started!!!")
           
        }

        
        //other player exits the game
        socket!.on("exitPlayer") { data, ack in
            print("\(data[0]) exits the gmae. Wait for another player.")
        }
        
        // other player played {color: strng, place: Int}
        socket!.on("playedBoard") { data, ack in
            print("\(data[0]) pressed")
        }
        
        //who's turn? data[0] == player name
        socket!.on("takeTurn"){ data, ack in
            print("current turn" , data[0])
            print("myName", self.myName!)
            if data[0] as! String == self.myName! {
                print("myTurn")
                self.myTurn = true
            }else{
                self.myTurn = false
            }
                
            self.statusLabel.text = "Turn: \(data[0])"
        }
            //set myTurn = true or false
        
        //data --> winner
        socket!.on("gameOver"){ data, ack in
            print("gaveOver")
            print(data[0])
            let winner = data[0] as! String
            self.statusLabel.text = "Game over! \(winner) is the winnter"
            self.gameOver = true
        }
        
        socket!.on("changeBoard") { data, ack in
            print("board color changed")
            if let info = data[0] as? NSDictionary {
                print(info["color"], info["place"])
                let color = info["color"] as! String
                let place = info["place"] as! Int
                let tmpButton = self.view.viewWithTag(place) as? UIButton
                if color == "Red" {
                    tmpButton!.backgroundColor = UIColor.redColor()
                }else{
                    tmpButton!.backgroundColor = UIColor.blueColor()
                }
            }
        }
        
        socket!.on("resetGame"){ data, ack in
            print("game reset!!")
            self.myTurn = false
            self.gameOver = false
            //button color change
            self.btn1.backgroundColor = UIColor.grayColor()
            self.btn2.backgroundColor = UIColor.grayColor()
            
            self.btn3.backgroundColor = UIColor.grayColor()
            self.btn4.backgroundColor = UIColor.grayColor()
            
            self.btn5.backgroundColor = UIColor.grayColor()
            self.btn6.backgroundColor = UIColor.grayColor()
            
            self.btn7.backgroundColor = UIColor.grayColor()
            self.btn8.backgroundColor = UIColor.grayColor()
            self.btn9.backgroundColor = UIColor.grayColor()
        }
    }
}

