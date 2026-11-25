import QtQuick
import QtQuick.Layouts
import atlas
import "../"

Row {
    id: root

    enum Type {
        Filled,
        Tonal,
        Elevated
    }

    property real horizontalPadding: Tokens.padding.medium
    property real verticalPadding: Tokens.padding.small
    property int type: SplitButton.Filled
    property bool disabled
    property string fallbackIcon
    property string fallbackText
    property real minLeftWidth

    property alias menuItems: menu.items
    property alias active: menu.active
    property alias expanded: menu.expanded
    readonly property alias menu: menu
    readonly property alias iconLabel: iconLabel
    readonly property alias label: label
    readonly property alias stateLayer: stateLayer
    readonly property alias textRow: textRow
    readonly property alias expandBtn: expandBtn

    // Contrast fix: Elevate tonal/surface container tokens above the parent surface
    // MochiFile: mochi'de iki parca da klavye tusu (tus zemini + murekkep yazi)
    property color colour: {
        if (Colours.mochi)
            return Colours.palette.m3surfaceContainerHigh;
        switch (type) {
            case SplitButton.Filled: return Colours.palette.m3primary
            case SplitButton.Elevated: return Colours.palette.m3surfaceContainerHighest
            case SplitButton.Tonal:
            default: return Colours.palette.m3secondaryContainer
        }
    }
    property color textColour: {
        if (Colours.mochi)
            return Colours.palette.m3onSurface;
        switch (type) {
            case SplitButton.Filled: return Colours.palette.m3onPrimary
            case SplitButton.Elevated: return Colours.palette.m3onSurface
            case SplitButton.Tonal:
            default: return Colours.palette.m3onSecondaryContainer
        }
    }
    property color disabledColour: Qt.alpha(Colours.palette.m3onSurface, 0.1)
    property color disabledTextColour: Qt.alpha(Colours.palette.m3onSurface, 0.38)

    spacing: Colours.mochi ? Tokens.spacing.extraSmall : Math.floor(Tokens.spacing.extraSmall / 2)

    // TTY: one bracketed choice, `[ label ▾ ]`, opening the menu wherever it's clicked
    Item {
        id: ttyBtn

        visible: Colours.tty
        implicitWidth: ttyText.implicitWidth
        implicitHeight: ttyText.implicitHeight + 8

        StyledText {
            id: ttyText

            anchors.centerIn: parent
            textFormat: Text.StyledText
            readonly property color edge: root.expanded || ttyArea.containsMouse ? Colours.palette.m3primary : Colours.palette.m3outline
            text: `<font color="${edge}">[</font> ${(root.active?.activeText ?? root.fallbackText).toLowerCase()} <font color="${edge}">${root.expanded ? "▴" : "▾"} ]</font>`
            color: root.disabled ? root.disabledTextColour : Colours.palette.m3onSurface
            font: Tokens.font.body.medium
        }

        MouseArea {
            id: ttyArea

            anchors.fill: parent
            hoverEnabled: true
            enabled: !root.disabled
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    StyledRect {
        visible: !Colours.tty
        radius: Colours.mochi ? Tokens.mochi.keyRadius : implicitHeight / 2 * Math.min(1, Tokens.rounding.scale)
        topRightRadius: Colours.mochi ? Tokens.mochi.keyRadius / 2 : Tokens.rounding.medium / 2
        bottomRightRadius: Colours.mochi ? Tokens.mochi.keyRadius / 2 : Tokens.rounding.medium / 2
        color: root.disabled ? root.disabledColour : root.colour
        mochiKey: true
        mochiDown: stateLayer.pressed

        implicitWidth: Math.max(root.minLeftWidth, textRow.implicitWidth + root.horizontalPadding * 2)
        implicitHeight: expandBtn.implicitHeight

        StateLayer {
            id: stateLayer

            topRightRadius: parent.topRightRadius
            bottomRightRadius: parent.bottomRightRadius
            color: root.textColour
            disabled: root.disabled
            onClicked: root.active?.clicked()
        }

        RowLayout {
            id: textRow

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: Math.floor(root.verticalPadding / 4)
            spacing: Tokens.spacing.small

            MaterialIcon {
                id: iconLabel

                Layout.alignment: Qt.AlignVCenter
                animate: true
                text: root.active?.activeIcon ?? root.fallbackIcon
                color: root.disabled ? root.disabledTextColour : root.textColour
                fill: 1
            }

            StyledText {
                id: label

                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: implicitWidth
                animate: true
                text: root.active?.activeText ?? root.fallbackText
                color: root.disabled ? root.disabledTextColour : root.textColour
                clip: true

                Behavior on Layout.preferredWidth {
                    Anim {
                        type: Anim.Emphasized
                    }
                }
            }
        }
    }

    StyledRect {
        id: expandBtn

        visible: !Colours.tty

        property real rad: root.expanded ? implicitHeight / 2 * Math.min(1, Tokens.rounding.scale) : Tokens.rounding.medium / 2

        radius: Colours.mochi ? Tokens.mochi.keyRadius : implicitHeight / 2 * Math.min(1, Tokens.rounding.scale)
        topLeftRadius: Colours.mochi ? Tokens.mochi.keyRadius / 2 : rad
        bottomLeftRadius: Colours.mochi ? Tokens.mochi.keyRadius / 2 : rad
        color: root.disabled ? root.disabledColour : root.colour
        mochiKey: true
        mochiDown: expandStateLayer.pressed || root.expanded

        implicitWidth: implicitHeight
        implicitHeight: expandIcon.implicitHeight + root.verticalPadding * 2

        StateLayer {
            id: expandStateLayer

            rect.topLeftRadius: parent.topLeftRadius
            rect.bottomLeftRadius: parent.bottomLeftRadius
            color: root.textColour
            disabled: root.disabled
            onClicked: root.expanded = !root.expanded
        }

        MaterialIcon {
            id: expandIcon

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: root.expanded ? 0 : -Math.floor(root.verticalPadding / 4)

            text: "expand_more"
            color: root.disabled ? root.disabledTextColour : root.textColour
            rotation: root.expanded ? 180 : 0

            Behavior on anchors.horizontalCenterOffset {
                Anim {}
            }

            Behavior on rotation {
                Anim {}
            }
        }

        Behavior on rad {
            Anim {}
        }
    }

    Menu {
        id: menu

        attachTo: Colours.tty ? ttyBtn : expandBtn
        marginY: Tokens.spacing.small
    }
}