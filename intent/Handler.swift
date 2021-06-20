import Intents

final class Handler: INExtension, FastIntentHandling {
    func resolveSites(for intent: FastIntent, with: @escaping (SitesResolutionResult) -> Void) {
        with(.success(with: intent.sites))
    }
}
