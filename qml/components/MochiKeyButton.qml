import QtQuick
import QtQuick.Layouts
import atlas

// MochiFile: ikon + kisa etiketli klavye tusu (onizleme eylemleri).
StyledRect {
    id: root

    property string icon: ""
    property string label: ""
    property bool on: false
    readonly property alias hovered: area.containsMouse
    signal clicked()

    implicitHeight: Tokens.mochi.actionKeyHeight
    radius: Tokens.mochi.keyRadius
    mochiKey: true
    mochiDown: area.pressed || on
    color: on ? Colours.palette.m3primary : (area.containsMouse ? Colours.palette.m3surfaceContainerHighest : Colours.palette.m3surfaceContainerHigh)

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

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
