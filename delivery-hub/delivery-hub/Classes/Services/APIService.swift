//
//  APIService.swift
//  delivery-hub
//
//  Created by Александр on 10.04.2022.
//

import Foundation
import CoreLocation

struct Suggestion: Decodable {
    var value: String
}
            
struct GeocodeResponse: Decodable {
    var suggestions: [Suggestion]
}

class APIService {
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping ((GeocodeResponse?, String?) -> Void)) {
        let query = "lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        let url = URL(string: "https://suggestions.dadata.ru/suggestions/api/4_1/rs/geolocate/address?\(query)")!
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        request.httpMethod = "GET"
        request.addValue("Token 8eca6198cbffc32615f05c3907be17f973dc5e16", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: { data, response, error in
                var errorString: String?
                if let error = error {
                    errorString = error.localizedDescription
                }
                if let data = data {
                    var version: GeocodeResponse?
                    do {
                        let decoder = JSONDecoder()
                        version = try decoder.decode(GeocodeResponse.self, from: data)
                        completion(version, nil)
                        return
                    } catch let error {
                        print(error)
                        errorString = error.localizedDescription
                    }
                }

                completion(nil, errorString)
            }
        )

        task.resume()
    }
    
}
