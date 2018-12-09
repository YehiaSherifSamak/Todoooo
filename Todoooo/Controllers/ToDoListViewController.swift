//
//  ViewController.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/6/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
   // var itemArray  = ["call mama", "buy milk", "call youssef"]
    var itemArray = [Item]()
    
    let defaults =  UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]
//        {
//            itemArray = items;
//        }
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = (itemArray[indexPath.row].done) ? .checkmark : .none;
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK: - TableView Delegarte Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
       // (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ? (tableView.cellForRow(at: indexPath)?.accessoryType = .none) : (tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark);
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    // MARK - adding new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let itemTitle : String = textField.text!
            self.itemArray.append(Item(itemTitle: itemTitle))
            self.tableView.reloadData()
           // self.defaults.set(self.itemArray, forKey: "ToDoListArray");
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField;
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

