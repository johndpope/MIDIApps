//
// Copyright 2001-2002 Kurt Revis. All rights reserved.
//

#import "SMVirtualOutputStream.h"

#import <OmniBase/OmniBase.h>
#import <OmniFoundation/OmniFoundation.h>

#import "SMClient.h"
#import "SMEndpoint.h"


@implementation SMVirtualOutputStream

- (id)initWithName:(NSString *)name uniqueID:(SInt32)uniqueID;
{
    if (!(self = [super init]))
        return nil;

    endpoint = [[SMSourceEndpoint createVirtualSourceEndpointWithName:name uniqueID:uniqueID] retain];
    if (!endpoint) {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc;
{
    [endpoint remove];
    [endpoint release];
    endpoint = nil;

    [super dealloc];
}

- (SMSourceEndpoint *)endpoint;
{
    return endpoint;
}

- (void)sendMIDIPacketList:(MIDIPacketList *)packetList;
{
    MIDIEndpointRef endpointRef;
    OSStatus status;

    if (!(endpointRef = [endpoint endpointRef]))
        return;

    status = MIDIReceived(endpointRef, packetList);
    if (status) {
        NSLog(@"MIDIReceived(%p, %p) returned error: %ld", endpointRef, packetList, status);
    }
}

@end
