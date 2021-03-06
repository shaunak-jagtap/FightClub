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

    func getData(url:URL, success:@escaping(TopLevelobject) -> Void, failure:@escaping(String) -> Void)
    {
        if InternetConnection.isRechable() {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let smResponse = response as? HTTPURLResponse, (200...299).contains(smResponse.statusCode)
                {
                    do {
                        if let data = data
                        {
                            let topLevelObject = try JSONDecoder().decode(TopLevelobject.self, from: data)
                                DispatchQueue.main.async {
                                    success(topLevelObject)
                                }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                failure(Constants.errors.networkError);
                            }
                        }
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
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
        }else{
            DispatchQueue.main.async {
                failure(Constants.errors.noInternet);
            }
        }
    }
}
