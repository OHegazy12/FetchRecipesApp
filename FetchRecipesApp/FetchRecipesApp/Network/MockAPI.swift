//
//  MockAPI.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/13/24.
//

import SwiftUI

class MockAPI {
    let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let emptyURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

    let validRecipesData = """
    {
        "recipes": [
            {
                "cuisine": "Italian",
                "name": "Pizza",
                "photo_url_large": null,
                "photo_url_small": null,
                "source_url": null,
                "uuid": "1",
                "youtube_url": null
            }
        ]
    }
    """.data(using: .utf8)!

    let malformedRecipesData = """
    { "recipes": [ { "cuisine": "Italian" }
    """.data(using: .utf8)!

    let emptyRecipesData = """
    { "recipes": [] }
    """.data(using: .utf8)!

    func setupResponse(for url: String, data: Data) {
        // Use URLProtocol to intercept requests and provide the desired response
        URLProtocolMock.testURLs[url] = (data, HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}
