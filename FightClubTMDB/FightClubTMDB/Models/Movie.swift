//
//  Movie.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import Foundation

// MARK: - Result
struct TopLevelobject: Codable {
    let total_results: Int?
    let results: [Movie]
    let page: Int?
    let total_pages: Int?
}

struct Movie: Codable,Identifiable {
    let popularity: Double
    let vote_count: Int
    let video: Bool
    let poster_path: String?
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let original_title: String
    let genre_ids: [Int]
    let title: String
    let vote_average: Double
    let overview : String
    let release_date: String

    public var posterURL: String {
        guard let poster = poster_path else {return ""}
        return  Constants.strings.posterEndPoint + poster
    }

    public var backdropURL: URL? {
        guard let path = backdropPath else {return nil}
        return URL(string: Constants.strings.posterEndPoint + path)
    }
}
