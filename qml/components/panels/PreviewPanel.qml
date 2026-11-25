import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"
import atlas

StyledRect {
    id: root

    property string targetPath: ""
    property bool expanded: false
    property int panelWidth: 260
    signal previewClicked(string path)
    // MochiFile: alttaki eylem tuslari ("open", "openWith", "rename", "properties")
    signal actionRequested(string action, var item)

    implicitWidth: expanded ? (Colours.mochi ? Tokens.mochi.previewWidth : panelWidth) : 0
    visible: width > 0
    clip: true
    color: Colours.mochi ? Colours.palette.m3surface : Colours.tPalette.m3surfaceContainer

    // MochiFile: mochi'de sol kenarda ince ayirici
    Rectangle {
        visible: Colours.mochi
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Tokens.mochi.hair
        color: Colours.palette.m3outlineVariant
        z: 5
    }

    Behavior on implicitWidth {
        Anim {
            type: Anim.DefaultSpatial
        }
    }

    FileMetadata {
        id: meta
        path: root.targetPath
    }

    component InfoRow: ColumnLayout {
        id: infoRow

        required property var modelData
        readonly property string rowLabel: (infoRow.modelData.label ?? "").toString()
        readonly property string rowValue: {
            const v = infoRow.modelData.value;
            return v === undefined || v === null ? "" : String(v);
        }

        Layout.fillWidth: true
        spacing: 2
        visible: infoRow.modelData.visible !== false && infoRow.rowValue.length > 0

        StyledText {
            visible: !Colours.mochi
            text: infoRow.rowLabel.endsWith(":") ? infoRow.rowLabel : infoRow.rowLabel + ":"
            color: Colours.palette.m3onSurfaceVariant
            font: Tokens.font.label.medium
        }

        StyledText {
            Layout.fillWidth: true
            visible: !Colours.mochi
            text: infoRow.rowValue
            color: Colours.palette.m3onSurface
            font: Tokens.font.body.small
            wrapMode: Text.Wrap
        }

        // MochiFile: etiket solda, deger sagda, altta ince cizgi
        RowLayout {
            Layout.fillWidth: true
            visible: Colours.mochi
            spacing: Tokens.spacing.small

            StyledText {
                // panel genisligi sabit: satir icinden genislik okumak dongu yapar
                Layout.preferredWidth: root.implicitWidth * 0.32
                text: infoRow.rowLabel.replace(/:$/, "")
                color: Colours.palette.m3onSurfaceVariant
                font: Tokens.font.label.builders.small.weight(Font.Black).build()
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                text: infoRow.rowValue
                color: Colours.palette.m3onSurface
                font: Tokens.font.label.builders.medium.weight(Font.Black).build()
                wrapMode: Text.Wrap
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: Tokens.spacing.extraSmall
            visible: Colours.mochi
            implicitHeight: Tokens.mochi.hair
            color: Colours.palette.m3outlineVariant
        }
    }

    TtyBox {
        anchors.fill: parent
        anchors.margins: 4
        anchors.topMargin: 12
        title: qsTr("preview")
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        anchors.bottomMargin: actionKeys.visible ? actionKeys.height + Tokens.padding.medium * 2 : Tokens.padding.medium
        anchors.topMargin: Colours.tty ? 26 : Tokens.padding.medium
        contentHeight: previewCol.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: StyledScrollBar {
            flickable: parent
        }

        ColumnLayout {
            id: previewCol

            width: parent.width
            spacing: Tokens.spacing.medium

            MochiTitle {
                Layout.fillWidth: true
                visible: Colours.mochi
                jp: "プレビュー"
                title: qsTr("Preview")
            }

            // Header
            RowLayout {
                Layout.fillWidth: true
                visible: !Colours.mochi
                spacing: Tokens.spacing.small

                MaterialIcon {
                    text: "info"
                    color: Colours.palette.m3primary
                    fontStyle: Tokens.font.icon.medium
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Information")
                    color: Colours.palette.m3onSurface
                    font: Tokens.font.title.medium
                }
            }

            // Image / Video / Icon Preview
            StyledRect {
                Layout.fillWidth: true
                implicitHeight: Colours.mochi ? Tokens.mochi.previewHeight : 200
                radius: Colours.mochi ? Tokens.mochi.itemRadius : Tokens.rounding.medium
                color: Colours.mochi ? Colours.palette.m3surfaceContainerLow : (previewCardHover.containsMouse ? Colours.palette.m3surfaceContainerHighest : Colours.tPalette.m3surfaceContainerHigh)
                clip: true
                mochiLine: true
                mochiBorder: Tokens.mochi.line

                // Image & Video Preview (Full size)
                Image {
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.small
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    source: (meta.isImage || meta.isVideo) && meta.path.length > 0
                        ? ("image://thumb/" + meta.path + "?t=" + meta.lastModifiedMs)
                        : ""
                    visible: meta.isImage || meta.isVideo
                    asynchronous: true
                    mipmap: true
                    smooth: true
                }

                // Generic File / Folder Icon Preview (when not media)
                CachingIconImage {
                    anchors.centerIn: parent
                    implicitSize: 72
                    visible: !meta.isImage && !meta.isVideo
                    source: FileUtils.iconForFile(meta.name, meta.isDir, meta.mimeType)
                }

                // Video Badge Overlay
                StyledRect {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: Tokens.padding.small
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: Tokens.rounding.full
                    color: Qt.alpha(Colours.palette.m3surface, 0.8)
                    visible: meta.isVideo

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "play_arrow"
                        color: Colours.palette.m3primary
                        fontStyle: Tokens.font.icon.small
                    }
                }

                MouseArea {
                    id: previewCardHover
                    anchors.fill: parent
                    hoverEnabled: meta.isImage || meta.isVideo
                    enabled: meta.isImage || meta.isVideo
                    cursorShape: (meta.isImage || meta.isVideo) ? Qt.PointingHandCursor : undefined
                    onClicked: root.previewClicked(meta.path)
                }
            }

            // Name and path
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    Layout.fillWidth: true
                    text: meta.name.length > 0 ? meta.name : qsTr("No Selection")
                    color: Colours.palette.m3onSurface
                    font: Colours.mochi ? Tokens.font.title.medium : Tokens.font.title.small
                    wrapMode: Text.Wrap
                }

                // MochiFile: tur ve boyut cipleri
                Flow {
                    Layout.fillWidth: true
                    Layout.topMargin: Tokens.spacing.small
                    visible: Colours.mochi && meta.name.length > 0
                    spacing: Tokens.spacing.small

                    Repeater {
                        model: [
                            { text: meta.isDir ? "" : (meta.name.lastIndexOf(".") > 0 ? meta.name.substring(meta.name.lastIndexOf(".") + 1).toUpperCase() : ""), tone: 0 },
                            { text: meta.isImage ? meta.imageDimensions : (meta.isVideo ? meta.videoDimensions : ""), tone: 1 },
                            { text: (meta.isVideo || meta.isAudio) ? meta.durationFormatted : "", tone: 2 }
                        ]

                        StyledRect {
                            required property var modelData
                            visible: modelData.text.length > 0
                            implicitHeight: Tokens.mochi.chipHeight
                            implicitWidth: chipText.implicitWidth + Tokens.padding.medium * 2
                            radius: height / 2
                            mochiLine: true
                            color: modelData.tone === 0 ? Colours.palette.m3primaryContainer : (modelData.tone === 2 ? Colours.palette.m3tertiaryContainer : Colours.palette.m3surface)

                            StyledText {
                                id: chipText
                                anchors.centerIn: parent
                                text: parent.modelData.text
                                color: Colours.palette.m3onSurface
                                font: Tokens.font.label.builders.medium.weight(Font.Black).build()
                            }
                        }
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: meta.path.length > 0
                    text: meta.path
                    color: Colours.palette.m3outline
                    font: Tokens.font.body.small
                    elide: Text.ElideMiddle
                }

                // Symlink target if applicable
                StyledText {
                    Layout.fillWidth: true
                    visible: meta.isSymLink
                    text: `↳ ${meta.symLinkTarget}`
                    color: Colours.palette.m3primary
                    font: Tokens.font.mono.small
                    elide: Text.ElideMiddle
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Colours.palette.m3outlineVariant
                visible: meta.name.length > 0 && !Colours.mochi
            }

            // Key-Value Metadata List
            Repeater {
                model: [
                    { label: qsTr("Size"), value: meta.isDir ? `${meta.itemCount} items` : meta.formattedSize },
                    { label: qsTr("Type"), value: meta.mimeDescription.length > 0 ? meta.mimeDescription : (meta.isDir ? "Folder" : "File") },
                    { label: qsTr("Dimensions"), value: meta.imageDimensions, visible: meta.isImage && meta.imageDimensions.length > 0 },
                    { label: qsTr("Resolution"), value: meta.videoDimensions, visible: meta.isVideo && meta.videoDimensions.length > 0 },
                    { label: qsTr("Duration"), value: meta.durationFormatted, visible: (meta.isVideo || meta.isAudio) && meta.durationFormatted.length > 0 },
                    { label: qsTr("Modified"), value: meta.formattedModified },
                    { label: qsTr("Created"), value: meta.formattedCreated },
                    { label: qsTr("Accessed"), value: meta.formattedAccessed },
                    { label: qsTr("Permissions"), value: meta.permissions },
                    { label: qsTr("Owner"), value: `${meta.owner} : ${meta.group}` }
                ]

                InfoRow {}
            }

            // Rich media metadata (EXIF / container tags)
            Repeater {
                model: meta.mediaDetails

                InfoRow {}
            }
        }
    }

    // MochiFile: alt eylem tuslari
    GridLayout {
        id: actionKeys

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Tokens.padding.medium
        visible: Colours.mochi && meta.name.length > 0
        columns: 4
        columnSpacing: Tokens.spacing.small

        Repeater {
            model: [
                { action: "open", icon: "open_in_new", label: qsTr("Open") },
                { action: "openWith", icon: "apps", label: qsTr("Open with") },
                { action: "rename", icon: "edit", label: qsTr("Rename") },
                { action: "properties", icon: "info", label: qsTr("Properties") }
            ]

            MochiKeyButton {
                required property var modelData
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                icon: modelData.icon
                label: modelData.label
                onClicked: root.actionRequested(modelData.action, { path: meta.path, name: meta.name, isDir: meta.isDir })
            }
        }
    }
}
