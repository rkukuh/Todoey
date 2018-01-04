//
//  ViewController.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    
    var todoItems = [Item]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let newItem1 = Item()
        let newItem2 = Item()
        let newItem3 = Item()
        
        newItem1.title = "Buy milk"
        todoItems.append(newItem1)
        
        newItem2.title = "Buy eggs"
        newItem2.done = true
        todoItems.append(newItem2)
        
        newItem3.title = "Watch udemy videos"
        todoItems.append(newItem3)
        
        // Prevent from crash if user defaults data is not exists
        if let items = userDefaults.array(forKey: "todoItems") as? [Item] {
            
            todoItems = items
            
        }
        
    }
    
    
    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = todoItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = (item.done) ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Items
    
    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item()
            
            newItem.title = textField.text!
            self.todoItems.append(newItem)
            
            self.userDefaults.setValue(self.todoItems, forKey: "todoItems")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            
            alertTextField.placeholder = "e.g: Study"
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

}

