//
//  TransitionManager.swift
//  IteractiveTransition
//
//  Created by Gustavo  Motizuki on 9/9/15.
//  Copyright (c) 2015 Gustavo Motizuki. All rights reserved.
//

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {

//    private var presenting = false
    private var interactive = false
    private var goingLeft = false
    private var goingRight = false
    
    private var enterLeftPanGesture: UIScreenEdgePanGestureRecognizer!
    private var enterRightPanGesture: UIScreenEdgePanGestureRecognizer!
    private var statusBarBackground: UIView!
    
    var mainViewController: UIViewController! {
        didSet {
            self.enterLeftPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterLeftPanGesture.addTarget(self, action:"handleLeftOnStagePan:")
            self.enterLeftPanGesture.edges = UIRectEdge.Left
            self.mainViewController.view.addGestureRecognizer(self.enterLeftPanGesture)
            
            self.enterRightPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterRightPanGesture.addTarget(self, action:"handleRightOnStagePan:")
            self.enterRightPanGesture.edges = UIRectEdge.Right
            self.mainViewController.view.addGestureRecognizer(self.enterRightPanGesture)
        }
    }
    
    private var exitPanGesture: UIScreenEdgePanGestureRecognizer!
    
    var leftViewcontroller: UIViewController! {
        didSet {
            self.exitPanGesture = UIScreenEdgePanGestureRecognizer()
            self.exitPanGesture.edges = UIRectEdge.Right
            self.exitPanGesture.addTarget(self, action:"handleLeftOffstagePan:")
            self.leftViewcontroller.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
    
    var rightViewController: UIViewController! {
        didSet {
            self.exitPanGesture = UIScreenEdgePanGestureRecognizer()
            self.exitPanGesture.edges = UIRectEdge.Left
            self.exitPanGesture.addTarget(self, action:"handleRightOffstagePan:")
            self.rightViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }

    func handleLeftOnStagePan(pan: UIScreenEdgePanGestureRecognizer){

        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            // trigger the start of the transition
            self.mainViewController.performSegueWithIdentifier("leftSegue", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                // threshold crossed: finish
                self.finishInteractiveTransition()
            }
            else {
                // threshold not met: cancel
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func handleLeftOffstagePan(pan: UIPanGestureRecognizer){
        
        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * -0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.leftViewcontroller.performSegueWithIdentifier("unwindLeft", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.2){
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func handleRightOnStagePan(pan: UIPanGestureRecognizer){

        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * -0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            // trigger the start of the transition
            self.mainViewController.performSegueWithIdentifier("rightSegue", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                // threshold crossed: finish
                self.finishInteractiveTransition()
            }
            else {
                // threshold not met: cancel
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func handleRightOffstagePan(pan: UIPanGestureRecognizer){
        
        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.rightViewController.performSegueWithIdentifier("unwindRight", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.2){
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        var fromViewController: UIViewController?
        var toViewController: UIViewController?
        
        
        if let fromLeftViewController = screens.from as? LeftViewController{
            fromViewController = fromLeftViewController
            goingLeft = true
            goingRight = false
        }
        
        if let fromRightViewController = screens.from as? RightViewController{
            fromViewController = fromRightViewController
            goingRight = true
            goingLeft = false
        }
        
        if let fromMainViewController = screens.from as? MainViewController{
            fromViewController = fromMainViewController
        }
        
        if let toLeftViewController = screens.to as? LeftViewController{
            toViewController = toLeftViewController
            goingRight = true
            goingLeft = false
        }
        
        if let toRightViewController = screens.to as? RightViewController{
            toViewController = toRightViewController
            goingLeft = true
            goingRight = false
        }
        
        if let toMainViewController = screens.to as? MainViewController{
            toViewController = toMainViewController
        }
        
        let fromView = fromViewController!.view
        let toView = toViewController!.view
        
        if goingLeft{
            toView.layer.position = (CGPoint(x:container.layer.position.x*3, y:container.layer.position.y))

            fromView.layer.position = container.layer.position
        }
        
        if goingRight{
            toView.layer.position = (CGPoint(x:-container.layer.position.x, y:container.layer.position.y))
            fromView.layer.position = container.layer.position
        }
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: nil, animations: {
            
            
            if self.goingLeft{
                toView.layer.position = container.layer.position
                fromView.layer.position = (CGPoint(x:-container.layer.position.x, y:container.layer.position.y))
            }
            
            if self.goingRight{
                fromView.layer.position = (CGPoint(x:container.layer.position.x*3, y:container.layer.position.y))
                toView.layer.position = container.layer.position
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                if(transitionContext.transitionWasCancelled()){
                    
                    transitionContext.completeTransition(false)
//                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.from.view)
                    
                }
                else {
                    
                    transitionContext.completeTransition(true)
//                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                    
                }
                
        })

        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }

    
}