//
//  VC_DisplayArtist.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import UIKit
import CoreData

class VC_DisplayArtist: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var aFetchedRequestResultsControlller:NSFetchedResultsController?;
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    @IBAction func artistLongPressGesture(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began){
            var tapPoint = sender.locationInView(tableView) as CGPoint
            
            let indexPath = tableView.indexPathForRowAtPoint(tapPoint)
            
            let artist = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath!) as Artist
            
            self.performSegueWithIdentifier("manageArtistSegue", sender: artist)
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete){
            let artist = aFetchedRequestResultsControlller!.objectAtIndexPath(indexPath) as Artist
            
            artist.managedObjectContext?.deleteObject(artist)
            
            var e:NSError?;
            if(!(artist.managedObjectContext!.save(&e))){
                NSLog("delete artist error")
            }
        }
        
    }
    
    //normal click - show albums
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let artist = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath) as Artist
        
        self.performSegueWithIdentifier("displayAlbumSegue", sender: artist)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "displayAlbumSegue"){
            let displayAlbum = segue.destinationViewController as VC_DisplayAlbum
            displayAlbum.setArtist(sender as Artist)
        }else if(segue.identifier == "manageArtistSegue"){
            let manageArtist = segue.destinationViewController as VC_ManageArtist
            //only if you click on manage, not on add
            if(sender is Artist){
                manageArtist.setArtist(sender as Artist)
            }
        }
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
        
        fillCells(cell, indexPath: indexPath)
        
        return cell;
    }
    
    func fillCells(cell:UITableViewCell, indexPath:NSIndexPath){
        let artist = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath) as Artist;
        
        cell.textLabel.text = artist.name;
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {
        switch(type) {
            
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell? {
                    fillCells(cell, indexPath: indexPath)
                }
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.insertRowsAtIndexPaths([newIndexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType)
    {
        switch(type) {
            
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}