//
//  Album.h
//  MAD_Uebung2
//
//  Created by Markus on 11/13/14.
//  Copyright (c) 2014 Gartner&Krammer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSString * format;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) Artist *artist;

@end
