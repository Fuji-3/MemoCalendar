//
//  MemoCalendarAppCheck.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/17.
//

import Foundation
import FirebaseAppCheck
import FirebaseCore

class YourAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}


class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
#if targetEnvironment(simulator)
    // App Attest is not available on simulators.
    // Use a debug provider.
    let provider = AppCheckDebugProvider(app: app)

    // Print only locally generated token to avoid a valid token leak on CI.
    print("Firebase App Check debug token: \(provider?.localDebugToken() ?? "" )")

    return provider
#else
    // Use App Attest provider on real devices.
    return AppAttestProvider(app: app)
#endif
  }
}
