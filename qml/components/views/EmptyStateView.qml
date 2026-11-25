import QtQuick
import QtQuick.Layouts
import "../"
import atlas

Item {
    id: root

    property string path: ""
    property bool isSearching: false
    property string searchQuery: ""
    readonly property bool isTrash: path.indexOf("/Trash") !== -1 || path.indexOf("trash:") !== -1

    signal createFolder()
    signal createFile()
    signal paste()
    signal clearSearch()

    // MochiFile: chibi resmi Cindy-Dots ayarlarindan (repoda resim yok, kisisel)
    readonly property string mochiImage: Colours.mochi
        ? Colours.mochiSetting(isTrash ? "mochifileEmptyTrash" : (isSearching ? "mochifileEmptySearch" : "mochifileEmptyFolder"))
        : ""

    anchors.centerIn: parent
    width: Math.min(420, parent.width - 32)
    implicitHeight: col.implicitHeight

    // MochiFile: mochi'de bos durum kesik cizgili kutu icinde
    MochiDashBox {
        visible: Colours.mochi
        anchors.fill: parent
        anchors.margins: -Tokens.padding.extraLarge
    }

    ColumnLayout {
        id: col
        anchors.fill: parent
        spacing: Tokens.spacing.medium

        Image {
            Layout.alignment: Qt.AlignHCenter
            visible: root.mochiImage.length > 0 && status === Image.Ready
            Layout.preferredHeight: Tokens.mochi.emptyImageHeight
            Layout.preferredWidth: Tokens.mochi.emptyImageHeight
            source: root.mochiImage.length > 0 ? "file://" + root.mochiImage : ""
            sourceSize.height: Tokens.mochi.emptyImageHeight * 2
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            mipmap: true
        }

        // Centered Icon Circle
        StyledRect {
            visible: !Colours.mochi
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 80
            implicitHeight: 80
            radius: Tokens.rounding.full
            color: Colours.tPalette.m3surfaceContainerHigh

            MaterialIcon {
                anchors.centerIn: parent
                text: root.isTrash ? "delete_outline" : (root.isSearching ? "search_off" : "folder_open")
                fontStyle: Tokens.font.icon.extraLarge
                color: root.isTrash ? Colours.palette.m3error : Colours.palette.m3primary
            }
        }

        // Title
        StyledText {
            Layout.fillWidth: true
            text: Colours.mochi
                ? (root.isTrash ? qsTr("Trash is squeaky clean!") : (root.isSearching ? qsTr("Nothing found…") : qsTr("This folder is empty~")))
                : (root.isTrash ? qsTr("Trash is empty") : (root.isSearching ? qsTr("No matching files found") : qsTr("This folder is empty")))
            font: Tokens.font.title.medium
            color: Colours.palette.m3onSurface
            horizontalAlignment: Text.AlignHCenter
        }

        // Subtitle description
        StyledText {
            Layout.fillWidth: true
            text: Colours.mochi
                ? (root.isTrash ? qsTr("Deleted files wait here") : (root.isSearching ? qsTr("No results for \"%1\"").arg(root.searchQuery) : qsTr("Drag files here or press Ctrl+N")))
                : root.isTrash
                ? qsTr("Items you delete will be safely stored here until you empty the trash.")
                : (root.isSearching
                    ? qsTr("No items matched \"%1\". Try checking spelling or toggling hidden files.").arg(root.searchQuery)
                    : qsTr("Drop files here, or create a new file or directory to get started."))
            font: Colours.mochi ? Tokens.font.label.builders.large.weight(Font.Black).build() : Tokens.font.body.medium
            color: Colours.palette.m3onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        // Helpful Action Buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Tokens.spacing.medium
            spacing: Tokens.spacing.medium
            visible: !Colours.mochi && !root.isTrash && !root.isSearching

            // New Folder Button
            StyledRect {
                implicitHeight: 42
                implicitWidth: b1Content.implicitWidth + 36
                radius: Tokens.rounding.full
                color: b1Hover.containsMouse ? Colours.tPalette.m3surfaceContainerHighest : Colours.tPalette.m3surfaceContainerHigh

                RowLayout {
                    id: b1Content
                    anchors.centerIn: parent
                    spacing: 8
                    MaterialIcon { text: "create_new_folder"; fontStyle: Tokens.font.icon.small; color: Colours.palette.m3primary }
                    StyledText { text: qsTr("New Folder"); font: Tokens.font.label.large; color: Colours.palette.m3onSurface }
                }

                MouseArea {
                    id: b1Hover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.createFolder()
                }
            }

            // New File Button
            StyledRect {
                implicitHeight: 42
                implicitWidth: b2Content.implicitWidth + 36
                radius: Tokens.rounding.full
                color: b2Hover.containsMouse ? Colours.tPalette.m3surfaceContainerHighest : Colours.tPalette.m3surfaceContainerHigh

                RowLayout {
                    id: b2Content
                    anchors.centerIn: parent
                    spacing: 8
                    MaterialIcon { text: "note_add"; fontStyle: Tokens.font.icon.small; color: Colours.palette.m3primary }
                    StyledText { text: qsTr("New File"); font: Tokens.font.label.large; color: Colours.palette.m3onSurface }
                }

                MouseArea {
                    id: b2Hover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.createFile()
                }
            }
        }

        // MochiFile: bos durum tuslari
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Tokens.spacing.small
            spacing: Tokens.spacing.small
            visible: Colours.mochi && !root.isTrash

            MochiKeyButton {
                visible: !root.isSearching
                implicitHeight: Tokens.mochi.navKeyHeight
                implicitWidth: implicitContentWidth
                label: qsTr("New Folder")
                icon: "create_new_folder"
                horizontal: true
                onClicked: root.createFolder()
            }

            MochiKeyButton {
                visible: !root.isSearching
                implicitHeight: Tokens.mochi.navKeyHeight
                implicitWidth: implicitContentWidth
                label: qsTr("New File")
                icon: "note_add"
                horizontal: true
                onClicked: root.createFile()
            }

            MochiKeyButton {
                visible: root.isSearching
                implicitHeight: Tokens.mochi.navKeyHeight
                implicitWidth: implicitContentWidth
                label: qsTr("Clear search")
                icon: "search_off"
                horizontal: true
                onClicked: root.clearSearch()
            }
        }
    }
}
