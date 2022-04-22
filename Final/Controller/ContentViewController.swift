//
//  ImageContentViewController.swift
//  SlideImage
//
//  Created by evyhsiao on 2021/12/27.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var index = 0
    var image: Data? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(data: image!)
    }
    
}
