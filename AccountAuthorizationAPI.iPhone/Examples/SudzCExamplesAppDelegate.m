
#import "SudzCExamplesAppDelegate.h"
#import "ACAccountAuthorizationAPIExample.h"


@implementation SudzCExamplesAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

ACAccountAuthorizationAPIExample* example1 = [[[ACAccountAuthorizationAPIExample alloc] init] autorelease];
		[example1 run];


	[window makeKeyAndVisible];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
			