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
        let goodreadsUrl = goodReadsLinkPath()
        Text("Choose your next read")
            .font(.headline)
            .foregroundColor(.white)
        Link(destination: URL(string: goodreadsUrl)!, label: {
            Text("📚")
                .padding()
                .font(Font.system(size:80))
                .cornerRadius(10)
            })
        }
    
    func goodReadsLinkPath() -> String {
        let baseLink = "https://www.goodreads.com/review/list/"
         let and = "&"
         let uniqueId = "102281322-"
         let username = "cobalt-claudia?"
         let order = "order=a"
         let per_page = "per_page=1"
         let shelf = "shelf=to-read"
         let sort = "sort=random"
         let view = "view=covers"
         let completePath = baseLink + uniqueId + and + username + and + order + and + per_page + and + shelf + and + sort + and + and + view
        print(completePath)
        return completePath
    }
    
    func parseHtml(html: String){
        print(html)
        
    }
    

}
