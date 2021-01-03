//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Harry Chuang on 1/2/21.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = K.SwipeTableViewCell.rowHeight
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.flatBlack()
    }
    
    func updateNavBarAppearance(_ backgroundColor: UIColor, _ contrastColor: UIColor) {
        // NavigationController variable only gets assigned before the view appear, not when view did load
        // Therfore this method must be called in viewWillAppear instead of viewDidLoad
        guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exists.")}
        
        // Consistent color between Status Bar + Nav Bar https://stackoverflow.com/a/60519849
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
        navBarAppearance.backgroundColor = backgroundColor
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
        navBar.tintColor = contrastColor
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.SwipeTableViewCell.identifier, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    // MARK: - Swipe Cell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: K.SwipeTableViewCell.Delete.title) { (action, indexPath) in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: K.SwipeTableViewCell.Delete.icon)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Implement in Subclass
    }
    
    
}
