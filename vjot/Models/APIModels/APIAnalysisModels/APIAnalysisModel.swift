//
//  APIAnalysisModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD ANALYSIS

struct APIAnalysisLabelInstanceBoundingBox {
    var width: Double
    var height: Double
    var left: Double
    var top: Double
}

struct APIAnalysisLabelInstance {
    var boundingBox: APIAnalysisLabelInstanceBoundingBox
    var confidence: Double
}

struct APIAnalysisLabelParent {
    var name: String
}

struct APIAnalysisLabel {
    var name: String
    var confidence: Double
    var instances: [APIAnalysisLabelInstance]?
    var parents: [APIAnalysisLabelParent]?
}

struct APIAnalysis {
    var labels: [APIAnalysisLabel]
    var moderationLabels: [APIAnalysisLabel]
    var vendor: String?
    var approved: Bool?
    var rejected: Bool?
    var imageId: String?
    var createdAt: Date
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIAnalysisLabelInstanceBoundingBox(foldedAPIAnalysisLabelInstanceBoundingBox: FoldedAPIAnalysisLabelInstanceBoundingBox) -> APIAnalysisLabelInstanceBoundingBox {
    
    let width: Double = foldedAPIAnalysisLabelInstanceBoundingBox.width
    let height: Double = foldedAPIAnalysisLabelInstanceBoundingBox.height
    let left: Double = foldedAPIAnalysisLabelInstanceBoundingBox.left
    let top: Double = foldedAPIAnalysisLabelInstanceBoundingBox.top
    
    return APIAnalysisLabelInstanceBoundingBox(
        width: width,
        height: height,
        left: left,
        top: top
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIAnalysisLabelInstance(foldedAPIAnalysisLabelInstance: FoldedAPIAnalysisLabelInstance) -> APIAnalysisLabelInstance {
    
    let boundingBox = unfoldAPIAnalysisLabelInstanceBoundingBox(foldedAPIAnalysisLabelInstanceBoundingBox: foldedAPIAnalysisLabelInstance.boundingBox)
    let confidence = foldedAPIAnalysisLabelInstance.confidence
    
    return APIAnalysisLabelInstance(
        boundingBox: boundingBox,
        confidence: confidence
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIAnalysisLabelParent(foldedAPIAnalysisLabelParent: FoldedAPIAnalysisLabelParent) -> APIAnalysisLabelParent {
    let name = foldedAPIAnalysisLabelParent.name
    
    return APIAnalysisLabelParent(name: name)
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIAnalysisLabel(foldedAPIAnalysisLabel: FoldedAPIAnalysisLabel) -> APIAnalysisLabel {
    let name = foldedAPIAnalysisLabel.name
    let confidence = foldedAPIAnalysisLabel.confidence
    
    var instances: [APIAnalysisLabelInstance]?
    if let foldedAPIAnalysisLabelInstances = foldedAPIAnalysisLabel.instances {
        instances = []
        foldedAPIAnalysisLabelInstances.forEach { foldedAPIAnalysisLabelInstant in
            instances?.append(unfoldAPIAnalysisLabelInstance(foldedAPIAnalysisLabelInstance: foldedAPIAnalysisLabelInstant))
        }
    } else {
        instances = nil
    }
    
    var parents: [APIAnalysisLabelParent]?
    if let foldedAPIAnalysisLabelParents = foldedAPIAnalysisLabel.parents {
        parents = []
        foldedAPIAnalysisLabelParents.forEach { foldedAPIAnalysisLabelParent in
            parents?.append(unfoldAPIAnalysisLabelParent(foldedAPIAnalysisLabelParent: foldedAPIAnalysisLabelParent))
        }
    } else {
        parents = nil
    }
    
    return APIAnalysisLabel(
        name: name,
        confidence: confidence,
        instances: instances,
        parents: parents
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIAnalysis(foldedAPIAnalysis: FoldedAPIAnalysis) -> APIAnalysis {
    
    var labels: [APIAnalysisLabel] = []
    foldedAPIAnalysis.labels.forEach { foldedAPIAnalysisLabel in
        labels.append(unfoldAPIAnalysisLabel(foldedAPIAnalysisLabel:foldedAPIAnalysisLabel))
    }
    
    var moderationLabels: [APIAnalysisLabel] = []
    foldedAPIAnalysis.moderationLabels.forEach { foldedAPIAnalysisModerationLabel in
        moderationLabels.append(unfoldAPIAnalysisLabel(foldedAPIAnalysisLabel: foldedAPIAnalysisModerationLabel))
    }
    
    let vendor = foldedAPIAnalysis.vendor
    
    var approved: Bool? = nil
    if let foldedApproved = foldedAPIAnalysis.approved {
        approved = (foldedApproved == 0) ? false : true
    }
    
    var rejected: Bool? = nil
    if let foldedRejected = foldedAPIAnalysis.rejected {
        rejected = (foldedRejected == 0) ? false : true
    }
    
    let imageId = foldedAPIAnalysis.imageId
    
    let createdAt = foldedAPIAnalysis.createdAt
    
    return APIAnalysis(
        labels: labels,
        moderationLabels: moderationLabels,
        vendor: vendor,
        approved: approved,
        rejected: rejected,
        imageId: imageId,
        createdAt: createdAt
    )
}

// ----------------------------------------------------------------------------

func unfoldAPIAnalyses(foldedAPIAnalyses: [FoldedAPIAnalysis]) -> [APIAnalysis] {
    var aPIanalyses: [APIAnalysis] = []
    
    foldedAPIAnalyses.forEach { foldedAPIAnalysis in
        aPIanalyses.append(unfoldAPIAnalysis(foldedAPIAnalysis: foldedAPIAnalysis))
    }
    
    return aPIanalyses
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
