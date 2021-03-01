//
//  NetworkManager.swift
//  Dropryde
//
//  Created by Tayyab Ali on 23/04/2020.
//  Copyright © 2019 Fantech Labs. All rights reserved.
//

import UIKit
import Moya

class NetworkManager {
    
    //default enviroment
    static let enviroment: APIEviroment = .development
    static let shared = NetworkManager()
    
    fileprivate let provider = MoyaProvider<PsiAPI>(plugins:[NetworkLoggerPlugin()])

    //handles the server error that comes as success
    fileprivate func request(target: PsiAPI, completion:@escaping (Result<Response, Swift.Error>)->Void){
        
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        
        provider.request(target) { result in
            switch result{
                
            case .success(let response):
                // 1: success return
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    completion(.success(response))
                } else {
                    // 2: success but 400+ errors
                    do{

                        let json = try response.mapJSON()
                        guard let jsonObject = json as? [String:Any] else{
                            let error = NSError(domain:bundleIdentifier, code:0, userInfo:[NSLocalizedDescriptionKey: "Unknown Error From Server"])
                            completion(.failure(error))
                            return;
                        }
                        
                        //graceful error from server
                        var errorString  = "Unknown error"

                        if let error  = jsonObject["error"] as? String {
                            errorString = error
                        }
                        
                        if let msg  = jsonObject["msg"] as? String {
                            errorString = msg
                        }
                        
                        if let message  = jsonObject["message"] as? String, !message.isEmpty {
                            errorString = message
                        }
                        
                        let error = NSError(domain:bundleIdentifier, code:0, userInfo:[NSLocalizedDescriptionKey: errorString])
                        completion(.failure(error))
                        
                    }catch{
                        
                        let error = NSError(domain:bundleIdentifier, code:0, userInfo:[NSLocalizedDescriptionKey: "Invalid Content From Server"])
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Generic API Method
extension NetworkManager {
    
    func genericMethodCall<T: Decodable>(target: PsiAPI, completion:@escaping (Result<T, Swift.Error>)->Void){
        
        self.request(target: target, completion: { result in
            
            switch result {
                
            case .success(let response):
                do{
                    let jsonDecoder = JSONDecoder()
                    let obj = try jsonDecoder.decode(T.self, from: response.data)
                    completion(.success(obj))
                    
                }catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            }
        })
    }
}
