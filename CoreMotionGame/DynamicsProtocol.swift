//
//  DynamicsProtocol.swift
//  CoreMotionGame
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import Foundation

protocol DynamicsProtocol : NSObjectProtocol {
    func removeGravityBehaviour(_ figure: Figure)
    func addGravityBehaviour(_ figure: Figure)
    func updateTheStateOfTheFigure(_ figure: Figure)
}
