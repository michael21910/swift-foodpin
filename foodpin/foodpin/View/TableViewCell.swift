//
//  TableViewCell.swift
//  foodpin
//
//  Created by Tsuen Hsueh on 2021/11/1.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            // image become circle:
            // thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.layer.cornerRadius = 24
            thumbnailImageView.clipsToBounds = true
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
