//
//  MenuController.swift
//  restaurantMenu
//
//  Created by Gebruiker on 16-05-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//
import UIKit
import Foundation

// devines the class with URL location of menu
class MenuController {
    
    static let shared = MenuController()
    let baseURL = URL(string: "https://resto.mprog.nl/")!


    // function that gets menu categories
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        
        // appends to the base URL
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        // makes the data request to URL
        let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let categories = try? jsonDecoder.decode(Categories.self, from: data) {
                completion(categories.categories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    // function that gets all menu items
    func fetchMenuItems(categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        // fetches menu items
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
            let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                
                // checks if item has something in it
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    // function to submits order to restaurant
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        
        // makes URL a var
        var request = URLRequest(url: orderURL)
        
        // changes method to post and tells what you want to submit
        request.httpMethod = "POST"
        request.setValue("application/jason", forHTTPHeaderField: "Content-Type")
        
        // makes dictionary and converts data to json
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
