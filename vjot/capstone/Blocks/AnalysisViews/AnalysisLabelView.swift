//
//  AnalysisLabelView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct AnalysisLabelView: View {
    var label: APIAnalysisLabel
    
    var body: some View {
        VStack {
            VStack(alignment: .vjotBreedH) {
                HStack {
                    Text("name:")
                        .foregroundColor(Color.secondary)
                    Text(label.name)
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBreedH) { $0[.leading] }
                }
                HStack {
                    Text("confidence:")
                        .foregroundColor(Color.secondary)
                    Text(String(label.confidence))
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBreedH) { $0[.leading] }
                }
            }
            VStack {
                if let instances = label.instances {
                    if !instances.isEmpty {
                        VStack {
                            Text("instances")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding(.vertical)
                            ForEach(instances, id: \.confidence) { instance in
                                AnalysisLabelInstanceView(labelInstance: instance)
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
            VStack {
                if let parents = label.parents {
                    if !parents.isEmpty {
                        VStack {
                            Text("parents")
                                .foregroundColor(Color.secondary)
                                .font(.callout)
                                .padding(.vertical)
                            VStack(alignment: .vjotParentH) {
                                ForEach(parents, id: \.name) { parent in
                                    AnalysisLabelParentView(labelParent: parent)
                                }
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: KEY-VALUE VIEW
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct AnalysisKeyValueView: View {
    var key: String
    var value: String
    
    var body: some View {
        HStack {
            Text("\(key):")
                .foregroundColor(Color.secondary)
            Text(value)
                .foregroundColor(Color.primary)
        }
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: LABEL INSTANCE BOUNDING BOX
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][


struct AnalysisLabelInstanceBoundingBoxView: View {
    var boundingBox: APIAnalysisLabelInstanceBoundingBox
    
    var body: some View {
        VStack {
            Text("bounding box")
                .foregroundColor(Color.secondary)
                .font(.subheadline)
            VStack(alignment: .vjotBoxH) {
                HStack {
                    Text("width:")
                        .foregroundColor(Color.secondary)
                    Text(String(boundingBox.width))
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBoxH) { $0[.leading] }
                }
                HStack {
                    Text("height:")
                        .foregroundColor(Color.secondary)
                    Text(String(boundingBox.height))
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBoxH) { $0[.leading] }
                }
                HStack {
                    Text("top:")
                        .foregroundColor(Color.secondary)
                    Text(String(boundingBox.top))
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBoxH) { $0[.leading] }
                }
                HStack {
                    Text("left:")
                        .foregroundColor(Color.secondary)
                    Text(String(boundingBox.left))
                        .foregroundColor(Color.primary)
                        .alignmentGuide(.vjotBoxH) { $0[.leading] }
                }
            }
        }
        .font(.subheadline)
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: LABEL INSTANCE
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct AnalysisLabelInstanceView: View {
    var labelInstance: APIAnalysisLabelInstance
    
    var body: some View {
        VStack {
            AnalysisLabelInstanceBoundingBoxView(boundingBox: labelInstance.boundingBox)
            AnalysisKeyValueView(key: "Confidence", value: String(labelInstance.confidence))
        }
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: LABEL PARENT
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct AnalysisLabelParentView: View {
    var labelParent: APIAnalysisLabelParent
    
    var body: some View {
        HStack {
            Text("parent:")
                .foregroundColor(Color.secondary)
            Text(labelParent.name)
                .foregroundColor(Color.primary)
                .alignmentGuide(.vjotParentH) { $0[.leading] }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct AnalysisLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalysisLabelView()
//    }
//}
