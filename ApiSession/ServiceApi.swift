//
//  ServiceApi.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import Foundation

/*
* Clase que se encarga de realizar las peticiones a cualquier API
*/

class ServiceApi {
    
    enum RequestError: Error, LocalizedError {
        case itemsNotFound
    }

    /*
    * Función que realiza la petición a la API
    * @param url: url de la API
    * @param query: parámetros de la petición
    * @return: objeto de tipo Data con la respuesta de la API
    */
    
    static func fetchItems(url:String, matching query: [String: String]) async throws -> Data {

        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RequestError.itemsNotFound
        }
        
        return data
    }
}
