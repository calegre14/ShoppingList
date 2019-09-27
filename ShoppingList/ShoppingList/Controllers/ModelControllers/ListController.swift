//
//  ListController.swift
//  ShoppingList
//
//  Created by Christopher Alegre on 9/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import CoreData

class ListController {

    static let shared = ListController()
    
    var fetchResultsController: NSFetchedResultsController<List>
    init() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        let wasBought = NSSortDescriptor(key: "wasBought", ascending: false)
        request.sortDescriptors = [wasBought]
        
        let bigDaddyController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController = bigDaddyController
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }

    func add(item: String, wasBought: Bool) {
       List(item: item, wasBought: wasBought)
        saveToPersistantStorage()
    }
    
    func update(list: List, item:String, wasBought: Bool) {
        list.item = item
        list.wasBought = wasBought
        saveToPersistantStorage()
    }
    
    func delete(list: List) {
        CoreDataStack.context.delete(list)
        saveToPersistantStorage()
    }
    
    func toggle(list: List) {
        list.wasBought.toggle()
        saveToPersistantStorage()
    }
    
    func saveToPersistantStorage() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
}
