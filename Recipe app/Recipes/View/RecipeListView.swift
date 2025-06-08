//
//  RecipeListView.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.recipes.isEmpty {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage, viewModel.recipes.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                    Button("Retry") {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }
                } else {
                    VStack {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            ForEach(RecipeSortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding([.horizontal, .top])
                    }
                    List(viewModel.sortedRecipes) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle(Text("Recipes"))
            .searchable(text: $viewModel.searchText, prompt: "Search by name or cuisine")
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}
