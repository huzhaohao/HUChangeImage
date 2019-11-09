//
//  ViewController.m
//  HUChangeImage
//
//  Created by huzhaohao on 2019/11/9.
//  Copyright © 2019 huzhaohao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *_iconAarray;
}

@end

@implementation ViewController

NSString *tarPath=@"/Users/huzhaohao/Desktop/demo/demo/Assets.xcassets";

- (void)viewDidLoad {
    [super viewDidLoad];
    tarPath = @"/Users/huzhaohao/Desktop/HUChangeImage/HUChangeImage/Assets.xcassets";
    _iconAarray = [NSMutableArray arrayWithObjects:@"20@2",@"20@3",@"29@2",@"29@3",@"40@2",@"40@3",@"60@2",@"60@3",@"1024@1", nil];//iphone
    NSArray *ipadArray = [[NSArray alloc] initWithObjects:@"20@1",@"20@2",@"29@1",@"29@2",@"40@1",@"40@2",@"76@1",@"76@2",@"167@1", nil];
    [_iconAarray addObjectsFromArray:ipadArray];
    [self changeIconImage];
}

- (void)changeIconImage {
    NSString *name = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    for(int i = 0;i <_iconAarray.count;i++) {
        NSString *sizeStr = _iconAarray[i];
        NSArray *tempArray = [sizeStr componentsSeparatedByString:@"@"];
        NSString *aStr = [tempArray firstObject];
        NSString *bStr = [tempArray lastObject];
        NSInteger width = aStr.integerValue * bStr.integerValue;
        NSString *newName = [NSString stringWithFormat:@"%d%@x.png",i,_iconAarray[i]];
        NSLog(@"newName =%@",newName);
        [self makeNewImage:name newName:newName  size:CGSizeMake(width, width)];
        [self copyFileToDesktop:newName];
    }
}

-(void)copyFileToDesktop:(NSString *)file
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docuDir = [paths objectAtIndex:0];
    //    NSString *savedFileName = [docuDir stringByAppendingPathComponent:@"data"];
    NSString *srcPath=docuDir;
    srcPath = [srcPath stringByAppendingString:@"/"];
    srcPath = [srcPath stringByAppendingString:file];
    NSString *iconPath = [tarPath stringByAppendingString:@"/AppIcon.appiconset/"];
    iconPath = [iconPath stringByAppendingString:file];

    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL success=[fileManager createFileAtPath:iconPath contents:nil attributes:nil];
    if (success) {
        NSLog(@"文件创建成功");

        NSFileHandle *inFile=[NSFileHandle fileHandleForReadingAtPath:srcPath];
        NSFileHandle *outFile=[NSFileHandle fileHandleForWritingAtPath:iconPath];

        NSDictionary *fileAttu=[fileManager attributesOfItemAtPath:srcPath error:nil];
        NSNumber *fileSizeNum=[fileAttu objectForKey:NSFileSize];

        BOOL isEnd=YES;
        NSInteger readSize=0;//已经读取的数量
        NSInteger fileSize=[fileSizeNum longValue];//文件的总长度
        while (isEnd) {

            NSInteger subLength=fileSize-readSize;
            NSData *data=nil;
            if (subLength<5000) {
                isEnd=NO;
                data=[inFile readDataToEndOfFile];
            }else{
                data=[inFile readDataOfLength:5000];
                readSize+=5000;
                [inFile seekToFileOffset:readSize];
            }
            [outFile writeData:data];

        }

        [inFile closeFile];
        [outFile closeFile];
    }

    // 为了更方便地使用，我们可以直接在存储时，用下面的串代码， 并写入到这个文件中， 运行后， 就会发现该文件已经在桌面上了，且已被写入数据。
    //    NSString *savedFileName =@"/Users/yisanmaoyi/Desktop/data";
}



- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void) makeNewImage:(NSString *)name newName:(NSString *)newName
                size:(CGSize)targetSize
{

    UIImage *tabbarimage=[UIImage imageWithContentsOfFile:name];
    UIImage *image =[self scaleToSize:tabbarimage size:targetSize];

    //设置一个图片的存储路径
    NSString *imagePath;
    NSString *path_sandox;
    path_sandox = NSHomeDirectory();
    path_sandox = [path_sandox stringByAppendingString:@"/Documents/"];
    // NSLog(@"%@",path_sandox);
    path_sandox = [path_sandox stringByAppendingString:newName];
    imagePath = path_sandox;

    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];

}



@end
