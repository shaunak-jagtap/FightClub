//
//  Movie.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import Foundation

// MARK: - Result
struct Movie: Codable,Identifiable {
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let originalTitle: String
    let genreIds: [Int]
    let title: String
    let voteAverage: Double
    let overview : String
    let releaseDate: Date

    public var posterURL: URL? {
        guard let poster = posterPath else {return nil}
        return URL(string: Constants.strings.posterEndPoint + poster)
    }

    public var backdropURL: URL? {
        guard let path = backdropPath else {return nil}
        return URL(string: Constants.strings.posterEndPoint + path)
    }

    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    public var cleanMovieReleaseDate: String {
        return Movie.dateFormatter.string(from: self.releaseDate)
    }
}
