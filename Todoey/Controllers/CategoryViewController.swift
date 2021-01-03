//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Harry Chuang on 1/1/21.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundColor = UIColor(hexString:K.brandColor)!
        let contrastColor = ContrastColorOf(backgroundColor, returnFlat: true)
        super.updateNavBarAppearance(backgroundColor, contrastColor)
    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError("Category color does not exists.")}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Categories Added Yet"
            cell.backgroundColor = UIColor(hexString: K.brandColor)
        }
        return cell
    }
        
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.itemsSegue, sender: self)
    }
    
    // MARK: - Data Manipulation Methods

    func saveCategory (name: String, color: String = UIColor.randomFlat().hexValue()) {
        do {
            try realm.write{
                let newCategory = Category()
                newCategory.name = name
                newCategory.color = color
                realm.add(newCategory)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories () {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func deleteCategory(at index: Int) {
        if let category = categories?[index] {
            do {
                try realm.write{
                    realm.delete(category.items)
                    realm.delete(category)
                }
            } catch {
                print ("Error deleting catogry, \(error)")
            }
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
        }
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard let answer = alert.textFields?[0].text else {return}
            
            // create a new category
            self.saveCategory(name: answer)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(row: (self.categories?.count ?? 1)-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Swipe Table VC Methods
    
    override func updateModel(at indexPath: IndexPath) {
        deleteCategory(at: indexPath.row)
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.itemsSegue {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}
