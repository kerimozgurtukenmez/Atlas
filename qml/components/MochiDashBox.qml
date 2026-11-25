import QtQuick
import QtQuick.Shapes
import atlas

// MochiFile: kesik cizgi cerceveli yuvarlak kutu (bos durum alani).
Item {
    id: root

    property real radius: Tokens.mochi.itemRadius
    property color fill: Colours.palette.m3surfaceContainerLow
    readonly property real half: Tokens.mochi.hair / 2

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.fill
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: Colours.palette.m3outlineVariant
            strokeWidth: Tokens.mochi.hair
            strokeStyle: ShapePath.DashLine
            dashPattern: [3, 2]
            fillColor: "transparent"
            startX: root.radius
            startY: root.half

            PathLine { x: root.width - root.radius; y: root.half }
            PathArc { x: root.width - root.half; y: root.radius; radiusX: root.radius - root.half; radiusY: root.radius - root.half }
            PathLine { x: root.width - root.half; y: root.height - root.radius }
            PathArc { x: root.width - root.radius; y: root.height - root.half; radiusX: root.radius - root.half; radiusY: root.radius - root.half }
            PathLine { x: root.radius; y: root.height - root.half }
            PathArc { x: root.half; y: root.height - root.radius; radiusX: root.radius - root.half; radiusY: root.radius - root.half }
            PathLine { x: root.half; y: root.radius }
            PathArc { x: root.radius; y: root.half; radiusX: root.radius - root.half; radiusY: root.radius - root.half }
        }
    }
}
