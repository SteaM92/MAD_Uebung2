//
//  VC_DisplayArtist.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import UIKit
import CoreData

class VC_DisplayArtist: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var artist = [NSManagedObject]();
    
    var aFetchedRequestResultsControlller:NSFetchedResultsController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get managedObjectContext
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
        let moc = appDelegate.managedObjectContext!  as NSManagedObjectContext;
        
        //retrieve all artists
        var fetchRequest:NSFetchRequest = NSFetchRequest(entityName: "Artist");
        var sort:NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false);
        
        fetchRequest.sortDescriptors = [sort];
        
        var e:NSError?;
        
        aFetchedRequestResultsControlller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil);
        aFetchedRequestResultsControlller!.delegate = self;
        if(!aFetchedRequestResultsControlller!.performFetch(&e)){
            abort();
        }
        
        //NSLog("\(result)");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.aFetchedRequestResultsControlller?.sections![section] as NSFetchedResultsSectionInfo).numberOfObjects; //asks the conroller how many rows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1; //dont devide into sections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier:NSString = "ArtistCell";
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell; //get cell
    }
    
    func fillCells(cell:UITableViewCell, indexPath:NSIndexPath){
        let obj = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath) as Artist;
    }
    
}