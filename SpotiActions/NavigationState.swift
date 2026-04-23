import SwiftUI
import Foundation

// MARK: - NavigationState
class NavigationState: ObservableObject {
    enum ViewType {
        case welcome
        case main
        case howToSetup   // Lista de tutoriales paso a paso
        case subscription // Pantalla de suscripción Lifetime
    }

    @Published var currentView: ViewType

    // Para RootView / Tabs
    @Published var activeTab: Int = 0

    init(initialView: ViewType) {
        self.currentView = initialView
    }

    // MARK: - Deep Link Handler
    func handleDeepLink(_ url: URL) {
        guard url.scheme == "spotiactions" else { return }

        // 1. spotiactions://tab/0, spotiactions://tab/1, etc.
        if url.host == "tab", let tabIndex = Int(url.lastPathComponent) {
            self.activeTab = tabIndex
            self.currentView = .main
        }
        // 2. spotiactions://howToSetup -> Ir a la lista de tutoriales
        else if url.host == "howToSetup" {
            self.currentView = .howToSetup
        }
        // 3. spotiactions://subscription -> Pantalla Lifetime
        else if url.host == "subscription" || (url.host == "howToSetup" && url.pathComponents.contains("lifetime")) {
            self.currentView = .subscription
        }
        else if url.host == nil {
            print("🔹 App opened via simple spotiactions://")
        }
        else {
            print("⚠️ Deep link desconocido: \(url.absoluteString)")
        }
    }
}
