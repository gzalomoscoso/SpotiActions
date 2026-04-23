//StoreManager.swift

import Foundation
import SwiftUI

final class StoreManager: ObservableObject {
    @Published var isSubscribed: Bool = true  // todos los usuarios son automáticamente suscritos

    init() {
        // Fuerza la suscripción en cualquier escenario
        self.isSubscribed = true
        #if DEBUG
        print("🔓 StoreManager init: isSubscribed forzado a true")
        #endif
    }
}
