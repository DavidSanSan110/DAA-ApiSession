//
//  NasaModel.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import Foundation

struct NasaItem: Codable {

    //Variables de cada item de la respuesta
    let title: String
    let imgUrl: URL
    let explanation: String
    let hdurl: URL
    let date: String
    
    //Key asociado a cada variable en el JSON
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case imgUrl = "url"
        case explanation = "explanation"
        case hdurl = "hdurl"
        case date = "date"
    }
    
    //Inicializador para decodificar el JSON => convertir de JSON a Objeto
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: CodingKeys.title)
        imgUrl = try values.decode(URL.self, forKey: CodingKeys.imgUrl)
        explanation = try values.decode(String.self, forKey: CodingKeys.explanation)
        hdurl = try values.decode(URL.self, forKey: CodingKeys.hdurl)
        date = try values.decode(String.self, forKey: CodingKeys.date)
    }
}
