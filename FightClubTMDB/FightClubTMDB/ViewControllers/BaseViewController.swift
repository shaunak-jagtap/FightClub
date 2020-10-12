//
//  BaseViewController.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 12/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var activityIndicator = UIActivityIndicatorView()
    private var strLabel = UILabel()
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
}
extension BaseViewController {

    // MARK: Public methods

    func showLoading() {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            self.strLabel.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            self.effectView.removeFromSuperview()
            self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
            self.strLabel.text = "Loading.."
            self.strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
            self.strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

            self.effectView.frame = CGRect(x: self.view.frame.midX - self.strLabel.frame.width/2,
                                           y: self.view.frame.midY - self.strLabel.frame.height/2 ,
                                           width: 160, height: 46)
            self.effectView.layer.cornerRadius = 15
            self.effectView.layer.masksToBounds = true

            self.activityIndicator = UIActivityIndicatorView(style: .medium)
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            self.activityIndicator.startAnimating()

            self.effectView.contentView.addSubview(self.activityIndicator)
            self.effectView.contentView.addSubview(self.strLabel)
            self.view.addSubview(self.effectView)
        }
    }
    func hideLoading() { DispatchQueue.main.async { self.effectView.removeFromSuperview() } }
    func showAlert(with title: String, and message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
