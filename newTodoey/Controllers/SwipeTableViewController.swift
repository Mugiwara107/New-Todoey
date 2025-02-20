//
//  SwipeTableViewController.swift
//  Todoey1
//
//  Created by elamiri on 10/07/2020.
//  Copyright © 2020 elamiri. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
            super.viewDidLoad()

            tableView.rowHeight = 80.0
            tableView.separatorStyle = .none
        }
        
        // TableView Datasource Method
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
            
            //let category = categoryArray[indexPath.row]
            
    //        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? " No Categories added yet"
            
            cell.delegate = self
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                print("Deleted cell")
                
                self.updateModel(at: indexPath)
                // handle action by updating model with deletion

        }

            // customize the action appearance
                deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
        
        func updateModel(at indexPath: IndexPath) {
            // Update our data Model
        }

}
