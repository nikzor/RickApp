//
//  FavouritesViewController.swift
//  RickApp
//
//  Created by Никита Зорин on 23.07.2023.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let database = Database()
    var favorites: [FavouriteData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        favorites = database.load()
        tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let personCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as? FavouriteTableViewCell
        else { return UITableViewCell () }
        let celldata = favorites[indexPath.row]
        personCell.setUpData(celldata)
        return personCell
    }
    
}
