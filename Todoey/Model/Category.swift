//
//  Category.swift
//  Todoey
//
//  Created by R. Kukuh on 08/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    // Attributes
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    // Relationships
    
    let items = List<Item>()
}
