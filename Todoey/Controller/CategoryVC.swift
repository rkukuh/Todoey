//
//  CategoryVC.swift
//  Todoey
//
//  Created by R. Kukuh on 07/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadCategories()
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categories = categories?[indexPath.row] {
            
            cell.textLabel?.text = categories.name
            cell.backgroundColor = UIColor(hexString: (categories.color))
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("ERROR while saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
                         .sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        
        if let categoryDeletable = self.categories?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryDeletable)
                }
            } catch {
                print("ERROR while deleting category: \(error)")
            }
        }
    }
    
    @IBAction func addCategoryButton_Pressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category",
                                      message: nil,
                                      preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (field) in
            
            textField = field
            
            textField.placeholder = "e.g: Work, School, Project"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name  = (textField.text?.count == 0) ? "New Category" : textField.text!
            newCategory.color = UIColor(randomFlatColorOf: UIShadeStyle.light, withAlpha: 0.25).hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

