//
//  TableViewController.swift
//  SlideImage
//
//  Created by 羅壽之 on 2020/12/17.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var fetchResultController: NSFetchedResultsController<Scene>!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!

    var scenes: [Scene] = []
    
    lazy var dataSource = configureDataSource()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // write initial data entries into the database if empty
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let count = try? managedContext.count(for: fetchRequest)
        if count == 0 { Scene.generateData() }

        // set the data source to the tableview
        tableView.dataSource = dataSource
        
        //configure the navigation title
        navigationController?.navigationBar.prefersLargeTitles = true
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetch data from the data store
        fetchSceneData()   //will refresh the table view
    }


    // MARK: - Table view data source

    func configureDataSource() -> DiffableDataSource {
        let cellIdentifier = "datacell"
        let dataSource = DiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, scene in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
                
                //configure the cell's data
                cell.nameLabel.text = scene.name
                cell.cityLabel.text = scene.city
                return cell
            }
        )
        return dataSource
    }
    
    // MARK: - UITableView Swipe Actions
    
    //swipe-to-right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action
        let actionTitle = scenes[indexPath.row].isFavorite ? "uncheck" : "check"
        let favoriteAction = UIContextualAction(style: .destructive, title: actionTitle) { (action, sourceView, completionHandler) in
            
//            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
            //update source array
            self.scenes[indexPath.row].isFavorite = self.scenes[indexPath.row].isFavorite ? false : true
            
            //save the data change when mark or unmark the favorites
            self.appDelegate.saveContext()
            
            //update the cell's accessoryType
//            cell.accessoryType = self.scenes[indexPath.row].isFavorite ? .checkmark : .none
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // change the background color of the action button
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.scenes[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeConfiguration
    }
    
    //swipe-to-left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Get the selected scene
        guard let scene = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            // Delete the data from the data store
            self.managedContext.delete(scene)
            self.appDelegate.saveContext()

            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        
        // Configure the action as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

    }
    
    // MARK: - For Segue's function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //get the destination's view controller
                let destinationController = segue.destination as! DetailViewController
                //pass the data from the source side to the destination side
                destinationController.scene = scenes[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    func fetchSceneData() {

        // Get the NSFetchRequest object and set the sorting criteria (at least once)
        let fetchRequest: NSFetchRequest<Scene> = Scene.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        //Use the NSFetchedResultController to fetch and monitor the managed objects
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self

        //Start fetching data (run once and be monitored during the lifetime of the app)
        do {
            try fetchResultController.performFetch()
            updateSnapshot()  //create the snapshot for the table view
        } catch {
            print(error)
        }
    }
    
    func updateSnapshot() {
        // redirect the newly fetched objects to the scenes array
        if let fetchedObjects = fetchResultController.fetchedObjects {
            scenes = fetchedObjects
        }
        
        // Create a snapshot and refresh the tableview
        var snapshot = NSDiffableDataSourceSnapshot<Section, Scene>()
        snapshot.appendSections([.all])
        snapshot.appendItems(scenes, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}


extension TableViewController: NSFetchedResultsControllerDelegate {
    
    // this method will be called when the FetchedResultsController detects any data changes on fetched objects
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
    
}
