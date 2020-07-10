//
//  CategoryViewController.swift
//  Todoey1
//
//  Created by elamiri on 10/07/2020.
//  Copyright © 2020 elamiri. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let config = Realm.Configuration(fileURL:Realm.Configuration.defaultConfiguration.fileURL)
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categorys.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var encryptionKey: Data?
        
        print(Realm.Configuration.defaultConfiguration)

        loadItams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
                
                navBar.backgroundColor = UIColor(hexString: "000000")
            
    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //let category = categoryArray[indexPath.row]
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
                
                cell.backgroundColor = categoryColor
                
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        }
        
        
        return cell
    }
    
    //MARK: - TableView Delagate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(categoryArray[indexPath.row])
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //saveCategory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            //encoder.outputFormat = .xml
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error save context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItams() {
        categoryArray = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categorys = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write{
                    // deleted
                    self.realm.delete(categorys)
                }
            } catch {
                print("Error saving done status, \(error) ")
            }
        }
    }
}
