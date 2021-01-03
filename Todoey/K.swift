//
//  K.swift
//  Todoey
//
//  Created by Harry Chuang on 12/21/20.
//

import Foundation
import UIKit

struct K {
    static let appName = "Todoey"
    static let itemsSegue = "goToItems"
    static let brandColor = "1D9BF6"
    
    struct SwipeTableViewCell {
        struct Delete {
            static let icon = "delete-icon"
            static let title = "Delete"
        }
        static let rowHeight = CGFloat(80.0)
        static let identifier = "Cell"
    }
}
