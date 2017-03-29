//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Stefany Felicia on 28/3/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y)
       // trayUp = CGPoint(x: trayView.center.x, y: trayView.center.y - 200)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if(sender.state == .began) {
            trayOriginalCenter = trayView.center
        } else if(sender.state == .changed) {
            self.trayView.center.x = trayOriginalCenter.x
            self.trayView.center.y = trayOriginalCenter.y + translation.y
        } else if(sender.state == .ended) {
            //detect if tray is moving up or down
            let velocity = sender.velocity(in: view)
            if(velocity.y > 0) { //moving down
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayDown
                }, completion: nil)
            } else { //moving up
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .began) {
            
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            UIView.animate(withDuration: 0.2, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            })
            
            //add a new UIPanGestureRecognizer to the imageView created
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanOnCanvas(sender:)))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnCanvas(sender:)))
            pinchGestureRecognizer.delegate = self;
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            
        } else if(sender.state == .changed) {
            
            let translation = sender.translation(in: view)
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if(sender.state == .ended) {
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
        }
    }
    
    func didPanOnCanvas(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if(sender.state == .began) {
            
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
        } else if(sender.state == .changed) {
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if(sender.state == .ended) {
            
            
        }
    }
    
    func didPinchOnCanvas(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        newlyCreatedFace.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
