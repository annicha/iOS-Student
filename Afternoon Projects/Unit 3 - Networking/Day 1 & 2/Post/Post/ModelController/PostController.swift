//
//  PostController.swift
//  Post
//
//  Created by Annicha on 13/5/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    var posts: [Post] = []
    
    func fetchPosts(_ completion: @escaping () -> Void){
        guard let unwrappedURL = baseURL else {completion(); return}
        // appending path component gives us /stuff, but appendingpathextension gives .stuff
        let getterEndpoint = unwrappedURL.appendingPathExtension("json")
        var request = URLRequest(url:getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request){ (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            
            guard let data = data else {completion(); return}
            let jsonDecoder = JSONDecoder()
            do {
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({$0.value})
                posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
            } catch {
                print(error.localizedDescription)
                completion()
                return
            }
        }
        
        dataTask.resume()

    }
}
