//
//  CahcedAsyncImage.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/2/25.
//

import SwiftUI

struct CachedAsyncImage<Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    private let urlString: String
    private let placeholder: Placeholder

    init(
        urlString: String,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.urlString = urlString
        self.placeholder = placeholder()
    }

    var body: some View {
        content
            .onAppear {
                loader.load(urlString: urlString)
            }
            .onDisappear {
                loader.cancel()
            }
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
            } else {
                placeholder
            }
        }
    }


}
