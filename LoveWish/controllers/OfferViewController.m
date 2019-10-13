//
//  OfferViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

@synthesize lblTitle,lblItemName,textViewDescription, imageTableView, imageData, txtPrice,btnSave, btnAddImage, imageItem, isCreateNewOffer, offerData, db, wishItemData, firebaseUser, tmpDownloadURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [FIRFirestore firestore];

    
    // Need to do this because we use tableView in side viewController
    [imageTableView setDelegate:self];
    [imageTableView setDataSource:self];
    
    imageData = [[NSMutableArray alloc] init];
    
    [lblItemName setText:[wishItemData objectAtIndex:2]];
    if ([[self isCreateNewOffer] isEqualToString:@"NO"]){
        [lblTitle setText:@"Offer Detail"];
        [textViewDescription setText:[offerData objectAtIndex:3]];
        [txtPrice setText:[offerData objectAtIndex:4]];
        [[self btnSave] setHidden:YES];
        [[self btnAddImage] setHidden:YES];
        // get image data
        [self getAllImageByOfferId:[[self offerData] objectAtIndex:0]];
        
        
    } else {
        [lblTitle setText:@"Create New Offer"];
        [textViewDescription setText:@""];
        [txtPrice setText:@""];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imageData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.imageTableView registerNib:[UINib nibWithNibName:@"ImageViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:@"ImageViewCell"];
    
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
    imageItem = [imageData objectAtIndex:indexPath.row];
    
    // decode base64 before assign to imageview
    //[[cell imgBox] setImage:[imageItem objectAtIndex:2]];
    [[cell lblName] setText:[imageItem objectAtIndex:1]];
    
    
    return cell;
}


- (IBAction)btnSave:(id)sender {
    // check if not have description and not have price, show alert
    if (![textViewDescription hasText] || ![txtPrice hasText])
    {
        [self displayAlertWith:@"Alert" andMessage:@"Please provide description and price"];
        return;
    }

    // save wish item for user
    __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"offers"] addDocumentWithData:@{
            @"uid":[firebaseUser uid],
            @"wishItemId":[[self wishItemData] objectAtIndex:0],
            @"description":[[self textViewDescription] text],
            @"price":[[self txtPrice] text]
            }
        completion:^(NSError * _Nullable error)
         {
             if (error != nil) {
                 NSLog(@"Error: %@", error);
                 return;

             } else {
                 NSLog(@"Add Offer successful. with %@",ref.documentID);
                 
                 // save image data to offer
                 [self saveImage:ref.documentID];
                 [[self navigationController] popViewControllerAnimated:YES];
             }

         }];
    
}

- (IBAction)btnAddImageClick:(id)sender {
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
        //  code

    } else if (status == PHAuthorizationStatusDenied) {
        //  code
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // Do something with picked image
    
    NSString *str = [NSString stringWithFormat:@"Image%lu",[self.imageData count]+1];

    // add image data to imageData
    [self.imageData addObject:@[@"",str,image]];
    // reload image table view
    [[self imageTableView] reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    NSLog(@"===============didReceiveMemoryWarning===============");
}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // dismiss screen
        //[self dismissViewControllerAnimated:(YES) completion:nil];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)saveImage: (NSString *) offerId {
    //save image detail for offer item
    // if have image data, add image
    if (imageData)
    {
        
        
        for (int i = 0; i<[imageData count]; i++) {
            //statements
            NSMutableArray *tmpArray = [imageData objectAtIndex:i];
            
            // upload image
            
            [self uploadImage:[tmpArray objectAtIndex:2]];
            

            //NSLog(@"%@",self.tmpDownloadURL);
            
            // save image for offer
            __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"images"] addDocumentWithData:@{
                @"useFor":offerId,
                @"name":[tmpArray objectAtIndex:1]
                // ***Remark
                // Not save image data to firestore due to limit size of document.                                             //@"imageBase64Data":[tmpArray objectAtIndex:1]
                
                } completion:^(NSError * _Nullable error) {
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

- (void)getAllImageByOfferId:(NSString *)offerId{
    [[[self.db collectionWithPath:@"images"] queryWhereField:@"useFor" isEqualTo:offerId]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             [self displayAlertWith:@"Alert" andMessage:@"Get offer data fail."];
             return;
             
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 // store data uid, wishItemid, title, detail
                 NSArray *item = [[NSArray alloc] initWithObjects: document[@"useFor"],document[@"name"],@"need image", nil];
                 
                 [self.imageData addObject:item];
                 
             }
             [self.imageTableView reloadData];
         }
     }];
}



// [START] Upload fire to storage
- (void)uploadImage:(UIImage *)image{
    // Create a root reference
    FIRStorage *storage = [FIRStorage storage];
    
    FIRStorageReference *storageRef = [storage reference];
    
    
    // Local file you want to upload
    NSData* data = UIImagePNGRepresentation(image);
    NSLog(@"===============file path===============");
    
    // Create a reference to the file you want to upload
    FIRStorageReference *fileRef = [storageRef child:@"images"];
    
    self.tmpDownloadURL = @"";
    
    FIRStorageUploadTask *uploadTask = [fileRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"===============error1===============");
            NSLog(@"%@",error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //int size = metadata.size;
            // You can also access to download URL after upload.
            [fileRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    NSLog(@"===============error2===============");
                    NSLog(@"%@",error);
                    
                } else {
                    NSURL *downloadURL = URL;
                    NSLog(@"===============download url===============");
                    NSLog(@"%@",downloadURL);
                    self.tmpDownloadURL = downloadURL.absoluteString;
                    NSLog(@"%@",self.tmpDownloadURL);
                }
            }];
        }
    }];
    
    // Listen for state changes, errors, and completion of the upload.
    [uploadTask observeStatus:FIRStorageTaskStatusResume handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload resumed, also fires when the upload starts
        NSLog(@"===============resumed===============");
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusPause handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload paused
        NSLog(@"===============upload pause===============");
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload reported progress
        double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload completed successfully
        NSLog(@"===============Upload completed successfully===============");
    }];
    
    // Errors only occur in the "Failure" case
    [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
        if (snapshot.error != nil) {
            switch (snapshot.error.code) {
                case FIRStorageErrorCodeObjectNotFound:
                    // File doesn't exist
                    NSLog(@"===============not exit===============");
                    break;
                    
                case FIRStorageErrorCodeUnauthorized:
                    // User doesn't have permission to access file
                    NSLog(@"===============not have permission===============");
                    break;
                    
                case FIRStorageErrorCodeCancelled:
                    // User canceled the upload
                    NSLog(@"===============canceled upload===============");
                    break;
                    
                    /* ... */
                    
                case FIRStorageErrorCodeUnknown:
                    // Unknown error occurred, inspect the server response
                    NSLog(@"===============inspect the server response===============");
                    break;
            }
        }
    }];
}
//[FINISH] upload data

@end
