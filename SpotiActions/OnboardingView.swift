import SwiftUI

struct OnboardingView: View {
    var onFinished: (() -> Void)? = nil
    var startAtPage: Int = 0
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    // El link masivo de las 40 playlists
    private let masterShortcutURL = "https://www.icloud.com/shortcuts/317c1ca7a74b40f5b4c09e5348da6f1d"
    
    // Gradientes simplificados para 2 páginas
    private let pageGradients: [[Color]] = [
        [Color.orange, Color.red],
        [Color.purple, Color.pink]
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                // --- PÁGINA 1: BIENVENIDA ---
                OnboardingPageView(
                    systemName: "music.note",
                    gradient: pageGradients[0],
                    title: NSLocalizedString("Welcome to SpotiActions", comment: ""),
                    description: NSLocalizedString("SpotiActions lets you play your Spotify songs automatically", comment: ""),
                    lines: [
                        (NSLocalizedString("At a set time (perfect as a wake-up alarm)", comment: ""), nil),
                        (NSLocalizedString("Smart Location Playback", comment: ""), nil),
                        (NSLocalizedString("When you hop in your car and connect to CarPlay", comment: ""), nil)
                    ]
                ).tag(0)
                
                // --- PÁGINA 2: INSTALACIÓN DEL MASTER SHORTCUT ---
                OnboardingPageView(
                    systemName: "bolt.ring.closed",
                    gradient: pageGradients[1],
                    title: NSLocalizedString("SpotiActions always works", comment: ""),
                    description: NSLocalizedString("Shortcuts instead of APIs", comment: ""),
                    lines: [
                        (NSLocalizedString("install the shortcut", comment: ""), nil),
                        (NSLocalizedString("grant the permissions", comment: ""), nil),
                        (NSLocalizedString("Download Shortcuts App", comment: "Prompt to download Apple Shortcuts"), URL(string: "https://apps.apple.com/app/id1462947752"))
                    ]
                ).tag(1)
                
            } // fin del TabView
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            
            continueButton
        }
        .onAppear {
            currentPage = startAtPage
        }
    }
    
    // Botón de continuación con lógica de instalación
    private var continueButton: some View {
        Button(action: {
            if currentPage < 1 {
                withAnimation { currentPage += 1 }
            } else {
                // ---- Modo instalación (link iCloud) ----
                installShortcutAndFinish()
            }
        }) {
            Text(currentPage == 0
                 ? NSLocalizedString("continue", comment: "")
                 : NSLocalizedString("Install Shortcut & Start", comment: ""))
                .font(.system(.headline, design: .default).weight(.bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: pageGradients[currentPage]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
                .shadow(color: pageGradients[currentPage].last!.opacity(0.4),
                        radius: 6, x: 0, y: 3)
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 30)
    }
    
    private func installShortcutAndFinish() {
        guard let url = URL(string: masterShortcutURL) else { return }
        
        Task { @MainActor in
            UIApplication.shared.open(url)
            
            // Esperamos a que el usuario regrese o el sistema procese
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let defaults = UserDefaults.standard
                
                // 1. Obtenemos la versión REAL del plist (2.6)
                let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.6"
                
                // 2. Grabamos AMBAS llaves
                defaults.set(true, forKey: "hasSeenOnboarding")
                defaults.set(currentAppVersion, forKey: "lastSeenVersion")
                
                // 3. Forzamos el volcado al disco físico
                defaults.synchronize()
                
                print("--- ESCRITURA EN DISCO ---")
                print("Versión grabada: \(currentAppVersion)")
                print("--------------------------")
                
                // 4. Cambiamos la vista
                onFinished?()
            }
        }
    }
    
    
} // FIN DE OnboardingView


// ---------- ONBOARDING PAGE VIEW ----------
struct OnboardingPageView: View {
    let systemName: String
    let gradient: [Color]
    let title: String
    let description: String
    let lines: [(text: String, url: URL?)]?
    
    var body: some View {
        VStack(spacing: 18) {
            // --- ICONO CENTRAL ---
            Image(systemName: systemName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .font(.system(size: 160, weight: .bold))
                .padding(.top, 60)
                .padding(.bottom, 20)
                .shadow(color: gradient.last!.opacity(0.25), radius: 10, x: 0, y: 5)
            
            // --- TEXTOS PRINCIPALES ---
            VStack(spacing: 8) {
                Text(title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(description)
                    .font(.system(size: 19, weight: .regular, design: .default))
                    .italic()
                    .foregroundColor(Color.primary) // Adaptable a Dark Mode
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 4)
            }

            // --- LISTA DE LÍNEAS ---
            if let lines = lines {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(gradient.first)
                            
                            if let url = line.url {
                                Link(line.text, destination: url)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.blue)
                                    .underline()
                            } else {
                                Text(line.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
} // FIN DE OnboardingPageView


// --- Color Extension ---
extension Color {
    static let SubtitleColor = Color.gray
}

// --- abrirLinkMenu ---
func abrirLinkMenu(_ url: URL) {
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    } else {
        print("❌ No se pudo abrir el link \(url)")
    }
}
