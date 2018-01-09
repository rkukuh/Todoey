//
//  ViewController.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UITableViewController {
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    
    // Loads selectedCategory with Category once it's set
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType   = (item.done) ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No item, yet."
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            do {
                
                try realm.write {
                    
                    item.done = !item.done
                    
                    tableView.reloadData()
                }
                
            } catch {
                print("ERROR while changing done status: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item",
                                      message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    
                    print("ERROR while saving data: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            
            alertTextField.placeholder = "e.g: Buy milk"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}

// MARK: - SearchBar Methods
// You still can code searchbar's methods inside TodoListVC

/*extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.count == 0) {
            
            loadItems()
            
            // Actually you can resignFirstResponder() the search bar even without DispatchQueue,
            // but it's better having an async thread request
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}*/

