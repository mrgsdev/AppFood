//
//  RestaurantDetailViewController.swift
//  AppFood
//
//  Created by MRGS on 12.06.2022.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant = Restaurant()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        navigationItem.largeTitleDisplayMode = .never // Disabling Large Titles
        navigationController?.navigationBar.prefersLargeTitles = false
        // Configure header view
        headerViewSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
    }
    func headerViewSetting()  {
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemYellow : .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for:
                .normal)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        case "showReview":
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        default: break
        }
    }
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else {
            return
        }
        dismiss(animated: true, completion: {
            if let rating = Restaurant.Rating(rawValue: identifier) {
                print(rating)
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating.image)
            }
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.ratingImageView.transform = scaleTransform
            self.headerView.ratingImageView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.ratingImageView.transform = .identity
                self.headerView.ratingImageView.alpha = 1
            }, completion: nil)
        })
    }
}
extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailTextCell", for: indexPath) as! RestaurantDetailTextCell
            cell.selectionStyle = .none
            cell.descriptionLabel.text = restaurant.description
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailTwoColumnCell", for: indexPath) as! RestaurantDetailTwoColumnCell
            cell.selectionStyle = .none
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailMapCell", for: indexPath) as! RestaurantDetailMapCell
            cell.configureMapInCell(location: restaurant.location)
            cell.selectionStyle = .none
            return cell
        default:
            fatalError("Failed to instantiate the table view cell fordetail view controller")
        }
    }
}
