//
//  TodoListViewController.swift
//  Todoey1
//
//  Created by elamiri on 10/07/2020.
//  Copyright © 2020 elamiri. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
        
        var todoItems: Results<Item>?
        
        @IBOutlet weak var searchBar: UISearchBar!
        
        var selectedCategory : Category? {
            didSet{
                loadItams()
            }
        }
        
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //let request : NSFetchRequest<Item> = Item.fetchRequest()

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            //print(dataFilePath)
            
            //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            //    itemArray = items
            //}
            
            //let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            //loadItams()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if let colourHex = selectedCategory?.color {
                
                title = selectedCategory!.name
                
                guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
                
                if let navBarColor = UIColor(hexString: colourHex) {
                    
                    navBar.backgroundColor = navBarColor
                    
                    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                    
                    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    searchBar.barTintColor = navBarColor
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
            
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
    //        print(indexPath.row)
    //        print(todoItems!.count)
            
            //print(selectedCategory?.color)
            
            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                
                if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                    
                    cell.backgroundColor = colour
                    cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
                
    //            print("version 1 \(CGFloat(indexPath.row / todoItems!.count))")
    //            print(CGFloat(indexPath.row))
    //            print(CGFloat(todoItems!.count))
    //            print("version 2 \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
                
                // value = condition ? valueIfTrue : valueIfFalse
                
                cell.accessoryType = item.done ? .checkmark : .none
            } else {
                cell.textLabel?.text = " No Items Added yet"
            }
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write{
                        // deleted
                        //realm.delete(item)
                        item.done = !item.done
                    }
                } catch {
                    print("Error saving done status, \(error) ")
                }
            }
            
            tableView.reloadData()
            //print(todoItems[indexPath.row])
            // delete item
    //        context.delete(itemArray[indexPath.row])
    //        itemArray.remove(at: indexPath.row)
            
    //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
    //
    //        saveItems()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item \(error)")
                    }
                }
                
                self.tableView.reloadData()
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create New Item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        func saveItems(item: Item) {
            
            do {
                try realm.write{
                    realm.add(item)
                }
            } catch {
                print("Error save context \(error)")
            }
            self.tableView.reloadData()
        }
        
        func loadItams() {
            
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
            self.tableView.reloadData()
        }
        
        //MARK: - Delete Data From Swipe
        
        override func updateModel(at indexPath: IndexPath) {
            
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write{
                        // deleted
                        realm.delete(item)
                    }
                } catch {
                    print("Error saving done status, \(error) ")
                }
            }
        }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItams(with: request, predicate: predicate)

        //tableView.reloadData()

        print(searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItams()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                print("kkkkkkk")
            }
        }
    }
}

