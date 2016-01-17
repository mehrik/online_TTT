//
//  LoadScreenViewController.swift
//  online-TTT
//
//  Created by Maric Sobreo on 1/16/16.
//  Copyright © 2016 Maric Sobreo (Coding Dojo). All rights reserved.
//

import UIKit

class LoadScreenViewController: UIViewController, exitProtocol {
    // change the socket url to whatever your computer's url is
    // look at SocketUrl.swift to if you need to change localhost address
    let socket = SocketIOClient(socketURL: SocketUrl.url())
    var players = [String]()
    
    weak var cancelDelegate: cancelProtocol?
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        cancelDelegate?.cancelGameSearch(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playGameSegue" {
            let controller = segue.destinationViewController as! GameViewController
            controller.exitDelegate = self
        }
    }
    
    func exitGame(controller: GameViewController) {
        // --players
        // when a play exits the game, the player needs to be removed
        // the player.count needs to be decreased
        dismissViewControllerAnimated(true, completion: nil)
        cancelDelegate?.cancelGameSearch(self)
    }
    
    override func viewDidLoad() {
        print("view DID LOAD")
        self.addHandler()
        socket.connect()
        super.viewDidLoad()
    }
    
    // if you want to use this for linear in order loading programming
    override func viewWillAppear(animated: Bool) {

    }
    
    func socketFunction(data: AnyObject) {
        self.players = data[0] as! [String]
        print(data[0])
        print(self.players)
        if self.players.count == 2 {
            self.performSegueWithIdentifier("playGameSegue", sender: self)
        }
        
    }
    
    func addHandler() {
        socket.on("connect") { data, ack in print("Using Sockets in LoadScreenViewController") }
        socket.on("sendNumber") {data, ack in self.socketFunction(data) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}