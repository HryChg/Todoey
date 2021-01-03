//
//  Category.swift
//  Todoey
//
//  Created by Harry Chuang on 1/1/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    var items = List<Item>()
}
