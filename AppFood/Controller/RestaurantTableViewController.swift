//
//  RestaurantTableViewController.swift
//  AppFood
//
//  Created by MRGS on 11.06.2022.
//

import UIKit
import CoreData
class RestaurantTableViewController: UITableViewController {
    @IBOutlet var emptyRestaurantView: UIView!
    var searchController: UISearchController!
    var restaurants:[Restaurant] = []
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    lazy var dataSource = configureDataSource() //initial value cannot be retrieved until after the instance initialization completes.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        customNavBar()
        
        showBackgroundView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        fetchRestaurantData()
        customSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
            }
        }
    }
    func showBackgroundView()  {
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    func updateSnapshot(animatingChange: Bool = false) {
        if let fetchedObjects = fetchResultController.fetchedObjects {
            restaurants = fetchedObjects
        }
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false :
        true
    }
    func fetchRestaurantData(searchText:String = "") {
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        if !searchText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@",searchText)
        }
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                updateSnapshot(animatingChange: searchText.isEmpty ? false : true)
            } catch {
                print(error)
            }
            
        }
    }
    func customNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonTitle = ""
        
        //Смена шрифта + размера
        if let appearance = navigationController?.navigationBar.standardAppearance
        {
            appearance.configureWithTransparentBackground()
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    func customSearchController(){
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(named: "NavigationBarTitle")
    }
    // MARK: - Table view data source
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        let cellID = "datacell"
        
        let dataSource = RestaurantDiffableDataSource (tableView: tableView) { tableView, indexPath, restaurant in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RestaurantTableViewCell
            cell.nameLabel?.text = restaurant.name // restaruntname
            cell.locationLabel.text = self.restaurants[indexPath.row].location
            cell.typeLabel.text = self.restaurants[indexPath.row].type
            cell.thumbnailImageView?.image = UIImage(data: restaurant.image)
            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite ? false : true
            return cell
        }
        return dataSource
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        if searchController.isActive {
            return UISwipeActionsConfiguration()
        }
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                // Delete the item
                context.delete(restaurant)
                appDelegate.saveContext()
                // Update the view
                self.updateSnapshot(animatingChange: true)
            }
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        let favoriteLabel = self.restaurants[indexPath.row].isFavorite ? "Dislike" : "Like"
        let favoriteAction = UIContextualAction(style: .destructive, title: favoriteLabel) { (action, sourceView, completionHandler) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
                
                cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
                
                self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
                
                // Call completion handler to dismiss the action button
                completionHandler(true)
                
                appDelegate.saveContext()
                // Update the view
                self.updateSnapshot(animatingChange: true)
            }
            
        }
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            
            let defaultText = "Just checking in at " + restaurant.name
            let activityController: UIActivityViewController
            
            if let imageToShare = UIImage(data: restaurant.image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil) }else {
                    activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                }
            self.present(activityController, animated: true, completion: nil)
            if let popoverController = activityController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            completionHandler(true)
        }
        // Configure swipe action
        favoriteAction.backgroundColor = UIColor.link
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction,favoriteAction])
        return swipeConfiguration
    }
    
    
}
extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
extension RestaurantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        fetchRestaurantData(searchText: searchText)
    }
}
// MARK: - Old
//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Create an option menu as an action sheet
//        let optionMenu = UIAlertController(title: nil, message: "Что вы хотите сделать?", preferredStyle: .actionSheet)
//        // Add actions to the menu
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//
//        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default){ action in
//            let alertMessage = UIAlertController(title: "Пока не доступно", message: "Извините, эта функция пока недоступна. Пожалуйста, повторите попытку позже.", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "Принять", style: .default,handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//
//        // Mark as favorite action
//        let favoriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Удалить из любимых" : "Отметить как любимое"
//        let favoriteAction = UIAlertAction(title: favoriteActionTitle, style: .default, handler: { action in
//            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
//
//            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
//        })
//        optionMenu.addAction(cancelAction)
//        optionMenu.addAction(reserveAction)
//        optionMenu.addAction(favoriteAction)
//        //alertAction for iPads
//        if let popoverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//        // Display the menu
//        present(optionMenu, animated: true, completion: nil)
//        // Deselect the row
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//
//---
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let favoriteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
//
//            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//
//            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
//
//            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
//
//            // Call completion handler to dismiss the action button
//            completionHandler(true)
//        }
//        // Configure swipe action
//        favoriteAction.backgroundColor = UIColor.systemYellow
//        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
//
//        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
//
//        return swipeConfiguration
//    }
