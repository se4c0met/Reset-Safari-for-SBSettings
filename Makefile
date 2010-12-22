#using the ARM compiler found in XCode version 3.2.5
CC=arm-apple-darwin10-gcc-4.2.1
#CC=arm-apple-darwin-gcc

LD=$(CC)

#ALTROOT contains iOS 3.0 SDK frameworks, can be extracted from an iOS 3.0 phone's firmware
ALTROOT=-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.0.sdk
#CFLAGS contains a -I param that points to header files built with iPhone-Dev Tool-Chain
#see http://code.google.com/p/iphone-dev/
CFLAGS=-fconstant-cfstrings -std=gnu99 -Wall -O2  -I/usr/local/arm-apple-darwin/include

#OS 3.2
#ALTROOT=-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk
#CFLAGS=-fconstant-cfstrings -std=gnu99 -Wall -O2

#OS 4.0
#ALTROOT=-isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.0.sdk
#CFLAGS=-fconstant-cfstrings -std=gnu99 -Wall -O2

LDFLAGS=-lobjc -dynamiclib -bind_at_load -F"/System/Library/PrivateFrameworks" -framework CoreTelephony -framework CoreFoundation -framework Foundation -framework UIKit -framework CoreGraphics -framework SystemConfiguration
#LDFLAGS=-lobjc -dynamiclib -bind_at_load -F"/System/Library/PrivateFrameworks" -framework CoreFoundation -framework Foundation -framework UIKit -framework CoreGraphics -framework SystemConfiguration

VERSION=1.0

all:    Toggle.dylib

#the dylib is code-signed using an OSX version of ldid (download from http://thebigboss.org/hostedfiles/ldid)
Toggle.dylib: main.o
	$(LD) $(LDFLAGS) $(ALTROOT) -o $@ $^
	/usr/local/bin/ldid -S Toggle.dylib

%.o: %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(ALTROOT) $< -o $@
	   
%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(ALTROOT) $< -o $@

clean:
	rm -f *.o edge
