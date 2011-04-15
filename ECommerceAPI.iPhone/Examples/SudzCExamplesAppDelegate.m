
#import "SudzCExamplesAppDelegate.h"
#import "ACECommerceAPIExample.h"


@implementation SudzCExamplesAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

ACECommerceAPIExample* example1 = [[[ACECommerceAPIExample alloc] init] autorelease];
		[example1 run];


	[window makeKeyAndVisible];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
			