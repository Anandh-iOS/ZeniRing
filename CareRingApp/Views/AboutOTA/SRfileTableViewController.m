//  SRfileTableViewController.m
//
//  Created by linktoplinktop on 2022/5/02.
//  Copyright © 2022 Linktop. All rights reserved.
//  ta file choose
//

#import "SRfileTableViewController.h"
#import "UIViewController+Custom.h"
#import "ConfigModel.h"
#import <Masonry/Masonry.h>

@interface SRfileTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate>
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIButton *addBtn;
@end

@implementation SRfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];

    
//    WEAK_SELF
//    [self customNavStyleNormal:@"Select a file" BackBlk:^{
//        STRONG_SELF
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//    }];
    
    [self arrowback:nil];
    self.navigationItem.title = @"Select a file";
    
    self.fileArray = [self getFileListing];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // import file
    if (!self.fileArray.count) {
        [self importFiles];
    }
}


-(void)initUI {
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.tableView];
    
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(15);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).inset(20);
        make.height.equalTo(@44);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.addBtn.mas_top).inset(15);
    }];
}

-(void)importFiles {
   
        // import file @[@"public.image", @"public.content"]
        UIDocumentPickerViewController *documentPickVc = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[ @"public.data",@"public.archive",@"public.image", @"public.content"] inMode:UIDocumentPickerModeImport];
        documentPickVc.delegate = self;
        [self presentViewController:documentPickVc animated:YES completion:nil];
//    }
    
}

#pragma mark - UIDocumentPickerDelegate
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    
    if (urls.count) {
        [self copyFileFromResourceTOSandbox:urls];
        self.fileArray = [self getFileListing];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fileCell"];
    }
    NSString *fileName = self.fileArray[indexPath.row];
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", [fileName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet]]];
    NSNumber *fileSizeValue = nil;
    NSError *fileSizeError = nil;
    [fileURL getResourceValue:&fileSizeValue
                       forKey:NSURLFileSizeKey
                        error:&fileSizeError];

    NSArray *parts = [fileName componentsSeparatedByString:@"/"];
    NSString *baseName = parts[parts.count - 1];
    [cell.textLabel setText:baseName];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d B", [fileSizeValue intValue]]];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = self.fileArray[indexPath.row];

    NSURL *fileURL = [NSURL fileURLWithPath:fileName];
        
    if (self.fileCHooseCallBLK) {
        self.fileCHooseCallBLK(fileURL);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    // ready to ota
//    SROTAViewController *otaVc = [SROTAViewController new];
//    otaVc.updateImageFileUrl = fileURL;
//    [self.navigationController pushViewController:otaVc animated:YES];
    
    
}

- (NSMutableArray *)getFileListing {

    NSMutableArray *retval = [NSMutableArray array];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = paths[0];
    publicDocumentsDir = [publicDocumentsDir stringByAppendingPathComponent:OTAS_DIR];
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&error];
    if (!files) {
        NSLog(@"Error reading contents of documents directory: %@", error.localizedDescription);
        return retval;
    }

    for (NSString *file in files) {
        if ([file.pathExtension compare:@"bin" options:NSCaseInsensitiveSearch] == NSOrderedSame || [file.pathExtension compare:@"img" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [publicDocumentsDir stringByAppendingPathComponent:file];
            [retval addObject:fullPath];
        }
    }

    return retval;
}


-(void)addFile:(UIButton *)btn {
    [self importFiles];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
        _addBtn.backgroundColor = [UIColor lightGrayColor];
        [_addBtn addTarget:self action:@selector(addFile:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setTitle:@"Add Image File" forState:UIControlStateNormal];
        

    }
    
    return _addBtn;
}


@end
