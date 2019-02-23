//
//  ViewController.swift
//  Casino
//
//  Created by seattle on 12/22/18.
//  Copyright © 2018 ACA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ExpandingMenu

class ViewController: UIViewController, ARSCNViewDelegate, BlurredEffectDelegate {
    
    let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
    var menuButton: ExpandingMenuButton!
    var editMenuButton: ExpandingMenuButton!
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Menu configurations
        menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), image: UIImage(named: "settings")!, rotatedImage: UIImage(named: "highlighted-settings")!)
        
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
        
        view.addSubview(menuButton)
        
        editMenuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: self.menuButtonSize), image: UIImage(named: "edit")!, rotatedImage: UIImage(named: "edit")!)
        editMenuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
        editMenuButton.isHidden = true
        
        view.addSubview(self.editMenuButton)
        
        configMenu()
        configEditMenu()
        
        // Daily login
        let dict = UserDefaults.standard.value(forKey: UIApplication.appDelegate.user.userInfo["email"]!) as! Dictionary<String, Double>
        let lastLaunch = dict["lastLaunch"]!
        var daysCount = dict["count"]!
        let lastLaunchDate = Date(timeIntervalSince1970: lastLaunch)
        
        // Check to see if lastLaunchDate is today.
        let lastLaunchIsToday = Calendar.current.isDateInToday(lastLaunchDate)
        if !lastLaunchIsToday {
            if dict["isShown"] == 0 {
                if daysCount != 0 {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "DailyRewardViewController") as! DailyRewardViewController
                    vc.daysCount = daysCount
                    vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
                if daysCount >= 3 {
                    daysCount = 1
                } else {
                    daysCount += 1
                }
                UserDefaults.standard.set(["lastLaunch": Date().timeIntervalSince1970, "count": daysCount, "isShown": 1], forKey: UIApplication.appDelegate.user.userInfo["email"]!)
            }
        } else {
            // Update the last launch value
            UserDefaults.standard.set(["lastLaunch": Date().timeIntervalSince1970, "count": dict["count"]!, "isShown": 0], forKey: UIApplication.appDelegate.user.userInfo["email"]!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    //MARK: - Menu functions
    
    func configMenu() {
        
        let musicMenuItem = ExpandingMenuItem(size: menuButtonSize, title: "Sound", image: UIImage(named: "music")!, highlightedImage: UIImage(named: "music")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            
            self.overlayBlurredBackgroundView()
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let editMenuItem = ExpandingMenuItem(size: menuButtonSize, title: "Edit", image: UIImage(named: "edit")!, highlightedImage: UIImage(named: "edit")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.menuButton.isHidden = true
            self.editMenuButton.isHidden = false
        }
        
        let userMenuItem = ExpandingMenuItem(size: menuButtonSize, title: "User", image: UIImage(named: "user")!, highlightedImage: UIImage(named: "user")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        menuButton.addMenuItems([musicMenuItem, editMenuItem, userMenuItem])
    }
    
    func configEditMenu() {
        
        let woodTexture1 = ExpandingMenuItem(size: self.menuButtonSize, title: "", image: UIImage(named: "1")!, highlightedImage: UIImage(named: "1")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            
            self.change(image: UIImage(named: "wood1")!)
        }
        
        let woodTexture2 = ExpandingMenuItem(size: self.menuButtonSize, title: "", image: UIImage(named: "2")!, highlightedImage: UIImage(named: "2")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.change(image: UIImage(named: "wood2")!)
        }
        
        let texture = ExpandingMenuItem(size: self.menuButtonSize, title: "", image: UIImage(named: "3")!, highlightedImage: UIImage(named: "3")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.change(image: UIImage(named: "text")!)
        }
        
        let goBack = ExpandingMenuItem(size: self.menuButtonSize, title: "Go back", image: UIImage(named: "exit")!, highlightedImage: UIImage(named: "exit")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.menuButton.isHidden = false
            self.editMenuButton.isHidden = true
        }
        
        editMenuButton.addMenuItems([woodTexture1, woodTexture2, texture, goBack])
    }
    
    func change(image: UIImage) {
        
        scene.rootNode.childNodes[3].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[4].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[5].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[6].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[7].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[8].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[9].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[11].geometry?.firstMaterial?.diffuse.contents = image
        scene.rootNode.childNodes[10].geometry?.firstMaterial?.diffuse.contents = image
    }
    
    // Blur Effect
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        blurredBackgroundView.alpha = 0.8
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        view.addSubview(blurredBackgroundView)
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
}
