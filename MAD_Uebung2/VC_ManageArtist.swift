//
//  VC_ManageArtist.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import UIKit
import CoreData

class VC_ManageArtist: UIViewController {
    
    var artist : Artist?
    
    var moc:NSManagedObjectContext?; //? means it can be null aka optional
    var appDelegate:AppDelegate?;
    
    @IBOutlet var artist_name: UITextField!
    @IBOutlet var artist_label: UITextField!
    
    @IBAction func artist_save(sender: UIButton) {
        
        if(self.artist_name.text.isEmpty || self.artist_label.text.isEmpty){
            
            let alertController = UIAlertController(title: "Error", message:
                "Invalid Input.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
            self.save();
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func setArtist(artist: Artist){
        self.artist = artist
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get managedObjectContext
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate;
        moc = appDelegate!.managedObjectContext!  as NSManagedObjectContext; //! because its optional
        
        //because artist could be nil
        if let myArtist = artist {
            self.artist_name.text = myArtist.name
            self.artist_label.text = myArtist.label
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(){
        var hasValue = false;
        if let myArtist = artist {
            hasValue = true;
        }
        
        if (!hasValue) {
            let entity =  NSEntityDescription.entityForName("Artist",
                inManagedObjectContext: moc!)
            
            artist = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:moc) as? Artist
            
            if (artist == nil) {
                NSLog("Failed to create new Artist entitiy instance");
                return;
            }
        }
        
        //var myObject:Artist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: moc!) as Artist;
        //myObject.setValue(self.artist_name.text, forKey: "name")
        //myObject.setValue(self.artist_label.text, forKey: "label")
        
        artist?.label = artist_label.text;
        artist?.name = artist_name.text;
        
        var error: NSError?
        if !moc!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
}