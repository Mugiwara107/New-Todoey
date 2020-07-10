//
//  Category.swift
//  Todoey1
//
//  Created by elamiri on 10/07/2020.
//  Copyright © 2020 elamiri. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
