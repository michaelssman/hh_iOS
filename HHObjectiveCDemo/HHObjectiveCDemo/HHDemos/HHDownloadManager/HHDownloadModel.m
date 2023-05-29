//
//  HHDownloadModel.m
//  HHDownloadManager
//
//  Created by Michael on 2019/8/15.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHDownloadModel.h"

@implementation HHDownloadModel
- (void)openOutputStream {
    
    if (!_outputStream) {
        return;
    }
    [_outputStream open];
}

- (void)closeOutputStream {
    
    if (!_outputStream) {
        return;
    }
    if (_outputStream.streamStatus > NSStreamStatusNotOpen && _outputStream.streamStatus < NSStreamStatusClosed) {
        [_outputStream close];
    }
    _outputStream = nil;
}
@end
