//
//  PersonTableViewCell.swift
//  lab04hw
//
//  Created by Никита Зорин on 01.07.2023.
//

import UIKit
import Kingfisher

final class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personGender: UILabel!
    @IBOutlet weak var personStatus: UILabel!
    @IBOutlet weak var personSpecies: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData(_ data: DataResponseModel.Character) {
        personName.text = data.name
        personSpecies.text = "Species: \(data.species)"
        personStatus.text = "Status: \(data.status)"
        personGender.text = "Gender: \(data.gender)"
        
        if let imageUrl = URL(string: data.image) {
            personImage.kf.setImage(with: imageUrl)
        } else {
            personImage.backgroundColor = .blue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personName.text = nil
        personSpecies.text = nil
        personStatus.text = nil
        personGender.text = nil
        personImage.image = nil
    }
}
