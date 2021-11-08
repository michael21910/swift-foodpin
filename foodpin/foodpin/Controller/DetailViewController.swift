//
//  DetailViewController.swift
//  foodpin
//
//  Created by Tsuen Hsueh on 2021/11/8.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var restaurantImageView: UIImageView!
    
    var restaurantImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImageView.image = UIImage(named: restaurantImageName)
    }
    
}
