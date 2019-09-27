//
//  ListTableViewCell.swift
//  ShoppingList
//
//  Created by Christopher Alegre on 9/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewCell: UITableViewCell {


    var delegate: TableViewCellDelegate?

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        delegate?.checkBoxButtonTapped(self)
    }
}

extension ListTableViewCell {
    func update(list: List) {
        itemLabel.text = list.item
        
        if list.wasBought == false {
            checkBoxButton.setTitle("⬜️", for: .normal)
        } else if list.wasBought == true {
            checkBoxButton.setTitle("☑️", for: .normal)
        }
    }
}

protocol TableViewCellDelegate {
    func checkBoxButtonTapped(_ sender: ListTableViewCell)
}
