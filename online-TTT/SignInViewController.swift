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
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func joinButtonPressed(sender: UIButton) {
        guard nameTextField.text! != "" else { return }
        print(nameTextField.text!)
        let playerName = nameTextField.text!
        socket.emit("addPlayer", playerName)
        performSegueWithIdentifier("SignedInSegue", sender: sender)
    }
    
    
    func cancelGameSearch(controller: LoadScreenViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignedInSegue" {
            let controller = segue.destinationViewController as! LoadScreenViewController
            controller.cancelDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.on("connect") { data, ack in print("Using Sockets in SignInViewController") }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

