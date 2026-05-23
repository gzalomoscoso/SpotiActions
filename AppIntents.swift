import AppIntents
import Foundation

struct GetSessionMetadata: AppIntent {
    static var title: LocalizedStringResource = "SpotiActionsPLAY"
    
    static var description = IntentDescription("Carga metadatos técnicos de la sesión actual para validación en Shortcuts.")
    
    static var isDiscoverable: Bool = true
    
    func perform() async throws -> some ReturnsValue<Double> {
        let suiteName = "group.com.gzalomoscoso.spotiactions"
        
        // Se fuerza el desempaquetado seguro o fallback inmediato para evitar fallos de resolución en el proxy de cfprefsd
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            return .result(value: 0.0)
        }
        
        let version = defaults.string(forKey: "current_app_version") ?? "0.0"
        let versionNumber = Double(version) ?? 0.0
        
        return .result(value: versionNumber)
    }
    
    // --- Lógica de Codificación Sencilla (Base64) ---
    // Convierte "2.8" en algo como "Mi44"
    // Nota: Mantenido fuera de perform() si se requiere reactivar a futuro.
    // let encodedVersion = versionData.base64EncodedString()
}
