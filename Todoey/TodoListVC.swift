//
//  ViewController.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    let todoItems = [
        "Buy milk",
        "Buy eggs",
        "Watch udemy videos"
    ]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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

}

