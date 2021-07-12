//
//  NetworkManager.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation
import Combine


class NetworkManager: BaseNetworkManager {
    
    static var shared = NetworkManager()
    
    private override init() {}
    
    var cancelable = Set<AnyCancellable>()
    
//        MARK: - Pokomon List Data
    func getPokomonList(offset: Int, limit: Int) -> Future<PokomonResponse, ApiError> {

        return Future {[weak self] promise in

            guard let sSelf = self else {
                promise(.failure(ApiError.Server))
                return
            }

            guard let request = sSelf.pokomonRequest(url: Endpoint.pokomonList.url, method: .GET, offset: offset, limit: limit) else {
                promise(.failure(.Server))
                return
            }
            
            URLSession.shared.pokomonsTask(with: request) { (_data, _response, _error) in

                do {
                    let data = try NetworkManager.reponseCheck(data: _data, response: _response, error: _error)

                    promise(.success(data))

                } catch let error {
                    promise(.failure(error as! ApiError))
                    return
                }

            }.resume()

        }

    }
    
    func getPokomonDetail(url: String) -> Future<PokomonDetail, ApiError> {

        return Future {promise in

            guard let detailURL = URL(string: url) else {
                promise(.failure(.Server))
                return
            }
            
            let request = URLRequest(url: detailURL)
            
            URLSession.shared.pokomonDetailTask(with: request) { (_data, _response, _error) in

                do {
                    let data = try NetworkManager.reponseCheck(data: _data, response: _response, error: _error)

                    promise(.success(data))

                } catch let error {
                    promise(.failure(error as! ApiError))
                    return
                }

            }.resume()

        }

    }
    
}



