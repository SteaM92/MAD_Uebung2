//
//  Artist.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/20/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import Foundation
import CoreData

class Artist: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var label: String
    @NSManaged var name: String
    @NSManaged var albums: NSSet

}
