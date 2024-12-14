//
//  FetchRecipesAppTests.swift
//  FetchRecipesAppTests
//
//  Created by Omar Hegazy on 12/10/24.
//

import XCTest
@testable import FetchRecipesApp

final class FetchRecipesAppTests: XCTestCase {

    var viewModel: RecipeViewModel!
    var mockAPI: MockAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPI = MockAPI()
        viewModel = RecipeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPI = nil
        try super.tearDownWithError()
    }

    func testRefreshSuccessfullyFetchesRecipes() async throws {
        // Setup mock API response
        mockAPI.setupResponse(for: mockAPI.url, data: mockAPI.validRecipesData)

        await viewModel.refresh()

        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after refresh")
        XCTAssertFalse(viewModel.recipes.recipes.isEmpty, "Recipes should not be empty after a successful fetch")
    }

    func testRefreshHandlesMalformedDataGracefully() async throws {
        // Setup mock API response
        mockAPI.setupResponse(for: mockAPI.malformedURL, data: mockAPI.malformedRecipesData)

        await viewModel.fetchMalformedRecipes()

        XCTAssertTrue(viewModel.recipes.recipes.isEmpty, "Recipes should remain empty after receiving malformed data")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after handling an error")
    }

    func testRefreshHandlesEmptyResponse() async throws {
        // Setup mock API response
        mockAPI.setupResponse(for: mockAPI.emptyURL, data: mockAPI.emptyRecipesData)

        await viewModel.fetchEmptyRecipes()

        XCTAssertTrue(viewModel.recipes.recipes.isEmpty, "Recipes should be empty after receiving an empty response")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after handling an empty response")
    }

    func testPurgeClearsAllRecipes() {
        viewModel.recipes.recipes = [Recipe(cuisine: "Italian", name: "Pizza", photo_url_large: nil, photo_url_small: nil, source_url: nil, uuid: "1", youtube_url: nil)]
        
        viewModel.purge()

        XCTAssertTrue(viewModel.recipes.recipes.isEmpty, "All recipes should be cleared after purge")
    }

    func testIsLoadingTogglesCorrectly() async throws {
        // Simulate fetching recipes
        mockAPI.setupResponse(for: mockAPI.url, data: mockAPI.validRecipesData)

        XCTAssertFalse(viewModel.isLoading, "isLoading should initially be false")

        await viewModel.fetchRecipes()

        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after fetchRecipes completes")
    }
}
