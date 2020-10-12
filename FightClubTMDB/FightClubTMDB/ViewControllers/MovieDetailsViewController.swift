//
//  MovieDetailsViewController.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 12/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: - Properties
    var selectedMovie: Movie?

    // MARK: - IBOutlets
    @IBOutlet weak var viewForBlur: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieBlurImageView: UIImageView!
    @IBOutlet weak var movieDetailsLTextView: UITextView!

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var movieBudget: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        cosmeticUI()
        movieTitle.text = selectedMovie?.title
        movieDetailsLTextView.text = selectedMovie?.overview
//        movieGenre.text = selectedMovie?.genre_ids
        movieGenre.text = "Popularity: \(selectedMovie?.popularity ?? 0)"
        actorsLabel.text = "Vote Average: \(selectedMovie?.vote_average ?? 0)"
        movieBudget.text = "Vote Count: \(selectedMovie?.vote_count ?? 0)"
        if let posterURL = selectedMovie?.posterURL {
            ImageLoader().obtainImageWithPath(imagePath: posterURL) { [weak self] (image) in
                self?.movieImageView.image = image
                self?.movieBlurImageView.image = image
            }
        }

    }

    private func cosmeticUI() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = viewForBlur.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewForBlur.addSubview(blurEffectView)

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 1, y: 1)
        gradient.colors = [Constants.appColors.darkBlueColor.cgColor, UIColor.black.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)

       reviewButton.layer.cornerRadius = 5
       reviewButton.layer.shadowOpacity = 1
       reviewButton.layer.shadowColor = UIColor.black.cgColor
       reviewButton.layer.masksToBounds = false;
       reviewButton.layer.shadowOffset = CGSize.init(width: 0, height: 1.0)

       creditsButton.layer.cornerRadius = 5
       creditsButton.layer.shadowOpacity = 1
       creditsButton.layer.shadowColor = UIColor.black.cgColor
       creditsButton.layer.masksToBounds = false;
       creditsButton.layer.shadowOffset = CGSize.init(width: 0, height: 1.0)
    }


    @IBAction func creditsTapped(_ sender: Any) {

    }

    @IBAction func similarMoviesTapped(_ sender: Any) {
        MovieManager.fetchSimilarMovies(movieID: "\(selectedMovie?.id ?? 0)", page: 1, success: { [weak self] result in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
                if let topLevelobject = result as? TopLevelobject, topLevelobject.results.count > 0 {
                    vc.movies = topLevelobject.results
                }
                vc.setForSimilars = true
                self?.present(vc, animated: true)
            }
            }, failure: { errorString in
                print(errorString)
        })
    }

    @IBAction func reviewsTapped(_ sender: Any) {
    }

}
