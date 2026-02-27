//
//  InlineMovieView.swift
//  YouTooOld Watch App
//

import SwiftUI
import WatchKit

struct InlineMovieView: WKInterfaceObjectRepresentable {
    let url: URL

    func makeWKInterfaceObject(context: Context) -> WKInterfaceInlineMovie {
        WKInterfaceInlineMovie()
    }

    func updateWKInterfaceObject(_ movie: WKInterfaceInlineMovie, context: Context) {
        movie.setMovieURL(url)
        movie.setLoops(false)
        movie.setVideoGravity(.resizeAspect)
        movie.playFromBeginning()
    }
}
