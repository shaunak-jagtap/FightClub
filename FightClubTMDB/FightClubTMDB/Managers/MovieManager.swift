//
//  MovieManager.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import Foundation

class MovieManager {

    static let shared = MovieManager()
    private init() {}


    static func fetchMovies(searchTerm: String, success:@escaping(Any) -> Void, failure:@escaping(String) -> Void) {
        guard let baseURL = URL(string: Constants.strings.baseURL) else { return failure(Constants.errors.networkError) }
        let searchURL = baseURL.appendingPathComponent(Constants.strings.searchEndpoint)

        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: Constants.strings.searchKey, value: searchTerm),
            URLQueryItem(name: Constants.strings.apiKey, value: Constants.strings.apiValue)
        ]

        guard let finalURL = urlComponents?.url else { return failure(Constants.errors.networkError) }
        print(finalURL)

        NetworkManger.sharedInstance.getData(params:[:], url: finalURL, success: success, failure: failure)

    }
}
