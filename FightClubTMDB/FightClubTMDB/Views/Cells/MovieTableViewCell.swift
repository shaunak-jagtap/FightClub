//
//  MovieTableViewCell.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 11/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }

    func styleCell()  {
        let darkBlueColor = UIColor.init(red: 45/255, green:50/255, blue: 69/255, alpha: 1)

        let gradient = CAGradientLayer()
        gradient.frame = bgView.bounds
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 1, y: 1)
        gradient.colors = [darkBlueColor.cgColor, UIColor.black.cgColor]
        gradient.cornerRadius = 15

        bgView.layer.insertSublayer(gradient, at: 0)

        bgView.layer.cornerRadius = 15
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowColor = UIColor.lightGray.cgColor
        bgView.layer.masksToBounds = true;
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.5)
    }

}
