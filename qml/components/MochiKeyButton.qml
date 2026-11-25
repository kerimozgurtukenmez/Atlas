import QtQuick
import QtQuick.Layouts
import atlas

// MochiFile: ikon + kisa etiketli klavye tusu (onizleme eylemleri).
StyledRect {
    id: root

    property string icon: ""
    property string label: ""
    property bool on: false
    // yatay: ikon solda, yazi sagda (tek satirlik tus)
    property bool horizontal: false
    readonly property real implicitContentWidth: content.implicitWidth + Tokens.padding.large * 2
    readonly property alias hovered: area.containsMouse
    signal clicked()

    implicitHeight: Tokens.mochi.actionKeyHeight
    radius: Tokens.mochi.keyRadius
    mochiKey: true
    mochiDown: area.pressed || on
    color: on ? Colours.palette.m3primary : (area.containsMouse ? Colours.palette.m3surfaceContainerHighest : Colours.palette.m3surfaceContainerHigh)

    GridLayout {
        id: content

        anchors.centerIn: parent
        columns: root.horizontal ? 2 : 1
        rowSpacing: 0
        columnSpacing: Tokens.spacing.small

        MaterialIcon {
            Layout.alignment: Qt.AlignHCenter
            text: root.icon
            fill: 1
            color: root.on ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface
            fontStyle: Tokens.font.icon.small
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: root.width - Tokens.padding.small * 2
            elide: Text.ElideRight
            visible: root.label.length > 0
            text: root.label
            color: root.on ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface
            font: Tokens.font.label.builders.small.weight(Font.Black).build()
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
