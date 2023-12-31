//
//  ViewController.swift
//  lab04hw
//
//  Created by Никита Зорин on 27.06.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let manager = NetworkManager()
    var characters : [DataResponseModel.Character] = []
    let database = Database()
    var favorites: [FavouriteData] = []
    var page: Int = 1
    
    lazy var frc: NSFetchedResultsController<SingleCharacter> = {
        let request = SingleCharacter.fetchRequest()
        request.sortDescriptors = []
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        return frc
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = tableView.contentOffset.y
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        super.viewDidLoad()
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        tableView.dataSource = self
        tableView.delegate = self
        favorites = database.load()
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites = database.load()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier:"DetailViewController") as? DetailViewController else {
            return
        }
        detailViewController.delegate = self
        present(detailViewController, animated: true)
        detailViewController.data = characters[indexPath.row]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let personCell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell") as? PersonTableViewCell
        else { return UITableViewCell () }
        let celldata = characters[indexPath.row]
        personCell.setUpData(celldata)
        return personCell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let characterData = characters[indexPath.row]
            let isFavorite = favorites.contains { $0.userId == characterData.id }
            let actionTitle = isFavorite ? "Remove from Favorites" : "Add to Favorites"
            let actionStyle: UIContextualAction.Style = isFavorite ? .destructive : .normal
            let action = UIContextualAction(style: actionStyle, title: actionTitle) { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                if isFavorite {
                    self.favorites.removeAll { $0.userId == characterData.id }
                } else {
                    let newFavorite = FavouriteData(userId: characterData.id, characterName: characterData.name, imageString: characterData.image)
                    self.favorites.append(newFavorite)
                }
                
                self.database.save(items: self.favorites)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            
            if isFavorite {
                action.backgroundColor = .red
            } else {
                action.backgroundColor = .systemMint
            }
            
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
        }

    private func fetchData() {
        if(manager.isRequesting) { return }
        
        if Reachability.shared.isConnectedToNetwork() {
            manager.fetchData(page) { [weak self] result in
                switch result {
                case let .success(response):
                    if !(self?.characters.isEmpty ?? true) {
                        self?.characters.append(contentsOf: response.results)
                    }
                    else {
                        self?.characters = response.results
                    }
                    self?.saveCharacters(arr: self?.characters ?? [])
                    self?.tableView.reloadData()
                    self?.page += 1
                case let .failure(error):
                    print(error)
                    self?.loadCharactersFromCoreData()
                }
            }
        } else {
            print(1)
            loadCharactersFromCoreData()
        }
    }

    private func loadCharactersFromCoreData() {
        let request = SingleCharacter.fetchRequest()
        do {
            let fetchedCharacters = try PersistentContainer.shared.viewContext.fetch(request)
            self.characters = fetchedCharacters.map { character in
                return DataResponseModel.Character(id: Int(character.id),
                                                   name: character.name ?? "",
                                                   status: character.status ?? "",
                                                   species: character.species ?? "",
                                                   gender: character.gender ?? "",
                                                   location: DataResponseModel.Location(name: character.location ?? "",url: ""),
                                                   image: ""
                )
            }
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }

    private func saveCharacters(arr: [DataResponseModel.Character]) {
        PersistentContainer.shared.performBackgroundTask { backgroundContext in
            for character in arr {
                let fetchRequest: NSFetchRequest<SingleCharacter> = SingleCharacter.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)
                
                if let existingCharacter = try? backgroundContext.fetch(fetchRequest).first {
                    // Update existing character
                    existingCharacter.gender = character.gender
                    existingCharacter.location = character.location.name
                    existingCharacter.name = character.name
                    existingCharacter.species = character.species
                    existingCharacter.status = character.status
                } else {
                    // Create new character
                    let newEntity = SingleCharacter(context: backgroundContext)
                    newEntity.id = Int16(character.id)
                    newEntity.gender = character.gender
                    newEntity.location = character.location.name
                    newEntity.name = character.name
                    newEntity.species = character.species
                    newEntity.status = character.status
                }
            }
            
            PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
        }
    }
}

extension ViewController : DetailViewControllerDelegate {
    func updatePersonSpecies(with id: Int, value: String) {
        if let index = characters.firstIndex(where: {$0.id==id}){
            characters[index].species = value
            tableView.reloadData()
        }
        dismiss(animated: true)
    }
    
    func updatePersonLocation(with id: Int, value: String) {
        if let index = characters.firstIndex(where: {$0.id==id}){
            characters[index].location.name = value
            tableView.reloadData()
        }
        dismiss(animated: true)
    }
}
