//
//  Constants.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

// FightClubTMDB custom error
public enum FightClubTMDBMovieError: Error {
    case errorFromServer
    case emptyData
    case invalidURL
    case invalidResponse
    case serializationError
}

struct Constants
{
    struct dimenssions
    {
        static let cellHeight = 150.0
    }

    struct colors {
        let darkBlueColor = UIColor.init(red: 45/255, green:50/255, blue: 69/255, alpha: 1)
    }

    //String constants
    struct strings
    {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let apiValue = "bbd73bf0a182480cb44034ccce24d2c1"
        static let searchEndpoint = "search/movie"
        static let apiKey = "api_key"
        static let searchKey = "query"
        static let posterEndPoint = "https://image.tmdb.org/t/p/w500"
    }

    //Error contsants
    struct errors
    {
        static let networkError = "something went wrong"
        static let errorLoadingImage = "Failed loading image"
    }

}
