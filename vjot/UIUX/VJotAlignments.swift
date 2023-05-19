//
//  VJotAlignments.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 15/4/23.
//

import Foundation
import SwiftUI

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: BREEDS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotBreedH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.leading]
        }
    }
    static let vjotBreedH: HorizontalAlignment = HorizontalAlignment(VJotBreedH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: ANALYSES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotAnalysisH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    
    struct VJotBoxH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }
    
    struct VJotParentH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }
    
    static let vjotAnalysisH: HorizontalAlignment = HorizontalAlignment(VJotAnalysisH.self)
    static let vjotBoxH: HorizontalAlignment = HorizontalAlignment(VJotBoxH.self)
    static let vjotParentH: HorizontalAlignment = HorizontalAlignment(VJotParentH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: IMAGES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotImageH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotImageH: HorizontalAlignment = HorizontalAlignment(VJotImageH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: UPLOADS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotUploadH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotUploadH: HorizontalAlignment = HorizontalAlignment(VJotUploadH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: FAVS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotFavH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotFavH: HorizontalAlignment = HorizontalAlignment(VJotFavH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: VOTES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotVoteH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotVoteH: HorizontalAlignment = HorizontalAlignment(VJotVoteH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: DELETES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotDeleteH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotDeleteH: HorizontalAlignment = HorizontalAlignment(VJotDeleteH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: SOURCES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotSourcesH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }
    static let vjotSourcesH: HorizontalAlignment = HorizontalAlignment(VJotSourcesH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: VERSION
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotVersionH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }
    static let vjotVersionH: HorizontalAlignment = HorizontalAlignment(VJotVersionH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: VETERINARIANS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotJotH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotJotdH: HorizontalAlignment = HorizontalAlignment(VJotJotH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: VETERINARIANS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotVetH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let vjotVetdH: HorizontalAlignment = HorizontalAlignment(VJotVetH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: INCIDENTS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotIncH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.trailing]
        }
    }
    static let vjotIncH: HorizontalAlignment = HorizontalAlignment(VJotIncH.self)
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: ABOUT
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

extension HorizontalAlignment {
    
    struct VJotAboutH: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.trailing]
        }
    }
    static let vjotAboutH: HorizontalAlignment = HorizontalAlignment(VJotAboutH.self)
}


