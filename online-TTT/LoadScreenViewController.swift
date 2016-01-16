//
//  LoadScreenViewController.swift
//  online-TTT
//
//  Created by Maric Sobreo on 1/16/16.
//  Copyright © 2016 Maric Sobreo (Coding Dojo). All rights reserved.
//

import UIKit

class LoadScreenViewController: UIViewController, exitProtocol {
    var players = 2
    
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
        --players
        dismissViewControllerAnimated(true, completion: nil)
        cancelDelegate?.cancelGameSearch(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if players == 2 {
            performSegueWithIdentifier("playGameSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}