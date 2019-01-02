//
//  AsyncImageView.swift
//  countryApp
//
//  Created by Esmir Cabrera on 23/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
    
    var lastMark: UUID? = nil // variable para comprobar ultima petición al cache

    func fillWithURL(_ url: URL, place: String?) {
        
            self.image = place != nil ? UIImage(named: place!) : nil
        
            let mark = UUID() // creando intancia
        
            self.lastMark = mark
        
            ImageCache.shared.imageWithURL(url) { [weak self] (image) in
                
                guard self?.lastMark == mark else { // comprobando ultima petición al cache
                    return
                }
                
                guard image != nil else { return }
                
                if Thread.isMainThread { // pregunto si estoy en el hilo principal
                    
                    self?.image = image!
                    
                } else { // sino hago un dispatch al hilo principal
                    
                    DispatchQueue.main.async {
                        self?.image = image!
                    }
                }
            }
      }
}
