import QtQuick
import QtQuick.Layouts
import atlas
import "../"

StyledRect {
    id: root

    property var model: []
    property var currentValue: undefined
    property string valueKey: "value"
    property string labelKey: "label"
    property string iconKey: "icon"
    property int buttonHeight: 40

    property color activeColor: Colours.mochi ? Colours.palette.m3primary : Colours.palette.m3primaryContainer
    property color inactiveColor: Colours.tPalette.m3surfaceContainerHigh
    property color activeOnColor: Colours.mochi ? Colours.palette.m3onPrimary : Colours.palette.m3onPrimaryContainer
    property color inactiveOnColor: Colours.palette.m3onSurface
    property color inactiveIconColor: Colours.palette.m3onSurfaceVariant

    signal selected(var value, int index)

    readonly property int currentIndex: {
        for (let i = 0; i < root.model.length; ++i) {
            if (root.model[i][root.valueKey] === root.currentValue)
                return i;
        }
        return 0;
    }

    implicitHeight: buttonHeight
    radius: Tokens.rounding.full
    color: root.inactiveColor
    clip: true

    StyledRect {
        id: indicator

        // itemAt bildirimsiz: oge eklenince (itemRev) yeniden hesaplansin
        readonly property Item target: repeater.itemRev >= 0 && repeater.count > root.currentIndex ? repeater.itemAt(root.currentIndex) : null

        x: target ? target.x + 2 : 2
        y: 2
        width: target ? Math.max(0, target.width - 4) : 0
        height: Math.max(0, root.height - 4)

        radius: Tokens.rounding.full
        color: root.activeColor
        mochiLine: true

        Behavior on x {
            Anim {
                type: Anim.DefaultSpatial
            }
        }

        Behavior on width {
            Anim {
                type: Anim.DefaultSpatial
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Repeater {
            id: repeater

            property int itemRev: 0

            model: root.model
            onItemAdded: itemRev++

            delegate: Item {
                id: entry

                required property int index
                required property var modelData

                readonly property bool isCurrent: root.currentIndex === entry.index
                readonly property color contentColour: entry.isCurrent
                    ? root.activeOnColor
                    : (layer.containsMouse ? root.inactiveOnColor : root.inactiveIconColor)

                Layout.fillWidth: true
                Layout.fillHeight: true

                StateLayer {
                    id: layer

                    anchors.fill: parent
                    radius: Tokens.rounding.full
                    color: entry.isCurrent ? root.activeOnColor : root.inactiveOnColor
                    onClicked: root.selected(entry.modelData[root.valueKey], entry.index)
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4

                    MaterialIcon {
                        visible: text.length > 0
                        text: entry.modelData[root.iconKey] ?? ""
                        color: entry.contentColour
                        fontStyle: Tokens.font.icon.small
                        fill: entry.isCurrent ? 1 : 0

                        Behavior on color {
                            CAnim {
                                duration: Tokens.anim.durations.expressiveFastEffects
                            }
                        }

                        Behavior on fill {
                            Anim {
                                type: Anim.DefaultEffects
                            }
                        }
                    }

                    StyledText {
                        text: entry.modelData[root.labelKey] ?? ""
                        color: entry.contentColour
                        font: entry.isCurrent
                            ? Tokens.font.body.builders.small.weight(Font.DemiBold).build()
                            : Tokens.font.body.small

                        Behavior on color {
                            CAnim {
                                duration: Tokens.anim.durations.expressiveFastEffects
                            }
                        }
                    }
                }
            }
        }
    }
}
