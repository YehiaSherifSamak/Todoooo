//
//  ViewController.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/6/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
   // var itemArray  = ["call mama", "buy milk", "call youssef"]
    var itemArray : Results<Item>?
    var selectedCategory : Category?
    {
        didSet{
            loadItems();
        }
    }
    let realm = try! Realm()
//    let defaults =  UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadItems()
//        loadItemsFromFile()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]
//        {
//            itemArray = items;
//        }
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
          if let item = itemArray?[indexPath.row]
        {
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done) ? .checkmark : .none;
       
          }else{
            cell.textLabel?.text =  "No Items Added"
        }
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1;
    }
    
    
    //MARK: - TableView Delegarte Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]
        {
            do{
                try! realm.write {
                   item.done = !item.done;
                   realm.delete(item)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData();
    }
    // MARK: - adding new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let itemTitle : String = textField.text!
           
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemTitle
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Errot in saving items, \(error)");
                }
            }
            self.tableView.reloadData();
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField;
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
 
    func loadItems()
    {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true);
        tableView.reloadData()
    }
    func savingData(add item : Item)
    {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch  {
            print("Error in Saving Categories, \(error)");
        }
        self.tableView.reloadData();
    }
   
}

//MARK: - SearchBar
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true);
        tableView.reloadData();
}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0
        {
            loadItems();
            
            //to make sure that it happen immediatilly
            //should be happpen when we code somthing to UI but only changes the UI
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();// to remove the keyboard and the cursure
            }
            
        
        }
    }
}
