//
//  Restaurant.swift
//  AppFood
//
//  Created by MRGS on 11.06.2022.
//

import UIKit

struct Restaurant:Hashable {
    
    enum Rating: String {
        case awesome
        case good
        case okay
        case bad
        case terrible
        var image: String {
            switch self {
                case .awesome: return "love"
                case .good: return "cool"
                case .okay: return "happy"
                case .bad: return "sad"
                case .terrible: return "angry"
            }
        }
    } 
    var name: String
    var type: String
    var location: String
    var phone: String
    var description: String
    var image: String
    var isFavorite: Bool
    var rating: Rating?
    init(name: String, type: String, location: String,phone:String,description:String, image: String, isFavorite: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.image = image
        self.isFavorite = isFavorite
    }
    init() {
        self.init(name: "", type: "", location: "", phone:"",description:"",image: "", isFavorite:false)
    }
}


//var restaurants:[Restaurant] = [
//    Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location:"Hong Kong", image: "Cafe Deadend", isFavorite: false),
//    Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image:"Homei", isFavorite: false),
//    Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "Teakha", isFavorite: false),
//    Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "Cafe Loisl", isFavorite: false),
//    Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "Petite Oyster", isFavorite: false),
//    Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "For Kee Restaurant", isFavorite: false),
//    Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "Po's Atelier", isFavorite: false),
//    Restaurant(name: "Bourke Street Backery", type: "Chocolate", location:"Sydney", image: "Bourke Street Backery", isFavorite: false),
//    Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "Haigh's Chocolate", isFavorite: false),
//    Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "Palomino Espresso", isFavorite: false),
//    Restaurant(name: "Upstate", type: "American", location: "New York", image: "Upstate", isFavorite: false),
//    Restaurant(name: "Traif", type: "American", location: "New York", image: "Traif", isFavorite: false),
//    Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "Graham Avenue Meats", isFavorite: false),
//    Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "Waffle & Wolf", isFavorite: false),
//    Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "Five Leaves", isFavorite: false),
//    Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "Cafe Lore", isFavorite: false),
//    Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "Confessional", isFavorite: false),
//    Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "Barrafina", isFavorite: false),
//    Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "Donostia", isFavorite: false),
//    Restaurant(name: "Royal Oak", type: "British", location: "London", image: "Royal Oak", isFavorite: false),
//    Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "CASK Pub and Kitchen", isFavorite: false)
//]
