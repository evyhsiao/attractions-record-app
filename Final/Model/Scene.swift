//
//  Scene+CoreDataClass.swift
//  FoodPin
//
//  Created by evyhsiao on 2021/12/29.
//
//

import Foundation
import CoreData
import UIKit

public class Scene: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scene> {
        return NSFetchRequest<Scene>(entityName: "Scene")
    }

    @NSManaged public var name: String
    @NSManaged public var city: String
    @NSManaged public var address: String
    @NSManaged public var summary: String
    @NSManaged public var image1: Data
    @NSManaged public var image2: Data
    @NSManaged public var image3: Data
    @NSManaged public var photoCount: Int16
    @NSManaged public var isFavorite: Bool
        
    // implement one customized managed object constructor
    convenience init(name: String, city: String, address: String, summary: String, photoCount: Int16, imageName: [String]) {
        
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        // call the original constructor to create one managed object
        self.init(context: appDelegate!.persistentContainer.viewContext)
        // fill the data fields from the passing parameters
        self.name = name
        self.city = city
        self.summary = summary
        self.address = address
        for i in 0..<imageName.count {
            if i == 0 {
                self.image1 = UIImage(named: imageName[0])!.pngData()!
            }
            else if i == 1 {
                self.image2 = UIImage(named: imageName[1])!.pngData()!
            }
            else if i == 2{
                self.image3 = UIImage(named: imageName[2])!.pngData()!
            }
        }
        self.photoCount = photoCount
    }
}


extension Scene {
    
    static func generateData() {
        
        // create some managed objects for testing
        _ = [
            Scene(name: "Taipei 101", city: "Taipei", address: "Taipei 101, Taipei", summary: "The Taipei 101 (台北101) is a supertall skyscraper designed by C.Y. Lee and C.P. Wang in Xinyi, Taipei, Taiwan. This building was officially classified as the world's tallest from its opening in 2004 until the 2010 completion of the Burj Khalifa in Dubai, UAE.", photoCount: 2, imageName: ["photo0_0.jpg", "photo0_1.jpg"]),
            Scene(name: "Taroko National Park", city: "Hualien", address: "Taroko National Park, Hualien, Taiwan", summary: "Taroko National Park (太魯閣國家公園) is one of the nine national parks in Taiwan and was named after the Taroko Gorge, the landmark gorge of the park carved by the Liwu River. The park spans Taichung Municipality, Nantou County, and Hualien County and is located at Xiulin Township, Hualien County, Taiwan.", photoCount: 3, imageName: ["photo1_0.jpg",  "photo1_1.jpg", "photo1_2"]),
            Scene(name: "Kenting National Park", city: "Pingtung", address: "Kenting National Park, Taiwan",summary: "Kenting National Park (墾丁國家公園) is a national park located on the Hengchun Peninsula of Pingtung County, Taiwan, covering Hengchun, Checheng, and Manzhou Townships. Established on 1 January 1984, it is Taiwan's oldest and the southernmost national park on the main island, covering the southernmost area of the Taiwan island along Bashi Channel.", photoCount: 2, imageName: ["photo2_0.jpg", "photo2_1.jpg"])
        ]
        
        //write all managed objects into the database
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
    }
}

//struct Scene {
//    var name: String = ""
//    var city: String = ""
//    var address: String = ""
//    var summary: String = ""
//    var photoCount: Int = 0
//    var image1: String?
//    var image2: String?
//    var image3: String?
//}

