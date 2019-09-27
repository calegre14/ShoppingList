//
//  List+Con.swift
//  ShoppingList
//
//  Created by Christopher Alegre on 9/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import CoreData

extension List {
    @discardableResult
    convenience init(item: String, wasBought: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.item = item
        self.wasBought = wasBought
    }
    
}
