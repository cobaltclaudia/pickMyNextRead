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
                if showWebView {
                    // loads page in app
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

