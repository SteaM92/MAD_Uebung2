//
//  Album.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/20/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {

    @NSManaged var format: String
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var year: NSDate
    @NSManaged var artist: Artist

}
