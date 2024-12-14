//
//  RecipeCell.swift
//  FetchRecipesApp
//
//  Created by Omar Hegazy on 12/11/24.
//

import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe
    
    var body: some View {
        LazyVStack(spacing: 0) {
            let imageURL = URL(string: recipe.photo_url_small ?? "")
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .padding([.leading, .bottom], 8)
                case .failure(_):
                    Image(systemName: "exclamationmark.warninglight")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .padding([.leading, .bottom], 8)
                @unknown default:
                    fatalError()
                }
            }
        }
        VStack {
            Text(recipe.name)
                .font(.title2)
                .padding(.horizontal, 30)
            Text(recipe.cuisine)
                .font(.subheadline)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    let recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    return RecipeCell(recipe: recipe)
}
