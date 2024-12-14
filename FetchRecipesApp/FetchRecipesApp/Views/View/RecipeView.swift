//
//  RecipeView.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/11/24.
//

import SwiftUI
import WebKit

struct RecipeView: View {
    @StateObject var viewModel = RecipeViewModel()
    @State var loadWebView: Bool = false
    
    var body: some View {
        NavigationView {
            viewController
                .task {
                    await viewModel.fetchRecipes()
                }
                .fullScreenCover(isPresented: $loadWebView, content: {
                    NavigationView {
                        if let selectedRecipe = viewModel.selectedRecipe {
                            VStack {
                                WebView(recipe: selectedRecipe)
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("", systemImage: "x.circle") {
                                        loadWebView = false
                                    }
                                }
                            }
                            .navigationTitle(selectedRecipe.name)
                            .navigationBarTitleDisplayMode(.inline)
                        }
                    }
                })
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var viewController: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                Spacer()
            } else {
                contentView
            }
        }
    }
    
    var contentView: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    if viewModel.recipes.recipes.isEmpty {
                        ContentUnavailableView {
                            Label("No Recipes Found", systemImage: "tray")
                        } description: {
                            Text("No recipes are available, please try again later")
                        }
                    } else {
                        ForEach(viewModel.recipes.recipes ) { recipe in
                            RecipeCell(recipe: recipe)
                                .onTapGesture {
                                    DispatchQueue.main.async {
                                        viewModel.selectedRecipe = recipe
                                        loadWebView.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    RecipeView()
}

struct WebView: UIViewRepresentable {
    
    let webView: WKWebView
    let recipe: Recipe
    
    init(recipe: Recipe) {
        webView = WKWebView(frame: .zero)
        self.recipe = recipe
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: recipe.source_url ?? "https://www.google.com")!))
    }
}
