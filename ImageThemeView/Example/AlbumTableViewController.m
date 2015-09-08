//
//  AlbumTableViewController.m
//  ImageColorView
//
//  Created by Kip Ricker on 8/31/15.
//  Copyright (c) 2015 Kilopound. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "AlbumTableViewCell.h"

@interface AlbumTableViewController ()

@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation AlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = [[NSMutableArray alloc] init];
    NSArray *imageFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] pathForResource:@"TestImages" ofType:@""] error:nil];
    
    for (NSString *imageNamed in imageFiles) {
        [_images addObject:[NSString stringWithFormat:@"TestImages/%@", imageNamed]];
    }
        
    UINib *cell = [UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"AlbumTableViewCell"];
    
    self.tableView.rowHeight = 82;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _images.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell" forIndexPath:indexPath];
    
    [cell displayAlbumImageNamed:[_images objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
