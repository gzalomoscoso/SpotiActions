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

            HStack {
                Spacer()
                
                // OnBoarding
                Button(action: {
                    onShowOnboarding?()
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
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
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 10)
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
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .disabled(true)
                
                Spacer()
                
                // Tutorials
                Button(action: {
                    onShowSetup?()
                }) {
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
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                
                Spacer()
            }
            .padding(.top, 45)

            // 🔹 Mensaje dinámico fijo (no desplaza íconos)
            Text(lastMessage)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(red: 255/255, green: 100/255, blue: 124/255))
                .padding(.top, 10)
                .padding(.bottom, 6)
                .opacity(lastMessage.isEmpty ? 0 : 1)
                .onChange(of: lastMessage) { _, newValue in
                    if !newValue.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                lastMessage = ""
                            }
                        }
                    }
                }

                
        }
        .frame(height: 13 + (UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.bottom ?? 0))
        .background(Color.black)
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

    var title: String = NSLocalizedString("app_title", comment: "")
    var subtitle: String? = nil
    var showBack: Bool = false
    var showGear: Bool = true
    let bgColors: [Color]
    var onBack: (() -> Void)? = nil
    var onShowOnboarding: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .top) {
            bgColors.first?.ignoresSafeArea(edges: .top)

            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0)
            }

            VStack(spacing: 0) {
                // --- HStack BOTONES ---
                HStack {
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
                            .foregroundColor(Color("Color8"))
                        }

                        if showGear {
                            Menu {
                                Button(NSLocalizedString("suggest_song", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdTxxtKI8kXjjV9XnOCvnts49bt1d7ax1SjvuLmHatc9NrWkQ/viewform")!)
                                }
                                Button(NSLocalizedString("support_url", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/support.html")!)
                                }
                                Button(NSLocalizedString("main_page", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org")!)
                                }
                                Button(NSLocalizedString("get_welcomeback", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.icloud.com/shortcuts/e26c47aad12d40f4965c98a693bb6bb3")!)
                                }
                                Divider()
                                Button(NSLocalizedString("Terms of Use", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/terms.html")!)
                                }
                                Button(NSLocalizedString("Privacy Policy", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/privacy.html")!)
                                }
                            } label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Color8"))
                                    .padding(10)
                            }
                        }
                    }
                    .padding(.leading, showBack ? 6 : 12)

                    Spacer()

                    // Toggle sol/luna
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isDarkMode ? 14 : 20, height: 20)
                            .foregroundColor(Color("Color8"))
                            .padding(10)
                    }
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 16)

                Spacer(minLength: 0)

                // --- TITULO + SUBTITULO ---
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 38)) // Ajustá el tamaño a tu gusto
                        .fontWeight(.bold)
                        .foregroundColor(Color("Color8"))
                        .multilineTextAlignment(.center)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 16))
                            .foregroundColor(Color("SubtitleColor"))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)

                Spacer(minLength: 0)
            }
        }
    }
}
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
                    subtitle: NSLocalizedString("Pick only the tutorial you need", comment: ""),
                    showBack: true,
                    showGear: false,
                    bgColors: rowColors,
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

## MainView.swift

```swift
import SwiftUI
import UIKit

// ================================================================
// abrirShortcutDesdeLink (con control de suscripción)
// ================================================================
@MainActor
func abrirShortcutDesdeLink(_ urlString: String, storeManager: StoreManager, freeLinks: [String] = ["https://www.icloud.com/shortcuts/ad8ac70847464936990ee2667e68df91"]) {
    #if DEBUG
    //UserDefaults.standard.set(true, forKey: "isSubscribed")
    storeManager.isSubscribed = true
    print("🔓 Debug Mode: Forzado isSubscribed = true")
    #endif

    // Ahora: siempre leer el estado actual del StoreManager (fuente única de verdad)
    let isSubscribed = storeManager.isSubscribed

    // Usar la lista pasada como argumento en lugar de una lista local fija
    let shortcutLinkFree = freeLinks

    // 🔒 Si NO está suscrito y es premium, bloqueamos pero NO cambiamos UI global
    if !isSubscribed && !shortcutLinkFree.contains(urlString) {
        print("⚠️ Premium shortcut bloqueado: \(urlString)")
        UserDefaults.standard.set(
            NSLocalizedString("Requires Annual Subscription", comment: "Message when trying premium content"),
            forKey: "lastMessage"
        )
        return
    }

    // ✅ Limpiar mensaje previo si es free
    if shortcutLinkFree.contains(urlString) {
        UserDefaults.standard.set("", forKey: "lastMessage")
    }

    // Validar URL y abrir
    guard let url = URL(string: urlString) else { return }
    Task { @MainActor in
        UIApplication.shared.open(url)
    }
}







// ================================================================
// MainView
// ================================================================
struct MainView: View {
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    
    @EnvironmentObject var navigationState: NavigationState
    
    @Binding var activeIndex: Int
    @State private var imported: [Bool] = Array(repeating: false, count: 5)
    @State private var showWelcome: Bool = false
    
    @EnvironmentObject var storeManager: StoreManager
    
    private let rowTitles = [
        NSLocalizedString("PICK THE PLAYLIST YOU WANT TO WAKE UP TO", comment: "Section title for integrated playlists"),
        NSLocalizedString("ROW_TWO_TEXT", comment: "Section title for free songs"),
        NSLocalizedString("SINGLES SONGS - CANCIONES SUELTAS", comment: "Section title for single songs")
    ]
    
    private let rowDescriptions = [
        NSLocalizedString("Many playlists to choose from — all played in shuffle", comment: "Description for integrated playlists section"),
        NSLocalizedString("Wake up with your liked songs on Spotify", comment: "Description for liked songs section"),
        NSLocalizedString("Single Songs suggested by the community", comment: "Description for single songs section")
    ]
    
    private let IntegratedPlaylistsImages = [
        "sweet",
        "rock",
        "wakeup",
        "yourlikes",
        "piano",
        "allout2010s",
        "magnetismo",
        "hbo",
        "heaven",
        "hymns"
    ]
    
    private let IntegratedPlaylistsName: [String] = [
        "Sweet Nothing Beat",
        "Rock N Roll Wake Up",
        "Wake up Happy",
        "My liked songs - Mis me gusta",
        "Gentle Piano",
        "All out 2010s",
        "Magnetismo",
        "HBO theme songs",
        "The other side of heaven",
        "Hymns on violin and piano"
    ]
    
    private let IntegratedPlaylistsDescription = [
        NSLocalizedString("DESC_Sweet Nothing Beat", comment: "Playlist description"),
        NSLocalizedString("DESC_Rock N Roll Wake Up", comment: "Playlist description"),
        NSLocalizedString("DESC_Wake up Happy", comment: "Playlist description"),
        NSLocalizedString("DESC_My liked songs", comment: "Playlist description"),
        NSLocalizedString("DESC_Gentle Piano", comment: "Playlist description"),
        NSLocalizedString("DESC_All out 2010s", comment: "Playlist description"),
        NSLocalizedString("DESC_Magnetismo", comment: "Playlist description"),
        NSLocalizedString("DESC_HBO theme songs", comment: "Playlist description"),
        NSLocalizedString("DESC_The other side of heaven", comment: "Playlist description"),
        NSLocalizedString("DESC_Hymns on violin and piano", comment: "Playlist description")
    ]
    
    private let shortcutLinkFree = ["https://www.icloud.com/shortcuts/ad8ac70847464936990ee2667e68df91"]
    
    private let shortcutLinks = [
        "https://www.icloud.com/shortcuts/4103035b1b3242ba8e4d1518833e0200",
        "https://www.icloud.com/shortcuts/99570e6ea3ad4614976cbf6f286eb51d",
        "https://www.icloud.com/shortcuts/7d7263dd5ca64980bb269990e8887abc",
        "https://www.icloud.com/shortcuts/ccb8562e1e8548b283d84cac64887272",
        "https://www.icloud.com/shortcuts/54e18e2f5e2a4c878787632cb707cce2",
        "https://www.icloud.com/shortcuts/0b7b9addea004a8498b074ee52cec428",
        "https://www.icloud.com/shortcuts/f2013e04be7b42de820e6cd7209a9317",
        "https://www.icloud.com/shortcuts/e799f3a9b3b743528337516360d5265d",
        "https://www.icloud.com/shortcuts/d85d19af689e42298529971e53ae66fb",
        "https://www.icloud.com/shortcuts/23c60a0a0ac04807a476410c3cf9dbb2"
    ]
    
    
    private let SingleSongsImagesEN = [
        "marianastrench",
        "gymnopedie",
        "goodmorning"
    ]
    
    private let SingleSongsImagesES = [
        "megustas",
        "otrapiel",
        "noaguanto",
        "comoeres"
    ]
    
    private let shortcutSINGLELinksEN = [
        "https://www.icloud.com/shortcuts/be85c58cc84144aba70b3b368e55cb38",
        "https://www.icloud.com/shortcuts/2bfd296a19cd436ba2ab6f31066388b5",
        "https://www.icloud.com/shortcuts/921547a4839f4e5db46b569581233e37"
    ]
    
    private let TextoMenuINGLES = [
        NSLocalizedString("In Mariana's Trench – ABR", comment: "Song title"),
        NSLocalizedString("Gymnopédie No 1 – E. Satie", comment: "Song title"),
        NSLocalizedString("Good Morning – Kanye West", comment: "Song title"),
    ]
    
    private let shortcutSINGLELinksES = [
        "https://www.icloud.com/shortcuts/60bc106862224654b864c75ece254a0a",
        "https://www.icloud.com/shortcuts/9a356e3141e44c8f95416f053110d2a8",
        "https://www.icloud.com/shortcuts/4ba8e0a96d51475d8afd348ca92e7303",
        "https://www.icloud.com/shortcuts/3452c786889e4409a4d0405b0b4d9aed"
    ]
    
    private let TextoMenuESPANOL = [
        NSLocalizedString("Me Gustas Tanto - Miranda", comment: "Song title"),
        NSLocalizedString("Otra Piel - Gustavo Cerati", comment: "Song title"),
        NSLocalizedString("No aguanto - Conociendo Rusia", comment: "Song title"),
        NSLocalizedString("Asi como Eres - Germán Barceló", comment: "Song title")
    ]
    
    init(
        activeTab: Binding<Int>,
        isDarkMode: Binding<Bool>,
        activeIndex: Binding<Int>
    ) {
        self._activeTab = activeTab
        self._isDarkMode = isDarkMode
        self._activeIndex = activeIndex
        // NO reciba storeManager aquí
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            let W = geometry.size.width
            let H = geometry.size.height
            
            ZStack(alignment: .top) {
                bgColors[0].ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HeaderView(
                        W: W,
                        H: H,
                        isDarkMode: $isDarkMode,
                        title: NSLocalizedString("SpotiActions", comment: "App title"),
                        subtitle: storeManager.isSubscribed ? "Premium Version" : "Free Version",
                        showBack: false,
                        showGear: true,
                        bgColors: [Color("Color1")]
                    )
                    .frame(height: H * 0.23)
                    
                    // --- FRANJA 1 ---
                    HorizontalPlaylistsRowView(
                        H: H,
                        playlists: IntegratedPlaylistsImages.indices.map { i in
                            PlaylistItem(
                                image: IntegratedPlaylistsImages[i],
                                title: IntegratedPlaylistsName[i],
                                description: IntegratedPlaylistsDescription[i],
                                link: shortcutLinks[i]
                            )
                        },
                        title: rowTitles[0],
                        isActive: true,
                        backgroundColor: Color("Color2"),
                        sectionIndex:1
                    )
                    .environmentObject(storeManager)
                    
                    // --- FRANJA 2 ---
                    VStack(spacing: 0) {
                        let isActive = (activeIndex == 1)
                        
                        HStack {
                            Text(rowTitles[1])
                                .font(.custom("AllerDisplay", size: 18))
                                .foregroundColor(isActive ? Color("ColorNaranja") : Color("SubtitleColor"))
                                .shadow(color: Color("Color1").opacity(0.6), radius: 3, x: 1, y: 1)
                            Spacer()
                        }
                        .padding(.leading, 12)
                        .padding(.vertical, 6)
                        .background(Color("Color3"))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                activeIndex = isActive ? -1 : 1
                            }
                        }
                        
                        if isActive {
                            HStack(alignment: .top, spacing: 12) {
                                Button(action: {
                                    abrirShortcutDesdeLink(shortcutLinkFree[0], storeManager: storeManager, freeLinks: shortcutLinkFree)
                                        imported[1] = true
                                }) {
                                    Image("freeplaylist")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(rowDescriptions[1])
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                        .shadow(color: .gray.opacity(0.6), radius: 2, x: 1, y: 1)
                                        .padding(.top,10)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .background(Color("Color3"))
                    
                    // --- FRANJA 3 ---
                    VStack(spacing: 0) {
                        let isActive = (activeIndex == 2)
                        
                        HStack {
                            Text(rowTitles[2])
                                .font(.custom("AllerDisplay", size: 19))
                                .foregroundColor(isActive ? Color("ColorNaranja") : Color("SubtitleColor"))
                            Spacer()
                        }
                        .padding(.leading, 12)
                        .padding(.vertical, 2)
                        .background(isActive ? Color("Color3") : Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                activeIndex = isActive ? -1 : 2
                            }
                        }
                        
                        if isActive {
                            let englishPlaylists = zip(zip(SingleSongsImagesEN, TextoMenuINGLES), shortcutSINGLELinksEN).map { imageTitle, link in
                                PlaylistItem(image: imageTitle.0, title: imageTitle.1, link: link)
                            }
                            
                            let spanishPlaylists = zip(zip(SingleSongsImagesES, TextoMenuESPANOL), shortcutSINGLELinksES).map { imageTitle, link in
                                PlaylistItem(image: imageTitle.0, title: imageTitle.1, link: link)
                            }
                            
                            HorizontalPlaylistsRowView(
                                H: H,
                                playlists: englishPlaylists + spanishPlaylists,
                                title: "",
                                isActive: true,
                                backgroundColor: Color("Color6"),
                                sectionIndex:3
                            )
                            .environmentObject(storeManager)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color("Color6"))
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(edges: .bottom)
            .fullScreenCover(isPresented: $showWelcome) {
                Button(NSLocalizedString("Show Onboarding Again", comment: "Button to repeat onboarding")) {
                    UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
                }
                .environmentObject(navigationState)
            }
        }
    }
}



// ================================================================
// MARK: - PlaylistItem y HorizontalPlaylistsRowView
// ================================================================
struct PlaylistItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String?
    let link: String
    
    init(image: String, title: String, description: String? = nil, link: String) {
        self.image = image
        self.title = title
        self.description = description
        self.link = link
    }
}



struct HorizontalPlaylistsRowView: View {
    let H: CGFloat
    let playlists: [PlaylistItem]
    let title: String
    let isActive: Bool
    let backgroundColor: Color
    var sectionIndex: Int   // 👈 nuevo
    @EnvironmentObject var storeManager: StoreManager

    init(
        H: CGFloat,
        playlists: [PlaylistItem],
        title: String,
        isActive: Bool = false,
        backgroundColor: Color = Color("Color4"),
        sectionIndex: Int = 0
    ) {
        self.H = H
        self.playlists = playlists
        self.title = title
        self.isActive = isActive
        self.backgroundColor = backgroundColor
        self.sectionIndex = sectionIndex   // ✅ ahora sí se pasa correctamente
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.custom("AllerDisplay", size: 19))
                    .foregroundColor(isActive ? Color("ColorNaranja") : Color("Color8"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .cornerRadius(8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                if isActive {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(playlists) { playlist in
                            PlaylistCardView(playlist: playlist,sectionIndex: sectionIndex)
                                .environmentObject(storeManager) // inyectar automáticamente
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .background(backgroundColor)
        }
        .padding(.vertical, 4)
        .background(backgroundColor)
    }
}


struct PlaylistCardView: View {
    let playlist: PlaylistItem
    var sectionIndex: Int
    @EnvironmentObject var storeManager: StoreManager

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                abrirShortcutDesdeLink(playlist.link, storeManager: storeManager)
            }) {
                Image(playlist.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Text(playlist.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(
                    sectionIndex == 1
                        ? Color("ColorNaranja")
                        : (sectionIndex == 3 ? Color("Color8") : Color("SubtitleColor"))
                )

                .lineLimit(sectionIndex == 1 ? 1 : (sectionIndex == 3 ? 2 : nil))


            if let description = playlist.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(Color("SubtitleColor"))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, -3)

            }
        }
        .frame(width: 140, alignment: .topLeading)
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
import SwiftUI
import StoreKit

struct OnboardingView: View {
    var onFinished: (() -> Void)? = nil
    var startAtPage: Int = 0
    @State private var currentPage = 0
    
    @EnvironmentObject var store: StoreManager
    @State private var isSubscribed = false
    @State private var restoreMessage: String? = nil

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
            if store.isLoading {
                ProgressView("Checking subscription...")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
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
                            (NSLocalizedString("Sure, you can make one that just opens Spotify — but it won’t run by itself and you’d have to confirm every single time", comment: ""), nil),
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

                    // --- PÁGINA 5 SOLO SI NO ESTÁ SUSCRITO ---
                    if !isSubscribed {
                        OnboardingPageView(
                            systemName: "infinity.circle.fill",
                            gradient: [Color.purple, Color.orange],
                            title: NSLocalizedString("Unlock Lifetime Premium", comment: ""),
                            description: NSLocalizedString("lifetime_description", comment: "Lifetime Premium description shown in onboarding"),
                            lines: [
                                (NSLocalizedString("Lifetime access to all playlists and features", comment: ""), nil),
                                (NSLocalizedString("No subscriptions, no renewals — one payment forever", comment: ""), nil),
                                (NSLocalizedString("Use URL schemes like spotiactions://", comment: ""), nil)
                            ]
                        )
                        .tag(4)
                        .overlay(premiumOverlay)
                    }

                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }

            Spacer()

            continueButton

            if currentPage == 4 && !isSubscribed {
                restoreButton
            }
        }
        .onAppear {
            currentPage = startAtPage
            Task {
                store.isLoading = true
                isSubscribed = await store.checkActiveSubscription()
                store.isLoading = false
                if isSubscribed {
                    onFinished?()
                }
            }
        }
    }

    // --- CONTINUE BUTTON ---
    private var continueButton: some View {
        Button(action: {
            if currentPage < 4 {
                withAnimation { currentPage += 1 }
            } else {
                onFinished?()
            }
        }) {
            Text(currentPage < 4 ? NSLocalizedString("continue", comment: "") : NSLocalizedString("continue_free", comment: ""))
                .font(.system(.headline, design: .default).weight(.bold))
                .foregroundColor(currentPage < 4 ? .white : .blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    currentPage < 4 ?
                        LinearGradient(
                            gradient: Gradient(colors: pageGradients[currentPage]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) : nil
                )
                .cornerRadius(14)
                .shadow(color: currentPage < 4 ? pageGradients[currentPage].last!.opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 30)
    }

    // --- PREMIUM OVERLAY ---
   private var premiumOverlay: some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                if !isSubscribed { // 1. Solo mostrar si no hay suscripción
                    if let lifetimeProduct = store.products.first(where: { $0.id == store.lifetimeProductID }) {
                        VStack(spacing: 6) {
                            Text(NSLocalizedString("Se te pedirá tu Apple ID para completar la compra.", comment: ""))
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)

                            Button(action: {
                                Task {
                                    store.isLoading = true
                                    do {
                                        try await store.purchase(lifetimeProduct)
                                        isSubscribed = true
                                        onFinished?()
                                    } catch {
                                        restoreMessage = NSLocalizedString("Purchase failed. Please try again later.", comment: "")
                                        print("❌ Lifetime purchase failed: \(error)")
                                    }
                                    store.isLoading = false
                                }
                            }) {
                                HStack {
                                    if store.isLoading {
                                        ProgressView()
                                    } else {
                                        Text(String(format: NSLocalizedString("Unlock Lifetime Premium – %@", comment: ""), lifetimeProduct.displayPrice))
                                            .font(.system(.headline, design: .default).weight(.bold))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(color: Color.purple.opacity(0.4), radius: 6, x: 0, y: 3)
                            }
                            .disabled(store.isLoading)
                        }
                        .padding(.horizontal, 24)
                    } else {
                        Text(NSLocalizedString("Lifetime product not available", comment: ""))
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }


    // --- RESTORE BUTTON ---
    private var restoreButton: some View {
        VStack(spacing: 8) {
            Button(action: {
                Task {
                    do {
                        var foundPurchase = false
                        for await result in Transaction.currentEntitlements {
                            if case .verified(let transaction) = result {
                                isSubscribed = true
                                foundPurchase = true
                                restoreMessage = NSLocalizedString("Your purchases have been successfully restored.", comment: "")
                                print("✅ Purchases restored successfully: \(transaction.productID)")
                                onFinished?()
                                break
                            }
                        }
                        if !foundPurchase {
                            restoreMessage = NSLocalizedString("No active purchases were found to restore.", comment: "")
                            print("ℹ️ No active purchases found.")
                        }
                    } catch {
                        restoreMessage = NSLocalizedString("Failed to restore purchases. Please try again later.", comment: "")
                        print("❌ Failed to restore purchases: \(error)")
                    }
                }
            }) {
                Text(NSLocalizedString("Restore Purchases", comment: ""))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
            }
            .alert(isPresented: Binding<Bool>(
                get: { restoreMessage != nil },
                set: { if !$0 { restoreMessage = nil } }
            )) {
                Alert(
                    title: Text(NSLocalizedString("Restore Purchases", comment: "")),
                    message: Text(restoreMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        restoreMessage = nil
                    }
                )
            }
        }
        .padding(.top, 8)
    }
}

// --- OnboardingPageView ---
struct OnboardingPageView: View {
    let systemName: String
    let gradient: [Color]
    let title: String
    let description: String
    let lines: [(text: String, url: URL?)]?

    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .shadow(color: gradient.last!.opacity(0.6), radius: 25, x: 0, y: 0)

                Image(systemName: systemName)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }

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
                .padding(.bottom, 10)

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

// --- Función global para cualquier color ---
extension Color {
    static let SubtitleColor = Color.gray // Ajusta si tenés un color específico en Assets
}

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

    @State private var activeTab: Int = 0
    @State private var showHowToSetup: Bool = false
    @State private var barraHeight: CGFloat = 0
    @State private var didCheckOnboarding: Bool = false
    @State private var activeIndex = 1
    @EnvironmentObject var storeManager: StoreManager

    var body: some View {
        ZStack(alignment: .bottom) {
            // CONTENIDO PRINCIPAL: solo se muestra el view según navigationState
            switch navigationState.currentView {
            case .welcome:
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    navigationState.currentView = .main
                }
                // Si está en welcome, NO mostramos la barra inferior.

            case .main:
                // En .main mostramos MainView y la BarraInferior (pegada al bottom por el ZStack)
                MainView(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    activeIndex: $activeIndex
                )
                .environmentObject(storeManager) // <- esto es lo que falta
            case .subscription:
                SubscriptionView()
            }

            // BarraInferior solo debe estar visible en .main
            if navigationState.currentView == .main {
                BarraInferior(
                    activeTab: $activeTab,
                    isDarkMode: $isDarkMode,
                    onShowOnboarding: {
                        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
                        navigationState.currentView = .welcome
                    },
                    onShowSetup: {
                        showHowToSetup = true
                    },
                    onHeightChange: { newHeight in
                        barraHeight = newHeight
                    }
                )
                // la BarraInferior está dentro del ZStack alineada al bottom
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Presenta HowtoSETUP en pantalla completa (controlado por RootView)
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
            let hasSeen = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            navigationState.currentView = hasSeen ? .main : .welcome

            #if DEBUG
            //UserDefaults.standard.set(true, forKey: "isSubscribed")
            storeManager.isSubscribed = true
            print("🔓 Debug Mode: Forzado isSubscribed = true")
            #endif
        }
    }

    // MARK: - Deep Link handler
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "spotiactions" else { return }

        switch url.host {
        case "tab":
            if let tab = Int(url.lastPathComponent) {
                self.activeTab = tab
            }

        case "subscribe":
            if url.pathComponents.contains("lifetime") {
                // Abrir pantalla de suscripción Lifetime
                navigationState.currentView = .subscription
            }

        default:
            break
        }
    }


    // MARK: - UserDefaults cleanup y migración
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
            // Si querés resetear el onboarding solo cuando hay cambios grandes:
            // defaults.set(false, forKey: "hasSeenOnboarding")
        }

    }
}
```

---

## SpotiActionsApp.swift

```swift
import SwiftUI
import Foundation

@main
struct SpotiActionsApp: App {
    @StateObject private var navigationState = NavigationState(initialView: .welcome)
    @StateObject private var storeManager: StoreManager

    @State private var isDarkMode: Bool = true

    init() {
        // ✅ Limpiar mensajes previos
        UserDefaults.standard.set("", forKey: "lastMessage")

        #if DEBUG
        //UserDefaults.standard.set(true, forKey: "isSubscribed")
        //UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        print("🔧 Debug init: no persisto banderas en UserDefaults")
        #endif

        // Guardar versión actual
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        UserDefaults.standard.set(currentVersion, forKey: "lastSeenVersion")

        // Inicializar StoreManager
        _storeManager = StateObject(wrappedValue: StoreManager())
    }

    var body: some Scene {
        WindowGroup {
            RootView(isDarkMode: $isDarkMode)
                .environmentObject(navigationState)
                .environmentObject(storeManager)
                // Deep Link handler
                .onOpenURL { url in
                    navigationState.handleDeepLink(url)
                }
                .onAppear {
                    let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

                    #if DEBUG
                    // Evita freeze al inicio del modo Debug
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        navigationState.currentView = hasSeenOnboarding ? .main : .welcome
                    }
                    #else
                    navigationState.currentView = hasSeenOnboarding ? .main : .welcome
                    #endif
                }
        }
    }
}

```

---

## StoreManager.swift

```swift
import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var isSubscribed: Bool = UserDefaults.standard.bool(forKey: "isSubscribed")

    let annualProductID = "com.spotiactions.premium.anual"
    let lifetimeProductID = "com.spotiactions.premium.lifetime"
    let lastPaidVersion = "1.8" // Última versión que fue de pago único

    // 🟢 Mantener la escucha activa de transacciones
    private var updatesTask: Task<Void, Never>? = nil

    init() {
        Task {
            await fetchProducts()
            await updateSubscriptionStatus()
            await checkLegacyPurchaseLocally()
        }

        // Iniciar escucha de actualizaciones de transacciones
        updatesTask = Task {
            await listenForTransactionUpdates()
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    // MARK: - Fetch Products
    private func fetchProducts() async {
        await MainActor.run { self.isLoading = true }
        do {
            let storeProducts = try await Product.products(for: [annualProductID, lifetimeProductID])
            await MainActor.run {
                self.products = storeProducts
                self.isLoading = false
            }
        } catch {
            print("\(NSLocalizedString("fetch_products_failed", comment: "")) \(error)")
            await MainActor.run {
                self.products = []
                self.isLoading = false
            }
        }
    }

    // MARK: - Escucha continua de transacciones
    private func listenForTransactionUpdates() async {
        for await verificationResult in Transaction.updates {
            switch verificationResult {
            case .verified(let transaction):
                await handle(transaction)
            case .unverified(_, let error):
                print("⚠️ Unverified transaction update: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Manejo de transacción
    private func handle(_ transaction: Transaction) async {
        if transaction.productID == annualProductID || transaction.productID == lifetimeProductID {
            isSubscribed = true
            UserDefaults.standard.set(true, forKey: "isSubscribed")
            if transaction.productID == lifetimeProductID {
                UserDefaults.standard.set(true, forKey: "isLifetimeUser")
                print("✅ Lifetime purchase verified (update)")
            } else {
                UserDefaults.standard.set(false, forKey: "isLifetimeUser")
                print("✅ Annual subscription verified (update)")
            }
        }
        await transaction.finish()
    }

    // MARK: - Purchase Product
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await handle(transaction)
                print(NSLocalizedString("purchase_verified", comment: ""))

            case .unverified(_, let error):
                throw error
            }

        case .userCancelled:
            throw NSError(
                domain: "Store",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("user_cancelled", comment: "")]
            )

        case .pending:
            print(NSLocalizedString("purchase_pending", comment: ""))

        @unknown default:
            print(NSLocalizedString("purchase_failed", comment: ""))
        }
    }

    // MARK: - Subscription Check
    func checkActiveSubscription() async -> Bool {
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                if transaction.productID == annualProductID {
                    if let expiry = transaction.expirationDate {
                        if expiry > Date() { return true }
                    } else {
                        return true
                    }
                } else if transaction.productID == lifetimeProductID {
                    return true
                }
            case .unverified(_, _):
                continue
            }
        }
        return false
    }

    // MARK: - Update Subscription Status
    func updateSubscriptionStatus() async {
        var subscribed = false
        var lifetime = false

        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                if transaction.productID == annualProductID {
                    if let expiry = transaction.expirationDate {
                        if expiry > Date() { subscribed = true }
                    } else {
                        subscribed = true
                    }
                } else if transaction.productID == lifetimeProductID {
                    lifetime = true
                    subscribed = true
                }
            case .unverified(_, _):
                continue
            }
        }

        self.isSubscribed = subscribed
        UserDefaults.standard.set(subscribed, forKey: "isSubscribed")
        UserDefaults.standard.set(lifetime, forKey: "isLifetimeUser")
    }

    // MARK: - Legacy Purchase (before subscriptions)
    func checkLegacyPurchaseLocally() async {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
        guard FileManager.default.fileExists(atPath: receiptURL.path),
              let receiptData = try? Data(contentsOf: receiptURL) else { return }

        do {
            let responseJSON = try await postVerifyReceipt(
                to: URL(string: "https://buy.itunes.apple.com/verifyReceipt")!,
                receiptData: receiptData
            )

            if let receipt = responseJSON["receipt"] as? [String: Any],
               let originalVersion = receipt["original_application_version"] as? String {

                if compareVersions(originalVersion, lastPaidVersion) <= 0 {
                    self.isSubscribed = true
                    UserDefaults.standard.set(true, forKey: "isLifetimeUser")
                    UserDefaults.standard.set(true, forKey: "isSubscribed")
                    print("Legacy user detected → granted lifetime")
                } else {
                    self.isSubscribed = false
                    UserDefaults.standard.set(false, forKey: "isLifetimeUser")
                }
            }
        } catch {
            print("checkLegacyPurchaseLocally failed: \(error)")
        }
    }

    // MARK: - Version Comparison
    private func compareVersions(_ v1: String, _ v2: String) -> Int {
        let comps1 = v1.split(separator: ".").compactMap { Int($0) }
        let comps2 = v2.split(separator: ".").compactMap { Int($0) }
        let maxLen = max(comps1.count, comps2.count)
        for i in 0..<maxLen {
            let a = i < comps1.count ? comps1[i] : 0
            let b = i < comps2.count ? comps2[i] : 0
            if a < b { return -1 }
            if a > b { return 1 }
        }
        return 0
    }

    // MARK: - Verify Receipt
    private func postVerifyReceipt(to url: URL, receiptData: Data) async throws -> [String: Any] {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let base64 = receiptData.base64EncodedString()
        let body: [String: Any] = [
            "receipt-data": base64,
            "exclude-old-transactions": true
        ]

        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: req)

        if let httpResp = response as? HTTPURLResponse, !(200...299).contains(httpResp.statusCode) {
            let bodyText = String(data: data, encoding: .utf8) ?? "<no-body>"
            throw NSError(
                domain: "StoreManager",
                code: httpResp.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Apple verifyReceipt returned HTTP \(httpResp.statusCode): \(bodyText)"]
            )
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            let bodyText = String(data: data, encoding: .utf8) ?? "<no-body>"
            throw NSError(
                domain: "StoreManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid JSON from Apple: \(bodyText)"]
            )
        }

        return json
    }
}
```

---

## SubscriptionView.swift

```swift
import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var store = StoreManager()
    private let annualID = "com.spotiactions.premium.anual"
    private let lifetimeID = "com.spotiactions.premium.lifetime"

    var body: some View {
        VStack(spacing: 20) {
            if store.isLoading {
                ProgressView(NSLocalizedString("loading_price", comment: ""))
            } else {
                // Intentamos obtener ambos productos
                let annualProduct = store.products.first { $0.id == annualID }
                let lifetimeProduct = store.products.first { $0.id == lifetimeID }

                if let annual = annualProduct {
                    Button(action: {
                        Task {
                            do {
                                try await store.purchase(annual)
                            } catch {
                                print("\(NSLocalizedString("purchase_failed", comment: "")) \(error)")
                            }
                        }
                    }) {
                        Text(String(format: NSLocalizedString("continue_with_price", comment: ""), annual.displayPrice))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }

                if let lifetime = lifetimeProduct {
                    Button(action: {
                        Task {
                            do {
                                try await store.purchase(lifetime)
                            } catch {
                                print("\(NSLocalizedString("purchase_failed", comment: "")) \(error)")
                            }
                        }
                    }) {
                        Text(String(format: NSLocalizedString("lifetime_access_price", comment: ""), lifetime.displayPrice))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }

                if annualProduct == nil && lifetimeProduct == nil {
                    Text(NSLocalizedString("product_not_available", comment: ""))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}
```

---

## Theme.swift

```swift
import SwiftUI

let bgColors: [Color] = [
    Color("Color1"),
    Color("Color2"),
    Color("Color3"),
    Color("Color5"),
    Color("Color6"),
    Color("Color7"),
    Color("Color8"),
    Color("Color8"),
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


Todos los archivos SWIFT del proyecto son los siguientes:

- BarraInferior.swift
- HeaderView.swift
- howtoSETUP.swift
- MainView.swift
- NavigationState.swift
- OnboardingView.swift
- RootView.swift
- SpotiActionsApp.swift
- StoreManager.swift
- SubscriptionView.swift
- Theme.swift

Si durante el transcurso del chat necesitas el código de alguno de ellos, recurre a esta información tanto al nombre como al contenido. Recordar que el nombre de los iconos de la barra inferior son house.fill, rectangle.stack y wrench.and.screwdriver
