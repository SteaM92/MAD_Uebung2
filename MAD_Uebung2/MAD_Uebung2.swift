//
//  MAD_Uebung2.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/27/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import Foundation
import CoreData

class MAD_Uebung2: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var label: String
    @NSManaged var name: String
    @NSManaged var albums: NSSet

}
