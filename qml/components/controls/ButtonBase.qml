import QtQuick
import "../"
import atlas

StyledRect {
    id: root

    enum ButtonType {
        Filled,
        Tonal,
        Text,
        Outlined
    }

    property bool checked: false
    property alias disabled: stateLayer.disabled
    property bool isToggle: false
    property bool isRound: false

    property bool radiusMorph: true
    property bool fillWidth: false

    property font font: Tokens.font.label.large
    property int type: ButtonBase.Filled

    property real padding: 0
    property real horizontalPadding: padding
    property real verticalPadding: padding

    readonly property alias pressed: stateLayer.pressed
    readonly property alias hovered: stateLayer.containsMouse
    readonly property alias stateLayer: stateLayer

    property color activeColour: Colours.palette.m3primary
    property color inactiveColour: Colours.palette.m3primary
    property color activeOnColour: Colours.palette.m3onPrimary
    property color inactiveOnColour: Colours.palette.m3onPrimary
    property color disabledColour: Qt.alpha(Colours.palette.m3onSurface, 0.1)
    property color disabledOnColour: Qt.alpha(Colours.palette.m3onSurface, 0.38)

    property bool internalChecked: false
    readonly property color onColour: disabled && !mochiKeycap ? disabledOnColour : (mochiKeycap && disabled ? Colours.palette.m3onSurface : mochiKeycap && !mochiPrimary ? Colours.palette.m3onSurface : (internalChecked ? activeOnColour : inactiveOnColour))

    property real pressedRadius: Tokens.rounding.small
    property real checkedRadius: Tokens.rounding.medium
    property real defaultRadius: Tokens.rounding.large

    // MochiFile: mochi stilinde butonlar klavye tusu gibi. Ana eylem (Filled) ve
    // secili toggle kendi rengiyle, digerleri tus zemini + murekkep yazi.
    property bool mochiStyle: true
    readonly property bool mochiKeycap: Colours.mochi && mochiStyle
    readonly property bool mochiPrimary: isToggle ? internalChecked : type === ButtonBase.Filled

    mochiKey: mochiStyle
    mochiDown: pressed

    signal clicked()

    onCheckedChanged: internalChecked = checked

    radius: {
        if (Colours.mochi && mochiStyle)
            return isRound ? (implicitHeight || height) / 2 : Tokens.mochi.keyRadius;
        if (radiusMorph && pressed)
            return pressedRadius;
        if (internalChecked)
            return checkedRadius;
        if (isRound)
            return (implicitHeight || height) / 2 * Math.min(1, Tokens.rounding.scale);
        return defaultRadius;
    }
    opacity: mochiKeycap && disabled ? 0.45 : 1
    color: mochiKeycap
        ? (disabled ? Colours.palette.m3surfaceContainerHigh : (mochiPrimary ? (internalChecked ? activeColour : inactiveColour) : Colours.palette.m3surfaceContainerHigh))
        : (type === ButtonBase.Text ? "transparent" : (disabled ? disabledColour : (internalChecked ? activeColour : inactiveColour)))
    border.width: mochiActive ? mochiBorder : (type === ButtonBase.Outlined ? 1 : 0)
    border.color: mochiActive ? mochiBorderColour : (type === ButtonBase.Outlined ? (disabled ? disabledColour : Colours.palette.m3outline) : "transparent")

    StateLayer {
        id: stateLayer

        radius: parent.radius
        color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour
        disabled: root.disabled
        onClicked: {
            if (root.isToggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    Behavior on radius {
        Anim {
            type: Anim.DefaultEffects
        }
    }
    Behavior on color {
        CAnim {}
    }
}
