import QtQuick
import atlas

// MochiFile: menulerde kisayol tusu cipi (or. "Ctrl+C").
StyledRect {
    id: root

    property alias text: label.text

    implicitHeight: Tokens.mochi.shortcutHeight
    implicitWidth: label.implicitWidth + Tokens.padding.small * 2
    radius: Tokens.mochi.shortcutRadius
    color: Colours.palette.m3surface
    mochiLine: true
    mochiBorder: Tokens.mochi.shortcutLine

    StyledText {
        id: label
        anchors.centerIn: parent
        color: Colours.palette.m3onSurface
        font: Tokens.font.mono.builders.small.weight(Font.Bold).build()
    }
}
