import SwiftUI
import Foundation

@main
struct SpotiActionsApp: App {
    @StateObject private var navigationState: NavigationState
    @StateObject private var storeManager: StoreManager
    @State private var isDarkMode: Bool = true
    @State private var isShortcutMode: Bool = false

    init() {
        let defaults = UserDefaults.standard
        
        // 1. Forzar lectura fresca del disco
        defaults.synchronize()
        
        let majorUpdateVersion = "2.6"
        let lastSeenVersion = defaults.string(forKey: "lastSeenVersion") ?? "0.0"
        let hasSeenGeneral = defaults.bool(forKey: "hasSeenOnboarding")
        
        // --- LOGS DE DIAGNÓSTICO ---
        print("--- DEBUG ONBOARDING ---")
        print("Versión Requerida: \(majorUpdateVersion)")
        print("Versión en Disco: \(lastSeenVersion)")
        print("¿Visto anteriormente?: \(hasSeenGeneral)")
        
        // 2. Lógica de decisión simplificada y trazable
        let isAncientVersion = lastSeenVersion.compare(majorUpdateVersion, options: .numeric) == .orderedAscending
        let needsOnboarding = !hasSeenGeneral || isAncientVersion
        
        print("Resultado: \(needsOnboarding ? "MOSTRAR ONBOARDING" : "IR A MAIN")")
        print("------------------------")

        let initialView: NavigationState.ViewType = needsOnboarding ? .welcome : .main
        
        _navigationState = StateObject(wrappedValue: NavigationState(initialView: initialView))
        _storeManager = StateObject(wrappedValue: StoreManager())
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                isDarkMode: $isDarkMode,
                isShortcutMode: $isShortcutMode
            )
            .environmentObject(navigationState)
            .environmentObject(storeManager)
        }
    }
}
