//
//  DetailViewController.swift
//  lab04hw
//
//  Created by Никита Зорин on 01.07.2023.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject{
    func updatePersonSpecies(with id : Int, value : String)
    func updatePersonLocation(with id : Int, value : String)
}

final class DetailViewController: UIViewController{
    
    var data: DataResponseModel.Character? {
        didSet{
            guard let data else {return}
            setUpData(data)
        }
    }
    
    var delegate: DetailViewControllerDelegate?
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personGender: UILabel!
    @IBOutlet weak var personStatus: UILabel!
    @IBOutlet weak var personSpecies: UILabel!
    @IBOutlet weak var personLocation: UILabel!
    
    func setUpData(_ data : DataResponseModel.Character){
        personName.text = data.name
        personLocation.text = "Location: \(data.location.name)"
        personSpecies.text = "Species: \(data.species)"
        personStatus.text = "Status: \(data.status)"
        personGender.text = "Gender: \(data.gender)"
        if let imageUrl = URL(string: data.image){
            personImage.kf.setImage(with: imageUrl)}
        else{
            personImage.backgroundColor = .blue
        }
    }
    @IBAction func changeSpecies(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Change Person Species", message: "Here you can change species of person", preferredStyle: .alert)
        
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type in new species"
        })
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.delegate?.updatePersonSpecies(with: self.data!.id, value: dialogMessage.textFields?.first?.text ?? "")
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }

        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        self.present(dialogMessage, animated: true, completion: nil)
    }
    @IBAction func changeLocation(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Change Person Location", message: "Here you can change location of person", preferredStyle: .alert)
        
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type in new location"
        })
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.delegate?.updatePersonLocation(with: self.data!.id, value: dialogMessage.textFields?.first?.text ?? "")
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }

        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        self.present(dialogMessage, animated: true, completion: nil)
    }
}
