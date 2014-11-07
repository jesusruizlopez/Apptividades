//
//  ActivitiesTableViewController.m
//  Apptividades
//
//  Created by Jesús Ruiz on 05/11/14.
//  Copyright (c) 2014 Pretzel. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "ActivityTableViewCell.h"

@interface ActivitiesTableViewController ()

@end

@implementation ActivitiesTableViewController {
    NSUserDefaults *ud;
    NSMutableArray *activitiesList;
    NSIndexPath *index;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    ud = [NSUserDefaults standardUserDefaults];
    activitiesList = [[NSMutableArray alloc] init];
    index = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([ud objectForKey:@"activities"] != nil)
        activitiesList = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"activities"]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Actividades (%ld)", [activitiesList count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [activitiesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    NSMutableDictionary *activity = [activitiesList objectAtIndex:indexPath.row];
    
    cell.lblName.text = [activity objectForKey:@"name"];
    NSInteger count = [[activity objectForKey:@"count"] integerValue];
    cell.lblCount.text = [activity objectForKey:@"count"];
    
    switch ([[activity objectForKey:@"type"] integerValue]) {
        case 1:
            cell.lblType.text = @"POSITIVA";
            cell.lblType.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:208.0/255.0 blue:177.0/255.0 alpha:1.0];
            
            if (count == 0)
                cell.lblMessage.text = @"Mal, todavía no empiezas";
            else if (count <= 10)
                cell.lblMessage.text = @"Bien, sigue así";
            else if (count <= 20)
                cell.lblMessage.text = @"Perfecto, un poco más";
            else if (count <= 30)
                cell.lblMessage.text = @"Excelente, felicitaciones";
            break;
        case 2:
            cell.lblType.text = @"NEGATIVA";
            cell.lblType.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:50.0/255.0 blue:42.0/255.0 alpha:1.0];
            
            if (count == 0)
                cell.lblMessage.text = @"Todo bien hasta ahorita";
            else if (count <= 10)
                cell.lblMessage.text = @"Oye, ¿qué está pasando?";
            else if (count <= 20)
                cell.lblMessage.text = @"No sigas, vas muy mal";
            else if (count <= 30)
                cell.lblMessage.text = @"Eres caso perdido...";
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Eliminar";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmación" message:@"¿Está seguro que desea eliminar la actividad?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
        alert.tag = 1;
        index = indexPath;
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary *activity = [[activitiesList objectAtIndex:indexPath.row] mutableCopy];
    long count = [[activity objectForKey:@"count"] integerValue];
    count ++;
    [activity setValue:[NSString stringWithFormat:@"%ld", count] forKey:@"count"];
    
    [activitiesList replaceObjectAtIndex:indexPath.row withObject:activity];
    
    [ud setObject:activitiesList forKey:@"activities"];
    [ud synchronize];
    
    [self.tableView reloadData];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 1) {
            [activitiesList removeObjectAtIndex:index.row];
            
            [ud setObject:activitiesList forKey:@"activities"];
            [ud synchronize];
            
            [self.tableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"Actividades (%ld)", [activitiesList count]];
        }
        index = nil;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
