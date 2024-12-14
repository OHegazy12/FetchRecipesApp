//
//  API.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/10/24.
//

import SwiftUI

struct Recipes: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    var id: String { uuid }
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var source_url: String?
    var uuid: String
    var youtube_url: String?
}

class API {
    let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let emptyURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
}
