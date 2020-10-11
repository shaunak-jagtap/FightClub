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
    var setForSimilars = false
    private let paginateAt = 1
    private var page = 1
    private var pageLength = 5
    private let minimalSectionHeaderHeight: CGFloat = 44.0
    private var isLoading = false
    private var hasLoaded = false

    @IBOutlet weak var recentSearchesLabel: UILabel!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovies(query: "")
    }

    private func setupUI() {
        cosmeticUI()
        movieSearchBar.delegate = self
        recentSearchesLabel.isHidden = true
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieTableview.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        self.showRecentSearchResult()
    }

    private func cosmeticUI() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        movieSearchBar.searchTextField.textColor = .white
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 1, y: 1)
        gradient.colors = [Constants.appColors.darkBlueColor.cgColor, UIColor.darkGray.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    private func fetchMovies(query: String? = nil) {
        if setForSimilars {
            movieSearchBar.isHidden = true
            recentSearchesLabel.isHidden = true
        } else {
            isLoading = true
            MovieManager.fetchMovies(searchTerm: query ?? "", page: page, success: { [weak self] result in
                self?.recentSearchesLabel.isHidden = true
                if let topLevelobject = result as? TopLevelobject, topLevelobject.results.count > 0 {
                    self?.isLoading = false
                    if self?.page ?? 0 > 1 {
                        if self?.movies.count ?? 0 > 0 {
                            self?.movies.append(contentsOf: topLevelobject.results)
                            self?.saveToRecentSearches(query: query ?? "", moviesToSave: topLevelobject.results)
                            self?.movieTableview.reloadData()
                            self?.hidePaginationIndicator()
                        } else {
                            self?.hasLoaded = true
                        }
                    } else {
                        self?.saveToRecentSearches(query: query ?? "", moviesToSave: topLevelobject.results)
                        self?.movies = topLevelobject.results
                        self?.movieTableview.reloadData()
                        self?.hidePaginationIndicator()
                    }

                    if self?.movies.count == topLevelobject.total_results {
                        self?.hasLoaded = true
                    } else {
                        self?.hasLoaded = false
                    }

                    if self?.movies.count == 0 && !(self?.isLoading ?? false) {
                        if let searchTextCount = self?.movieSearchBar.text?.count {
                            if searchTextCount > 0 {
                                self?.showRecentSearchResult()
                            } else {
                                self?.showRecentSearchResult()
                            }
                        }
                    } else {
                        //hide empty view
                    }
                }

                }, failure:  { [weak self] errorString in
                    self?.showRecentSearchResult()
            })
        }
    }

    private func showRecentSearchResult() {
        if let storedMovies = UserDefaults.standard.object([String : [Movie]].self, with: "recentSearches") {
            MovieManager.recentSearches = storedMovies
        }

        if !MovieManager.recentSearches.isEmpty {
            self.recentSearchesLabel.isHidden = false
            self.recentSearchesLabel.text = "Recent search results for: \(MovieManager.recentSearches.first?.key ?? "")"
            if let savedMovies = MovieManager.recentSearches.first?.value {
                self.movies = savedMovies
                self.movieTableview.reloadData()
            }
        }
    }

    private func saveToRecentSearches(query: String, moviesToSave: [Movie]) {
        for index in 0...4 {
            if MovieManager.recentSearches[query]?.count ?? 0 > 0 {

                if MovieManager.recentSearches.first?.key != query {
                    MovieManager.recentSearches.removeAll()
                    UserDefaults.standard.removeObject(forKey: "recentSearches")
                }

                var savedMovies = MovieManager.recentSearches.first?.value
                if savedMovies?.count ?? 0 < 5, moviesToSave.count > index {
                    savedMovies?.append(moviesToSave[index])
                    if let updatedMovies = savedMovies {
                        MovieManager.recentSearches[query] = updatedMovies
                    }
                }
            } else {
                MovieManager.recentSearches[query] = [moviesToSave[0]]
            }
        }

        UserDefaults.standard.set(object: MovieManager.recentSearches, forKey: "recentSearches")
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
        fetchMovies(query: getSearchText())
    }

    private func hidePaginationIndicator() {
        movieTableview.tableFooterView = nil
        movieTableview.tableFooterView?.isHidden = true
    }

    private func showPaginationIndicator(indexPath: IndexPath) {
        let lastRowIndex = movieTableview.numberOfRows(inSection: 0) - 1
        if indexPath.section ==  0, lastRowIndex != 0, indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: movieTableview.bounds.width, height: minimalSectionHeaderHeight)

            movieTableview.tableFooterView = spinner
            movieTableview.tableFooterView?.isHidden = false
        }
    }

    private func getSearchText() -> String? {
        return self.movieSearchBar.text != "" ? self.movieSearchBar.text : nil
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            vc.selectedMovie = movies[indexPath.row]
            self.present(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if movies.isEmpty {
            return
        }

        // Call pagination API when the user is at the 4 row from last for smooth scrolling
        if !hasLoaded, !isLoading, indexPath.row == movies.count - paginateAt {
            page += 1
            fetchMovies(query: getSearchText())
        }
    }
}
