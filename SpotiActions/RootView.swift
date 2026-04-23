import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigationState: NavigationState
    @Binding var isDarkMode: Bool
    @Binding var isShortcutMode: Bool
    @EnvironmentObject var storeManager: StoreManager

    // Estados internos de UI
    @State private var activeTab: Int = 0
    @State private var showHowToSetup: Bool = false
    @State private var didCheckOnboarding: Bool = false
    @State private var activeIndex = 1

    var body: some View {
        ZStack {
            // El flujo se decide por el NavigationState calculado en SpotiActionsApp
            switch navigationState.currentView {
            case .welcome:
                OnboardingView {
                    // Clausura de finalización: solo cambia la vista en tiempo real
                    withAnimation(.spring()) {
                        navigationState.currentView = .main
                    }
                }

            case .main:
                MainView(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    activeIndex: $activeIndex
                )
                .environmentObject(storeManager)
                
            case .howToSetup:
                // Aquí es donde "aterriza" el usuario al pulsar el botón
                howtoSETUP(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    onBack: {
                        // Al volver, regresamos al MainView
                        navigationState.currentView = .main
                    }
                )
                .environmentObject(storeManager)
            @unknown default:
                EmptyView()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $showHowToSetup) {
            howtoSETUP(
                activeTab: $activeTab,
                isDarkMode: $isDarkMode,
                onBack: { showHowToSetup = false }
            )
            .environmentObject(storeManager)
        }
        .onAppear {
            // Evitamos ejecuciones duplicadas de limpieza
            guard !didCheckOnboarding else { return }
            didCheckOnboarding = true
            cleanLegacyKeys()
        }
    }

    /// Limpieza de llaves antiguas para evitar basura en UserDefaults
    private func cleanLegacyKeys() {
        let defaults = UserDefaults.standard
        let legacyKeys = ["noVolverAMostrarWelcome", "MedejasContinuar"]
        for key in legacyKeys {
            if defaults.object(forKey: key) != nil {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
