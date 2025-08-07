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
                    reloadTrigger = UUID() // Change state to trigger reload
                    showWebView = true
                }) {
                    Text("Pick My Next Read 📚").font(.title).fontWeight(.regular).foregroundColor(.white).multilineTextAlignment(.center)
                    
                }
                let imageCheck = imageCheck(from: goodReadsLinkPath())
                Text("This is the selected book: " + imageCheck)
                if showWebView {
                    // loads page in app
                    // TODO connect
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

func imageCheck(from urlString: String) -> String {
    guard let url = URL(string: goodReadsLinkPath()) else { return "no"}
    var selectedBook = "this isnt working"

    URLSession.shared.dataTask(with: url) { data, _, error in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            do {
                let doc = try SwiftSoup.parse(html)
                let images = try doc.select("img")

                for img in images {
                    let src = try img.attr("src")
                    for src in src.split(separator: " ") {
                        if src.lowercased().contains("compressed.photo.goodreads.com/books") {
                                print("Found the words 'compressed.photo.goodreads.com/books'!")
                            print("Found book image URL: \(src)")
                            selectedBook = "\(src)"
                            print("break 1")
                            break
                            }
                        print("break 2")
                        break
                    }
                }
                print("Final selection in loop " + selectedBook)
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
    }.resume()
    print("Final selection before return: " + selectedBook)
    return selectedBook
}
