//
//  Item.swift
//  Todoey
//
//  Created by R. Kukuh on 08/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    // Attributes
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var created_at : Date?
    
    // Relationships
    
    var belongsTo = LinkingObjects(fromType: Category.self, property: "items")
}
