//
//  APICaller.swift
//  CryptoWatch
//
//  Created by Ömer Faruk Kılıçaslan on 11.06.2022.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "F98BE444-8367-41B0-9B1A-ED23F7B4942B"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    private init() { }
    
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    //Mark - Public
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ) {
        
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                //Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos.sorted { first, second in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            } catch  {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=F98BE444-8367-41B0-9B1A-ED23F7B4942B") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                //Decode response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                
                if let completion = self?.whenReadyBlock{
                    self?.getAllCryptoData(completion: completion)
                }
                
                
                
            } catch  {
               print(error)
            }
        }
        
        task.resume()
    }

}
