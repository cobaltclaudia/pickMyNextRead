////
////  Model.swift
////  PickMyNextRead
////
////  Created by Claudia on 3/11/25.
////
//
//import SwiftUI
//import Combine
//
//// Model to fetch the URL from the og:image meta tag
//class ImageFetcher: ObservableObject {
//    @Published var imageUrl: URL?
//    private var cancellables = Set<AnyCancellable>()
//
//    func fetchImageUrl(from url: String) {
//        guard let url = URL(string: url) else { return }
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map { data, response in
//                return String(data: data, encoding: .utf8) ?? ""
//            }
//            .map { html in
//                self.extractOgImageUrl(from: html)
//            }
//            .sink { [weak self] url in
//                self?.imageUrl = url
//            }
//            .store(in: &cancellables)
//    }
//
//    private func extractOgImageUrl(from html: String) -> URL? {
//        let pattern = "<meta property=\"og:image\" content=\"(.*?)\""
//        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
//            let range = NSRange(location: 0, length: html.utf16.count)
//            if let match = regex.firstMatch(in: html, options: [], range: range),
//               let urlRange = Range(match.range(at: 1), in: html) {
//                let imageUrlString = String(html[urlRange])
//                return URL(string: imageUrlString)
//            }
//        }
//        return nil
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var imageFetcher = ImageFetcher()
//    @State private var showImage = false
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                // Replace with the desired URL
//                imageFetcher.fetchImageUrl(from: "https://example.com")
//                showImage = true
//            }) {
//                Text("Load Image")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            if showImage, let imageUrl = imageFetcher.imageUrl {
//                AsyncImage(url: imageUrl) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        image.resizable().scaledToFit().frame(width: 300, height: 300)
//                    case .failure:
//                        Text("Failed to load image")
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//                .padding()
//            }
//        }
//        .padding()
//    }
//}
//
//@main
//struct MyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
