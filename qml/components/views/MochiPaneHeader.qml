import QtQuick
import "../"
import atlas

// MochiFile: bolunmus gorunumde bolmenin ust seridi (yol + odak rengi).
Rectangle {
    id: root

    property string path: ""
    property bool active: false

    height: Tokens.mochi.paneHeaderHeight
    color: active ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainerLow

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Tokens.mochi.hair
        color: Colours.palette.m3outlineVariant
    }

    StyledText {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Tokens.padding.medium
        anchors.rightMargin: Tokens.padding.medium
        elide: Text.ElideMiddle
        text: root.path.startsWith(FileUtils.home) ? "~" + root.path.substring(FileUtils.home.length) : root.path
        color: Colours.palette.m3onSurface
        font: Tokens.font.title.builders.medium.family(Tokens.font.headline.small.family).build()
    }
}
