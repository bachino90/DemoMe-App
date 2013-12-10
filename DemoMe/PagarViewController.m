//
//  PagarViewController.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "PagarViewController.h"
#import "FacturaViewController.h"

@interface PagarViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchBillButton;
@property (weak, nonatomic) IBOutlet UITextField *billNumber;
@end

@implementation PagarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBillButton.enabled = TRUE;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Factura Segue"])
    {
        // Get reference to the destination view controller
        FacturaViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.items = sender;
    }
}

- (IBAction)searchBill:(id)sender {
    if (self.billNumber.text.length > 0) {
        self.searchBillButton.enabled = NO;
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://localhost:3000/api/bills/%@",self.billNumber.text]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        // You need a customer id in order to save a card to the Braintree vault.
        // Here, for the sake of example, we set customer_id to device id.
        // In practice, this is probably whatever user_id your app has assigned to this user.
        
        request.HTTPMethod = @"GET";
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
         {
             NSError *err = nil;
             if (!response && requestError) {
                 NSLog(@"requestError: %@", requestError);
                 //[self.paymentViewController showErrorWithTitle:@"Error" message:@"Unable to reach the network."];
                 return;
             }
             
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&err];
             //NSLog(@"saveCardToServer: paymentInfo: %@ response: %@, error: %@", paymentInfo, responseDictionary, requestError);
             NSArray *items = [responseDictionary valueForKey:@"items"];
             NSNumber *pagado = [responseDictionary valueForKey:@"pagado"];
             if ([pagado isKindOfClass:[NSNull class]]) {
                 pagado = [NSNumber numberWithBool:FALSE];
             }
             if (items && [pagado boolValue] == FALSE) { // Success!
                 // Don't forget to call the cleanup method,
                 // `prepareForDismissal`, on your `BTPaymentViewController`
                 // Now you can dismiss and tell the user everything worked.
            
                 [self performSegueWithIdentifier:@"Factura Segue" sender:items];
                 
             } else { // The card did not save correctly, so show the error from server with convenenience method `showErrorWithTitle`
                self.searchBillButton.enabled = TRUE;
             }
         }];

    }
}

@end
