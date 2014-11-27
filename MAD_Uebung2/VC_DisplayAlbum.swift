//
//  VC_DisplayAlbum.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import UIKit
import CoreData

class VC_DisplayAlbum: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {
    
    var artist: Artist?
    
    var aFetchedRequestResultsControlller:NSFetchedResultsController?;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get managedObjectContext
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
        let moc = appDelegate.managedObjectContext!  as NSManagedObjectContext;
        
        //retrieve all artists
        var fetchRequest:NSFetchRequest = NSFetchRequest(entityName: "Album");
        var sort:NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false);
        
        var predicate = NSPredicate(format: "artist == %@", self.artist!);
        
        fetchRequest.predicate = predicate
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
    
    @IBAction func albumLongPressGesture(sender: AnyObject) {
        if (sender.state == UIGestureRecognizerState.Began){
            tableView.setEditing(!tableView.editing, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete){
            let album = aFetchedRequestResultsControlller!.objectAtIndexPath(indexPath) as Album
            
            artist!.managedObjectContext!.deleteObject(album)
            
            var e:NSError?;
            if(!(artist!.managedObjectContext!.save(&e))){
                NSLog("delete album error")
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let album = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath) as Album
        
        if(tableView.editing){
            return;
        }
        
        self.performSegueWithIdentifier("manageAlbumSegue", sender: album)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "manageAlbumSegue"){
            let manageAlbum = segue.destinationViewController as VC_ManageAlbum
            manageAlbum.setAlbum(sender as Album)
            
            manageAlbum.setArtist(self.artist!)
        }else if(segue.identifier == "addAlbumSegue"){
            let manageAlbum = segue.destinationViewController as VC_ManageAlbum
            
            manageAlbum.setArtist(self.artist!)
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
        var identifier:NSString = "AlbumCell";
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell; //get cell
        
        fillCells(cell, indexPath: indexPath)
        
        return cell;
    }
    
    func fillCells(cell:UITableViewCell, indexPath:NSIndexPath){
        let album = aFetchedRequestResultsControlller?.objectAtIndexPath(indexPath) as Album;
        
        cell.textLabel.text = album.name;
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
    
    func setArtist(artist: Artist){
        self.artist = artist
    }
    
    
}