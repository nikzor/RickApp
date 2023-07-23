//
//  FavouriteTableViewCell.swift
//  RickApp
//
//  Created by Никита Зорин on 23.07.2023.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpData(_ data: FavouriteData) {
        personName.text = data.characterName
        if let imageUrl = URL(string: data.imageString ?? "") {
            personImage.kf.setImage(with: imageUrl)
        } else {
            personImage.backgroundColor = .systemMint
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        personName.text = nil
        personImage.image = nil
    }
}
