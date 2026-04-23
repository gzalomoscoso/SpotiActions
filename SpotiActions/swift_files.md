## BarraInferior.swift

```swift
import SwiftUI

struct BarraInferior: View {
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    
    @AppStorage("lastMessage") private var lastMessage: String = ""
    
    var onShowOnboarding: (() -> Void)? = nil
    var onShowSetup: (() -> Void)? = nil
    var onHeightChange: ((CGFloat) -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            Spacer() // empuja todo hacia abajo
            
            HStack {
                Spacer()
                
                // OnBoarding
                Button(action: { onShowOnboarding?() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "autostartstop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.white)
                        Text(NSLocalizedString("OnBoarding", comment: "Bottom bar onboarding tab"))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 65)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                Spacer()
                
                // MainView Shortcuts (disabled if no subscription)
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "rectangle.stack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.orange)
                        Text(NSLocalizedString("Shortcuts", comment: "Bottom bar shortcuts tab"))
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
                .disabled(true)
                
                Spacer()
                
                // Tutorials
                Button(action: { onShowSetup?() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "wrench.and.screwdriver")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.white)
                        Text(NSLocalizedString("Tutorials", comment: "Bottom bar tutorials tab"))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom,
                UIDevice.current.userInterfaceIdiom == .pad
                    ? (UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                        .first?.safeAreaInsets.bottom ?? 0)
                    : 8 // solo 8 pts en iPhone
            )
            .background(Color.black)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // 🔹 evita que la barra suba con el teclado
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { onHeightChange?(proxy.size.height) }
                    .onChange(of: proxy.size.height) { _, newHeight in
                        onHeightChange?(newHeight) }
            }
        )

    }
}
```

---

## HeaderView.swift

```swift
import SwiftUI
import UIKit

struct HeaderView: View {
    let W: CGFloat
    let H: CGFloat
    @Binding var isDarkMode: Bool
    var isShortcutMode: Binding<Bool>? = nil


    var title: String = NSLocalizedString("app_title", comment: "")
    var showBack: Bool = false
    var showGear: Bool = true
    let bgColors: [Color]
    var onBack: (() -> Void)? = nil
    var onShowOnboarding: (() -> Void)? = nil
    
    @State private var restoreMessage: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColors.first?.ignoresSafeArea(edges: .top)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 0)
                }

            VStack(spacing: 0) {
                // --- HStack HEADER ---
                HStack(alignment: .center) {
                    // IZQUIERDA — back + gear
                    HStack(spacing: 12) {
                        if showBack {
                            Button(action: { onBack?() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text(NSLocalizedString("back", comment: ""))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(8)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(Color("ColorHeaderView"))
                        }

                        if showGear {
                            Menu {
                                Button(NSLocalizedString("support_url", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/support.html")!)
                                }

                                Button(NSLocalizedString("main_page", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/spotiactions.html")!)
                                }

                                Button(NSLocalizedString("suggest_song", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://patreon.com/gonzalomoscoso?utm_medium=unknown&utm_source=join_link&utm_campaign=creatorshare_creator&utm_content=copyLink")!)
                                }

                                Divider()

                                Button(NSLocalizedString("get_welcomeback", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.icloud.com/shortcuts/e26c47aad12d40f4965c98a693bb6bb3")!)
                                }
                            } label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Color1reverse"))
                                    .padding(10)
                            }
                        }
                    }
                    .frame(width: 80, alignment: .leading)

                    Spacer()
                    
                    // CENTRO — título
                    Text(title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("ColorNaranja"))
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    // DERECHA — toggle play/install mode
                    if let isShortcutMode {
                        Button(action: {
                            isShortcutMode.wrappedValue.toggle()
                            UserDefaults.standard.set(
                                isShortcutMode.wrappedValue,
                                forKey: "ShortcutPlayModeEnabled"
                            )
                        }) {
                            Image(systemName: isShortcutMode.wrappedValue
                                  ? "play.circle.fill"
                                  : "square.and.arrow.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("Color1reverse"))
                                .padding(10)
                        }
                        .frame(width: 80, alignment: .trailing)
                    } else {
                        Spacer()
                            .frame(width: 80)
                    }

                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
    }
}
```

---

## MainView.swift

```swift
import SwiftUI
import UIKit

// ================================================================
// abrirShortcutDesdeLink (con control de suscripción)
// Mantengo esta función global EXACTA (para compatibilidad con otros .swift)
// ================================================================

@MainActor
func abrirShortcutDesdeLink(
    data: [String: String],
    storeManager: StoreManager,
    isShortcutMode: Bool
) {
    guard
        let urlString = data["url"],
        let nameshortcut = data["nameshortcut"]
    else {
        print("❌ Datos incompletos en el diccionario")
        return
    }

    // ---- Modo ejecución directa ----
    if isShortcutMode {
        let encodedName = nameshortcut.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? nameshortcut

        if let runURL = URL(string: "shortcuts://run-shortcut?name=\(encodedName)") {
            Task { @MainActor in
                UIApplication.shared.open(runURL)
            }
        }
        return
    }

    // ---- Modo instalación (link iCloud) ----
    guard let url = URL(string: urlString) else { return }
    Task { @MainActor in
        UIApplication.shared.open(url)
    }
}

// ================================================================
// MARK: - MainView
// ================================================================
struct MainView: View {
    // Bindings & environment
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    @EnvironmentObject var navigationState: NavigationState
    @Binding var activeIndex: Int
    
    // Local state
    @State private var isShortcutMode: Bool =
        UserDefaults.standard.bool(forKey: "ShortcutPlayModeEnabled")
    @State private var showWelcome: Bool = false
    @EnvironmentObject var storeManager: StoreManager
    @State private var showTip: Bool = true
    @State private var lastMessage: String = NSLocalizedString("SwipeDown", comment: "")
    
    private let rowTitles = [
        NSLocalizedString("FRANJAINTEGRADAS", comment: ""),
        NSLocalizedString("FRANJACURADAS", comment: ""),
        NSLocalizedString("FRANJAGRATIS", comment: ""),
        NSLocalizedString("FRANJA_SINGLES", comment: ""),
        NSLocalizedString("FRANJAMASESCUCHADAS", comment: ""),
        NSLocalizedString("FRANJAVERYSPECIFIC", comment: "")
    ]
    
    private let SeasonPlaylistsImages = [
        "christmas","new year"
    ]
    
    struct ShortcutItem: Identifiable {
        let id = UUID()
        let name: String
        let imageasset: String
        let description: String
        let url: String
    }
    
    private let IntegratedPlaylists: [[String: String]] = [
        [
            "nameshortcut": "Shuffle Sweet Nothing Beat",
            "name": "Sweet Nothing Beat",
            "imageasset": "sweet",
            "description": NSLocalizedString("DESC_Sweet Nothing Beat", comment: ""),
            "url": "https://www.icloud.com/shortcuts/4103035b1b3242ba8e4d1518833e0200"
        ],
        [
            "nameshortcut": "Shuffle Rock Wake Up",
            "name": "Rock N Roll Wake Up",
            "imageasset": "rock",
            "description": NSLocalizedString("DESC_Rock N Roll Wake Up", comment: ""),
            "url": "https://www.icloud.com/shortcuts/99570e6ea3ad4614976cbf6f286eb51d"
        ],
        [
            "nameshortcut": "wakeup-1",
            "name": "Wake up Happy",
            "imageasset": "wakeup",
            "description": NSLocalizedString("DESC_Wake up Happy", comment: ""),
            "url": "https://www.icloud.com/shortcuts/7d7263dd5ca64980bb269990e8887abc"
        ],
        [
            "nameshortcut": "piano-1",
            "name": "Gentle Piano",
            "imageasset": "piano",
            "description": NSLocalizedString("DESC_Gentle Piano", comment: ""),
            "url": "https://www.icloud.com/shortcuts/54e18e2f5e2a4c878787632cb707cce2"
        ],
        [
            "nameshortcut": "allout2010s",
            "name": "All out 2010s",
            "imageasset": "allout2010s",
            "description": NSLocalizedString("DESC_All out 2010s", comment: ""),
            "url": "https://www.icloud.com/shortcuts/0b7b9addea004a8498b074ee52cec428"
        ],
        [
            "nameshortcut": "Reproducir Magnetismo",
            "name": "Magnetismo",
            "imageasset": "magnetismo",
            "description": NSLocalizedString("DESC_Magnetismo", comment: ""),
            "url": "https://www.icloud.com/shortcuts/f2013e04be7b42de820e6cd7209a9317"
        ]
    ]
        
    private let shortcutLinksCuradas: [[String: String]] = [
        [
            "nameshortcut": "Crying myself to sleep",
            "name": "Crying myself to sleep",
            "imageasset": "crying",
            "description": "Crying myself to sleep",
            "url": "https://www.icloud.com/shortcuts/b3bc169cecc14a059edb85d76e2507cd"
        ],
        [
            "nameshortcut": "Reproducir Beatles influenced without The Beatles",
            "name": "Beatles without the Beatles",
            "imageasset": "Beatles without the Beatles",
            "description": NSLocalizedString("Beatles without the Beatles", comment: ""),
            "url": "https://www.icloud.com/shortcuts/8d115b8c185145bc8689db47cd4c1533"
        ],
        [
            "nameshortcut": "Reproducir op de fiets",
            "name": "op de fiets",
            "imageasset": "op de fiets",
            "description": NSLocalizedString("op de fiets", comment: ""),
            "url": "https://www.icloud.com/shortcuts/10d30a121bb440dfbd3a1a1b045cf460"
        ],
        [
            "nameshortcut": "Reproducir ROCK is still amazing",
            "name": "ROCK is still amazing",
            "imageasset": "ROCK is still amazing",
            "description": NSLocalizedString("ROCK is still amazing", comment: ""),
            "url": "https://www.icloud.com/shortcuts/43b46bba03434876a06da7e666901c39"
        ],
        [
            "nameshortcut": "Reproducir Love songs",
            "name": "Love Songs",
            "imageasset": "Love Songs",
            "description": NSLocalizedString("Love Songs", comment: ""),
            "url": "https://www.icloud.com/shortcuts/1410cc93f40c41d7bdf97193c455bb04"
        ]
    ]
    
    private let SingleSongsEN: [[String: String]] = [
        [
            "nameshortcut": "marianastrench",
            "name": "In Mariana's Trench – ABR",
            "imageasset": "marianastrench",
            "description": NSLocalizedString("In Mariana's Trench – ABR", comment: ""),
            "url": "https://www.icloud.com/shortcuts/be85c58cc84144aba70b3b368e55cb38"
        ],
        [
            "nameshortcut": "gymnopedie",
            "name": "Gymnopédie No 1 – E. Satie",
            "imageasset": "gymnopedie",
            "description": NSLocalizedString("Gymnopédie No 1 – E. Satie", comment: ""),
            "url": "https://www.icloud.com/shortcuts/2bfd296a19cd436ba2ab6f31066388b5"
        ],
        [
            "nameshortcut": "goodmorning",
            "name": "Good Morning – Kanye West",
            "imageasset": "goodmorning",
            "description": NSLocalizedString("Good Morning – Kanye West", comment: ""),
            "url": "https://www.icloud.com/shortcuts/921547a4839f4e5db46b569581233e37"
        ]
    ]
    
    private let SingleSongsES: [[String: String]] = [
        [
            "nameshortcut": "Me gustas tanto",
            "name": "Me Gustas Tanto - Miranda",
            "imageasset": "megustas",
            "description": NSLocalizedString("Me Gustas Tanto - Miranda", comment: ""),
            "url": "https://www.icloud.com/shortcuts/60bc106862224654b864c75ece254a0a"
        ],
        [
            "nameshortcut": "Otra Piel",
            "name": "Otra Piel - Gustavo Cerati",
            "imageasset": "otrapiel",
            "description": NSLocalizedString("Otra Piel - Gustavo Cerati", comment: ""),
            "url": "https://www.icloud.com/shortcuts/9a356e3141e44c8f95416f053110d2a8"
        ],
        [
            "nameshortcut": "NoAguanto",
            "name": "No aguanto - Conociendo Rusia",
            "imageasset": "noaguanto",
            "description": NSLocalizedString("No aguanto - Conociendo Rusia", comment: ""),
            "url": "https://www.icloud.com/shortcuts/4ba8e0a96d51475d8afd348ca92e7303"
        ]
    ]
    
    
    private let MoreListened: [[String: String]] = [

        [
            "nameshortcut": "Dayly Mix",
            "name": NSLocalizedString("DESC_dailymix", comment: ""),
            "imageasset": "dayly",
            "description": NSLocalizedString("DESC_dailymix", comment: ""),
            "url": "https://www.icloud.com/shortcuts/02660a438efd46b2bcf22d605ada2947"
        ],
        [
            "nameshortcut": "yourlikes",
            "name": NSLocalizedString("Playlist_My liked songs", comment: ""),
            "imageasset": "yourlikes",
            "description": NSLocalizedString("DESC_My liked songs", comment: ""),
            "url": "https://www.icloud.com/shortcuts/ccb8562e1e8548b283d84cac64887272"
        ]
    ]
    
    private let VerySpecific: [[String: String]] = [
        [
            "nameshortcut": "HBO Themes",
            "name": "HBO theme songs",
            "imageasset": "hbo",
            "description": NSLocalizedString("DESC_HBO theme songs", comment: ""),
            "url": "https://www.icloud.com/shortcuts/e799f3a9b3b743528337516360d5265d"
        ],
        [
            "nameshortcut": "The Other Side of Heaven 2",
            "name": "The other side of heaven",
            "imageasset": "heaven",
            "description": NSLocalizedString("DESC_The other side of heaven", comment: ""),
            "url": "https://www.icloud.com/shortcuts/d85d19af689e42298529971e53ae66fb"
        ],
        [
            "nameshortcut": "LDS Hymns on violin and piano",
            "name": "Hymns on violin and piano",
            "imageasset": "hymns",
            "description": NSLocalizedString("DESC_Hymns on violin and piano", comment: ""),
            "url": "https://www.icloud.com/shortcuts/23c60a0a0ac04807a476410c3cf9dbb2"
        ]
    ]
    
    init(
        activeTab: Binding<Int>,
        isDarkMode: Binding<Bool>,
        activeIndex: Binding<Int>
    ) {
        self._activeTab = activeTab
        self._isDarkMode = isDarkMode
        self._activeIndex = activeIndex
    }

    
    // ================================================================
    // MARK: - BODY
    // ================================================================
    var body: some View {
        GeometryReader { geometry in
            let W = geometry.size.width
            let H = geometry.size.height
            
            ZStack(alignment: .top) {
                bgColors[0].ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Header compacto
                        HeaderView(
                            W: W,
                            H: H,
                            isDarkMode: $isDarkMode,
                            isShortcutMode: $isShortcutMode,
                            title: NSLocalizedString("SpotiActions", comment: ""),
                            showBack: false,
                            showGear: true,
                            bgColors: [Color("ColorFondo")]
                        )
                        .frame(height: 80)
                        .onChange(of: isShortcutMode) { value in
                            lastMessage = value
                                ? NSLocalizedString("ModoPlay", comment: "")
                                : NSLocalizedString("ModoInstalar", comment: "")
                            showTip = true
                        }
                        
                        // Contenido con grid de 2 columnas
                        VStack(spacing: 0) {
                            
                            // --- SECCION: MAS ESCUCHADAS ---
                            PlaylistGridSection(
                                title: NSLocalizedString("FRANJAMASESCUCHADAS", comment: ""),
                                playlists: MoreListened,
                                isShortcutMode: isShortcutMode,
                                storeManager: storeManager
                            )
                            
                            // Separador centrado
                            SectionSeparator()
                            
                            // --- SECCION: INTEGRADAS ---
                            PlaylistGridSection(
                                title: NSLocalizedString("FRANJAINTEGRADAS", comment: ""),
                                playlists: IntegratedPlaylists,
                                isShortcutMode: isShortcutMode,
                                storeManager: storeManager
                            )
                            
                            // Separador centrado
                            SectionSeparator()
                            
                            // --- SECCION: CURADAS ---
                            PlaylistGridSection(
                                title: NSLocalizedString("FRANJACURADAS", comment: ""),
                                playlists: shortcutLinksCuradas,
                                isShortcutMode: isShortcutMode,
                                storeManager: storeManager
                            )
                            
                            // Separador centrado
                            SectionSeparator()
                            
                            // --- SECCION: SINGLES ---
                            PlaylistGridSection(
                                title: NSLocalizedString("FRANJA_SINGLES", comment: ""),
                                playlists: SingleSongsEN + SingleSongsES,
                                isShortcutMode: isShortcutMode,
                                storeManager: storeManager
                            )
                            
                            // Separador centrado
                            SectionSeparator()
                            
                            // --- SECCION: VERY SPECIFIC ---
                            PlaylistGridSection(
                                title: NSLocalizedString("FRANJAVERYSPECIFIC", comment: ""),
                                playlists: VerySpecific,
                                isShortcutMode: isShortcutMode,
                                storeManager: storeManager
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 80)
                    }
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea(edges: .bottom)
                
                // Tip overlay
                if showTip {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Text(lastMessage)
                                .font(.headline)
                                .foregroundColor(.yellow)
                            Image(systemName: "hand.draw")
                                .foregroundColor(.yellow)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 60)
                        .zIndex(1)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showTip = false
                            }
                        }
                    }
                }
            }
        }
    }
}

// ================================================================
// MARK: - PlaylistGridSection
// ================================================================
struct PlaylistGridSection: View {
    let title: String
    let playlists: [[String: String]]
    let isShortcutMode: Bool
    let storeManager: StoreManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Grid de 2 columnas
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(playlists.indices, id: \.self) { index in
                    PlaylistGridCard(
                        playlist: playlists[index],
                        rowTitle: title,
                        isShortcutMode: isShortcutMode,
                        storeManager: storeManager
                    )
                }
            }
        }
    }
}

// ================================================================
// MARK: - SectionSeparator
// ================================================================
struct SectionSeparator: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.5),
                    Color.cyan.opacity(0.5)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .padding(.vertical, 8) // Espacio arriba y abajo del separador
    }
}

// ================================================================
// MARK: - PlaylistGridCard
// ================================================================
struct PlaylistGridCard: View {
    let playlist: [String: String]
    let rowTitle: String
    let isShortcutMode: Bool
    let storeManager: StoreManager
    
    var body: some View {
        Button(action: {
            abrirShortcutDesdeLink(
                data: playlist,
                storeManager: storeManager,
                isShortcutMode: isShortcutMode
            )
        }) {
            GeometryReader { geo in
                ZStack(alignment: .bottomLeading) {
                    // Imagen de fondo
                    Image(playlist["imageasset"] ?? "")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width)
                        .clipped()
                        .cornerRadius(12)
                    
                    // Overlay con texto
                    VStack(alignment: .leading, spacing: 0) {
                        // Línea 1: Título de la sección (bold)
                        Text(rowTitle)
                            .font(.system(size: 11))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        // Línea 2: Nombre de la playlist
                        Text(playlist["name"] ?? "")
                            .font(.system(size: 11))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        // Línea 3: Descripción
                        //Text(playlist["description"] ?? "")
                          //  .font(.system(size: 11))
                          //  .foregroundColor(.white)
                          //  .lineLimit(2)
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Color.black.opacity(0.5)
                            .cornerRadius(12, corners: [.topLeft, .topRight])
                    )
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// ================================================================
// MARK: - RoundedCorner Extension
// ================================================================
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
```

---

## NavigationState.swift

```swift
import SwiftUI
import Foundation

// MARK: - NavigationState
class NavigationState: ObservableObject {
    enum ViewType {
        case welcome
        case main
        case subscription   // pantalla de suscripción Lifetime
        // agrega otras vistas si las tenés
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

        if url.host == "tab", let tabIndex = Int(url.lastPathComponent) {
            self.activeTab = tabIndex
            self.currentView = .main
        }
        else if url.host == "subscribe" && url.pathComponents.contains("lifetime") {
            self.currentView = .subscription
        }
        else if url.host == nil {
            // solo spotiactions:// → abrir app
            // No hace nada, deja la pantalla que ya estaba
            print("🔹 App opened via simple spotiactions://")
        }
        else {
            print("⚠️ Deep link desconocido: \(url.absoluteString)")
        }
    }
}
```

---

## OnboardingView.swift

```swift
// --- REFERENCIA DE ESTRUCTURA DEL ARCHIVO ---
//
// Tu jerarquía en este archivo es así:
//
// struct OnboardingView: View { ... }
// Dentro de él están:
// - el body
// - las funciones privadas (continueButton, premiumOverlay)
//
// Este struct debe cerrarse con una llave solitaria `}` justo antes de que comience el siguiente:
//
// struct OnboardingPageView: View { ... }
// Dentro de él solo hay el body
// Este struct debe cerrarse con otra llave solitaria `}` antes del bloque de extensión y de la función global.
// Luego de eso ya pueden ir tus extensiones o funciones globales, por ejemplo:
//
// extension Color { ... }
// func abrirLinkMenu(_ url: URL) { ... }
//



import SwiftUI
struct OnboardingView: View {
    var onFinished: (() -> Void)? = nil
    var startAtPage: Int = 0
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    
    @State private var isSubscribed = true
    
    // Gradientes correspondientes a cada página
    private let pageGradients: [[Color]] = [
        [Color.orange, Color.red],
        [Color.purple, Color.pink],
        [Color.blue, Color.cyan],
        [Color.mint, Color.blue],
        [Color.purple, Color.orange]
    ]
    
    var body: some View {
        VStack {

                TabView(selection: $currentPage) {
                    // --- PÁGINA 1 ---
                    OnboardingPageView(
                        systemName: "music.note",
                        gradient: [Color.orange, Color.red],
                        title: NSLocalizedString("Welcome to SpotiActions", comment: ""),
                        description: NSLocalizedString("SpotiActions lets you play your Spotify songs automatically", comment: ""),
                        lines: [
                            (NSLocalizedString("At a set time (perfect as a wake-up alarm)", comment: ""), nil),
                            (NSLocalizedString("At a specific place (so your music plays when you arrive home)", comment: ""), nil),
                            (NSLocalizedString("When you hop in your car and connect to CarPlay", comment: ""), nil)
                        ]
                    ).tag(0)
                    
                    // --- PÁGINA 2 ---
                    OnboardingPageView(
                        systemName: "sparkles",
                        gradient: [Color.purple, Color.pink],
                        title: NSLocalizedString("How does it work?", comment: ""),
                        description: NSLocalizedString("SpotiActions creates shortcuts that control your Spotify", comment: ""),
                        lines: [
                            (NSLocalizedString("SpotiActions puts ready-made shortcuts right on the main screen", comment: ""), nil),
                            (NSLocalizedString("They can shuffle playlists, play them in order, or play specific songs", comment: ""), nil),
                            (NSLocalizedString("Just install and run them once — this gives them permission to work on their own", comment: ""), nil),
                            (NSLocalizedString("Install the Shortcuts App if you don’t have it yet", comment: ""), URL(string: "https://apps.apple.com/app/atajos/id1462947752"))
                        ]
                    ).tag(1)
                    
                    // --- PÁGINA 3 ---
                    OnboardingPageView(
                        systemName: "lightbulb.fill",
                        gradient: [Color.blue, Color.cyan],
                        title: NSLocalizedString("Why not just make my own shortcuts?", comment: ""),
                        description: NSLocalizedString("Apple doesn’t provide native Spotify shortcuts", comment: ""),
                        lines: [
                            (NSLocalizedString("OnboardingviewP3Parrafo1", comment: ""), nil),
                            (NSLocalizedString("SpotiActions shortcuts only ask for permission once, after that, they run completely automatically", comment: ""), nil)
                        ]
                    ).tag(2)
                    
                    // --- PÁGINA 4 ---
                    OnboardingPageView(
                        systemName: "gearshape",
                        gradient: [Color.mint, Color.blue],
                        title: NSLocalizedString("How do I set them up?", comment: ""),
                        description: NSLocalizedString("Spotify and Shortcuts must be installed on your iPhone", comment: ""),
                        lines: [
                            (NSLocalizedString("Create an automation that triggers your chosen shortcut", comment: ""), nil),
                            (NSLocalizedString("Just follow our easy step-by-step guide and you’ll be set", comment: ""), nil),
                            (NSLocalizedString("If you have any trouble setting up, our support team is here to help! Just write to us", comment: ""), nil)
                        ]
                    ).tag(3)
                                        
                } // fin del TabView
                
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            

            
            Spacer()
            
            // ocultamos el continueButton normal si estamos en la página premium y no está suscrito,
            // porque el premiumOverlay mostrará los botones grandes y los links.
            if !(currentPage == 4 && !isSubscribed) {
                continueButton
            }
        }
        .onAppear {
            currentPage = startAtPage
        }



        
    }
    
    
    // continueButton
    private var continueButton: some View {
        Button(action: {
            let lastPage = isSubscribed ? 3 : 4
            if currentPage < lastPage {
                withAnimation { currentPage += 1 }
            } else {
                hasSeenOnboarding = true
                onFinished?()
            }
        }) {
            Text(currentPage < (isSubscribed ? 3 : 4)
                 ? NSLocalizedString("continue", comment: "")
                 : NSLocalizedString("continue_free", comment: ""))
                .font(.system(.headline, design: .default).weight(.bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Group {
                        if currentPage < (isSubscribed ? 3 : 4) {
                            LinearGradient(
                                gradient: Gradient(colors: pageGradients[currentPage]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.blue
                        }
                    }
                )
                .cornerRadius(14)
                .shadow(color: pageGradients[min(currentPage, 4)].last!.opacity(0.4),
                        radius: 6, x: 0, y: 3)
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 30)
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
        let isPremiumPage = systemName == "infinity.circle.fill"
        
        VStack(spacing: 18) {
            // --- ICONO CENTRAL (grande o pequeño según la página) ---
            Image(systemName: systemName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .font(.system(size: isPremiumPage ? 80 : 160, weight: .bold))
                .padding(.top, isPremiumPage ? 20 : 60)
                .offset(y: isPremiumPage ? -30 : 20)
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
                    .foregroundColor(Color("Color1reverse"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 4)
            }
            .padding(.top, isPremiumPage ? 0 : 10)

            // --- LISTA DE LÍNEAS ---
            if let lines = lines {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                        if let url = line.url {
                            Link(line.text, destination: url)
                                .font(.system(size: 14))
                                .foregroundColor(Color.blue)
                        } else {
                            Text(line.text)
                                .font(.system(size: 14))
                                .foregroundColor(Color("SubtitleColor"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}


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


```

---

## RootView.swift

```swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigationState: NavigationState
    @Binding var isDarkMode: Bool
    @Binding var isShortcutMode: Bool
    @EnvironmentObject var storeManager: StoreManager

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    @State private var activeTab: Int = 0
    @State private var showHowToSetup: Bool = false
    @State private var barraHeight: CGFloat = 0
    @State private var didCheckOnboarding: Bool = false
    @State private var activeIndex = 1

    var body: some View {
        ZStack(alignment: .bottom) {
            switch navigationState.currentView {
            case .welcome:
                OnboardingView {
                    hasSeenOnboarding = true
                    navigationState.currentView = .main
                }

            case .main:
                MainView(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    activeIndex: $activeIndex
                )
                .environmentObject(storeManager)

            @unknown default:
                EmptyView() // fallback seguro
            }

            if navigationState.currentView == .main {
                BarraInferior(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    onShowOnboarding: {
                        hasSeenOnboarding = false
                        navigationState.currentView = .welcome
                    },
                    onShowSetup: {
                        showHowToSetup = true
                    },
                    onHeightChange: { newHeight in
                        barraHeight = newHeight
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $showHowToSetup) {
            howtoSETUP(
                activeTab: $activeTab,
                isDarkMode: $isDarkMode,
                onBack: {
                    showHowToSetup = false
                }
            )
            .environmentObject(storeManager)
        }
        .onAppear {
            guard !didCheckOnboarding else { return }
            didCheckOnboarding = true
            migrateUserDefaults()
            navigationState.currentView = hasSeenOnboarding ? .main : .welcome
        }
    }

    // MARK: - Migración de claves antiguas
    private func migrateUserDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "noVolverAMostrarWelcome") != nil ||
            defaults.object(forKey: "MedejasContinuar") != nil {
            defaults.removeObject(forKey: "noVolverAMostrarWelcome")
            defaults.removeObject(forKey: "MedejasContinuar")
        }

        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let lastVersion = defaults.string(forKey: "lastSeenVersion")

        if lastVersion != currentVersion {
            defaults.set(currentVersion, forKey: "lastSeenVersion")
        }
    }
}
```

---

## SpotiActionsApp.swift

```swift
//SpotiActionsApp.swift
import SwiftUI
import Foundation

@main
struct SpotiActionsApp: App {
    @StateObject private var navigationState: NavigationState
    @StateObject private var storeManager: StoreManager
    @State private var isDarkMode: Bool = true
    @State private var isShortcutMode: Bool = false

    init() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        UserDefaults.standard.set(currentVersion, forKey: "lastSeenVersion")

        let hasSeen = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let initialView: NavigationState.ViewType = hasSeen ? .main : .welcome
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
            .onOpenURL { url in
                navigationState.handleDeepLink(url)
            }
        }
    }
}
```

---

## StoreManager.swift

```swift
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
```

---

## Theme.swift

```swift
import SwiftUI

let bgColors: [Color] = [
    Color("ColorFondo"),
    Color("Color2"),
    Color("Color3"),
    Color("Color5"),
    Color("Color7"),
    Color("Color9"),
    Color("Color3a"),
    Color("Color3b"),
    Color("Color3c"),
    Color("Color3d"),
    Color("Color3e"),
    Color("ColorNaranja")
]


```

---

## howtoSETUP.swift

```swift
import SwiftUI

// --------------------------------------------------
// howtoSETUP.swift
// Versión corregida: evita sobrescribir navigationState al aparecer,
// y garantiza que Back en la lista de tutoriales vuelva a MainView.
// --------------------------------------------------

struct howtoSETUP: View {
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) private var dismiss
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    
    var onBack: (() -> Void)? = nil
    @State private var selectedTutorial: SelectedTutorial? = nil

    private let sectionTitles: [String] = [
        NSLocalizedString("How to import shortcuts", comment: ""),
        NSLocalizedString("How to create an automation and use it as an alarm", comment: ""),
        NSLocalizedString("Hear ‘Welcome Back, Sir’ when you get in your car ( only with carplay )", comment: ""),
        NSLocalizedString("Play Music Automatically when you get home", comment: ""),
        NSLocalizedString("Start your song as you cross the finish line of your training", comment: ""),
        NSLocalizedString("Play Music Automatically when you get home", comment: "")
    ]

    private let sectionDescriptions: [String] = [
        NSLocalizedString("Choose a playlist or song and install the shortcut into your Shortcuts app.", comment: ""),
        NSLocalizedString("Create a time-based automation (alarm) and assign a shortcut to run when it triggers.", comment: ""),
        NSLocalizedString("Use CarPlay as trigger so the shortcut plays when the car connects to your device.", comment: ""),
        NSLocalizedString("Enable location-based automation to start playback as you arrive home.", comment: ""),
        NSLocalizedString("Set a geofence at your finish line so your victory song plays automatically.", comment: ""),
        NSLocalizedString("Alternative method to play a playlist when arriving home (arrive-home trigger).", comment: "")
    ]

    private let rowColors: [Color] = [
        Color("Color5"),
        Color("Color4"),
        Color("Color3a"),
        Color("Color3b"),
        Color("Color3c"),
        Color("Color3d"),
        Color("Color3e"),
        Color("ColorNaranja")
    ]

    let tutorialesDisponibles: [Bool] = [
        true,  true, true, false, false, false
    ]
    
    var body: some View {
        GeometryReader { geometry in
            HowToSetupContent(
                W: geometry.size.width,
                H: geometry.size.height,
                activeTab: $activeTab,
                isDarkMode: $isDarkMode,
                selectedTutorial: $selectedTutorial,
                sectionTitles: sectionTitles,
                sectionDescriptions: sectionDescriptions,
                tutorialesDisponibles: tutorialesDisponibles,
                rowColors: rowColors,
                onBack: {
                    // Garantizar: al tocar Back en la lista -> volver a MainView
                    navigationState.currentView = .main
                    // si esta pantalla está presentada como fullScreenCover, cerrarla
                    dismiss()
                    // si el caller proveyó un onBack extra, también ejecutarlo
                    onBack?()
                }
            )
            // NO .task que modifique navigationState aquí
        }
    }
}

// MARK: - Identificable para sheet(item:)
fileprivate struct SelectedTutorial: Identifiable, Equatable {
    let index: Int
    var id: Int { index }
}

// MARK: - Contenido principal separado
fileprivate struct HowToSetupContent: View {
    let W: CGFloat
    let H: CGFloat
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var storeManager: StoreManager
    
    @Environment(\.dismiss) private var dismiss
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool

    @Binding var selectedTutorial: SelectedTutorial?
    let sectionTitles: [String]
    let sectionDescriptions: [String]
    let tutorialesDisponibles: [Bool]
    let rowColors: [Color]
    let onBack: () -> Void

    var body: some View {
        // --------------------------------------------------
        // Calculamos si debemos mover el contenido hacia arriba
        // Solo para tutoriales de la 1 a la 5 (índices 0 a 4)
        // --------------------------------------------------
        let shouldShiftUp: Bool = {
            guard let sel = selectedTutorial else { return false }
            return sel.index >= 0 && sel.index < 5
        }()

        ZStack {
            VStack(spacing: 0) {
                HeaderView(
                    W: W,
                    H: H,
                    isDarkMode: $isDarkMode,
                    title: NSLocalizedString("Tutorials", comment: ""),
                    showBack: true,
                    showGear: true,
                    bgColors: [Color("ColorFondo")],
                    onBack: {
                        // Este onBack es el que se llama desde HeaderView (flecha superior izquierda)
                        // Queremos que vuelva a MainView
                        onBack()
                    }
                )
                
                
                .frame(height: H * 0.26)

                ScrollSectionView(
                    W: W,
                    H: H,
                    sectionTitles: sectionTitles,
                    sectionDescriptions: sectionDescriptions,
                    selectedTutorial: $selectedTutorial,
                    tutorialesDisponibles: tutorialesDisponibles,
                    isDarkMode: $isDarkMode,
                    rowColors: rowColors
                )

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Color1"))
            .ignoresSafeArea(edges: .bottom)
            // --------------------------------------------------
            // Offset vertical: mueve todo 10% de la altura hacia arriba
            // --------------------------------------------------
            .offset(y: shouldShiftUp ? -H * 0.1 : 0)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// (los subcomponentes ScrollSectionView, SectionRow, TutorialModalWrapper, ModalPageView,
// ModalHeader, PageIndicator y tutorialItemsForIndex permanecen iguales — los mantengo tal como los tenías,
// porque estaban correctos estructuralmente)

fileprivate struct ScrollSectionView: View {
    let W: CGFloat
    let H: CGFloat
    let sectionTitles: [String]
    let sectionDescriptions: [String]
    @Binding var selectedTutorial: SelectedTutorial?
    let tutorialesDisponibles: [Bool]
    @Binding var isDarkMode: Bool
    let rowColors: [Color]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(sectionTitles.indices, id: \.self) { index in
                    SectionRow(
                        W: W,
                        H: H,
                        title: sectionTitles[index],
                        description: sectionDescriptions.indices.contains(index) ? sectionDescriptions[index] : "",
                        index: index,
                        selectedTutorial: $selectedTutorial,
                        isDarkMode: $isDarkMode,
                        rowColors: rowColors,
                        tutorialesDisponibles: tutorialesDisponibles
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color("ColorScrollview"))
        .ignoresSafeArea(edges: .bottom)
        .animation(.easeInOut(duration: 0.18), value: isDarkMode)
        .sheet(item: $selectedTutorial) { sel in
            TutorialModalWrapper(
                sectionTitle: sectionTitles[sel.index],
                tutorialItems: tutorialItemsForIndex(sel.index),
                initialPage: 0
            )
        }
    }
}

fileprivate struct SectionRow: View {
    let W: CGFloat
    let H: CGFloat
    let title: String
    let description: String
    let index: Int
    @Binding var selectedTutorial: SelectedTutorial?
    @Binding var isDarkMode: Bool
    let rowColors: [Color]
    let tutorialesDisponibles: [Bool]

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color("ColorNaranja"))
                .padding(.leading, 6)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("ColorNaranja"))
                    .multilineTextAlignment(.leading)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color("Color1reverse"))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer().frame(height: 8)

                Button(action: { selectedTutorial = SelectedTutorial(index: index) }) {
                    Text(NSLocalizedString("Watch tutorial", comment: ""))
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color("Color3"))
                        .foregroundColor(Color("Color1reverse"))
                        .cornerRadius(10)
                }
                .disabled(!tutorialesDisponibles[index])
                .opacity(tutorialesDisponibles[index] ? 1.0 : 0.5)
            }
            .padding(.vertical, 12)
            .padding(.trailing, 12)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: H * 0.18, alignment: .topLeading)
        .background(
            Color("ColorCardNaranja")
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal, 12)
        .animation(.easeInOut(duration: 0.14), value: isDarkMode)
    }
}

fileprivate struct TutorialModalWrapper: View {
    let sectionTitle: String
    let tutorialItems: [(image: String, description: String)]
    @State private var selectedPage: Int
    @Environment(\.dismiss) private var dismiss

    init(sectionTitle: String, tutorialItems: [(image: String, description: String)], initialPage: Int = 0) {
        self.sectionTitle = sectionTitle
        self.tutorialItems = tutorialItems
        _selectedPage = State(initialValue: initialPage)
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height

            VStack(spacing: 0) {
                // Header
                ModalHeader(sectionTitle: sectionTitle) {
                    // cerrar el modal y dejar la lista (no tocamos navigationState aquí)
                    dismiss()
                }

                // TabView de tutoriales
                ModalPageView(
                    w: w,
                    h: h,
                    tutorialItems: tutorialItems,
                    sectionTitle: sectionTitle,
                    selectedPage: $selectedPage
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()
            }
            .background(Color("Color1"))
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

fileprivate struct ModalPageView: View {
    let w: CGFloat
    let h: CGFloat
    let tutorialItems: [(image: String, description: String)]
    let sectionTitle: String
    @Binding var selectedPage: Int

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            TabView(selection: $selectedPage) {
                ForEach(0..<tutorialItems.count, id: \.self) { index in
                    VStack(spacing: 16) {
                        Image(tutorialItems[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()

                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(String(format: "%02d.", index + 1))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("Color7"))
                            Text(NSLocalizedString(tutorialItems[index].description, comment: ""))
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color("Color7"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 15)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

fileprivate struct ModalHeader: View {
    let sectionTitle: String
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // --- Barra superior con BACK ---
            HStack {
                Button(action: { onBack() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                        Text(NSLocalizedString("Back", comment: "Back button in modal header"))
                            .font(.system(size: 16))
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(Color("ColorNaranja")) // usar color de la paleta
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)

            Divider()
                .background(Color.gray)

            // --- Título de sección ---
            Text(sectionTitle)
                .font(.system(size: 18 , weight: .semibold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color("Color9"))

            Divider()
                .background(Color.gray)
        }
    }
}

// Datos (sin cambios funcionales)
fileprivate func tutorialItemsForIndex(_ index: Int) -> [(image: String, description: String)] {
    switch index {
    case 0: return [
        ("tuto1", NSLocalizedString("First, choose the playlist or song you want to use, then tap the album cover to install the shortcut", comment: "")),
        ("tuto2", NSLocalizedString("The shortcut will open in full screen. Tap “Add Shortcut", comment: "")),
        ("tuto3", NSLocalizedString("The shortcut will appear in your Shortcuts list. Tap it, and when it runs, press “Allow” to grant permissions", comment: "")),
        ("tuto4", NSLocalizedString("The shortcut is ready. Next step, go to Automation (explained in the next tutorial)", comment: ""))
    ]
    case 1: return [
        ("tuto5", NSLocalizedString("This is the longest tutorial, so please be patient. First, tap “Automation” in the bottom bar", comment: "")),
        ("tuto6", NSLocalizedString("Tap the “+” button to create a new automation", comment: "")),
        ("tuto7", NSLocalizedString("Select [Time of Day]. Let's set an alarm for 6:00 AM, Monday to Friday", comment: "")),
        ("tuto8", NSLocalizedString("Choose the values as shown on the screen, and make sure “Run Immediately” is checked. Then tap Done", comment: "")),
        ("tuto9", NSLocalizedString("Tap [Create New Shortcut]", comment: "")),
        ("tuto10", NSLocalizedString("Include at least the volume, and...", comment: "")),
        ("tuto11", NSLocalizedString("and make sure to select the shortcut so it looks like this. Then tap the blue checkmark", comment: "")),
        ("tuto12", NSLocalizedString("That's it! Your automation is ready and can be seen in your Automations list. It will play every day; in this case, the playlist will play shuffled, so a different song will play each day", comment: ""))
    ]
    case 2: return [
        ("tuto13", NSLocalizedString("Follow steps 1, 2, and 3 from the previous tutorial, but instead of selecting “Time of Day”, choose “CarPlay”. This shortcut is in the Settings menu ", comment: "")),
        ("tuto14", NSLocalizedString("To play “Welcome Back Sir” when CarPlay connects, choose these options and then tap the blue checkmark.", comment: "")),
        ("tuto15", NSLocalizedString("Always make sure all your automations are set to “Run Immediately”", comment: ""))
    ]
    case 3: return [
        ("tutoC1", NSLocalizedString("Enable location-based automation.", comment: "")),
        ("tutoC2", NSLocalizedString("Set your home location.", comment: "")),
        ("tutoC3", NSLocalizedString("Choose 'Play Playlist' action.", comment: "")),
        ("tutoC4", NSLocalizedString("Select your favorite playlist.", comment: ""))
    ]
    case 4: return [
        ("tutoD1", NSLocalizedString("Open your running app.", comment: "")),
        ("tutoD2", NSLocalizedString("Set a geofence at the finish line.", comment: "")),
        ("tutoD3", NSLocalizedString("Choose 'Play Music' action.", comment: "")),
        ("tutoD4", NSLocalizedString("Select your victory song.", comment: ""))
    ]
    case 5: return [
        ("tutoE1", NSLocalizedString("Open Shortcuts automation.", comment: "")),
        ("tutoE2", NSLocalizedString("Set trigger: Arrive Home.", comment: "")),
        ("tutoE3", NSLocalizedString("Add 'Play Playlist' action.", comment: "")),
        ("tutoE4", NSLocalizedString("Select playlist to play automatically.", comment: "")),
        ("tutoE5", NSLocalizedString("Test the automation to confirm.", comment: ""))
    ]
    default: return []
    }
}

```

---


Todos los archivos SWIFT del proyecto son los siguientes:

- BarraInferior.swift
- HeaderView.swift
- MainView.swift
- NavigationState.swift
- OnboardingView.swift
- RootView.swift
- SpotiActionsApp.swift
- StoreManager.swift
- Theme.swift
- howtoSETUP.swift

Si durante el transcurso del chat necesitas el código de alguno de ellos, recurre a esta información tanto al nombre como al contenido. Recordar que el nombre de los iconos de la barra inferior son house.fill, rectangle.stack y wrench.and.screwdriver
