import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"
import atlas

StyledRect {
    id: root

    property var mediaList: []
    property int currentIndex: -1
    property bool active: false
    property bool showControls: true

    signal itemSelected(int index)

    implicitHeight: (active && showControls) ? 76 : 0
    opacity: (active && showControls) ? 1.0 : 0.0
    scale: (active && showControls) ? 1.0 : 0.92
    transformOrigin: Item.Bottom
    visible: opacity > 0.001
    clip: true

    Behavior on implicitHeight { Anim { type: Anim.FastSpatial } }
    Behavior on opacity { Anim { type: Anim.FastEffects } }
    Behavior on scale { Anim { type: Anim.FastSpatial } }

    radius: Tokens.rounding.medium
    color: Colours.mochi ? "transparent" : Qt.alpha(Colours.palette.m3surfaceContainerHighest, 0.85)

    ListView {
        id: filmListView
        anchors.fill: parent
        anchors.margins: 6
        orientation: ListView.Horizontal
        spacing: 8
        clip: true
        model: root.mediaList

        highlightFollowsCurrentItem: true
        currentIndex: root.currentIndex

        delegate: StyledRect {
            id: thumbDelegate
            required property int index
            required property var modelData

            implicitWidth: 64
            implicitHeight: 64
            radius: Colours.mochi ? Tokens.mochi.rowRadius : Tokens.rounding.small
            // MochiFile: secili kucuk resim pembe cerceve + murekkep halka, digerleri beyaz cerceve
            color: Colours.mochi ? (root.currentIndex === index ? Colours.palette.m3primary : Colours.palette.m3surface) : (root.currentIndex === index ? Colours.palette.m3primary : (thumbHover.containsMouse ? Colours.palette.m3surfaceContainerHigh : Colours.palette.m3surfaceContainer))
            border.width: Colours.mochi && root.currentIndex === index ? Tokens.mochi.line : 0
            border.color: Colours.palette.m3outline
            opacity: Colours.mochi && root.currentIndex !== index && !thumbHover.containsMouse ? 0.75 : 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: Colours.mochi ? (root.currentIndex === index ? Tokens.mochi.line * 2 : Tokens.mochi.line) : (root.currentIndex === index ? 2 : 0)
                radius: Colours.mochi ? Tokens.mochi.rowRadius - anchors.margins : Tokens.rounding.small
                color: Colours.palette.m3surface
                clip: true

                CachingIconImage {
                    anchors.fill: parent
                    implicitSize: 64
                    source: {
                        if (!thumbDelegate.modelData) return "";
                        let t = thumbDelegate.modelData.lastModified ? thumbDelegate.modelData.lastModified.getTime() : 0;
                        return "image://thumb/" + thumbDelegate.modelData.path + "?t=" + t;
                    }
                }
            }

            MouseArea {
                id: thumbHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.itemSelected(thumbDelegate.index)
            }
        }
    }
}
