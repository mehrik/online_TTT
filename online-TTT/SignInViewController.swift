//
//  ViewController.swift
//  online-TTT
//
//  Created by Maric Sobreo on 1/16/16.
//  Copyright © 2016 Maric Sobreo (Coding Dojo). All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, cancelProtocol {
    // change the socket url to whatever your computer's url is
    // look at SocketUrl.swift to if you need to change localhost address
//
     var socket: SocketIOClient?
//    var controller: LoadScreenViewController?
    
    @IBOutlet weak var nameTextField: UITextField!
   
    
    @IBAction func joinButtonPressed(sender: UIButton) {
        guard nameTextField.text! != "" else { return }
        print(nameTextField.text!)
        let playerName = nameTextField.text!
        socket!.emit("addPlayer", playerName)
//        controller!.myName = nameTextField.text!
        performSegueWithIdentifier("SignedInSegue", sender: sender)
    }
    
    
    func cancelGameSearch(controller: LoadScreenViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func socketHandler(){
        
        socket!.connect()
        socket!.on("connect") { data, ack
            in print("Using Sockets in SignInViewController")
        }
        
        socket!.on("showPlayer1") { data, ack
            in print("Player1 joined the game", data[0])
        }
        
        socket!.on("showPlayer2") { data, ack
            in print("Player2 joined the game", data[0])
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignedInSegue" {
            let controller = segue.destinationViewController as! LoadScreenViewController
            controller.cancelDelegate = self
            controller.socket = self.socket
            controller.myName = nameTextField.text!
        }
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
}