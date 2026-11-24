import QtQuick
import atlas

Rectangle {
    id: root

    // Cards that float (dialogs, menus) are drawn as boxes in TTY, where
    // every surface shares one ground and borders, not tones, divide them.
    property bool ttyFrame: false

    // MochiFile "mochi" stili (Colours.mochi acikken):
    //  mochiFrame: sticker kart, kalin murekkep cizgi + alta duz golge
    //  mochiKey:   klavye tusu, ayni cizgi + kisa golge; mochiDown basili hali
    //  mochiLine:  sadece ince cizgi, golge yok (cip, kutu)
    property bool mochiFrame: false
    property bool mochiKey: false
    property bool mochiLine: false
    property bool mochiDown: false
    property real mochiShadow: mochiKey ? Tokens.mochi.keyShadow : (mochiLine ? 0 : Tokens.mochi.shadow)
    property real mochiBorder: mochiLine ? Tokens.mochi.thin : Tokens.mochi.line
    property color mochiBorderColour: Colours.palette.m3outline
    // ttyFrame'li yuzen kartlar (diyalog, menu) mochi'de de sticker kart olur
    readonly property bool mochiActive: Colours.mochi && (mochiFrame || mochiKey || mochiLine || ttyFrame)
    readonly property real mochiPress: mochiActive && mochiDown ? Math.max(0, mochiShadow - 1) : 0

    color: "transparent"
    border.width: mochiActive ? mochiBorder : (ttyFrame && Colours.tty ? 1 : 0)
    border.color: mochiActive ? mochiBorderColour : Colours.palette.m3outlineVariant

    transform: Translate {
        y: root.mochiPress

        Behavior on y {
            Anim {
                type: Anim.FastSpatial
            }
        }
    }

    // Duz golge: ebeveynin arkasinda (negatif z), asagi kaydirilmis ayni sekil.
    Loader {
        active: root.mochiActive && root.mochiShadow > 0
        z: -1
        y: root.mochiShadow - root.mochiPress
        width: root.width
        height: root.height
        sourceComponent: Rectangle {
            radius: root.radius
            topLeftRadius: root.topLeftRadius
            topRightRadius: root.topRightRadius
            bottomLeftRadius: root.bottomLeftRadius
            bottomRightRadius: root.bottomRightRadius
            color: Colours.palette.m3shadow
        }
    }

    Behavior on color {
        CAnim {}
    }
}
