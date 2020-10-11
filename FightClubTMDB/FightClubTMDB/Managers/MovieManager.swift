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

    static var recentSearches = [String:[Movie]]()

    static func fetchMovies(searchTerm: String, page: Int, success:@escaping(Any) -> Void, failure:@escaping(String) -> Void) {
        guard let baseURL = URL(string: Constants.strings.baseURL) else { return failure(Constants.errors.networkError) }
        let searchURL = baseURL.appendingPathComponent(Constants.strings.searchEndpoint)
        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: Constants.strings.searchKey, value: searchTerm),
            URLQueryItem(name: Constants.strings.apiKey, value: Constants.strings.apiValue),
            URLQueryItem(name: Constants.strings.page, value: "\(page)")
        ]

        guard let finalURL = urlComponents?.url else { return failure(Constants.errors.networkError) }

        NetworkManger.sharedInstance.getData(url: finalURL, success: success, failure: failure)

    }
}
