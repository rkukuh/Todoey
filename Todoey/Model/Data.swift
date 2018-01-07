//
//  Data.swift
//  Todoey
//
//  Created by R. Kukuh on 07/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    
    // The "@objc dynamic" means that these property will be monitored by Realm
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
