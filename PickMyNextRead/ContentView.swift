//
//  ContentView.swift
//  PickMyNextRead
//
//  Created by Claudia on 4/1/25.
//

import SwiftUI
import SwiftSoup
struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose your next read")
                .font(.headline)
                .foregroundColor(.white)

            Button(action: fetchMetaImage) {
                Text("📚")
                    .padding()
                    .font(Font.system(size:80))
                    .cornerRadius(10)
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }

    func openImageLink() {
        if let url = URL(string: "https://www.example.com") {
            UIApplication.shared.open(url)
        }
    }
}


//@main
struct ImageLinkApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
}


struct MyViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController() // A UIKit ViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update if needed
    }
}

func fetchMetaImage() {
    let urlString = "https://www.goodreads.com/review/list/102281322-cobalt-claudia?order=a&per_page=1&shelf=to-read&sort=random&utf8=%E2%9C%93&view=covers" // Hardcoded URL
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data, let html = String(data: data, encoding: .utf8) else {
            print("Failed to fetch HTML")
            return
        }
        
        if let imageUrl = try? SwiftSoup.parse(html).select("meta[property='og:image']").attr("content"),
           !imageUrl.isEmpty {
//            print("Found image URL: \(imageUrl)")
//                AsyncImage(url: URL(string:imageUrl)) { phase in  // Unused
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        image.resizable()
//                            .scaledToFit()
//                    case .failure:
//                        Image(systemName: "photo")
//                            .resizable()
//                            .scaledToFit()
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//
//                .frame(width: 200, height: 200)
            
        } else {
            print("No og:image found")
        }
    }.resume()
}
