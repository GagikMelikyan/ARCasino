//
//  ViewController.swift
//  AR Casino
//
//  Created by Garush Batikyan on 12/20/18.
//  Copyright © 2018 Garush Batikyan. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation
import ARKit
import SpriteKit
import ExpandingMenu
import Firebase

class GameVIewController: UIViewController, ARSCNViewDelegate, BlurredEffectDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var balanceBackground: UIVisualEffectView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func removeSlot() {
        scene.rootNode.removeFromParentNode()
        removeButton.isHidden = true
        slotAdded = false
    }
    
    var planes = [ARPlaneAnchor: Plane]()
    var playing = false
    let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
    var menuButton: ExpandingMenuButton!
    var editMenuButton: ExpandingMenuButton!
    var slotAdded: Bool = false
    var slotRollPosition: [Int] = [0, 0, 0]
    var startBalance: String = ""
    let userId = UserDefaults.standard.string(forKey: "userId")
    var balance = 0
    var history: History!
    var dailyHistory: DailyHistory!
    let scene = SCNScene(named: "art.scnassets/untitled.dae")!
    let date = Date()
    var gamesCount = 0
    private var ref: DatabaseReference  = Database.database().reference()
    private var today: String!
    let formatter = DateFormatter()
    private var currDateStamp: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "dd.MM.yyyy"
      //  ref.child("ServerTime").setValue(ServerValue.timestamp())
        today = formatter.string(from: Date())
        getTodayDate()
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { [weak self] (snapshot)  in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                UIApplication.appDelegate.user = User(user: value as! [String : String])
                if let balance = UIApplication.appDelegate.user.userInfo["balance"] {
                    self!.balance = Int(balance)!
                    self!.startBalance = balance
                    self!.balanceLabel.text = balance
//                    self!.dailyCheckIn()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        balanceBackground.alpha = 0.8
        balanceBackground.effect = UIBlurEffect(style: .light)
        
        view.isMultipleTouchEnabled = true
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.automaticallyUpdatesLighting = false
        // Create a new scene
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GameVIewController.handlePitch(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(GameVIewController.rotatePiece(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let balance = UIApplication.appDelegate.user.userInfo["balance"] {
            self.balance = Int(balance)!
            self.startBalance = balance
        }
        balanceLabel.text = String(balance)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
//        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        navigationController?.navigationBar.isHidden = true
        let historyDictionaty =  ["Date": today!,
                                  "StartBalance": startBalance,
                                  "FinishBalance": ""]
        history = History(historyDictionaty)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.appDelegate.user.userInfo["balance"] = String(balance)
        self.ref.child("users").child(self.userId!).updateChildValues(UIApplication.appDelegate.user.userInfo)
        
        if gamesCount != 0 {
            // History
            history.finishBalance = String(balance)
            history.date = today
            UIApplication.appDelegate.user.addHistory(history: history)
        }
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if !slotAdded {
            addSlot(touches)
        } else {
            let touchLocation = touches.first?.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(touchLocation!)
            guard let node = hitTestResults.first?.node else {
            return
            }
            DispatchQueue.main.async {
                if node.name == "handle" || node.name == "handleBall" || node.name == "Cube_002" {   // erevi dnenq aparatin
                    self.play()
                }
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if slotAdded {
            return
        } else {
            if anchor is ARPlaneAnchor {
                
                DispatchQueue.main.async {
                    if let planeAnchor = anchor as? ARPlaneAnchor {
                        self.addPlane(node: node, anchor: planeAnchor)
                    }
                }
            } else {
                return
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //MARK-Functions
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func addSlot(_ touches: Set<UITouch>) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first {
                let slotNode = scene.rootNode
                slotNode.position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: hitResult.worldTransform.columns.3.y + slotNode.boundingSphere.radius,
                    z: hitResult.worldTransform.columns.3.z - 0.4
                )
                let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
                let rotateTransform = simd_mul(hitResult.worldTransform, rotate)
                slotNode.transform = SCNMatrix4(rotateTransform)
                slotNode.scale = SCNVector3(0.03, 0.03, 0.03)
                sceneView.node(for: hitResult.anchor!)?.removeFromParentNode()
                for plane in planes {
                    sceneView.node(for: plane.key)?.removeFromParentNode()
                }
                
                sceneView.scene.rootNode.addChildNode(slotNode)
                DispatchQueue.main.async {
                    self.removeButton.isHidden = false
                }
                slotAdded = true
            }
        }
    }
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        node.addChildNode(plane)
        planes[anchor] = plane
    }
    
    func play() {
        
        if !playing && balance >= 10 {
            //
            if  UserDefaults.standard.bool(forKey: "isSoundOn") {
                AudioPlayer.sharedInstance.coinSoundPlay()
            }
            startBalance = String(self.balance)
            let slotNode = scene.rootNode
            playing = true
            let r1 = CGFloat((arc4random_uniform(8) + 1))
            let r2 = CGFloat((arc4random_uniform(8) + 1))
            let r3 = CGFloat((arc4random_uniform(8) + 1))
            
            let random1 = (r1 * (2 * CGFloat.pi/9)) * 40
            let random2 = (r2 * (2 * CGFloat.pi/9)) * 40
            let random3 = (r3 * (2 * CGFloat.pi/9)) * 40
            
            let roll1 = slotNode.childNode(withName: "roll1", recursively: true)!
            let roll2 = slotNode.childNode(withName: "roll2", recursively: true)!
            let roll3 = slotNode.childNode(withName: "roll3", recursively: true)!
            let handle = slotNode.childNode(withName: "handle", recursively: true)!
            
            let sequence = SCNAction.sequence([SCNAction.rotate(by: CGFloat.pi/4 , around: SCNVector3(1, 0, 0), duration: 0.2),
                                               SCNAction.rotate(by: -CGFloat.pi/4 , around: SCNVector3(1, 0, 0), duration: 0.2)])
            
            handle.runAction(sequence)
            
            if UserDefaults.standard.bool(forKey: "isSoundOn") {
                AudioPlayer.sharedInstance.rollSoundPlay()
            }
            
            roll1.runAction(SCNAction.rotate(by: random1 , around: SCNVector3(1, 0, 0), duration: 3))
            roll2.runAction(SCNAction.rotate(by: random2 , around: SCNVector3(1, 0, 0), duration: 4))
            roll3.runAction(SCNAction.rotate(by: random3 , around: SCNVector3(1, 0, 0), duration: 5)) {

                if UserDefaults.standard.bool(forKey: "isSoundOn") {
                    AudioPlayer.sharedInstance.rollSoundStop()
                }
                
                DispatchQueue.main.async {
                    
                    let a1 = self.slotRollPosition[0] % 9
                    let a2 = self.slotRollPosition[1] % 9
                    let a3 = self.slotRollPosition[2] % 9
                    self.playing = false
                    if a1 == a2 && a2 == a3 {
                        self.balance += 400
                        self.balanceLabel.text = String(self.balance)
                        UIApplication.appDelegate.user.userInfo["balance"] = String(self.balance)
                        self.startFirework()
                        if  UserDefaults.standard.bool(forKey: "isSoundOn"){
                            AudioPlayer.sharedInstance.winnewSoundPlay()
                        }
                        self.ref.child("users").child(self.userId!).updateChildValues(UIApplication.appDelegate.user.userInfo )
                    } else if a1 == a2 || a2 == a3 || a1 == a3 {
                        self.balance += 40
                        self.balanceLabel.text = String(self.balance)
                        UIApplication.appDelegate.user.userInfo["balance"] = String(self.balance)
                        self.ref.child("users").child(self.userId!).updateChildValues(UIApplication.appDelegate.user.userInfo )
                        self.startFirework()
                        if  UserDefaults.standard.bool(forKey: "isSoundOn") {
                            AudioPlayer.sharedInstance.winnewSoundPlay()
                        }
                    } else {
                        self.balance -= 10
                        self.balanceLabel.text = String(self.balance)
                        UIApplication.appDelegate.user.userInfo["balance"] = String(self.balance)
                        self.ref.child("users").child(self.userId!).updateChildValues(UIApplication.appDelegate.user.userInfo )
                    }
                }
                DispatchQueue.main.async {
                    self.addDailyHistory()
                }
                
            }
            
            slotRollPosition[0] += Int(r1)
            slotRollPosition[1] += Int(r2)
            slotRollPosition[2] += Int(r3)
            gamesCount += 1
        }
    }
    
    @objc func handlePitch(withGestureRecognizer recognizer: UIPinchGestureRecognizer) {
        let node = scene.rootNode
        if (recognizer.state == .changed) {
            
            let pinchScaleX = Float(recognizer.scale) * node.scale.x
            let pinchScaleY =  Float(recognizer.scale) * node.scale.y
            let pinchScaleZ =  Float(recognizer.scale) * node.scale.z
            
            node.scale = SCNVector3(x: Float(pinchScaleX), y: Float(pinchScaleY), z: Float(pinchScaleZ))
            recognizer.scale = 1
        }
    }
    
    //MARK: - Menu functions
    func configMenu() {
        
        let musicMenuItem = ExpandingMenuItem(size: menuButtonSize, title: "Sound", image: UIImage(named: "music")!, highlightedImage: UIImage(named: "music")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            
            self.overlayBlurredBackgroundView()
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let editMenuItem = ExpandingMenuItem(size: menuButtonSize, title: "Colors", image: UIImage(named: "edit")!, highlightedImage: UIImage(named: "edit")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            
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
        sceneView.addSubview(blurredBackgroundView)
    }
    
    func removeBlurredBackgroundView() {
        for subview in sceneView.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func startFirework() {
        let node = SKEmitterNode(fileNamed: "CoinParticle")
        node?.position = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        
        let skScene = SKScene(size: UIScreen.main.bounds.size)
        skScene.addChild(node!)
        
        sceneView.overlaySKScene = skScene
        sceneView.overlaySKScene!.scaleMode = .resizeFill

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //    skScene.removeFromParent()
        //    skScene.removeAllChildren()
            self.sceneView.overlaySKScene = nil
        }
    }
    
    func getTodayDate(){
        ref.child("ServerTime").setValue(ServerValue.timestamp())
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot)  in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                self!.currDateStamp = value!["ServerTime"] as? Double
                self!.today = self!.changeTimeStampToDate(self!.currDateStamp)
                self!.getLastLaunchDate()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getLastLaunchDate() {
        ref.child("userDailyCheckin").child(userId!).observeSingleEvent(of: .value, with: { [weak self] (snapshot)  in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let timeStamp = value!["lastLaunch"] as? Double
                let dayCount = value!["count"] as? Int
                self!.dailyCheckIn(timeStamp: timeStamp!, count: dayCount!)
            } else {
                self!.dailyCheckIn(timeStamp: self!.currDateStamp!, count: 1)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func dailyCheckIn(timeStamp: Double, count: Int) {
        var daysCount = count
        let lastLaunch = changeTimeStampToDate(timeStamp)
        if lastLaunch != "" && lastLaunch != today {

            let dateToday = formatter.date(from: today)!
            let dateLastLaunch = formatter.date(from: lastLaunch)!
            let components = Calendar.current.dateComponents([.day], from: dateLastLaunch, to: dateToday)
            if let dayDifference = components.day {
                if dayDifference == 1 {
                    
                    self.definesPresentationContext = true
                    self.providesPresentationContextTransitionStyle = true
                    self.overlayBlurredBackgroundView()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DailyRewardViewController") as! DailyRewardViewController
                    vc.daysCount = Double(daysCount)
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                    
                    if daysCount == 3 {
                        daysCount = 1
                        UIApplication.appDelegate.user.userInfo["balance"]! =  String(Int(UIApplication.appDelegate.user.userInfo["balance"]!)! + 500)
                    } else {
                        if daysCount == 2 {
                            UIApplication.appDelegate.user.userInfo["balance"]! =  String(Int(UIApplication.appDelegate.user.userInfo["balance"]!)! + 200)
                            daysCount += 1
                        } else {
                            daysCount += 1
                            UIApplication.appDelegate.user.userInfo["balance"]! =  String(Int(UIApplication.appDelegate.user.userInfo["balance"]!)! + 100)
                        }
                    }
                    
                    self.ref.child("users").child(self.userId!).updateChildValues(UIApplication.appDelegate.user.userInfo)
                    
//                    ref.child("userDailyCheckin").child(userId!).setValue(["lastLaunch": currDateStamp,
//                                                                           "count": daysCount])
                    self.balance = Int(UIApplication.appDelegate.user.userInfo["balance"]!)!
                    self.balanceLabel.text = String(self.balance)
                    history.finishBalance = String(balance)
                    history.date = today
                    addDailyHistory()
                } //else {
                ref.child("userDailyCheckin").child(userId!).setValue(["lastLaunch": currDateStamp,
                                                                           "count": daysCount])
                //}
            }
           
        } else {
            // Update the last launch value
            daysCount = 1
            ref.child("userDailyCheckin").child(userId!).setValue(["lastLaunch": currDateStamp,
                                                                   "count": daysCount])
        }
    }

    func addDailyHistory() {
        let formatterHours = DateFormatter()
        formatterHours.dateFormat = "HH:mm:ss" // "a" prints "pm" or "am"
        let hourString = formatterHours.string(from: Date()) // "12 AM"
        self.dailyHistory = DailyHistory(time: hourString, date: self.today!, startBalance: startBalance, finishBalance: String(self.balance))
        DispatchQueue.main.async {
            UIApplication.appDelegate.user.addDailyHistory(dailyHistory: self.dailyHistory)
        }
    }
    
    func changeTimeStampToDate(_ timeStamp: Double) -> String {
        
        let interval = TimeInterval(timeStamp)
        let date =  formatter.string(from: NSDate(timeIntervalSince1970: interval/1000) as Date)
        return date
    }
 
    @objc func rotatePiece(withGestureRecognizer gestureRecognizer : UIRotationGestureRecognizer) {   // Move the anchor point of the view's layer to the center of the
        let node = scene.rootNode
        var currentAngleY: Float = 0.0
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gestureRecognizer.rotation)
        
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gestureRecognizer.state == .changed{
            
            node.eulerAngles.y = currentAngleY + rotation
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gestureRecognizer.state == .ended) {
            currentAngleY = node.eulerAngles.y
        }
    }
    
}

//
