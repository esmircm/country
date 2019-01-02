//
//  DetailViewController.swift
//  countryApp
//
//  Created by Esmir Cabrera on 17/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var flag: AsyncImageView!
    
    var country: Country?
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = country?.name
        // obteniendo las banderas
        if let fileName = country?.imageFileName {
            let urlString = "http://apptones.net/test02_assets/\(fileName)"
            if let url = URL(string: urlString){
                flag.fillWithURL(url, place: nil)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard firstTime else {
            return
        }
        
        flag.transform = CGAffineTransform (scaleX: 10.0, y: 0.0) // ejecuntando animación cuando aparece la bandera
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard firstTime else{
            return
        }
        
        firstTime = false
        
        UIView.animate(withDuration: 1.0){ [weak self] in
            self?.flag.transform = .identity
        }
    }
}

