//
//  NetworkManager.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 10/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import Foundation

class NetworkManger {

    static let sharedInstance = NetworkManger()

    func getData(params:[String:Any], url:URL, success:@escaping(Any) -> Void, failure:@escaping(String) -> Void)
    {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let smResponse = response as? HTTPURLResponse, (200...299).contains(smResponse.statusCode)
            {
                do {
                    if let data = data
                    {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                            DispatchQueue.main.async {
                                success(json)
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            failure(Constants.errors.networkError);
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure(Constants.errors.networkError);
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    failure(Constants.errors.networkError);
                }
            }
        }

        task.resume()
    }

    func getImageData(params:[String:Any], stringURL:String, success:@escaping(Any) -> Void, failure:@escaping(String) -> Void)
    {
        if let url = URL(string: stringURL)
        {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let smResponse = response as? HTTPURLResponse, smResponse.statusCode == 200
                {
                    do {
                        if let data = data
                        {
                            DispatchQueue.main.async {
                                success(data)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                failure(Constants.errors.networkError)
                            }
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        failure(Constants.errors.networkError)
                    }
                }
            }

            task.resume()
        }
        else
        {
            failure(Constants.errors.networkError);
        }
    }

}
