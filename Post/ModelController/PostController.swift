//
//  PostController.swift
//  Post
//
//  Created by Kaden Staker on 10/15/18.
//  Copyright © 2018 Kaden Staker. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = URL(string: "https://dm-post.firebaseio.com/posts")
    
    var posts: [Post]?
    
    static func getPosts(completion: @escaping ([Post]) -> Void) {
        guard let url = baseURL else {
            fatalError("Bad base URL")
        }
        
        let getterEndPoint = url.appendingPathExtension("json")
        print(getterEndPoint)
        let request = URLRequest(url: getterEndPoint)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error getting posts: \(error) \(error.localizedDescription)")
                completion([]); return
            }
            guard let data = data else { completion([]); return }
            let decoder = JSONDecoder()
            do {
                let postDictionary = try decoder.decode([String : Post].self, from: data)
                let posts = postDictionary.compactMap({ $0.value })
                let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                completion(sortedPosts)
            } catch {
                print("Error decoding post: \(error) \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
    
    static func addNewPostWith(username: String, text: String, completion: @escaping () -> Void) {
        let post = Post(username: username, text: text)
        var postData: Data
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(post)
        } catch {
            print("Error encoding post object: \(error) \(error.localizedDescription)")
            completion()
            return
        }
        guard let url = baseURL else { completion(); return }
        let postEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error posting object \(error) \(error.localizedDescription)")
                completion(); return
            }
            guard let data = data,
            let responseString = String(data: data, encoding: .utf8)
                else { completion(); return }
            self.getPosts(completion: { () in
                <#code#>
            })
        }.resume()
    }
}
