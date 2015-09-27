//
//  MainViewController.swift
//  IteractiveTransition
//
//  Created by Gustavo  Motizuki on 9/9/15.
//  Copyright (c) 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let transitionManager: TransitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        transitionManager.mainViewController = self
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // set transition delegate for our menu view controller
        if let left = segue.destinationViewController as? LeftViewController {
            left.transitioningDelegate = self.transitionManager
            self.transitionManager.leftViewcontroller = left
        }
        
        if let right = segue.destinationViewController as? RightViewController {
            right.transitioningDelegate = self.transitionManager
            self.transitionManager.rightViewController = right
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
