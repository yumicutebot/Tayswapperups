#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.taysswapper.app";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "DeathKnightIcon" asset catalog image resource.
static NSString * const ACImageNameDeathKnightIcon AC_SWIFT_PRIVATE = @"DeathKnightIcon";

/// The "DemonHunterIcon" asset catalog image resource.
static NSString * const ACImageNameDemonHunterIcon AC_SWIFT_PRIVATE = @"DemonHunterIcon";

/// The "DruidIcon" asset catalog image resource.
static NSString * const ACImageNameDruidIcon AC_SWIFT_PRIVATE = @"DruidIcon";

/// The "EvokerIcon" asset catalog image resource.
static NSString * const ACImageNameEvokerIcon AC_SWIFT_PRIVATE = @"EvokerIcon";

/// The "HunterIcon" asset catalog image resource.
static NSString * const ACImageNameHunterIcon AC_SWIFT_PRIVATE = @"HunterIcon";

/// The "MageIcon" asset catalog image resource.
static NSString * const ACImageNameMageIcon AC_SWIFT_PRIVATE = @"MageIcon";

/// The "MonkIcon" asset catalog image resource.
static NSString * const ACImageNameMonkIcon AC_SWIFT_PRIVATE = @"MonkIcon";

/// The "PaladinIcon" asset catalog image resource.
static NSString * const ACImageNamePaladinIcon AC_SWIFT_PRIVATE = @"PaladinIcon";

/// The "PriestIcon" asset catalog image resource.
static NSString * const ACImageNamePriestIcon AC_SWIFT_PRIVATE = @"PriestIcon";

/// The "RogueIcon" asset catalog image resource.
static NSString * const ACImageNameRogueIcon AC_SWIFT_PRIVATE = @"RogueIcon";

/// The "ShamanIcon" asset catalog image resource.
static NSString * const ACImageNameShamanIcon AC_SWIFT_PRIVATE = @"ShamanIcon";

/// The "WarlockIcon" asset catalog image resource.
static NSString * const ACImageNameWarlockIcon AC_SWIFT_PRIVATE = @"WarlockIcon";

/// The "WarriorIcon" asset catalog image resource.
static NSString * const ACImageNameWarriorIcon AC_SWIFT_PRIVATE = @"WarriorIcon";

#undef AC_SWIFT_PRIVATE
