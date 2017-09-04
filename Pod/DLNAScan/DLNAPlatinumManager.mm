//
//  DLNAPlatinumManager.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "DLNAPlatinumManager.h"

#import <Platinum/PltLeaks.h>
#import <Platinum/PltDownloader.h>
#import <Platinum/Platinum.h>
#import <Platinum/PltMediaServer.h>
#import <Platinum/PltSyncMediaBrowser.h>
#import <Platinum/PltMediaController.h>
#import <Platinum/Neptune.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#import "DLNAScanManager.h"

typedef NPT_Map <NPT_String, NPT_String>            PLT_StringMap;
typedef NPT_Lock<PLT_StringMap>                     PLT_LockStringMap;
typedef NPT_Map <NPT_String, NPT_String>::Entry     PLT_StringMapEntry;


#pragma mark- func
static void strchomp(char* str) {
    if (!str) return;
    char* e = str+NPT_StringLength(str)-1;
    while (e >= str && *e) {
        if ((*e != ' ')  &&
            (*e != '\t') &&
            (*e != '\r') &&
            (*e != '\n'))
        {
            *(e+1) = '\0';
            break;
        }
        --e;
    }
}


#pragma mark- PLT_MicroMediaController.声明
class PLT_MicroMediaController: public PLT_SyncMediaBrowser, public PLT_MediaController, public PLT_MediaControllerDelegate {
private:
    DLNAPlatinumManager * manager;
    
    NPT_Stack<NPT_String>   m_curBrowseDirectoryStack;
    NPT_Lock<PLT_DeviceMap> m_MediaRenderers;
    NPT_Lock<PLT_DeviceMap> m_MediaServers;
    
    PLT_DeviceDataReference m_CurMediaRenderer;
    NPT_Mutex               m_CurMediaRendererLock;
    
public:
    PLT_MicroMediaController(PLT_CtrlPointReference & ctrlPoint, DLNAPlatinumManager * manager);
    virtual ~PLT_MicroMediaController();
    
    bool finded_device(PLT_DeviceDataReference & device);
    void remove_device(PLT_DeviceDataReference & device);
    
    void stopScan();
    void startScan();
    
    PLT_DeviceDataReference getCurrentMediaRenderer();
    const PLT_StringMap getMediaRenderersNameTable();
    const char * chooseIDFromTable(PLT_StringMap & table);
    void getCurMediaRenderer(PLT_DeviceDataReference& renderer);
    void chooseMediaRenderer(NPT_String chosenUUID);
    PLT_DeviceDataReference chooseDevice(const NPT_Lock<PLT_DeviceMap>& deviceList, NPT_String chosenUUID);
};




#pragma mark- PLT_MicroMediaController.实现
PLT_MicroMediaController::PLT_MicroMediaController(PLT_CtrlPointReference & ctrlPoint, DLNAPlatinumManager * manager): PLT_SyncMediaBrowser(ctrlPoint), PLT_MediaController(ctrlPoint) {//init
    m_curBrowseDirectoryStack.Push("0");
    PLT_MediaController::SetDelegate(this);
    PLT_MicroMediaController::manager = manager;
};

PLT_MicroMediaController::~PLT_MicroMediaController() {
}

bool PLT_MicroMediaController::finded_device(PLT_DeviceDataReference & device) {
    NPT_String uuid = device->GetUUID();
    
    PLT_Service* service;
    if (NPT_SUCCEEDED(device->FindServiceByType("urn:schemas-upnp-org:service:AVTransport:*", service))) {
        //  处理
    }
    if (manager && [manager respondsToSelector:@selector(finded_device)]) {
        // 代理， //TODO：
        [manager finded_device];
    }
    return true;
}

void PLT_MicroMediaController::remove_device(PLT_DeviceDataReference & device) {
    NPT_String uuid = device->GetUUID();
    NPT_AutoLock lock(m_MediaRenderers);
    m_MediaRenderers.Erase(uuid);
    
    if (manager && [manager respondsToSelector:@selector(remove_device)]) {
        //代理方法
        [manager remove_device];
        
    }
}


const char * PLT_MicroMediaController::chooseIDFromTable(PLT_StringMap &table) {
    printf("Select one of the following:\n");
    NPT_List<PLT_StringMapEntry*> entries = table.GetEntries();
    
    if (entries.GetItemCount() == 0) {
        printf("None available\n");
    }else { // display the list of entries
        NPT_List<PLT_StringMapEntry*>::Iterator entry = entries.GetFirstItem();
        int count = 0;
        while (entry) {
            printf("%d)\t%s (%s)\n", ++count, (const char*)(*entry)->GetValue(), (const char*)(*entry)->GetKey());
            ++entry;
        }
        
        int index = 0, watchdog = 3;
        char buffer[1024];
        
        // wait for input
        while (watchdog > 0) {
            fgets(buffer, 1024, stdin);
            strchomp(buffer);
            
            if (1 != sscanf(buffer, "%d", &index)) {
                printf("Please enter a number\n");
            } else if (index < 0 || index > count)    {
                printf("Please choose one of the above, or 0 for none\n");
                watchdog--;
                index = 0;
            } else {
                watchdog = 0;
            }
        }

        if (index != 0) {// find the entry back
            entry = entries.GetFirstItem();
            while (entry && --index) {
                ++entry;
            }
            if (entry) {
                return (*entry)->GetKey();
            }
        }
    }
    return NULL;
};

const PLT_StringMap PLT_MicroMediaController:: getMediaRenderersNameTable() {
    const NPT_Lock<PLT_DeviceMap>& deviceList = m_MediaRenderers;
    
    PLT_StringMap            namesTable;
    NPT_AutoLock             lock(m_MediaServers);
    
    const NPT_List<PLT_DeviceMapEntry*>& entries = deviceList.GetEntries();
    NPT_List<PLT_DeviceMapEntry*>::Iterator entry = entries.GetFirstItem();
    while (entry) {
        PLT_DeviceDataReference device = (*entry)->GetValue();
        NPT_String              name   = device->GetFriendlyName();
        namesTable.Put((*entry)->GetKey(), name);
        ++entry;
    }
    return namesTable;
}

PLT_DeviceDataReference PLT_MicroMediaController::getCurrentMediaRenderer() {
    PLT_DeviceDataReference device;
    getCurMediaRenderer(device);
    return device;
}

void PLT_MicroMediaController::getCurMediaRenderer(PLT_DeviceDataReference& renderer)
{
    NPT_AutoLock lock(m_CurMediaRendererLock);
    
    if (m_CurMediaRenderer.IsNull()) {
        NSLog(@"没有设备被选择");
    } else {
        renderer = m_CurMediaRenderer;
    }
}
void stopScan();
void startScan();

PLT_DeviceDataReference PLT_MicroMediaController::chooseDevice(const NPT_Lock<PLT_DeviceMap>& deviceList, NPT_String chosenUUID) {
    PLT_DeviceDataReference* result = NULL;
    
    if (chosenUUID.GetLength()) {
        deviceList.Get(chosenUUID, result);
    }
    
    return result?*result:PLT_DeviceDataReference(); // return empty reference if not device was selected
}

void PLT_MicroMediaController::chooseMediaRenderer(NPT_String chosenUUID) {
    NPT_AutoLock lock(m_CurMediaRendererLock);
    m_CurMediaRenderer = chooseDevice(m_MediaRenderers, chosenUUID);
}



/****************************************************************************************/
/****************************************************************************************/
/****************************************************************************************/



@implementation DLNAPlatinumManager {
    PLT_UPnP * upnp;
    PLT_MicroMediaController * pltControl;
}

#pragma mark- Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        upnp = new PLT_UPnP();
        PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint());
        upnp->AddCtrlPoint(ctrlPoint);
        pltControl = new PLT_MicroMediaController(ctrlPoint, self);
    }
    return self;
}

- (void)dealloc {
    delete upnp;
    delete pltControl;
}

#pragma mark- Partive:Device
- (NSArray *)getAllFindDevice {
    NSMutableArray * devices = [NSMutableArray array];
    const PLT_StringMap redersNames = pltControl->getMediaRenderersNameTable();
    NPT_List<PLT_StringMapEntry *>::Iterator entry = redersNames.GetEntries().GetFirstItem();
    while (entry) {
        DLNADeviceEntity * device = [[DLNADeviceEntity alloc] init];
        device.name = [NSString stringWithUTF8String:(const char *)(*entry)->GetValue()];
        device.uuid = [NSString stringWithUTF8String:(const char *)(*entry)->GetKey()];
        
        [devices addObject:device];
        ++entry;
    }
    return [devices copy];
}

-(DLNADeviceEntity *)getCurrentDevice {
    PLT_DeviceDataReference device = pltControl->getCurrentMediaRenderer();
    if (!device.IsNull()) {
        NSString * name = [NSString stringWithUTF8String:device->GetFriendlyName()];
        NSString * uuid = [NSString stringWithUTF8String:device->GetUUID()];
        NSString * manufacturer = [NSString stringWithUTF8String:device->m_Manufacturer];
        NSString * modelName = [NSString stringWithUTF8String:device->m_ModelName];
        NSString * modelNumber = [NSString stringWithUTF8String:device->m_ModelNumber];
        NSString * serialNumber = [NSString stringWithUTF8String:device->m_SerialNumber];
        NSString * descriptionURL = [NSString stringWithUTF8String:device->GetDescriptionUrl()];
        DLNADeviceEntity * dlnaDevice = [[DLNADeviceEntity alloc] initWithName:name
                                                                          UUID:uuid
                                                                  manufacturer:manufacturer
                                                                     modelName:modelName
                                                                   modelNumber:modelNumber
                                                                  serialNumber:serialNumber
                                                                descriptionURL:descriptionURL];
        return dlnaDevice;
    }else{
        NSLog(@"Render device is nil in %s",__FUNCTION__);
        return nil;
    }
}

- (DLNADeviceEntity *)getDeviceWithUUID:(NSString *)uuid {
    if (![uuid isEqualToString:@""]) {
        pltControl->chooseMediaRenderer([uuid UTF8String]);
        return [self getCurrentDevice];
    }
    return nil;
}

#pragma mark- Prative:Runner
- (void)startMediaControl {
    if ([self isRunning]) {
        upnp->Start();
    }else {
        NSLog(@"Upnp is runnning");
    }
}

- (void)reStartMediaControll {
    if ([self isRunning]) {
        upnp->Stop();
    }
    upnp->Start();
}

- (void)stopMediaControll {
    if ([self isRunning] && upnp != NULL) {
        upnp->Stop();
    }
}

- (BOOL)isRunning {
    if (upnp->IsRunning()) {
        return YES;
    }
    return NO;
}

#pragma mark- Action
- (void)finded_device {
    NSArray * devices = [self getAllFindDevice];
}
- (void)remove_device {
    NSArray * devices = [self getAllFindDevice];
}

@end
