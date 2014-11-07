//
//  ActivityTableViewController.h
//  Apptividades
//
//  Created by Jesús Ruiz on 05/11/14.
//  Copyright (c) 2014 Pretzel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *txtActivityName;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityType;

@end
