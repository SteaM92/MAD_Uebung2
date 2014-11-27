//
//  VC_ManageAlbum.swift
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

import UIKit
import CoreData

class VC_ManageAlbum: UIViewController {
    
    var album : Album?
    var artist : Artist?
    
    var moc:NSManagedObjectContext?; //? means it can be null aka optional
    var appDelegate:AppDelegate?;
    
    @IBOutlet weak var album_format: UITextField!
    @IBOutlet weak var album_name: UITextField!
    @IBOutlet weak var album_year: UITextField!
    
    @IBAction func album_save(sender: UIButton) {
        
        if(self.album_name.text.isEmpty || self.album_format.text.isEmpty || self.album_year.text.isEmpty){
            
            let alertController = UIAlertController(title: "Error", message:
                "Invalid Input.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
            self.save();
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func setAlbum(album: Album){
        self.album = album
    }
    
    func setArtist(artist: Artist){
        self.artist = artist
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get managedObjectContext
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate;
        moc = appDelegate!.managedObjectContext!  as NSManagedObjectContext; //! because its optional
        
        //because album could be nil
        if let myAlbum = album {
            self.album_format.text = myAlbum.format
            self.album_name.text = myAlbum.name
            self.album_year.text = myAlbum.year
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(){
        var hasValue = false;
        if let myAlbum = album {
            hasValue = true;
        }
        
        if (!hasValue) {
            let entity =  NSEntityDescription.entityForName("Album",
                inManagedObjectContext: moc!)
            
            album = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:moc) as? Album
            
            if (album == nil) {
                NSLog("Failed to create new Album entitiy instance");
                return;
            }
        }
        
        //var myObject:Artist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: moc!) as Artist;
        //myObject.setValue(self.artist_name.text, forKey: "name")
        //myObject.setValue(self.artist_label.text, forKey: "label")
        
        album?.year = album_year.text;
        album?.name = album_name.text;
        album?.format = album_format.text
        album?.artist = artist!
        
        var error: NSError?
        if !moc!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
}