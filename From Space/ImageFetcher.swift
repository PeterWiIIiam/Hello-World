//
//  image-fetcher.swift
//  From Space
//
//  Created by 何幸宇 on 10/22/17.
//  Copyright © 2017 X. All rights reserved.
//

import Foundation

//: Playground - noun: a place where people can play

import UIKit

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

struct PropertyKeys{
    static let title = "title"
    static let description = "explanation"
    static let url = "url"
    static let copyright = "copyright"
}


var query: [String: String] = [
    "api_key": "07zmH2jxbrL8jgwzXvMFNEhGunfvYuPYrxAZEbwG",
    "date": "2011-07-16",
    "hd":"false"
]

struct DataStructureNASA{
    var title:String
    var description: String
    var url:String
    var copyright: String?
    init?(json: [String:String]) {
        guard let title = json[PropertyKeys.title],
            let description = json[PropertyKeys.description],
            let url = json[PropertyKeys.url]
            else{return nil}
        
        let copyright = json[PropertyKeys.copyright]
        self.title = title
        self.copyright = copyright
        self.url = url
        self.description = description
    }
}

func fetchNASAPicture( completion:@escaping (DataStructureNASA?)-> Void){
    let baseurl = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
    let url = baseurl.withQueries(query)!
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data{
            let jsonRaw =  try? JSONSerialization.jsonObject(with: data)
            if let dictionaryJson = jsonRaw as? [String:String]{
             let dataStructureNASA = DataStructureNASA(json: dictionaryJson)
            completion(dataStructureNASA)
            }
        }
    }
    dataTask.resume()
    
}





