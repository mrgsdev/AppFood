//
//  RestaurantDetailHeaderView.swift
//  AppFood
//
//  Created by MRGS on 12.06.2022.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

   
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!{
        didSet {
            nameLabel.numberOfLines = 0
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                nameLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
             
            }
        }
    }
    @IBOutlet var typeLabel: UILabel!{
        didSet {
            if let customFont = UIFont(name: "Nunito-Bold", size: 20.0) {
                typeLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
                typeLabel.layer.cornerRadius = 5
                typeLabel.clipsToBounds = true
            }
        }
    }
    @IBOutlet var heartButton: UIButton!

}
