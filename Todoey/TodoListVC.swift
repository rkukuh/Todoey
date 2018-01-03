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
    
    var todoItems = [
        "Buy milk",
        "Buy eggs",
        "Watch udemy videos"
    ]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Prevent from crash if user defaults data is not exists
        if let items = userDefaults.array(forKey: "todoListItems") as? [String] {
            
            todoItems = items
            
        }
        
    }
    
    
    //MARK: TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItems[indexPath.row]
        
        return cell
        
    }
    
    
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(todoItems[indexPath.row])
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add New Items
    
    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            self.todoItems.append(textField.text!)
            
            self.userDefaults.setValue(self.todoItems, forKey: "todoListItems")
            
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

