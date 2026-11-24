import QtQuick
import atlas

// MochiFile: bolum basligi. Japonca kisim sabit sus, ikinci kisim ceviriden
// (or. "ばしょ - Places"). Sadece mochi stilinde kullanilir.
StyledText {
    property string jp: ""
    property string title: ""

    text: jp.length > 0 ? jp + " - " + title : title
    color: Colours.palette.m3onPrimaryContainer
    font: Tokens.font.label.builders.small.weight(Font.Black).letterSpacing(Tokens.mochi.sectionSpacing).build()
}
