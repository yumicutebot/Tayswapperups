import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "DeathKnightIcon" asset catalog image resource.
    static let deathKnightIcon = DeveloperToolsSupport.ImageResource(name: "DeathKnightIcon", bundle: resourceBundle)

    /// The "DemonHunterIcon" asset catalog image resource.
    static let demonHunterIcon = DeveloperToolsSupport.ImageResource(name: "DemonHunterIcon", bundle: resourceBundle)

    /// The "DruidIcon" asset catalog image resource.
    static let druidIcon = DeveloperToolsSupport.ImageResource(name: "DruidIcon", bundle: resourceBundle)

    /// The "EvokerIcon" asset catalog image resource.
    static let evokerIcon = DeveloperToolsSupport.ImageResource(name: "EvokerIcon", bundle: resourceBundle)

    /// The "HunterIcon" asset catalog image resource.
    static let hunterIcon = DeveloperToolsSupport.ImageResource(name: "HunterIcon", bundle: resourceBundle)

    /// The "MageIcon" asset catalog image resource.
    static let mageIcon = DeveloperToolsSupport.ImageResource(name: "MageIcon", bundle: resourceBundle)

    /// The "MonkIcon" asset catalog image resource.
    static let monkIcon = DeveloperToolsSupport.ImageResource(name: "MonkIcon", bundle: resourceBundle)

    /// The "PaladinIcon" asset catalog image resource.
    static let paladinIcon = DeveloperToolsSupport.ImageResource(name: "PaladinIcon", bundle: resourceBundle)

    /// The "PriestIcon" asset catalog image resource.
    static let priestIcon = DeveloperToolsSupport.ImageResource(name: "PriestIcon", bundle: resourceBundle)

    /// The "RogueIcon" asset catalog image resource.
    static let rogueIcon = DeveloperToolsSupport.ImageResource(name: "RogueIcon", bundle: resourceBundle)

    /// The "ShamanIcon" asset catalog image resource.
    static let shamanIcon = DeveloperToolsSupport.ImageResource(name: "ShamanIcon", bundle: resourceBundle)

    /// The "WarlockIcon" asset catalog image resource.
    static let warlockIcon = DeveloperToolsSupport.ImageResource(name: "WarlockIcon", bundle: resourceBundle)

    /// The "WarriorIcon" asset catalog image resource.
    static let warriorIcon = DeveloperToolsSupport.ImageResource(name: "WarriorIcon", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "DeathKnightIcon" asset catalog image.
    static var deathKnightIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .deathKnightIcon)
#else
        .init()
#endif
    }

    /// The "DemonHunterIcon" asset catalog image.
    static var demonHunterIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .demonHunterIcon)
#else
        .init()
#endif
    }

    /// The "DruidIcon" asset catalog image.
    static var druidIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .druidIcon)
#else
        .init()
#endif
    }

    /// The "EvokerIcon" asset catalog image.
    static var evokerIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .evokerIcon)
#else
        .init()
#endif
    }

    /// The "HunterIcon" asset catalog image.
    static var hunterIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hunterIcon)
#else
        .init()
#endif
    }

    /// The "MageIcon" asset catalog image.
    static var mageIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mageIcon)
#else
        .init()
#endif
    }

    /// The "MonkIcon" asset catalog image.
    static var monkIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .monkIcon)
#else
        .init()
#endif
    }

    /// The "PaladinIcon" asset catalog image.
    static var paladinIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .paladinIcon)
#else
        .init()
#endif
    }

    /// The "PriestIcon" asset catalog image.
    static var priestIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priestIcon)
#else
        .init()
#endif
    }

    /// The "RogueIcon" asset catalog image.
    static var rogueIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rogueIcon)
#else
        .init()
#endif
    }

    /// The "ShamanIcon" asset catalog image.
    static var shamanIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shamanIcon)
#else
        .init()
#endif
    }

    /// The "WarlockIcon" asset catalog image.
    static var warlockIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .warlockIcon)
#else
        .init()
#endif
    }

    /// The "WarriorIcon" asset catalog image.
    static var warriorIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .warriorIcon)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "DeathKnightIcon" asset catalog image.
    static var deathKnightIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .deathKnightIcon)
#else
        .init()
#endif
    }

    /// The "DemonHunterIcon" asset catalog image.
    static var demonHunterIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .demonHunterIcon)
#else
        .init()
#endif
    }

    /// The "DruidIcon" asset catalog image.
    static var druidIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .druidIcon)
#else
        .init()
#endif
    }

    /// The "EvokerIcon" asset catalog image.
    static var evokerIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .evokerIcon)
#else
        .init()
#endif
    }

    /// The "HunterIcon" asset catalog image.
    static var hunterIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hunterIcon)
#else
        .init()
#endif
    }

    /// The "MageIcon" asset catalog image.
    static var mageIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mageIcon)
#else
        .init()
#endif
    }

    /// The "MonkIcon" asset catalog image.
    static var monkIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .monkIcon)
#else
        .init()
#endif
    }

    /// The "PaladinIcon" asset catalog image.
    static var paladinIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .paladinIcon)
#else
        .init()
#endif
    }

    /// The "PriestIcon" asset catalog image.
    static var priestIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priestIcon)
#else
        .init()
#endif
    }

    /// The "RogueIcon" asset catalog image.
    static var rogueIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rogueIcon)
#else
        .init()
#endif
    }

    /// The "ShamanIcon" asset catalog image.
    static var shamanIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shamanIcon)
#else
        .init()
#endif
    }

    /// The "WarlockIcon" asset catalog image.
    static var warlockIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .warlockIcon)
#else
        .init()
#endif
    }

    /// The "WarriorIcon" asset catalog image.
    static var warriorIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .warriorIcon)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

