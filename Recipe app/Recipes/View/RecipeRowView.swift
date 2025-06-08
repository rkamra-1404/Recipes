//
//  RecipeRowView.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/2/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            CachedAsyncImage(urlString: recipe.photoSmall, placeholder: {
                ProgressView()
                    .frame(width: 60, height: 60)
            })
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
