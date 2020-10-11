//
//  MovieViewController.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    // MARK: - Properties
    var movies: [Movie] = []
    let imageLoader = ImageLoader()
    private let paginateAt = 1
    private var page = 1
    private var pageLength = 5
    private let minimalSectionHeaderHeight: CGFloat = 44.0
    private var isLoading = false
    private var hasLoaded = false

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        fetchMovies(query: "")
    }

    private func setupUI() {
        movieSearchBar.delegate = self
        cosmeticUI()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieTableview.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func cosmeticUI()  {
     let darkBlueColor = UIColor.init(red: 45/255, green:50/255, blue: 69/255, alpha: 1)
     let gradient = CAGradientLayer()
     gradient.frame = view.bounds
     gradient.startPoint = CGPoint.init(x: 0, y: 0)
     gradient.endPoint = CGPoint.init(x: 1, y: 1)
        gradient.colors = [darkBlueColor.cgColor, UIColor.darkGray.cgColor]
     self.view.layer.insertSublayer(gradient, at: 0)
    }

    private func fetchMovies(query: String? = nil) {
        isLoading = true
        MovieManager.fetchMovies(searchTerm: query ?? "", success: { result in
            if let movies = result as? [Movie], movies.count > 0 {
                self.movies = movies
                self.movieTableview.reloadData()
            }
        }, failure:  { errorString in

        })
    }

    private func fillCellData(cell: MovieTableViewCell, indexPath :IndexPath) {
        let movie = movies[indexPath.row]
        cell.movieName?.text = movie.title
        cell.releaseDate?.text = movie.release_date
        cell.movieDescription?.text = movie.overview
        imageLoader.obtainImageWithPath(imagePath: movie.posterURL) { [weak self] (image) in
            if let updateCell = self?.movieTableview.cellForRow(at: indexPath) as? MovieTableViewCell {
                updateCell.posterImageView.image = image
            }
        }
    }

    @objc private func performSearch() {
        page = 1
        movies.removeAll()
        movieTableview.reloadData()
        hidePaginationIndicator()
        fetchMovies(query: self.movieSearchBar.text)
    }

    private func hidePaginationIndicator() {
        movieTableview.tableFooterView = nil
        movieTableview.tableFooterView?.isHidden = true
    }
}

// MARK: - UISearchBarDelegate
extension MovieViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.performSearch), object: nil)
        self.perform(#selector(self.performSearch), with: nil, afterDelay: 0.5)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieTableview.reloadData()
        hidePaginationIndicator()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearch()
    }

}

extension MovieViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = self.movieTableview.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell,
            movies.count > indexPath.row {
            fillCellData(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("did tap for connection. trying to connect")
    }
}
