//
//  ViewController.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    var todoItems = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // loadItems()
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
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add New Items
    
    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
            self.todoItems.append(newItem)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            
            alertTextField.placeholder = "e.g: Study"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model manipulation methods
    
    func saveItem() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Error saving context: \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    /*func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {

                todoItems = try decoder.decode([Item].self, from: data)
                
            } catch {
                
                print("Error when decode items: \(error)")
                
            }
            
        }
    }*/

}

