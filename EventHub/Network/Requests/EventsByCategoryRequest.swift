//
//  EventsByCategoryRequest.swift
//  EventHub
//
//  Created by Валентина Попова on 20.11.2024.
//

import Foundation

struct EventsByCategoryRequest: DataRequest {
    typealias Response = [Event]
    
    var headers: [String : String]
    var category: String
    var citySlug: String?
    
    var queryItems: [String: String] {
        var items: [String: String] = [
            "categories": category,
            "actual_since": "\(Int(Date().timeIntervalSince1970))",
            "page_size": "10"
        ]
        if let citySlug = citySlug {
            items["location"] = citySlug
        }
        return items
    }
    
    var url: String {
        "https://kudago.com/public-api/v1.4/events"
    }
    
    var method: HTTPMethod { .get }
    
    func decode(_ data: Data) throws -> [Event] {
        let decoder = JSONDecoder()
        return try decoder.decode([Event].self, from: data)
    }
}
