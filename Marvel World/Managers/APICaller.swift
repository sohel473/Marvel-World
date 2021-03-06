//
//  APICaller.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit
import CryptoKit

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    private let baseURL = "https://gateway.marvel.com:443/v1/public"
    private let API_KEY_Public = "903579549e48f3649a5632561fa58c23"
    private let API_KEY_Privat = "03b7a5d97355a4f19b0100788724c3aecc351b84"
    private let YouTube_baseURL = "https://youtube.googleapis.com/youtube/v3/search?"
//    private let YouTube_API_KEY1 = "AIzaSyAWgmuN6Bb8BFV_p-gIxv8OY1KUZW7RKgg"
    private let YouTube_API_KEY2 = "AIzaSyCAJsBNySy-HqREsSJnitMCK2OwDEVmCHY"
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    //MARK: - Get Characters
    func getCharacters(completion: @escaping(Result<[Character], Error>) -> Void) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(API_KEY_Privat)\(API_KEY_Public)")
        let endpoint = "\(baseURL)/characters?limit=100&orderBy=-modified&ts=\(ts)&apikey=\(API_KEY_Public)&hash=\(hash)"
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let decoder = JSONDecoder()
                let results = try decoder.decode(CharacterResponse.self, from: data)
                completion(.success(results.data.results))
//                print(results.data.results)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
//                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: - Search Characters
    func search(with query: String, completion: @escaping(Result<[Character], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        print(query)
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(API_KEY_Privat)\(API_KEY_Public)")
        let endpoint = "\(baseURL)/characters?nameStartsWith=\(query)&limit=10&orderBy=-modified&ts=\(ts)&apikey=\(API_KEY_Public)&hash=\(hash)"
        //        print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(CharacterResponse.self, from: data)
                completion(.success(results.data.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Movies
    func getMovies(query: String, completion: @escaping(Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        print(query)
        let endpoint = "\(YouTube_baseURL)q=\(query)&key=\(YouTube_API_KEY2)"
//        print(endpoint)
        guard let url = URL(string: endpoint) else {
            print("Youtube URL error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
//                 print("IN")
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let decoder = JSONDecoder()
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
//                print(results)
//                items[0].id.videoId
                
            } catch {
                //                completion(.failure(APIError.failedToGetData))
                print(error)
            }
        }
        task.resume()
    }
    
}
