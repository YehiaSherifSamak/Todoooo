//
//  CategoryTableViewController.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/12/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm();
    
    //Our Main Varibles
    var categoryArray : Results<Category>?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingData()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet ";
        return cell;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1;
    }
    
    //MARK: - Data Manipulation Methods
    func savingData(category: Category)
    {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error in Saving Categories, \(error)");
        }
        self.tableView.reloadData();
    }
    func loadingData()
    {
         categoryArray = realm.objects(Category.self);
        tableView.reloadData();
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //adding alert
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category();
            newCategory.name = textField.text!;
//            self.categoryArray.append(newCategory);
            self.savingData(category: newCategory);
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category";
            textField = alertTextField;
        }
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    //MARK: - TableView Delagate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // add if statment if you have more than one segue
        let destinationVC = segue.destination as! ToDoListViewController;
        if  let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray?[indexPath.row];
        
        }
    }
}
