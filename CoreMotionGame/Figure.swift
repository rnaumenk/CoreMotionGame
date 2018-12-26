//
//  Figure.swift
//  CoreMotionGame
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import Foundation
import UIKit

class Figure: UIView {
    
    private var type : Int?
    
    weak var delegate : DynamicsProtocol?
    
    init(_ point: CGPoint) {
        super.init(frame: CGRect(x: point.x - 50, y: point.y - 50, width: CGFloat(100), height: CGFloat(100)))
        type = 0
        if arc4random_uniform(numericCast(2)) == 0 {
            type = 1
            layer.cornerRadius = 50
        }
        backgroundColor = UIColor.random
        
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:))))
        addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(_:))))
        
        clipsToBounds = true
        isUserInteractionEnabled = true
        
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if self.type == 0 {
            return .rectangle
        } else {
            return .ellipse
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pinchGesture(_ gesture: UIPinchGestureRecognizer)
    {
        switch gesture.state {
        case .began:
            self.delegate?.removeGravityBehaviour(self)
        case .changed:
            let side = frame.width * gesture.scale
            if side <= UIScreen.main.bounds.width && side <= UIScreen.main.bounds.height && side > 0 {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: side, height: side)
                if frame.width > frame.height {
                    frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.height, height: frame.height)
                }
                else if frame.width < frame.height {
                    frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width)
                }
                if type == 1 {
                    layer.cornerRadius = frame.width / 2
                }
                self.delegate?.updateTheStateOfTheFigure(self)
            }
        case .ended:
            self.delegate?.addGravityBehaviour(self)
        default:
            break
        }
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            self.delegate?.removeGravityBehaviour(self)
        case .changed:
            center = gesture.location(in: superview)
            self.delegate?.updateTheStateOfTheFigure(self)
        case .ended:
            self.delegate?.addGravityBehaviour(self)
        default:
            break
        }
    }
    
    @objc func rotationGesture(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.delegate?.removeGravityBehaviour(self)
        case .changed:
            transform = CGAffineTransform(rotationAngle: gesture.rotation)
            self.delegate?.updateTheStateOfTheFigure(self)
        case .ended:
            self.delegate?.addGravityBehaviour(self)
        default:
            break
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}

