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

    override func viewDidLoad() {
        super.viewDidLoad()
        MovieManager.fetchMovies(searchTerm: "dilwale", success: { result in
            print(result)
        }, failure:  { errorString in
            print(errorString)
        })
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
