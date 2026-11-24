import QtQuick
import atlas

// MochiFile: ana baslik. Japonca kisim sabit sus, ikinci kisim ceviriden
// (or. "プレビュー - Preview"), Mochiy Pop One yazisi.
StyledText {
    property string jp: ""
    property string title: ""

    text: jp.length > 0 ? jp + " - " + title : title
    color: Colours.palette.m3onSurface
    font: Tokens.font.title.builders.small.family(Tokens.font.headline.small.family).build()
    elide: Text.ElideRight
}
