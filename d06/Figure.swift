//
//  Figure.swift
//  d06
//
//  Created by Ruslan NAUMENKO on 10/10/18.
//  Copyright © 2018 Ruslan NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

class Figure: UIView {
    
    var type : Int?
    
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
        
        //????
        clipsToBounds = true
        layer.masksToBounds = true
        isUserInteractionEnabled = true

    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if (self.type == 0) {
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
            if gesture.scale < 1.0 && layer.bounds.width <= 5 {
                break
            }
            let side = layer.bounds.width * gesture.scale
            if side <= UIScreen.main.bounds.width && side <= UIScreen.main.bounds.height && side > 0 {
                layer.bounds = CGRect(x: layer.bounds.origin.x, y: layer.bounds.origin.y, width: side, height: side)
                if layer.bounds.width > layer.bounds.height {
                    layer.bounds = CGRect(x: layer.bounds.origin.x, y: layer.bounds.origin.y, width: layer.bounds.height, height: layer.bounds.height)
                }
                else if layer.bounds.width < layer.bounds.height {
                    layer.bounds = CGRect(x: layer.bounds.origin.x, y: layer.bounds.origin.y, width: layer.bounds.width, height: layer.bounds.width)
                }
                if type == 1 {
                    layer.cornerRadius = layer.bounds.width / 2
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
