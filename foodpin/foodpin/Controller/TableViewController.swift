//
//  TableViewController.swift
//  foodpin
//
//  Created by Tsuen Hsueh on 2021/11/1.
//

import UIKit

class TableViewController: UITableViewController {
    
    var restaurants:[Restaurant] = []
    
    //MARK: - UITableView Life Cycle
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize restaurant array
        Restaurant.generateData( sourceArray: &restaurants )
        
        tableView.dataSource = dataSource
        
        //Create the snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // set navigation bar font title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> DiffableDataSource {
        let cellIdentifier = "datacell"
        
        let dataSource = DiffableDataSource (
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
                
                cell.nameLabel?.text = restaurant.name
                cell.thumbnailImageView?.image = UIImage(named: restaurant.image)
                cell.locationLabel?.text = restaurant.location
                cell.typeLabel?.text = restaurant.type
                cell.accessoryType = restaurant.isFavorite ? .checkmark : .none
                return cell
            }
        )
        return dataSource
    }
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let cell = tableView.cellForRow(at: indexPath)
     cell?.accessoryType = .checkmark
     restaurants[indexPath.row].isFavorite = true
     tableView.deselectRow(at: indexPath, animated: false)
     }
     */
    //MARK: - swipe to right action / leading swipe
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action
        let favoriteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
            //update source array
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            //update data source of the tableview
            var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
            snapshot.appendSections([.all])
            snapshot.appendItems(self.restaurants, toSection: .all)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            
            //update cell
            cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none
            
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the action's color and icon
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeConfiguration
    }
    
    //MARK: - swipe to left action / trailing swipe
    
    //delete causes the constraint problem: top margin priority to 750
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            //delete from the table view (datasource and source array are separated: structure type)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            //delete from the source array
            self.restaurants.remove(at: indexPath.row)
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + restaurant.name
            let imageToShare = UIImage(named: restaurant.image)! //make sure always have the image
            
            let activityController: UIActivityViewController
            activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            
            //popover solution code
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        // Change the action's color and icon
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    //MARK: - for segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.restaurantImageName = restaurants[indexPath.row].image
            }
        }
    }
    
}
