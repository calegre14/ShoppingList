//
//  ListTableViewController.swift
//  ShoppingList
//
//  Created by Christopher Alegre on 9/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, TableViewCellDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.shared.fetchResultsController.delegate = self
        
    }
    //MARK: Alert Action
    
    @IBAction func newItemButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add an Item", message: "Let's go shopping", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addItem = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let newItem = alert.textFields?[0].text else {return}
            ListController.shared.add(item: newItem, wasBought: false)
        }
        alert.addTextField { (_) in }
        alert.addAction(cancel)
        alert.addAction(addItem)
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        ListController.shared.fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListController.shared.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListTableViewCell else {return UITableViewCell()}
        let list = ListController.shared.fetchResultsController.object(at: indexPath)
        cell.update(list: list)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = ListController.shared.fetchResultsController.object(at: indexPath)
            ListController.shared.delete(list: list)
            
        } else if editingStyle == .insert {
        }
    }
    
    func checkBoxButtonTapped(_ sender: ListTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else {return}
        let list = ListController.shared.fetchResultsController.object(at: index)
        ListController.shared.toggle(list: list)
        sender.update(list: list)
    }
}//End of Class


extension ListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: return
        }
    }
}
