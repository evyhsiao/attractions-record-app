//
//  ImageContentViewController.swift
//  SlideImage
//
//  Created by 羅壽之 on 2020/12/17.
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
