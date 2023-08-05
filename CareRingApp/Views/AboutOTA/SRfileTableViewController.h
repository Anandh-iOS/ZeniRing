//  SRfileTableViewController.h
//
//  Created by linktoplinktop on 2022/5/02.
//  Copyright © 2022 Linktop. All rights reserved.
//  ta file choose
//

#import "NAVTemplateViewController.h"

@interface SRfileTableViewController : NAVTemplateViewController

@property (strong) NSMutableArray *fileArray;
@property(copy, nonatomic)void (^ _Nullable fileCHooseCallBLK)(NSURL * _Nullable fileUrl);

@end
