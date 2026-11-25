import QtQuick
import QtQuick.Layouts
import "../"
import "../controls"
import atlas

MouseArea {
    id: root

    property bool expanded: false
    property var targetPaths: []
    property bool permanent: true

    signal confirmed(var paths)

    anchors.fill: parent
    visible: opacity > 0.001
    enabled: expanded
    hoverEnabled: expanded
    cursorShape: expanded ? Qt.ArrowCursor : undefined
    z: 100

    opacity: expanded ? 1.0 : 0.0
    Behavior on opacity {
        Anim {
            type: Anim.FastEffects
        }
    }

    onClicked: root.expanded = false
    onWheel: wheel => wheel.accepted = true

    Keys.onEscapePressed: root.expanded = false

    onExpandedChanged: {
        if (expanded) {
            root.forceActiveFocus();
        } else {
            root.targetPaths = [];
            if (typeof splitContainer !== "undefined" && splitContainer) {
                splitContainer.focusActiveView();
            }
        }
    }

    function accept(): void {
        const paths = root.targetPaths;
        root.expanded = false;
        if (paths.length > 0) {
            root.confirmed(paths);
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha(Colours.palette.m3scrim, 0.4)
    }

    LazyContent {
        expanded: root.expanded
        sourceComponent: Item {
            StyledRect {
                id: modalCard

                anchors.centerIn: parent
                width: Math.min(parent.width - 48, 440)
                height: Math.min(parent.height - 32, modalCol.implicitHeight + Tokens.padding.large * 2)
                implicitWidth: Math.min(parent.width - 48, 440)
                implicitHeight: modalCol.implicitHeight + Tokens.padding.large * 2

                radius: Colours.mochi ? Tokens.mochi.cardRadius : Tokens.rounding.large
                ttyFrame: true
                color: Colours.mochi ? Colours.palette.m3surface : Colours.palette.m3surfaceContainerHigh

                scale: root.expanded ? 1.0 : 0.94

                Behavior on scale {
                    Anim {
                        type: Anim.FastEffects
                        easing: Tokens.anim.standard
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse => mouse.accepted = true
                    onWheel: wheel => wheel.accepted = true
                }

                ColumnLayout {
                    id: modalCol

                    anchors.fill: parent
                    anchors.margins: Tokens.padding.large
                    spacing: Tokens.spacing.medium

                    RowLayout {
                        spacing: Tokens.spacing.small

                        MaterialIcon {
                            text: root.permanent ? "delete_forever" : "delete"
                            color: root.permanent ? Colours.palette.m3error : Colours.palette.m3primary
                            fontStyle: Tokens.font.icon.medium
                        }

                        StyledText {
                            Layout.fillWidth: true
                            text: (Colours.mochi ? "ほんとに消す？ - " : "") + (root.permanent ? qsTr("Delete permanently") : qsTr("Move to trash"))
                            color: Colours.palette.m3onSurface
                            font: Tokens.font.title.medium
                            wrapMode: Text.Wrap
                        }
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: {
                            const name = root.targetPaths.length > 0 ? root.targetPaths[0].split("/").pop() : "";
                            if (root.permanent) {
                                return root.targetPaths.length === 1
                                    ? qsTr("\"%1\" will be deleted permanently. This cannot be undone.").arg(name)
                                    : qsTr("%1 items will be deleted permanently. This cannot be undone.").arg(root.targetPaths.length);
                            }
                            return root.targetPaths.length === 1
                                ? qsTr("\"%1\" will be moved to the trash.").arg(name)
                                : qsTr("%1 items will be moved to the trash.").arg(root.targetPaths.length);
                        }
                        color: Colours.palette.m3onSurfaceVariant
                        font: Tokens.font.body.medium
                        wrapMode: Text.Wrap
                    }

                    // MochiFile: kalici silmede uyari satiri + silinecek dosyalarin listesi
                    StyledText {
                        Layout.fillWidth: true
                        visible: Colours.mochi && root.permanent
                        text: qsTr("Permanently deleted files skip the trash and cannot be restored.")
                        color: Colours.palette.m3onSurfaceVariant
                        font: Tokens.font.label.builders.medium.weight(Font.Black).build()
                        wrapMode: Text.Wrap
                    }

                    StyledRect {
                        Layout.fillWidth: true
                        visible: Colours.mochi && root.targetPaths.length > 0
                        implicitHeight: deleteList.implicitHeight + Tokens.padding.medium * 2
                        radius: Tokens.mochi.rowRadius
                        color: Qt.alpha(Colours.palette.m3errorContainer, 0.45)
                        mochiLine: true
                        mochiBorderColour: Colours.palette.m3errorContainer

                        Column {
                            id: deleteList

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: Tokens.padding.medium
                            spacing: Tokens.spacing.extraSmall

                            Repeater {
                                model: root.targetPaths.slice(0, Tokens.mochi.deleteListMax)

                                StyledText {
                                    required property string modelData
                                    width: deleteList.width
                                    text: modelData.split("/").pop()
                                    color: Colours.palette.m3onSurface
                                    font: Tokens.font.mono.small
                                    elide: Text.ElideMiddle
                                }
                            }

                            StyledText {
                                visible: root.targetPaths.length > Tokens.mochi.deleteListMax
                                text: qsTr("and %1 more").arg(root.targetPaths.length - Tokens.mochi.deleteListMax)
                                color: Colours.palette.m3onSurfaceVariant
                                font: Tokens.font.label.small
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.small

                        Item {
                            Layout.fillWidth: true
                        }

                        TextButton {
                            type: ButtonBase.Text
                            text: qsTr("Cancel")
                            onClicked: root.expanded = false
                        }

                        TextButton {
                            type: ButtonBase.Filled
                            // MochiFile: mochi'de kalici sil acik kirmizi tus + murekkep yazi
                            activeColour: root.permanent ? (Colours.mochi ? Colours.palette.m3errorContainer : Colours.palette.m3error) : Colours.palette.m3primary
                            activeOnColour: root.permanent ? (Colours.mochi ? Colours.palette.m3onErrorContainer : Colours.palette.m3onError) : Colours.palette.m3onPrimary
                            inactiveColour: root.permanent ? (Colours.mochi ? Colours.palette.m3errorContainer : Colours.palette.m3error) : Colours.palette.m3primary
                            inactiveOnColour: root.permanent ? (Colours.mochi ? Colours.palette.m3onErrorContainer : Colours.palette.m3onError) : Colours.palette.m3onPrimary
                            text: root.permanent ? qsTr("Delete") : qsTr("Move to Trash")
                            onClicked: root.accept()
                        }
                    }
                }
            }
        }
    }

    Keys.onReturnPressed: root.accept()
    Keys.onEnterPressed: root.accept()
}
