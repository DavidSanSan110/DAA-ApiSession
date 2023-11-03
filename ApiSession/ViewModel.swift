//
//  ViewModel.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import Foundation

/*
* Clase que se encarga gestionar los diferentes modelos
*/

class ViewModel {

    //Singleton
    static let shared = ViewModel()
    
    //URL y Query de ITunes (Que se puede cambiar)
    let iTunesUrl = "https://itunes.apple.com/search"
    let iTunesQuery = [
        "term": "Comedy",
        "media": "ebook",
        "lang": "en_us",
        "limit": "5"
    ]

    //URL y Query de Nasa (Que se puede cambiar)
    let nasaUrl = "https://api.nasa.gov/planetary/apod"
    let nasaQuery = [
        "api_key": "DEMO_KEY",
        "date": "2023-11-03"
    ]
    
    //Estructura de la respuesta de ITunes
    struct SearchITunesResponse: Codable {
        let results: [ITunesItem]
    }

    //No se necesita SearchNasaResponse porque solo devuelve un objeto
    //La respuesta es un JSON con un objeto dentro

    /*
    * Función que crea el query de ITunes
    * @param theme: tema de la búsqueda
    * @param media: tipo de multimedia
    * @return: query de ITunes
    */
    func createITunesQuery(theme: String, media: String) -> [String: String] {
        var query = self.iTunesQuery
        query["term"] = theme
        query["media"] = media
        return query
    }

    /*
    * Función que crea el query de Nasa
    * @param date: fecha de la búsqueda
    * @return: query de Nasa
    */
    func createNasaQuery(date: Date) -> [String: String] {
        var query = self.nasaQuery
        let stringDate = formatDate(date: date)
        query["date"] = stringDate
        return query
    }
    
    /*
    * Función que realiza la petición a la API de ITunes
    * @param theme: tema de la búsqueda
    * @param media: tipo de multimedia
    * @return: array de objetos de tipo ITunesItem => [ITunesItem]
    */
    func fetchITunesItems(theme: String, media:String) async throws -> [ITunesItem] {

        var data = try await ServiceApi.fetchItems(url:self.iTunesUrl, matching:createITunesQuery(theme: theme, media: media))
        let json = try JSONSerialization.jsonObject(with: data, options: [])

        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(SearchITunesResponse.self, from: data)
        return searchResponse.results
    }

    /*
    * Función que realiza la petición a la API de Nasa
    * @param date: fecha de la búsqueda
    * @return: objeto de tipo NasaItem => NasaItem
    */
    func fetchNasaItems(date: Date) async throws -> NasaItem {

        var data = try await ServiceApi.fetchItems(url:self.nasaUrl, matching:createNasaQuery(date: date))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(NasaItem.self, from: data)
        return searchResponse
    }

    /*
    * Función que formatea la fecha
    * @param date: fecha a formatear
    * @return: fecha formateada
    */
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return dateString
    }
}
