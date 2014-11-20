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
    
    var artist = [NSManagedObject]();
    
    var moc:NSManagedObjectContext?; //? means it can be null aka optional
    var appDelegate:AppDelegate?;
    
    @IBOutlet weak var artist_name: UITextField!
    @IBOutlet weak var artist_label: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get managedObjectContext
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
        moc = appDelegate!.managedObjectContext!  as NSManagedObjectContext; //! because its optional
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(){
        let entity =  NSEntityDescription.entityForName("Artist",
            inManagedObjectContext:
            moc!)
        
        let myObject = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:moc)
        
        //var myObject:Artist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: moc!) as Artist;
        
        myObject.setValue(self.artist_name.text, forKey: "name")
        myObject.setValue(self.artist_label.text, forKey: "label")
        
        var error: NSError?
        if !moc!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func edit(){

    }
    
    func insert(){
        
    }
    
}