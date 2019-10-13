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

@synthesize lblTitle,lblItemName,textViewDescription, imageTableView, imageData, txtPrice,btnSave, btnAddImage, imageItem, isCreateNewOffer, offerData, db, wishItemData, firebaseUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [FIRFirestore firestore];
    
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.isCreateNewOffer);
    
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
    [[cell imgBox] setImage:[imageItem objectAtIndex:2]];
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
        // User code
        NSLog(@"===============PHAuthorizationStatusRestricted===============");

    } else if (status == PHAuthorizationStatusDenied) {
        // User code
        NSLog(@"===============PHAuthorizationStatusDenied===============");

    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // Do something with picked image
    NSLog(@"===============Here===============");
    NSLog(@"%@",image);

    // convert image to base64 data
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSString *imageBase64Data = [imageData base64EncodedStringWithOptions:0];
    
    NSString *str = [NSString stringWithFormat:@"Image%lu",[self.imageData count]+1];

    // add image data to imageData
    [self.imageData addObject:@[@"",str,image]];
    // reload image table view
    [[self imageTableView] reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)saveImage: (NSString *) offerId {
    //save image detail for offer item
    // if have image data, add image
    if (imageData)
    {
        
        
        for (int i = 0; i<[imageData count]; i++) {
            //statements
            
            NSMutableArray *tmpArray = [imageData objectAtIndex:i];
            
            
            // save image for offer
            __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"images"] addDocumentWithData:@{
                @"useFor":offerId,
                @"name":[tmpArray objectAtIndex:1],
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
                 NSArray *item = [[NSArray alloc] initWithObjects: document[@"useFor"],document[@"name"], nil];
                 
                 [self.imageData addObject:item];
                 
             }
             [self.imageTableView reloadData];
         }
     }];
}

@end
