import QtQuick
import QtQuick.Shapes
import atlas

// MochiFile: kesik cizgili ince ayirici.
Shape {
    id: root

    implicitHeight: Tokens.mochi.hair
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeColor: Colours.palette.m3outlineVariant
        strokeWidth: Tokens.mochi.hair
        strokeStyle: ShapePath.DashLine
        dashPattern: [2, 1.6]
        capStyle: ShapePath.FlatCap
        fillColor: "transparent"
        startX: 0
        startY: root.height / 2

        PathLine {
            x: root.width
            y: root.height / 2
        }
    }
}
