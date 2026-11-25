import QtQuick
import atlas

// MochiFile: murekkep cizgili ilerleme cubugu, dolgu pembe ve capraz cizgili.
StyledRect {
    id: root

    property real value: 0
    property color fillColour: Colours.palette.m3primary

    implicitHeight: Tokens.mochi.barHeight + Tokens.mochi.thin * 2
    radius: height / 2
    color: Colours.palette.m3surfaceContainerHigh
    mochiLine: true

    Rectangle {
        id: fill

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: parent.border.width
        width: Math.max(height, (parent.width - parent.border.width * 2) * Math.min(1, Math.max(0, root.value)))
        radius: height / 2
        color: root.fillColour
        clip: true

        Behavior on width {
            Anim { type: Anim.FastEffects }
        }

        // capraz seritler
        Row {
            x: -height
            height: parent.height
            spacing: Tokens.mochi.stripeGap

            Repeater {
                model: Math.ceil((fill.width + fill.height * 2) / (Tokens.mochi.stripeWidth + Tokens.mochi.stripeGap))

                Rectangle {
                    width: Tokens.mochi.stripeWidth
                    height: fill.height * 2
                    y: -fill.height / 2
                    rotation: 35
                    color: Qt.alpha(Colours.palette.m3surface, 0.35)
                }
            }
        }
    }
}
