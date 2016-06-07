//
//  MasterViewController.swift
//  Stretchy Headers
//
//  Created by Zach Smoroden on 2016-06-07.
//  Copyright © 2016 Zach Smoroden. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var data : [NewsItem] = [NewsItem]()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var headerView2:UIView!
    
    let kTableHeaderHeight = 216
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        headerView2 = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        tableView.addSubview(headerView2)
        
        setupData()
        setupDate()
        
        tableView.contentInset = UIEdgeInsetsMake(CGFloat(kTableHeaderHeight), 0.0, 0.0, 0.0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        updateHeaderView()
        
        

    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: CGFloat(0), y: CGFloat(-kTableHeaderHeight), width: tableView.bounds.width, height: CGFloat(kTableHeaderHeight))
        if tableView.contentOffset.y < CGFloat(-kTableHeaderHeight) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView2.frame = headerRect
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupDate() {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE d"
        
        dateLabel.text = formatter.stringFromDate(date)
    }
    
    func setupData() {
        data.append(NewsItem(category: .World, headline: "Climate change protests, divestments meet fossil fuels realities"))
        data.append(NewsItem(category: .Europe, headline: "Scotland's 'Yes' leader says independence vote is 'once in a lifetime'"))
        data.append(NewsItem(category: .MiddleEast, headline: "Airstrikes boost Islamic State, FBI director warns more hostages possible"))
        data.append(NewsItem(category: .Africa, headline: "Nigeria says 70 dead in building collapse; questions S. Africa victim claim"))
        data.append(NewsItem(category: .AsiaPacific, headline: "Despite UN ruling, Japan seeks backing for whale hunting"))
        data.append(NewsItem(category: .Americas, headline: "Officials: FBI is tracking 100 Americans who fought alongside IS in Syria"))
        data.append(NewsItem(category: .World, headline: "South Africa in $40 billion deal for Russian nuclear reactors"))
        data.append(NewsItem(category: .Europe, headline: "'One million babies' created by EU student exchanges"))
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }

    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let entity = self.fetchedResultsController.fetchRequest.entity!
//        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
//             
//        // If appropriate, configure the new managed object.
//        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
//             
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            //print("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = self.data[indexPath.row]
                let controller = segue.destinationViewController as! DetailViewController
                controller.detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        
        let newsItem = data[indexPath.row]
        
        
        cell.categoryLabel.text = newsItem.category.rawValue
        cell.categoryLabel.textColor = newsItem.getColor()
        
        cell.headlineLabel.text = newsItem.headline
        
        return cell
    }
    
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }


//    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
//        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
//        cell.textLabel!.text = object.valueForKey("timeStamp")!.description
//    }

    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */
    
    


}

enum Category:String {
    case World = "World"
    case Americas = "Americas"
    case Europe = "Europe"
    case MiddleEast = "Middle East"
    case Africa = "Africa"
    case AsiaPacific = "Asia Pacific"
}

struct NewsItem {
    var category:Category
    var headline:String
    
    func getColor() -> UIColor {
        switch category {
        case .Africa:
            return UIColor.orangeColor()
        case .Americas:
            return UIColor.blueColor()
        case .AsiaPacific:
            return UIColor.purpleColor()
        case .Europe:
            return UIColor.greenColor()
        case .MiddleEast:
            return UIColor.yellowColor()
        case .World:
            return UIColor.redColor()
        }
        
    }
    
}

