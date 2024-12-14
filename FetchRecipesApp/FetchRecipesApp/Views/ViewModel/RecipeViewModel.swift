//
//  RecipeViewModel.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/10/24.
//

import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: Recipes = Recipes(recipes: [])
    @Published var selectedRecipe: Recipe? 
    @Published var isLoading: Bool = false
    @Published var allLoaded: Bool = false
    
    @MainActor
    func refresh() async {
        isLoading = true
        purge()
        await fetchRecipes()
        isLoading = false
    }
    
    func purge() {
        self.recipes.recipes.removeAll()
    }
    
    func fetchRecipes() async {
        guard let url = URL(string: API().url) else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
            do { self.isLoading = false }
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Recipes.self, from: data)
            DispatchQueue.main.async {
                self.recipes.recipes = response.recipes
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Testing Purposes Only
    
    func fetchMalformedRecipes() async {
        guard let url = URL(string: API().malformedURL) else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Recipes.self, from: data)
            DispatchQueue.main.async {
                self.recipes.recipes = response.recipes
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchEmptyRecipes() async {
        guard let url = URL(string: API().emptyURL) else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(Recipes.self, from: data)
            DispatchQueue.main.async {
                self.recipes.recipes = response.recipes
            }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
