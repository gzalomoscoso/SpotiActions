
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
        NSLocalizedString("How to create an automation and use it as an alarm", comment: ""),
        NSLocalizedString("Hear ‘Welcome Back, Sir’ when you get in your car ( only with carplay )", comment: ""),
        NSLocalizedString("Play Music Automatically when you get home", comment: ""),
        NSLocalizedString("Start your song as you cross the finish line of your training", comment: ""),
        NSLocalizedString("Play Music Automatically when you get home", comment: "")
    ]

    private let sectionDescriptions: [String] = [
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
          true, true, false, false, false
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

    // Definimos los colores aquí para usarlos en el body
        let topColor = Color(red: 242/255, green: 241/255, blue: 247/255)
        let bottomColor = Color(red: 233/255, green: 232/255, blue: 238/255)
    
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
                // Añadimos una barra superior para poder volver
                    HStack {
                        Button(action: { onBack() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text(NSLocalizedString("Back", comment: ""))
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("ColorNaranja"))
                        }
                        Spacer()
                    }
                    .padding()
                                    // IMPORTANTE: Cambiamos Color("Color1") por .clear para ver el gradiente
                                    .background(Color.clear)
                
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
                                // IMPORTANTE: Quitar el .background de ScrollSectionView (ver nota abajo)

                                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        // IMPORTANTE: Cambiamos Color("Color1") por .clear
                        .background(Color.clear)
                        .ignoresSafeArea(edges: .bottom)
                        .offset(y: shouldShiftUp ? -H * 0.1 : 0)
        }
        
        // 1. COLOCAR AQUÍ EL BACKGROUND (Al final del ZStack)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [topColor, bottomColor]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
        
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
        ("tuto01", NSLocalizedString("Paso1", comment: "")),
        ("tuto02", NSLocalizedString("Paso2", comment: "")),
        ("tuto03", NSLocalizedString("Paso3", comment: "")),
        ("tuto04", NSLocalizedString("Paso4", comment: "")),
        ("tutoALL", NSLocalizedString("Paso5", comment: ""))
    ]
    case 1: return [
        ("tuto13", NSLocalizedString("Follow steps 1, 2, and 3 from the previous tutorial, but instead of selecting “Time of Day”, choose “CarPlay”. This shortcut is in the Settings menu ", comment: "")),
        ("tuto14", NSLocalizedString("To play “Welcome Back Sir” when CarPlay connects, choose these options and then tap the blue checkmark.", comment: "")),
        ("tuto15", NSLocalizedString("Always make sure all your automations are set to “Run Immediately”", comment: ""))
        
    ]
    case 2: return [
        ("tuto05", NSLocalizedString("This is the longest tutorial, so please be patient. First, tap “Automation” in the bottom bar", comment: "")),
        ("tuto06", NSLocalizedString("Tap the “+” button to create a new automation", comment: "")),
        ("tuto07", NSLocalizedString("Select [Time of Day]. Let's set an alarm for 6:00 AM, Monday to Friday", comment: "")),
        ("tuto08", NSLocalizedString("Choose the values as shown on the screen, and make sure “Run Immediately” is checked. Then tap Done", comment: "")),
        ("tuto09", NSLocalizedString("Tap [Create New Shortcut]", comment: "")),
        ("tuto10", NSLocalizedString("Include at least the volume, and...", comment: "")),
        ("tuto11", NSLocalizedString("and make sure to select the shortcut so it looks like this. Then tap the blue checkmark", comment: "")),
        ("tuto12", NSLocalizedString("That's it! Your automation is ready and can be seen in your Automations list. It will play every day; in this case, the playlist will play shuffled, so a different song will play each day", comment: ""))
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
