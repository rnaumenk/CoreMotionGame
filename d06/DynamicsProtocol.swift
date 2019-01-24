//
//  DynamicsProtocol.swift
//  d06
//
//  Created by Ruslan NAUMENKO on 10/10/18.
//  Copyright © 2018 Ruslan NAUMENKO. All rights reserved.
//

import Foundation
import UIKit

protocol DynamicsProtocol : NSObjectProtocol {
    func removeGravityBehaviour(_ figure: Figure)
    func addGravityBehaviour(_ figure: Figure)
    func updateTheStateOfTheFigure(_ figure: Figure)
}

