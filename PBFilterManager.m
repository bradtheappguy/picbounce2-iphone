//
//  PBFilterManager.m
//  PicBounce2
//
//  Created by Thomas DiZoglio on 11/13/11.
//  Copyright (c) 2011 Clixtr, Inc. All rights reserved.
//

#import "PBFilterManager.h"
#import "ImageFilter.h"

NSMutableArray *lFilterObjects = nil;
NSDictionary *lFilterInformation = nil;
PBFilterManager *createButtonObject = nil;

@implementation PBFilterManager

@synthesize parentViewController;
@synthesize delegate;


#pragma mark init / dealloc


- (id) init:(PBNewFilterViewController *)parentView {
  
  if (self = [super init]) {
    parentViewController = parentViewController;
    delegate = nil;
    filterObjects = [[NSMutableArray alloc] init];
    PBFilterObject *filterObjectNormal = [[PBFilterObject alloc] init];    
    [filterObjectNormal setFilterName:@"Normal"];
    [filterObjectNormal setActions:nil];
    [filterObjects addObject:filterObjectNormal];
    [filterObjectNormal release];
    cleanImage = [self createCleanImageFilter:[[parentView imageView] image]];
    createButtonObject = self;
  }
  return self;
}

- (id) init {
  
  if (self = [super init]) {
    parentViewController = nil;
    delegate = nil;
    filterObjects = [[NSMutableArray alloc] init];
    PBFilterObject *filterObjectNormal = [[PBFilterObject alloc] init];    
    [filterObjectNormal setFilterName:@"Normal"];
    [filterObjectNormal setActions:nil];
    [filterObjects addObject:filterObjectNormal];
    [filterObjectNormal release];
    cleanImage = nil;
    createButtonObject = self;
  }
  return self;
}

- (void)dealloc {

  [super dealloc];

  [filterObjects release];
  [filterInformation release];
}

#pragma mark - filter managment functions

- (BOOL) loadFilterPList
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", FILTER_INFO_FILENAME]];
  if (![fileManager fileExistsAtPath: filePath])
  {
    [PBFilterManager createInitialScriptPListFiles];
  }

  filterInformation = [self loadFilterVersionFromPlist:FILTER_INFO_FILENAME];
  lFilterInformation = filterInformation;
  NSArray *filters = [self loadFilterDataFromPlist:FILTERS_FILENAME];

  // Make sure generic image for filter buttons is local and ready to use.
  NSString *local_filter_folder = [filterInformation objectForKey:@"local_filter_button_image"];
  if ([local_filter_folder isEqualToString:@""])
  {
    // Get generic image from server and create local version. For now just copy from bundle
    // to documents directory so PBFilterObjects can create there own versions
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:FILTER_DATA_DIRECTORY];
    // Create direcotry if doesn't exist
    if (![fileManager fileExistsAtPath:dirPath])
    {
      NSError *error;
      BOOL success = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
      if (!success)
        NSLog(@"ERROR:%@", error);
    }

    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mary_t" ofType:@"png"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", FILTER_DATA_DIRECTORY, @"gen_Filter.png"]];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];

    [filterInformation setValue:filePath forKey:@"local_filter_button_image"];
    [self storeFilterPlistFiles];
  }

  // Create the PBFilterObjects using filters
  for (NSDictionary *filter in filters) {

    PBFilterObject *pbFilterObj = [[PBFilterObject alloc] init];    
    [pbFilterObj setFilterName:[filter objectForKey:@"filter_name"]];
    [pbFilterObj setActions:[filter objectForKey:@"actions"]];
    [filterObjects addObject:pbFilterObj];
    [pbFilterObj release];
  }
  
  lFilterObjects = filterObjects;
  
  return NO;
}

- (CGFloat) layoutFilterView:(UIScrollView *)view
{

  CGFloat x = 10.0;
  int buttonTag = 0;
  for (PBFilterObject *filter in filterObjects) {

    UIButton *filterButton = [filter createFilterButton];
    [filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchDown];
    filterButton.tag = buttonTag;
    filterButton.frame = CGRectMake(x, 2, 80.0, 80.0);
    [view addSubview:filterButton];
    x += 90.0;
    buttonTag++;
  }

  return x;
}


- (void) filterButtonPressed:(id)sender
{
  UIButton *buttonPressed = (UIButton *)sender;
  UIImage *newImage = [self applyFilter:buttonPressed.tag withImage:nil];

  if (delegate != nil)
  {
    if ([delegate conformsToProtocol:@protocol(PBFilterNotifierDelegate)])
    {
      if ([delegate respondsToSelector:@selector(filterProcessingCompleteRefreshView:)])
      {
        [delegate filterProcessingCompleteRefreshView:newImage];
      }
    }
  }
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
  
  CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
  CGImageRef imageRef = image.CGImage;
  
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Set the quality level to use when rescaling
  CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
  CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
  
  CGContextConcatCTM(context, flipVertical);  
  // Draw into the context; this scales the image
  CGContextDrawImage(context, newRect, imageRef);
  
  // Get the resized image from the context and a UIImage
  CGImageRef newImageRef = CGBitmapContextCreateImage(context);
  UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
  
  CGImageRelease(newImageRef);
  UIGraphicsEndImageContext();    
  
  return newImage;
}

- (UIImage *) applyFilter:(int)index withImage:(UIImage *)image {

  UIImage *filterApplyImage = image;
  if (filterApplyImage == nil)
  {
    filterApplyImage = [self createCleanImageFilter:cleanImage];
    filterApplyImage = [self resizeImage:filterApplyImage newSize:CGSizeMake(600, 600)];
  }

  PBFilterObject *filter = [filterObjects objectAtIndex:index];
  NSString *filter_name = [filter filterName];
  NSLog(@"filter name pressed = %@", filter_name);
  if ([filter_name isEqualToString:@"Nostaglia"])
    return [filterApplyImage Nostalgia];
  else if ([filter_name isEqualToString:@"Nashville"])
    return [filterApplyImage Nashville];
  else if ([filter_name isEqualToString:@"Lomo"])
    return [filterApplyImage lomo];
  else
  {
    // Process actions for the selected filter
    NSArray *actions = [filter actions];
    if (actions == nil) // check for Normal image
    {
      return filterApplyImage;
    }
    NSLog(@"Filter is made up of %d actions", [actions count]);
    for (NSDictionary *action in actions) {
      NSString *action_name = [action objectForKey:@"action_name"];
      NSLog(@"Applying action \"%@\" to image", action_name);
      // Action: SHARPEN
      if ([action_name isEqualToString:@"sharpen"]) {
        
        NSArray *kernel = [action objectForKey:@"kernel"];
        
        NSMutableArray *sharpenKernel = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray *row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:0] floatValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:1] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:2] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:3] longValue]]];
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:4] floatValue]]];
        [sharpenKernel addObject:row];
        row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:5] floatValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:6] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:7] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:8] longValue]]];
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:9] floatValue]]];
        [sharpenKernel addObject:row];
        row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:10] floatValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:11] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:12] longValue]]];
        [row addObject:[NSNumber numberWithDouble:[[kernel objectAtIndex:13] longValue]]];
        [row addObject:[NSNumber numberWithLong:[[kernel objectAtIndex:14] floatValue]]];
        [sharpenKernel addObject:row];
        row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        // Make 2 more empty (creates 5x5)
        [row addObject:[NSNumber numberWithLong:0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithLong:0]];
        [sharpenKernel addObject:row];
        row = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        [row addObject:[NSNumber numberWithLong:0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithDouble:0.0]];
        [row addObject:[NSNumber numberWithLong:0]];
        [sharpenKernel addObject:row];
        
        return [UIImage ApplyConvolve:sharpenKernel withImage:filterApplyImage];
        
      }
      // Action: SEPIA
      else if ([action_name isEqualToString:@"sepia"]) {
        return [UIImage sepia:filterApplyImage];
      }
      // Action: DARKVIGNETTE
      else if ([action_name isEqualToString:@"darkVignette"]) {
        return [UIImage darkVignette:filterApplyImage];
      }
      // Action: SATURATE
      else if ([action_name isEqualToString:@"saturate"]) {
        double amount = [[action objectForKey:@"amount"] doubleValue];
        return [UIImage saturate:amount withImage:filterApplyImage];
      }
      // Action: CONTRAST
      else if ([action_name isEqualToString:@"contrast"]) {
        double amount = [[action objectForKey:@"amount"] floatValue];
        return [UIImage contrast:amount withImage:filterApplyImage];
      }
      // Action: LEVEL
      else if ([action_name isEqualToString:@"level"]) {
        int black = [[action objectForKey:@"black"] longValue];
        int mid = [[action objectForKey:@"mid"] longValue];
        int white = [[action objectForKey:@"white"] longValue];
        int channel = [[action objectForKey:@"channel"] longValue];
        return [UIImage levels:black mid:mid white:white channel:channel withImage:filterApplyImage];
      }
      // Action: APPLYCURVE
      else if ([action_name isEqualToString:@"applycurve"]) {
        // CurveChannel curve
        CurveChannel channel;
        NSInteger curveChannel = [[action objectForKey:@"CurveChannel"] integerValue];
        switch (curveChannel) {
          case 0:
            channel = CurveChannelNone;
            break;
          case 1:
            channel = CurveChannelRed;
            break;
          case 2:
            channel = CurveChannelGreen;
            break;
          case 3:
            channel = CurveChannelBlue;
            break;
        }
        // Get the 4 points that make up the curve
        NSArray *curve = [action objectForKey:@"curve"];
        NSArray *points = [NSArray arrayWithObjects:
                           [NSValue valueWithCGPoint:CGPointMake([[curve objectAtIndex:0] longValue], [[curve objectAtIndex:1] longValue])],
                           [NSValue valueWithCGPoint:CGPointMake([[curve objectAtIndex:2] longValue], [[curve objectAtIndex:3] longValue])],
                           [NSValue valueWithCGPoint:CGPointMake([[curve objectAtIndex:4] longValue], [[curve objectAtIndex:5] longValue])],
                           [NSValue valueWithCGPoint:CGPointMake([[curve objectAtIndex:6] longValue], [[curve objectAtIndex:7] longValue])],
                           nil];
        return [UIImage applyCurve:points toChannel:channel withImage:filterApplyImage];
      }
      // Action: INVERT
      else if ([action_name isEqualToString:@"invert"]) {
        return [UIImage invert:filterApplyImage];
      }
      // Action: VIGNETTE
      else if ([action_name isEqualToString:@"vignette"]) {
        return [UIImage vignette:filterApplyImage];
      }
      // Action: BRIGHTNESS
      else if ([action_name isEqualToString:@"brightness"]) {
        double amount = [[action objectForKey:@"amount"] doubleValue];
        return [UIImage brightness:amount withImage:filterApplyImage];
      }
      // Action: COLOR COMPOSITE
      else if ([action_name isEqualToString:@"colorComposite"]) {
        int red = [[action objectForKey:@"red"] intValue];
        int green = [[action objectForKey:@"red"] intValue];
        int blue = [[action objectForKey:@"red"] intValue];
        int alpha = [[action objectForKey:@"red"] doubleValue];
        int blendmode = [[action objectForKey:@"blendmode"] intValue];
        return [UIImage imageColorComposite:red withGreen:green withBlue:blue withAlpha:alpha withBlendMode:blendmode withImage:filterApplyImage];
      }
      // Action: IMAGE COMPOSITE
      else if ([action_name isEqualToString:@"imageComposite"]) {
        NSString *fileName = [action objectForKey:@"image_name"];
        int alpha = [[action objectForKey:@"red"] doubleValue];
        int blendmode = [[action objectForKey:@"blendmode"] intValue];
        return [UIImage imageCompositeImageNamed:fileName withAlpha:alpha withBlendMode:blendmode withImage:filterApplyImage];
      }
      // Action: IMAGE TILED COMPOSITE
      else if ([action_name isEqualToString:@"imageTiledComposite"]) {
        NSString *fileName = [action objectForKey:@"image_name"];
        int alpha = [[action objectForKey:@"red"] doubleValue];
        int blendmode = [[action objectForKey:@"blendmode"] intValue];
        return [UIImage imageCompositeImageTiledNamed:fileName withAlpha:alpha withBlendMode:blendmode withImage:filterApplyImage];
      }
      
    }
  }

  return nil;
}

#pragma mark - local filter managment functions

+(void) createInitialScriptPListFiles
{
  // Write out app filter information
  NSDictionary *filterInformation = [[[NSDictionary alloc] initWithObjectsAndKeys: 
                                      [NSDate date], @"createdOn",
                                      [NSNumber numberWithLong:0], @"version_major",
                                      [NSNumber numberWithLong:1], @"version_minor",
                                      @"http://via.me/cdn/filter.plist", @"filter_url",
                                      @"http://via.me/cdn/filter_image.png", @"filter_button_image",
                                      @"", @"local_filter_button_image", nil] autorelease];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", FILTER_INFO_FILENAME]];
  [filterInformation writeToFile:filePath atomically:NO];
  
  // Wite out start of filter data array
  // Should sub-class NSDictionary and create different action types
  NSDictionary *nashville_level_composite = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             @"level", @"action_name",
                                             [NSNumber numberWithLong:0], @"black",
                                             [NSNumber numberWithLong:1], @"mid",
                                             [NSNumber numberWithLong:236], @"white",
                                             [NSNumber numberWithInt:0], @"channel",
                                             nil];
  NSDictionary *nashville_colorcomposite = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"colorComposite", @"action_name",
                                            [NSNumber numberWithLong:247], @"red",
                                            [NSNumber numberWithLong:217], @"green",
                                            [NSNumber numberWithLong:2173], @"blue",
                                            [NSNumber numberWithFloat:1.0], @"alpha",
                                            [NSNumber numberWithLong:kCGBlendModeNormal], @"blendmode",
                                            nil];
  
  NSDictionary *nashville_imagecomposite = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"imageComposite", @"action_name",
                                            @"fx-film-mask.jpg", @"image_name",
                                            [NSNumber numberWithFloat:1.0], @"alpha",
                                            [NSNumber numberWithLong:kCGBlendModeNormal], @"blendmode",
                                            nil];
  
  NSDictionary *nashville_imagetiledcomposite = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 @"imageTiledComposite", @"action_name",
                                                 @"fx-film-nostalgia-stone.jpg", @"image_name",
                                                 [NSNumber numberWithFloat:1.0], @"alpha",
                                                 [NSNumber numberWithLong:kCGBlendModeNormal], @"blendmode",
                                                 nil];
  
  NSDictionary *sharpen_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"sharpen", @"action_name",
                                  [[NSArray alloc] initWithObjects:
                                   [NSNumber numberWithLong:0],[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:-0.2],[NSNumber numberWithDouble:0.0],[NSNumber numberWithLong:0],
                                   [NSNumber numberWithLong:0],[NSNumber numberWithDouble:-0.2],[NSNumber numberWithDouble:1.8],[NSNumber numberWithDouble:-0.2],[NSNumber numberWithLong:0],
                                   [NSNumber numberWithLong:0],[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:-0.2],[NSNumber numberWithDouble:0.0],[NSNumber numberWithLong:0], nil],
                                  @"kernel", nil];
  
  NSDictionary *sepia_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"sepia", @"action_name",
                                nil];
  
  NSDictionary *lomo_saturate_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"saturate", @"action_name",
                                        [NSNumber numberWithDouble:1.2], @"amount", nil];
  
  NSDictionary *lomo_contrast_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"contrast", @"action_name",
                                        [NSNumber numberWithDouble:1.15], @"amount", nil];
  
  NSDictionary *brightness_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"brightness", @"action_name",
                                     [NSNumber numberWithDouble:1.15], @"amount", nil];
  
  NSDictionary *lomo_applycurve_actionRed = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             @"applycurve", @"action_name",
                                             [NSNumber numberWithInteger:1], @"CurveChannel",
                                             [[NSArray alloc] initWithObjects:
                                              [NSNumber numberWithLong:0], [NSNumber numberWithLong:0],
                                              [NSNumber numberWithLong:137], [NSNumber numberWithLong:118],
                                              [NSNumber numberWithLong:137], [NSNumber numberWithLong:118],
                                              [NSNumber numberWithLong:255], [NSNumber numberWithLong:255], nil], @"curve",
                                             nil];
  NSDictionary *lomo_applycurve_actionGreen = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               @"applycurve", @"action_name",
                                               [NSNumber numberWithInteger:2], @"CurveChannel",
                                               [[NSArray alloc] initWithObjects:
                                                [NSNumber numberWithLong:0], [NSNumber numberWithLong:0],
                                                [NSNumber numberWithLong:64], [NSNumber numberWithLong:54],
                                                [NSNumber numberWithLong:175], [NSNumber numberWithLong:194],
                                                [NSNumber numberWithLong:255], [NSNumber numberWithLong:255], nil], @"curve",
                                               nil];
  NSDictionary *lomo_applycurve_actionBlue = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"applycurve", @"action_name",
                                              [NSNumber numberWithInteger:3], @"CurveChannel",
                                              [[NSArray alloc] initWithObjects:
                                               [NSNumber numberWithLong:0], [NSNumber numberWithLong:0],
                                               [NSNumber numberWithLong:59], [NSNumber numberWithLong:64],
                                               [NSNumber numberWithLong:203], [NSNumber numberWithLong:189],
                                               [NSNumber numberWithLong:255], [NSNumber numberWithLong:255], nil], @"curve",
                                              nil];
  
  NSDictionary *darkVignette_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"darkVignette", @"action_name",
                                       nil];
  
  NSDictionary *invert_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"invert", @"action_name",
                                 nil];
  
  NSDictionary *vignette_action = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"vignette", @"action_name",
                                   nil];
  
  NSMutableArray *filterArray = [[NSMutableArray alloc] initWithObjects:
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Sharpen", @"filter_name", [[NSArray alloc] initWithObjects: sharpen_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Sepia", @"filter_name", [[NSArray alloc] initWithObjects: sepia_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Lomo", @"filter_name", [[NSArray alloc] initWithObjects: lomo_saturate_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Lomo_Action", @"filter_name", [[NSArray alloc] initWithObjects: lomo_saturate_action, lomo_contrast_action, lomo_applycurve_actionRed, lomo_applycurve_actionGreen, lomo_applycurve_actionBlue, darkVignette_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Vignette", @"filter_name", [[NSArray alloc] initWithObjects: vignette_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Polaroidish", @"filter_name", [[NSArray alloc] initWithObjects: brightness_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Invert", @"filter_name", [[NSArray alloc] initWithObjects: invert_action, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Nostaglia", @"filter_name", [[NSArray alloc] initWithObjects: nashville_level_composite, nil], @"actions", nil],
                                 [[NSDictionary alloc] initWithObjectsAndKeys: @"Nashville", @"filter_name", [[NSArray alloc] initWithObjects: nashville_level_composite, nashville_colorcomposite, nashville_imagecomposite, nashville_imagetiledcomposite, nil], @"actions", nil],
                                 nil];

  NSString *filterfilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", FILTERS_FILENAME]];
  [filterArray writeToFile:filterfilePath atomically:NO];
}

-(NSMutableArray *) loadFilterDataFromPlist:(NSString *) filename
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
  NSLog(@"filter data plist file: %@", path);
  return [[NSMutableArray alloc] initWithContentsOfFile: path];
}

- (NSDictionary *) loadFilterVersionFromPlist:(NSString *) filename
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
  NSLog(@"filter version plist file: %@", path);
  return [[NSDictionary alloc] initWithContentsOfFile: path];
}

- (void) storeFilterPlistFiles {

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filtersInfoPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", FILTERS_FILENAME]];
  [filterObjects writeToFile:filtersInfoPath atomically:NO];

  NSString *filtersPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", FILTER_INFO_FILENAME]];
  [filterInformation writeToFile:filtersPath atomically:NO];
}

- (BOOL) updateFilterPlist
{
  // This function should compare the local filter's plist version with the latest server version.
  // and update it if the plist file needs to be.
  // then call loadFilterPList
  return NO;
}

+ (BOOL) createFilterButtonImages:(BOOL)reload;
{
  if (lFilterObjects == nil || lFilterInformation == nil)
    return NO;

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", FILTER_DATA_DIRECTORY, @"gen_Filter.png"]];
  UIImage* image = [UIImage imageWithContentsOfFile:path];
  
  int buttonTag = 0;
  for (PBFilterObject *filter in lFilterObjects) {

//    NSString *filePath = [NSString stringWithFormat:@"%@/%@-cache.png", FILTER_DATA_DIRECTORY, [filter filterName]];
    documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@-cache.png", documentsDirectory, FILTER_DATA_DIRECTORY, [filter filterName]];
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:filePath]];
    NSLog(@"filePath = %@", filePath);
    if (![fileManager fileExistsAtPath:filePath])
    {
      UIImage *finalImage = [createButtonObject applyFilter:buttonTag withImage:image];
      [UIImagePNGRepresentation(finalImage) writeToFile:path atomically:YES];  
    }
    buttonTag++;    
  }

  return YES;
}

- (UIImage *) createCleanImageFilter:(UIImage *)originalImage {
  
  if (originalImage == nil)
    return nil;

  CGImageRef cgImage = [originalImage CGImage];
  return [[UIImage alloc] initWithCGImage:cgImage];
}

@end
