//
//  ContentView.swift
//  PickMyNextRead
//
//  Created by Claudia on 4/1/25.
//

import SwiftUI
import SwiftSoup
import WebKit

// CONTENT VIEW
struct ContentView: View {
    @State private var reloadTrigger = UUID()
    @State private var showWebView = false
    @State private var imageURL: URL? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                reloadTrigger = UUID()
                showWebView = true
                
                imageCheck(from: goodReadsLinkPath()) { selected in
                    print("Selected book: \(selected)")
                    if let url = URL(string: selected) {
                        DispatchQueue.main.async {
                            imageURL = url
                        }
                    }
                }
            }) {
                Text("Pick My Next Read 📚")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .cornerRadius(10)
            }
            
            if let url = imageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 350)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
    }
}
    
func goodReadsLinkPath() -> String {
    let baseLink = "https://www.goodreads.com/review/list/"
    let and = "&"
    let order = "order=a"
    let per_page = "per_page=1"
    let shelf = "shelf=to-read"
    let sort = "sort=random"
    let view = "view=covers"
    
    //TODO change this
    let uniqueId = "102281322-"
    let username = "cobalt-claudia?"
    
    let completePath = baseLink + uniqueId + and + username + and + order + and + per_page + and + shelf + and + sort + and + and + view
    return completePath
}
    


func imageCheck(from urlString: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: goodReadsLinkPath()) else {
        completion("no")
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        var selectedBook = "this isn't working"

        if let data = data, let html = String(data: data, encoding: .utf8) {
            do {
                let doc = try SwiftSoup.parse(html)
                let images = try doc.select("img")

                for img in images {
                    let src = try img.attr("src")
                    for part in src.split(separator: " ") {
                        if part.lowercased().contains("compressed.photo.goodreads.com/books") {
                            selectedBook = String(part)
                            completion(selectedBook)
                            return // stop further processing
                        }
                    }
                }
                completion(selectedBook)
            } catch {
                print("Error parsing HTML: \(error)")
                completion("error")
            }
        } else {
            print("Data or HTML conversion failed")
            completion("error")
        }
    }.resume()
}
