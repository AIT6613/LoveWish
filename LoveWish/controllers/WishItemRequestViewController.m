//
//  WishItemRequestViewController.m
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "WishItemRequestViewController.h"

@interface WishItemRequestViewController ()

@end

@implementation WishItemRequestViewController

@synthesize imgData,txtTitle,txtDetail,imageTableView, imgDataItem, db, firebaseUser;



- (void)viewDidLoad {
    [super viewDidLoad];
    // get user from firestore
    db = [FIRFirestore firestore];

    // Need to do this because we use tableView in side viewController
    [imageTableView setDelegate:self];
    [imageTableView setDataSource:self];
    
    imgData = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.imageTableView reloadData];
}

// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imgData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.imageTableView registerNib:[UINib nibWithNibName:@"ImageViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:@"ImageViewCell"];
    
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    // Get image data and display on table view
    imgDataItem = [imgData objectAtIndex:indexPath.row];
    
    [[cell imgBox] setImage:[self decodeBase64ToImage:[imgDataItem objectAtIndex:1]]];
    [[cell lblName] setText:[imgDataItem objectAtIndex:0]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAddImage:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined) {
        // Request photo authorization
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // User code (show imagepicker)
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
            // Check if image access is authorized
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                // Use delegate methods to get result of photo library -- Look up UIImagePicker delegate methods
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:true completion:nil];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        // User code (show imagepicker)
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
        // Check if image access is authorized
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // Use delegate methods to get result of photo library -- Look up UIImagePicker delegate methods
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:true completion:nil];
        }
        
    } else if (status == PHAuthorizationStatusRestricted) {
        // User code
        NSLog(@"===============PHAuthorizationStatusRestricted===============");
        
    } else if (status == PHAuthorizationStatusDenied) {
        // User code
        NSLog(@"===============PHAuthorizationStatusDenied===============");
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // convert image to base64 data
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageBase64Data = [imageData base64EncodedStringWithOptions:0];
    
    NSLog(@"============Test===========");
    
    NSString *str = [NSString stringWithFormat:@"Image%lu",[self.imgData count]+1];
    
    // add image data to imageData
    [self.imgData addObject:@[str,imageBase64Data]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSave:(id)sender {
    
    // get user from firestore
    firebaseUser = [[FIRAuth auth] currentUser];
    
     NSString *str = [NSString stringWithFormat:@"users/%@/wishItems",[firebaseUser uid]];

    // save wish item for user
    __block FIRDocumentReference *ref = [[self.db collectionWithPath:str] addDocumentWithData:@{
            @"title":[[self txtTitle] text],
            @"detail":[[self txtDetail] text]} completion:^(NSError * _Nullable error)
                {
                    if (error != nil) {
                        NSLog(@"Error: %@", error);
                        return;
                        
                    } else {
                        NSLog(@"Add wish item request successful. with %@",ref.documentID);
                        [self saveImage:ref.documentID];
                        [[self navigationController] popViewControllerAnimated:YES];
                    }
                
                }];
    
}

-(void)saveImage: (NSString *) wishItemId {
    //save image detail for wish item
    // if user add image
    if (imgData)
    {
        

        for (int i = 0; i<[imgData count]; i++) {
            //statements
            
            NSMutableArray *tmpArray = [imgData objectAtIndex:i];
            
            
            // save wish item for user
            NSString *str = [NSString stringWithFormat:@"users/%@/wishItems/%@/images",[firebaseUser uid],wishItemId];
            
            __block FIRDocumentReference *ref = [[self.db collectionWithPath:str] addDocumentWithData:@{
                                                                                                        @"name":[tmpArray objectAtIndex:0],
                                                             
                                                           // Not save image data due to firestore limitation.                                             //@"imageBase64Data":[tmpArray objectAtIndex:1]
                                                                                                        }
                                                                                           completion:^(NSError * _Nullable error) {
                                                                                               if (error != nil) {
                                                                                                   NSLog(@"Error: %@", error);
                                                                                                   return;
                                                                                               } else {
                                                                                                   NSLog(@"Add Image successful. with %@",ref.documentID);
                                                                                                   
                                                                                               }
                                                                                           }];
        }
        
        
    }
}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
