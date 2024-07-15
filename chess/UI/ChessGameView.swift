//
//  ChessGameView.swift
//  Chess
//
//  Created by Yeliena Khaletska on 08.07.2024.
//

import SwiftUI

struct ChessGameView: View {

    @ObservedObject var chessViewModel: ChessGameViewModel

    var body: some View {
        ChessBoardView(chessViewModel: self.chessViewModel)
            .padding()
            .onAppear {
                self.chessViewModel.gameAppeared()
            }
            .errorAlert(error: self.$chessViewModel.error)
    }

}

#Preview {
    ChessGameView(chessViewModel: ChessGameViewModel())
}

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
