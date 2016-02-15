//
//  ViewController.m
//  AKSound
//
//  Created by Andrii Kurshyn on 1/17/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

#import "ViewController.h"
#import "SoundManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* soundsFolderPath;
@property (nonatomic, strong) NSArray* soundsName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSoundSegment;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.soundsFolderPath = [[NSBundle mainBundle] pathForResource:@"Sounds" ofType:nil];
    self.soundsName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.soundsFolderPath error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.soundsName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.soundsName[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString* nameFile = self.soundsName[indexPath.row];
    NSString* filePath = [self.soundsFolderPath stringByAppendingPathComponent:nameFile];
    
    [[SoundManager sharedInstance] playByPath:filePath isSound:self.typeSoundSegment.selectedSegmentIndex == 0 completion:^(NSError *error) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }];
}

@end
