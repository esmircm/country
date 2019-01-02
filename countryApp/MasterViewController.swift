//
//  MasterViewController.swift
//  countryApp
//
//  Created by Esmir Cabrera on 17/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    internal var countries: [Country]? // variable para verificar si no hay otra llamada
    
    private var downloader: CountryDownloader?
    
    private var observer: NSObjectProtocol? // guardar obeservador en la varible para dejar de observar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadCountries()
        
        // los ciclos de vida de la aplicacion ejecutan eventos para detectarlos
        
        // suscripcion al NotificationCenter para saber cuando el usuario entra al app y se ejecute el downloadCountries()
        // este se ejecuta pq se el app llama a UIApplication.didBecomeActiveNotification cuando se levanta el app
        // así mantenemos actualizadas las banderas
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) {
            (notification) in
            self.downloadCountries()
        }
        
        let rc = UIRefreshControl() // instancia para refrescar la vista cuando se haga scroll hacía abajo
        tableView.refreshControl = rc
        
        rc.addTarget(self, action: #selector(refreshControlAction(_ :)), for: .valueChanged) // llamamos al refrescamiento
        
    }
    
    deinit {
        if observer != nil {
            NotificationCenter.default.removeObserver(observer!) // eliminando observador
            observer = nil // eliminando observador
        }
    }
    
    @objc
    func refreshControlAction(_ sender: UIRefreshControl) { // refrescamiento
        
        sender.beginRefreshing()
        
        downloadCountries()
    }
    
    private func downloadCountries() {
        
        guard downloader == nil else { return } // verificar si no hay otra llamada
        
        downloader = CountryDownloader();
        CountryDownloader().download { [weak self] (countries) in
            DispatchQueue.main.async {
                
                self?.tableView.refreshControl?.endRefreshing() // finalizar refrescamiento del listado de vista
                
                self?.downloader = nil
            }

            if countries != nil {
                self?.updateCountries(countries!)
            }
            
        }
    }

    // MARK: - Table Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int { // numero de secciones que va a tener tu tabla
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    // obtenemos los los paises y se los asignamos a una celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        let country = countries![indexPath.row]
        
        cell.name.text = country.name
        
        cell.icon.image = nil
        
            let countryCode = country.code
            
           let urlString = "http://apptones.net/test02_assets/\(countryCode.lowercased()).png"
            
            if let url = URL(string: urlString) {
                cell.icon.fillWithURL(url, place: nil)
            } else {
                cell.icon.image = nil
            }

    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    // MARK: Navigation
    
    // evento que se llama al seleccionar un pais
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" { // verificamos el identificador del segue
            if let nav = segue.destination as? UINavigationController,
            let detail = nav.topViewController as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                detail.country = countries![indexPath.row]
                
            }
        }
    }

}

