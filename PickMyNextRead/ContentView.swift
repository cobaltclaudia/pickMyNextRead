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
    @State private var showWebView = false
    @State private var reloadTrigger = UUID()
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    reloadTrigger = UUID()
                    showWebView = true
                  
                    // TODO display image in app
                    imageCheck(from: goodReadsLinkPath()) { selected in
                        print("Selected book: \(selected)")
                    }
                }) {
                    Text("Pick My Next Read 📚").font(.title).fontWeight(.regular).foregroundColor(.white).multilineTextAlignment(.center)
                    
                }

                if showWebView {
                   // TODO remove placeholder
                    WebView(url: URL(string:goodReadsLinkPath())!, reloadTrigger: reloadTrigger)
                        .frame(width: 200.0, height: 350.0)
                }}
      
        }.navigationBarTitle(Text("Home")).foregroundColor(.white)
            
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
    
    //modifiable parameters
    let uniqueId = "102281322-"
    let username = "cobalt-claudia?"
    
    let completePath = baseLink + uniqueId + and + username + and + order + and + per_page + and + shelf + and + sort + and + and + view
    print(completePath)
    return completePath
}
    
    // WEBVIEW
struct WebView: UIViewRepresentable {
    let url: URL
    let reloadTrigger: UUID
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


func imageCheck(from urlString: String, completion: @escaping (String) -> Void) {
    print("IN IMAGE CHECK")
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
                            print("Found book image URL: \(part)")
                            selectedBook = String(part)
                            print("Assisgning selected book: "+selectedBook)
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
