//
//  CountriesDownloader.swift
//  countryApp
//
//  Created by Esmir Cabrera on 24/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import UIKit;

struct CountryDownloader {
    
    private let urlString = "http://apptones.net/test02_assets/Countries.json"
    
    func download(completion:@escaping ([Country]?) -> Void) {
        
        let session = URLSession.shared // obteniendo metodo shared para ejecutar un request
        
        let bkTask = UIApplication.shared.beginBackgroundTask { // forzando background para indicar que es un proceso importante y este no sea destruido
            debugPrint("Download stopped")
        }
        
        let req = URLRequest(url: URL(string: urlString)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = session.dataTask(with: req) { // haciendo la petición al url
            (data, response, error) in
            
            guard error == nil && data != nil else { // validadno si hay un error o un dato nil para detener la ejecución en segundo plano
                completion(nil)
                return
            }
            
            let countries = try? JSONDecoder().decode([Country].self, from: data!) // decodificando los datos
            
            completion(countries) // retornando los datos codificados
            
            UIApplication.shared.endBackgroundTask(bkTask) // finalizando background
            
        }
        
        task.resume() // iniciando el task
        
    }
}
