#import <UIKit/UIKit.h>

#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>

// Determines if the device is capable of running on this platform. If your toggle is device specific like only for
// 3g you would check that here.
BOOL isCapable()
{
	//NSLog(@"isCapable()\n"); 
	return YES;
}

// This runs when iPhone springboard resets. This is on boot or respring.
BOOL isEnabled()
{
	//NSLog(@"isEnabled()\n"); 
	return NO;
}

// This function is optional and should only be used if it is likely for the toggle to become out of sync
// with the state while the iPhone is running. It must be very fast or you will slow down the animated
// showing of the sbsettings window. Imagine 12 slow toggles trying to refresh tate on show.
BOOL getStateFast()
{
	//NSLog(@"getStateFast()\n"); 
//	BOOL bRet = isEnabled();
//	return bRet; //always shows 'ON' state
	return YES;
}

// Pass in state to set. YES for enable, NO to disable.
void setState(BOOL Enable)
{
	NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.se4c0met.resetsafari.plist"];
	BOOL RemoveCache = YES;
	BOOL RemoveHistory = YES;
	BOOL RemoveTabs = YES;
	BOOL KillEverCookies = YES;

	if (plistDict != NULL)
	{
	 	RemoveCache = [[plistDict objectForKey:@"RemoveCache"] boolValue];
	 	RemoveHistory = [[plistDict objectForKey:@"RemoveHistory"] boolValue];
	 	RemoveTabs = [[plistDict objectForKey:@"RemoveTabs"] boolValue];
	 	KillEverCookies = [[plistDict objectForKey:@"KillEverCookies"] boolValue];
	}
	
	//write the options to a temp param file to be consumed by the shell-script
	FILE *fp=fopen("/tmp/resetsafari.param","w");
	if (fp != NULL)
	{
		if (RemoveCache)
			fwrite( "RemoveCache\n",12,1,fp );
		if (RemoveHistory)
			fwrite( "RemoveHistory\n",14,1,fp );
		if (RemoveTabs)
			fwrite( "RemoveTabs\n",11,1,fp );
		if (KillEverCookies)
			fwrite( "KillEverCookies\n",16,1,fp );
		
		fclose(fp);
	}
	
	notify_post("com.sbsettings.resetsafari");
}

// Amount of time spinner should spin in seconds after the toggle is selected.
float getDelayTime()
{
	//NSLog(@"getDelayTime\n"); 
	return 0.7f;
}

// Runs when the dylib is loaded. Only useful for debug. Function can be omitted.
__attribute__((constructor)) 
static void toggle_initializer() 
{ 
	//NSString *logPath = @"/tmp/debug.log";
  //freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	
	NSLog(@"Initializing ResetSafari Toggle\n"); 
}
