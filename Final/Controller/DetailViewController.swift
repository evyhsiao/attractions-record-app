//
//  DetailViewController.swift
//  Final
//
//  Created by evyhsiao on 2021/12/27.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var placeTitle: UILabel!
    @IBOutlet var pageIndicator: UIPageControl!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var scene: Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeTitle.text = scene.name
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pageIndicator.numberOfPages = Int(scene.photoCount)
        
        let heartImage = scene.isFavorite ? "heart.fill" : "heart"
        heartButton.tintColor = scene.isFavorite ? .systemYellow : .white
        heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
    }
    
    @IBAction func heartButton(_ sender: Any) {
        if scene.isFavorite {
            scene.isFavorite = false
        }else {
            scene.isFavorite = true
        }
        let heartImage = scene.isFavorite ? "heart.fill" : "heart"
        heartButton.tintColor = scene.isFavorite ? .systemYellow : .white
        heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        
        //Create a managed object in the context
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        // Save the data to the data store
        appDelegate.saveContext()
    }
    
    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPager"{
            let des = segue.destination as! PageViewController
            des.scene = scene
            des.indexDelegate = self
        }
        else if segue.identifier == "showWeather" {
            let destinationController = segue.destination as! WeatherViewController
            destinationController.city = scene.city
        }
        else if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.scene = scene
        }
    }
    
}

extension DetailViewController: PageIndexDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        pageIndicator.currentPage = currentIndex
    }
}

// Method implementations for the tableview data source
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
       func numberOfSections(in tableView: UITableView) -> Int {

            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return 1
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell.self), for: indexPath) as! DetailTextCell
            
            cell.descriptionLabel.text = scene.summary
//            cell.selectionStyle = .none
            
            return cell
        }

    
}

