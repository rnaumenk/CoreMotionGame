//
//  ViewController.swift
//  CoreMotionGame
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, DynamicsProtocol {
    
    private var figures : [Figure] = []
    private var dynamicAnimator : UIDynamicAnimator!
    private var gravityBehaviour : UIGravityBehavior!
    private var collisionBehavior: UICollisionBehavior!
    private var elasticityBehavior: UIDynamicItemBehavior!
    private var motionManager: CMMotionManager!
    
    @IBOutlet weak var tapLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapLabel.text = "Tap on screen"
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravityBehaviour = UIGravityBehavior()
        elasticityBehavior = UIDynamicItemBehavior()
        collisionBehavior = UICollisionBehavior()
        
        gravityBehaviour.magnitude = 1
        elasticityBehavior.elasticity = 0.6
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        dynamicAnimator.addBehavior(gravityBehaviour)
        dynamicAnimator.addBehavior(collisionBehavior)
        dynamicAnimator.addBehavior(elasticityBehavior)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager = CMMotionManager()
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: accelerometerHandler)
        }
    }
    
    func removeGravityBehaviour(_ figure: Figure) {
        gravityBehaviour.removeItem(figure)
    }
    
    func updateTheStateOfTheFigure(_ figure: Figure) {
        collisionBehavior.removeItem(figure)
        elasticityBehavior.removeItem(figure)
        dynamicAnimator.updateItem(usingCurrentState: figure)
        collisionBehavior.addItem(figure)
        elasticityBehavior.addItem(figure)
    }
    
    func addGravityBehaviour(_ figure: Figure) {
        gravityBehaviour.addItem(figure)
    }
    
    private func accelerometerHandler(data: CMAccelerometerData?, error: Error?) {
        
        if let myData = data {
            let x = CGFloat(myData.acceleration.x)
            let y = CGFloat(myData.acceleration.y)
            let v = CGVector(dx: x, dy: -y)
            gravityBehaviour.gravityDirection = v
        }
    }
    
    private func createNewFigure(_ point: CGPoint) {
        figures.append(Figure(point))
        figures.last!.delegate = self
        view.addSubview(figures.last!)
        gravityBehaviour.addItem(figures.last!)
        collisionBehavior.addItem(figures.last!)
        elasticityBehavior.addItem(figures.last!)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
            self.tapLabel.alpha = 0.0
        }, completion: nil)
        
        switch sender.state {
        case .ended:
            createNewFigure(sender.location(in: view))
        default:
            break
        }
        
    }
    
}
