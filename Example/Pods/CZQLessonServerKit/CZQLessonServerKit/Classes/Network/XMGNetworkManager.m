//
//  XMGNetworkManager.m
//  码哥课堂
//
//  Created by yz on 2016/11/16.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGNetworkManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>

/*
 * Address families.
 */
#define	AF_UNSPEC	0		/* unspecified */
#define	AF_UNIX		1		/* local to host (pipes) */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define	AF_LOCAL	AF_UNIX		/* backward compatibility */
#endif	/* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
#define	AF_INET		2		/* internetwork: UDP, TCP, etc. */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define	AF_IMPLINK	3		/* arpanet imp addresses */
#define	AF_PUP		4		/* pup protocols: e.g. BSP */
#define	AF_CHAOS	5		/* mit CHAOS protocols */
#define	AF_NS		6		/* XEROX NS protocols */
#define	AF_ISO		7		/* ISO protocols */
#define	AF_OSI		AF_ISO
#define	AF_ECMA		8		/* European computer manufacturers */
#define	AF_DATAKIT	9		/* datakit protocols */
#define	AF_CCITT	10		/* CCITT protocols, X.25 etc */
#define	AF_SNA		11		/* IBM SNA */
#define	AF_DECnet	12		/* DECnet */
#define	AF_DLI		13		/* DEC Direct data link interface */
#define	AF_LAT		14		/* LAT */
#define	AF_HYLINK	15		/* NSC Hyperchannel */
#define	AF_APPLETALK	16		/* Apple Talk */
#define	AF_ROUTE	17		/* Internal Routing Protocol */
#define	AF_LINK		18		/* Link layer interface */
#define	pseudo_AF_XTP	19		/* eXpress Transfer Protocol (no AF) */
#define	AF_COIP		20		/* connection-oriented IP, aka ST II */
#define	AF_CNT		21		/* Computer Network Technology */
#define	pseudo_AF_RTIP	22		/* Help Identify RTIP packets */
#define	AF_IPX		23		/* Novell Internet Protocol */
#define	AF_SIP		24		/* Simple Internet Protocol */
#define	pseudo_AF_PIP	25		/* Help Identify PIP packets */
#define	AF_NDRV		27		/* Network Driver 'raw' access */
#define	AF_ISDN		28		/* Integrated Services Digital Network */
#define	AF_E164		AF_ISDN		/* CCITT E.164 recommendation */
#define	pseudo_AF_KEY	29		/* Internal key-management function */
#endif	/* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
#define	AF_INET6	30		/* IPv6 */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define	AF_NATM		31		/* native ATM access */
#define	AF_SYSTEM	32		/* Kernel event messages */
#define	AF_NETBIOS	33		/* NetBIOS */
#define	AF_PPP		34		/* PPP communication protocol */
#define	pseudo_AF_HDRCMPLT 35		/* Used by BPF to not rewrite headers
in interface output routine */
#define	AF_RESERVED_36	36		/* Reserved for internal usage */
#define	AF_IEEE80211	37		/* IEEE 802.11 protocol */
#define	AF_UTUN		38
#define	AF_MAX		40
#endif

#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
/*
 * PF_ROUTE - Routing table
 *
 * Three additional levels are defined:
 *	Fourth: address family, 0 is wildcard
 *	Fifth: type of info, defined below
 *	Sixth: flag(s) to mask with for NET_RT_FLAGS
 */
#define	NET_RT_DUMP		1	/* dump; may limit to a.f. */
#define	NET_RT_FLAGS		2	/* by flags, e.g. RESOLVING */
#define	NET_RT_IFLIST		3	/* survey interface list */
#define	NET_RT_STAT		4	/* routing statistics */
#define	NET_RT_TRASH		5	/* routes not in table but not freed */
#define	NET_RT_IFLIST2		6	/* interface list with addresses */
#define	NET_RT_DUMP2		7	/* dump; may limit to a.f. */
#define	NET_RT_MAXID		10
#endif /* (_POSIX_C_SOURCE && !_DARWIN_C_SOURCE) */

/*
 * Top-level identifiers
 */
#define	CTL_UNSPEC	0		/* unused */
#define	CTL_KERN	1		/* "high kernel": proc, limits */
#define	CTL_VM		2		/* virtual memory */
#define	CTL_VFS		3		/* file system, mount type is next */
#define	CTL_NET		4		/* network, see socket.h */
#define	CTL_DEBUG	5		/* debugging parameters */
#define	CTL_HW		6		/* generic cpu/io */
#define	CTL_MACHDEP	7		/* machine dependent */
#define	CTL_USER	8		/* user-level */
#define	CTL_MAXID	9		/* number of valid top-level ids */

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
//获取屏幕宽度
#define screenWide [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define screenHeight [UIScreen mainScreen].bounds.size.height

static NSString * const salt = @"gn1002015";

@implementation XMGNetworkManager

+ (NSString *)appVersion {
    
    NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
    
    NSString *version = [dic objectForKey:@"CFBundleVersion"];
    
    return version;
    
}


// 获取当前时间
+ (int)getDateByInt
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]];
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    int liDate = (int) dateInterval;
    return liDate;
}


// 参数md5 key值
+ (NSString *)md5ForParamas:(NSDictionary *)paramas time:(int) aiTime
{

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramas options:NSJSONReadingAllowFragments error:nil];
    // NSJSONReadingAllowFragments : 使用这个
    // NSJSONWritingPrettyPrinted 会有\n，不需要
    NSString *jsonParserString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString *myString = [NSString stringWithFormat:@"%@%d%@",jsonParserString,aiTime, salt];
    
    NSString *keyMD5 = [self getMd5_32Bit_String:myString];
    NSString *keymd5 = [self getMd5_32Bit_String:keyMD5];
    
    
    return keymd5;
}

//  MD5
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSDictionary *)getDinfo {
    NSString *mac = [self macaddress];
    NSString *udid = [self uuid];
    NSString *ip = [self ipAddressIsV4:YES];
    NSString *p =  [self getDeviceInfo];
    // NSString *jb = [NSString stringWithFormat:@"%i",[self jailbroken]];
    NSString *rw = [NSString stringWithFormat:@"%f",screenWide];
    NSString *rh = [NSString stringWithFormat:@"%f",screenHeight];
    NSString * o = [self chinaMobileModel];
    NSString *m = [self deviceName];
    NSString *osv = [self getSystemVersion];
    NSString *cv = [NSString stringWithFormat:@"%ld",[self version]];
    NSString *n = [self getNetWorkStates];
    
    NSDictionary *dinfo = @{
                            @"os":@"i",
                            @"osv": osv,
                            @"osvc":@"17",
                            @"udid": udid,
                            @"ip":ip,
                            @"p":p,
                            @"rw":rw,
                            @"rh":rh,
                            @"o":o,
                            @"m":m,
                            @"cv":cv,
                            @"cvc":@"14",
                            @"mac": mac,
                            @"n":n,
                            @"d":@"毛线",
                            @"phone":@"",
                            @"imsi":@"",
                            @"imei":@""
                            };
    return dinfo;
}

#pragma mark - 本机信息
// 设备mac 地址
+ (NSString *) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
//    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

// 获取设备uuid
+ (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    return result;
}

+ (NSDictionary *)addressInfo
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
    
}

// ip 地址
+ (NSString *)ipAddressIsV4:(BOOL)v4
{
    NSArray *searchArray = v4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self addressInfo];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
// 设备信息 产品名称
+ (NSString *)getDeviceInfo {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *name = device.name;       //获取设备所有者的名称
    NSString *model = device.name;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本
//    NSLog(@"-----name : %@,model : %@,type : %@,systemName :%@,systemVersion %@",name,model,type,systemName,systemVersion);
    return model;
}

// 是否越狱

// 运营商
+ (NSString *)chinaMobileModel
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        //        return @"不识别";
        return @"0";
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil) {
        //        return @"不识别";
        return @"0";
    }
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"])
    {
        //        return @"移动";
        return @"1";
    }else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"])
    {
        //        return @"联通";
        return @"2";
    }else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"])
    {
        //        return @"电信";
        return @"3";
    }else if ([code isEqualToString:@"20"])
    {
        return @"铁通";
    }
    return @"不识别";
}
+ (NSString *)deviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}

// 机型信息
+ (NSString *)deviceName
{
    NSString *platform = [self deviceModel];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (NSString *)getSystemVersion {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *systemVersion = device.systemVersion;
    return systemVersion;
}

//  判断当前网络连接状态
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    //                    state = @"无网络"; // 5
                    state = @"5";
                    //无网模式
                    break;
                case 1:
                    //                    state = @"2G"; // 1
                    state = @"1";
                    break;
                case 2:
                    //                    state = @"3G"; // 2
                    state = @"3";
                    break;
                case 3:
                    //                    state = @"4G"; //3
                    state = @"4";
                    break;
                case 5:
                    //                    state = @"WIFI"; //5
                    state = @"5";
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

+ (NSDictionary *)paramWithScheduleWithNextMonthIndex:(NSInteger)nextMonthIndex
{
    NSDictionary *parameters = @{
                                 @"uid":@"3193",
                                 @"index":@(nextMonthIndex),
                                 @"length":@(5),
                                 @"identity":@(1) // 老师 =》 1
                                 };
    
    int liTime = [self getDateByInt];
    
    NSString *keymd5 = [self md5ForParamas:parameters time:liTime];
    
    NSDictionary *codeParamas = @{@"u":@"i",@"v":@"2",@"time":@(liTime),@"params":parameters,@"key":keymd5};
    
    return codeParamas;
    
}


+ (NSDictionary *)paramWithInteresting
{
    //必传参数
    NSDictionary *paramas =@{
                             @"all":@"0"
                             };
    NSString *version = [self appVersion];
    
    //   获取当前的时间
    int liTime = [self getDateByInt];
    NSString *keymd5 = [self md5ForParamas:paramas time:liTime];
    NSDictionary *myparamses =@{
                                @"u":@"i",
                                @"v":version,
                                @"time":@(liTime),
                                @"params":paramas,
                                @"key":keymd5
                                };
    return myparamses;
}

#pragma mark - 获取首页参数
+ (NSDictionary *)paramWithHome
{
    NSDictionary * params = @{@"city":@"中国",
                              @"cityId":@0,
                              //                              @"condition":userDict[@"condition"],
                              @"condition":@"35,33,32,35,34",
                              //                              @"teacherSeach":userDict[@"teacherSeach"],
                              @"teacherSeach":@"1000,1000,1000"
                              };
    NSString *version = [self Version];
    
    //   获取当前的时间
    int liTime = [self getDateByInt];
    NSString *keymd5 = [self md5ForParamas:params time:liTime];
    NSDictionary *myparamses =@{
                                @"u":@"i",
                                @"v":version,
                                @"time":@(liTime),
                                @"params":params,
                                @"key":keymd5
//                                @"dinfo":[self getDinfo]
                                };
//    NSLog(@"%@",myparamses);

    return myparamses;
}

// Version
+ (NSString *)Version {
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:string];
    NSString *version = [dic objectForKey:@"CFBundleVersion"];
    return version;
    
}
+ (NSString *)urlWithHome
{
    return @"https://www.yunke.com/interface/main/home";
}

+ (NSString *)urlWithInteresting
{
    return  @"https://www.yunke.com/interface/search/gettag" ;
}

+ (NSString *)urlWithSchedule
{
    return @"https://www.yunke.com/interface/plan/tablev2";
}

@end
