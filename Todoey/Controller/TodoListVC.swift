//
//  ViewController.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableVC {
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Loads selectedCategory with Category once it's set
    var selectedCategory : Category! {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // DEBUG: Print app's data location
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // NOTE: Since navigationBar only exists AFTER viewDidLoad(),
    // then this one is the correct event to change its tint color
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory.name
        
        updateNavBar(withHexCodeColor: selectedCategory.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCodeColor: "1D9BF6")
    }
    
    // MARK: - NavigationBar Methods
    
    func updateNavBar(withHexCodeColor hexCode : String) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("ERROR: NavigationBar does not exists")
        }
        
        guard let tintColor = HexColor(hexCode) else { fatalError() }
        
        navBar.barTintColor = tintColor
        navBar.tintColor = ContrastColorOf(tintColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor:
                ContrastColorOf(tintColor, returnFlat: true)
        ]
        
        searchBar.barTintColor = tintColor
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType   = (item.done) ? .checkmark : .none
            
            if let categoryColor = UIColor(hexString: selectedCategory.color) {
                
                let cellColor = categoryColor.darken(
                    byPercentage: CGFloat(indexPath.row) / CGFloat((items?.count)!)
                )
                
                cell.backgroundColor = cellColor
                cell.textLabel?.textColor = ContrastColorOf(cellColor!, returnFlat: true)
            }
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            do {
                try realm.write {
                    
                    item.done = !item.done
                    
                    // If you want to delete the item instead of updating, here's how:
                    // realm.delete(item)
                    
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
        
        let alert = UIAlertController(title: "Add New Todo Item",
                                      message: "",
                                      preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            
            alertTextField.placeholder = "e.g: Buy milk"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            do {
                try self.realm.write {
                    
                    let newItem = Item()
                    
                    newItem.title = (textField.text?.count == 0) ? "New Item" : textField.text!
                    newItem.created_at = Date()
                    
                    self.selectedCategory.items.append(newItem)
                }
            } catch {
                
                print("ERROR while saving data: \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        items = selectedCategory.items.sorted(byKeyPath: "created_at", ascending: false)
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("ERROR while deleting item: \(error)")
            }
        }
    }

}


// MARK: - SearchBar Methods
// You still can code searchbar's methods inside TodoListVC

extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)
                     .sorted(byKeyPath: "created_at", ascending: false)
        
        tableView.reloadData()
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
}

