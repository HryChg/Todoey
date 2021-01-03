//
//  ViewController.swift
//  Todoey
//
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedCategory?.name ?? K.appName
        let backgroundColor = UIColor(hexString: selectedCategory?.color ?? K.brandColor)!
        let contrastColor = ContrastColorOf(backgroundColor, returnFlat: true)
        super.updateNavBarAppearance(backgroundColor, contrastColor)
        searchBar.barTintColor = backgroundColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: contrastColor]
    }
    
    // MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
            cell.backgroundColor = UIColor(hexString: K.brandColor)
        }
        
        let baseColor = UIColor(hexString: selectedCategory?.color ?? K.brandColor)!
        cell.backgroundColor = baseColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))!
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    // MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let answer = alert.textFields?[0].text else { return }
            
            if let currentCateory = self.selectedCategory {
                self.saveItem(name: answer, parentCategory: currentCateory)
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    func saveItem(name: String, parentCategory: Category) {
        do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = name
                newItem.dateCreated = Date()
                parentCategory.items.append(newItem)
            }
        } catch {
            print("Error saving item, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems () {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func deleteItem(at index: Int) {
        if let item = todoItems?[index] {
            do {
                try realm.write{ realm.delete(item) }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    func toggleItem(at index: Int) {
        if let item = todoItems?[index] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(item)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Swipe Table VC Methods
    
    override func updateModel(at indexPath: IndexPath) {
        deleteItem(at: indexPath.row)
    }
}

// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
