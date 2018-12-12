//
//  ViewController.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/6/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
   // var itemArray  = ["call mama", "buy milk", "call youssef"]
    var itemArray : Array<Item> = [Item]()
    var selectedCategory : Category?
    {
        didSet{
            loadItems();
        }
    }
    
//    let defaults =  UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //to load coredata object
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        saveItemIntoFile()
    }
    // MARK: - adding new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let itemTitle : String = textField.text!
            //ToDo: - load object from coredata class
            
           
            let newItem = Item(context: self.context)
            newItem.title = itemTitle
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory;
            self.itemArray.append(newItem)
            //self.itemArray.append(Item(itemTitle: itemTitle))
           // self.defaults.set(self.itemArray, forKey: "ToDoListArray");
            
            self.saveItemIntoFile()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField;
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
     // Mark: - Saving data into file
    func saveItemIntoFile()
    {
        
//        let encoder = PropertyListEncoder();
        do
        {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!);
             try context.save()
            
        }
        catch
        {
            print("Error saving item array , \(error)");
        }
        self.tableView.reloadData()
    }
    
//    func loadItemsFromFile()
//    {
//        if let data = try? Data(contentsOf: dataFilePath!)
//        {
//            let decoder = PropertyListDecoder()
//            do
//            {
//                try context.save()
//               itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch
//            {
//                print("loading item array error, \(error)");
//            }
//
//        }
//    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicte : NSPredicate? = nil)
    {
//        let request : NSFetchRequest<Item>  = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);
        if let addtionalPredicate = predicte
        {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate]);
             request.predicate = compoundPredicate;
            
        }
        else
        {
            request.predicate = categoryPredicate;
        }
      
       
        do
        {
            itemArray =  try context.fetch(request)
            
        }
        catch
        {
            print ("fetching error \(error)");
        }
        tableView.reloadData()
    }
    
   
}

//MARK: - SearchBar
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
//        request.predicate = predicate;
        
        let sortDesriptor = NSSortDescriptor(key: "title", ascending: true);
        request.sortDescriptors = [sortDesriptor];
        
       loadItems(with: request, predicte: predicate)
//        print("ana hna ")
        
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
