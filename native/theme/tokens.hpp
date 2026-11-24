#pragma once

#include <QQmlEngine>
#include <QJSEngine>

#include "font.hpp"
#include <QObject>
#include <QEasingCurve>
#include <QFileSystemWatcher>
#include <QList>
#include <QJsonObject>
#include <QtQmlIntegration/qqmlintegration.h>

namespace atlas::config {

class RoundingTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY valuesChanged)

#define TOKEN_PROP(name, defaultVal) \
    Q_PROPERTY(int name READ name NOTIFY valuesChanged) \
public: \
    int name() const { return m_squared ? 0 : static_cast<int>(m_##name * m_scale); } \
    void set_##name(int val) { m_##name = val; } \
private: \
    int m_##name = defaultVal;

    TOKEN_PROP(extraSmall, 4)
    TOKEN_PROP(small, 8)
    TOKEN_PROP(medium, 12)
    TOKEN_PROP(large, 16)
    TOKEN_PROP(largeIncreased, 20)
    TOKEN_PROP(extraLarge, 28)
    TOKEN_PROP(extraLargeIncreased, 32)
    TOKEN_PROP(extraExtraLarge, 48)
    TOKEN_PROP(full, 9999)

#undef TOKEN_PROP

public:
    explicit RoundingTokens(QObject* parent = nullptr) : QObject(parent) {}

    [[nodiscard]] qreal scale() const { return m_scale; }
    void setScale(qreal scale) {
        if (qFuzzyCompare(m_scale, scale))
            return;
        m_scale = scale;
        emit valuesChanged();
    }
    void loadJson(const QJsonObject& json);
    // TTY: every corner square, whatever the scale
    void setSquared(bool squared) {
        if (m_squared == squared)
            return;
        m_squared = squared;
        emit valuesChanged();
    }

signals:
    void valuesChanged();

private:
    qreal m_scale = 1.0;
    bool m_squared = false;
};

class SpacingTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY valuesChanged)

#define TOKEN_PROP(name, defaultVal) \
    Q_PROPERTY(int name READ name NOTIFY valuesChanged) \
public: \
    int name() const { return static_cast<int>(m_##name * m_scale); } \
    void set_##name(int val) { m_##name = val; } \
private: \
    int m_##name = defaultVal;

    TOKEN_PROP(extraSmall, 4)
    TOKEN_PROP(small, 8)
    TOKEN_PROP(medium, 12)
    TOKEN_PROP(large, 16)
    TOKEN_PROP(largeIncreased, 20)
    TOKEN_PROP(extraLarge, 28)
    TOKEN_PROP(extraLargeIncreased, 32)
    TOKEN_PROP(extraExtraLarge, 48)

#undef TOKEN_PROP

public:
    explicit SpacingTokens(QObject* parent = nullptr) : QObject(parent) {}

    [[nodiscard]] qreal scale() const { return m_scale; }
    void setScale(qreal scale) {
        if (qFuzzyCompare(m_scale, scale))
            return;
        m_scale = scale;
        emit valuesChanged();
    }
    void loadJson(const QJsonObject& json);

signals:
    void valuesChanged();

private:
    qreal m_scale = 1.0;
};

class PaddingTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY valuesChanged)

#define TOKEN_PROP(name, defaultVal) \
    Q_PROPERTY(int name READ name NOTIFY valuesChanged) \
public: \
    int name() const { return static_cast<int>(m_##name * m_scale); } \
    void set_##name(int val) { m_##name = val; } \
private: \
    int m_##name = defaultVal;

    TOKEN_PROP(extraSmall, 4)
    TOKEN_PROP(small, 8)
    TOKEN_PROP(medium, 12)
    TOKEN_PROP(large, 16)
    TOKEN_PROP(largeIncreased, 20)
    TOKEN_PROP(extraLarge, 28)
    TOKEN_PROP(extraLargeIncreased, 32)
    TOKEN_PROP(extraExtraLarge, 48)

#undef TOKEN_PROP

public:
    explicit PaddingTokens(QObject* parent = nullptr) : QObject(parent) {}

    [[nodiscard]] qreal scale() const { return m_scale; }
    void setScale(qreal scale) {
        if (qFuzzyCompare(m_scale, scale))
            return;
        m_scale = scale;
        emit valuesChanged();
    }
    void loadJson(const QJsonObject& json);

signals:
    void valuesChanged();

private:
    qreal m_scale = 1.0;
};

class AnimDurationTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY valuesChanged)

#define TOKEN_PROP(name, defaultVal, ttyVal) \
    Q_PROPERTY(int name READ name NOTIFY valuesChanged) \
public: \
    int name() const { return m_tty ? ttyVal : static_cast<int>(m_##name * m_scale); } \
    void set_##name(int val) { m_##name = val; } \
private: \
    int m_##name = defaultVal;

    TOKEN_PROP(small, 200, TtyMove)
    TOKEN_PROP(normal, 400, TtyMove)
    TOKEN_PROP(large, 600, TtyMove)
    TOKEN_PROP(extraLarge, 1000, TtyMove)
    TOKEN_PROP(expressiveFastSpatial, 350, TtyMove)
    TOKEN_PROP(expressiveDefaultSpatial, 500, TtyMove)
    TOKEN_PROP(expressiveSlowSpatial, 650, TtyMove)
    TOKEN_PROP(expressiveFastEffects, 150, 1)
    TOKEN_PROP(expressiveDefaultEffects, 200, 1)
    TOKEN_PROP(expressiveSlowEffects, 300, 1)

#undef TOKEN_PROP

public:
    explicit AnimDurationTokens(QObject* parent = nullptr) : QObject(parent) {}

    [[nodiscard]] qreal scale() const { return m_scale; }
    void setScale(qreal scale) {
        if (qFuzzyCompare(m_scale, scale))
            return;
        m_scale = scale;
        emit valuesChanged();
    }
    void loadJson(const QJsonObject& json);
    // TTY: a move takes TtyMove ms (drawn in TtySteps hard frames by the
    // curves), a fade is a single frame
    static constexpr int TtyMove = 180;
    void setTty(bool tty) {
        if (m_tty == tty)
            return;
        m_tty = tty;
        emit valuesChanged();
    }

signals:
    void valuesChanged();

private:
    qreal m_scale = 1.0;
    bool m_tty = false;
};

class AnimCurves : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(QEasingCurve emphasized READ emphasized NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve emphasizedAccel READ emphasizedAccel NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve emphasizedDecel READ emphasizedDecel NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve standard READ standard NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve standardAccel READ standardAccel NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve standardDecel READ standardDecel NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveFastSpatial READ expressiveFastSpatial NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveDefaultSpatial READ expressiveDefaultSpatial NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveSlowSpatial READ expressiveSlowSpatial NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveFastEffects READ expressiveFastEffects NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveDefaultEffects READ expressiveDefaultEffects NOTIFY curvesChanged)
    Q_PROPERTY(QEasingCurve expressiveSlowEffects READ expressiveSlowEffects NOTIFY curvesChanged)
    Q_PROPERTY(atlas::config::AnimDurationTokens* durations READ durations CONSTANT)

public:
    explicit AnimCurves(QObject* parent = nullptr);

    QEasingCurve emphasized() const { return m_tty ? s_ttyCurve() : m_emphasized; }
    QEasingCurve emphasizedAccel() const { return m_tty ? s_ttyCurve() : m_emphasizedAccel; }
    QEasingCurve emphasizedDecel() const { return m_tty ? s_ttyCurve() : m_emphasizedDecel; }
    QEasingCurve standard() const { return m_tty ? s_ttyCurve() : m_standard; }
    QEasingCurve standardAccel() const { return m_tty ? s_ttyCurve() : m_standardAccel; }
    QEasingCurve standardDecel() const { return m_tty ? s_ttyCurve() : m_standardDecel; }
    QEasingCurve expressiveFastSpatial() const { return m_tty ? s_ttyCurve() : m_expressiveFastSpatial; }
    QEasingCurve expressiveDefaultSpatial() const { return m_tty ? s_ttyCurve() : m_expressiveDefaultSpatial; }
    QEasingCurve expressiveSlowSpatial() const { return m_tty ? s_ttyCurve() : m_expressiveSlowSpatial; }
    QEasingCurve expressiveFastEffects() const { return m_tty ? s_ttyCurve() : m_expressiveFastEffects; }
    QEasingCurve expressiveDefaultEffects() const { return m_tty ? s_ttyCurve() : m_expressiveDefaultEffects; }
    QEasingCurve expressiveSlowEffects() const { return m_tty ? s_ttyCurve() : m_expressiveSlowEffects; }

    AnimDurationTokens* durations() const { return m_durations; }
    void loadJson(const QJsonObject& json);
    void setTty(bool tty);

signals:
    void curvesChanged();

private:
    AnimDurationTokens* m_durations = nullptr;
    bool m_tty = false;
    // TTY's motion: the first of four even steps at once, then one each
    // redraw, never overshooting, like a screen repainted at ~16fps
    static QEasingCurve s_ttyCurve();
    QEasingCurve m_emphasized;
    QEasingCurve m_emphasizedAccel;
    QEasingCurve m_emphasizedDecel;
    QEasingCurve m_standard;
    QEasingCurve m_standardAccel;
    QEasingCurve m_standardDecel;
    QEasingCurve m_expressiveFastSpatial;
    QEasingCurve m_expressiveDefaultSpatial;
    QEasingCurve m_expressiveSlowSpatial;
    QEasingCurve m_expressiveFastEffects;
    QEasingCurve m_expressiveDefaultEffects;
    QEasingCurve m_expressiveSlowEffects;

    static QEasingCurve makeBezier(qreal p1x, qreal p1y, qreal p2x, qreal p2y);
    static QEasingCurve parseBezierList(const QJsonArray& arr, const QEasingCurve& fallback);
};

class SidebarSizeTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(int width READ width NOTIFY valuesChanged)

public:
    explicit SidebarSizeTokens(QObject* parent = nullptr) : QObject(parent) {}
    int width() const { return m_width; }
    void set_width(int w) { if (m_width != w) { m_width = w; emit valuesChanged(); } }

signals:
    void valuesChanged();

private:
    int m_width = 230;
};

class SizeTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(atlas::config::SidebarSizeTokens* sidebar READ sidebar CONSTANT)

public:
    explicit SizeTokens(QObject* parent = nullptr)
        : QObject(parent)
        , m_sidebar(new SidebarSizeTokens(this)) {}

    SidebarSizeTokens* sidebar() const { return m_sidebar; }
    void loadJson(const QJsonObject& json);

private:
    SidebarSizeTokens* m_sidebar = nullptr;
};

// MochiFile: Cindy-Dots "mochi" stilinin cizgi, golge ve kose olculeri.
// Sadece Colours.mochi acikken kullanilir.
class MochiTokens : public QObject {
    Q_OBJECT
    QML_ANONYMOUS

    Q_PROPERTY(qreal line MEMBER m_line CONSTANT)          // tus/kart cizgisi
    Q_PROPERTY(qreal thin MEMBER m_thin CONSTANT)          // cip, secili satir
    Q_PROPERTY(qreal hair MEMBER m_hair CONSTANT)          // bolum ayiraci
    Q_PROPERTY(qreal keyShadow MEMBER m_keyShadow CONSTANT)
    Q_PROPERTY(qreal smallShadow MEMBER m_smallShadow CONSTANT)
    Q_PROPERTY(qreal shadow MEMBER m_shadow CONSTANT)      // kart, menu, diyalog
    Q_PROPERTY(qreal keyRadius MEMBER m_keyRadius CONSTANT)
    Q_PROPERTY(qreal rowRadius MEMBER m_rowRadius CONSTANT)
    Q_PROPERTY(qreal itemRadius MEMBER m_itemRadius CONSTANT)
    Q_PROPERTY(qreal cardRadius MEMBER m_cardRadius CONSTANT)
    Q_PROPERTY(qreal sectionSpacing MEMBER m_sectionSpacing CONSTANT) // basliktaki harf araligi
    Q_PROPERTY(int navKeyWidth MEMBER m_navKeyWidth CONSTANT)
    Q_PROPERTY(int navKeyHeight MEMBER m_navKeyHeight CONSTANT)
    Q_PROPERTY(int navBarHeight MEMBER m_navBarHeight CONSTANT)
    Q_PROPERTY(int tabBarHeight MEMBER m_tabBarHeight CONSTANT)
    Q_PROPERTY(int tabHeight MEMBER m_tabHeight CONSTANT)
    Q_PROPERTY(int crumbHeight MEMBER m_crumbHeight CONSTANT)
    Q_PROPERTY(int pathHeight MEMBER m_pathHeight CONSTANT)
    Q_PROPERTY(int rowHeight MEMBER m_rowHeight CONSTANT)
    Q_PROPERTY(int barHeight MEMBER m_barHeight CONSTANT)
    Q_PROPERTY(int paneHeaderHeight MEMBER m_paneHeaderHeight CONSTANT)
    Q_PROPERTY(int statusHeight MEMBER m_statusHeight CONSTANT)
    Q_PROPERTY(int actionKeyHeight MEMBER m_actionKeyHeight CONSTANT)
    Q_PROPERTY(int previewWidth MEMBER m_previewWidth CONSTANT)
    Q_PROPERTY(int previewHeight MEMBER m_previewHeight CONSTANT)
    Q_PROPERTY(int chipHeight MEMBER m_chipHeight CONSTANT)
    Q_PROPERTY(int shortcutHeight MEMBER m_shortcutHeight CONSTANT)
    Q_PROPERTY(qreal shortcutRadius MEMBER m_shortcutRadius CONSTANT)
    Q_PROPERTY(qreal shortcutLine MEMBER m_shortcutLine CONSTANT)
    Q_PROPERTY(int checkSize MEMBER m_checkSize CONSTANT)

public:
    explicit MochiTokens(QObject* parent = nullptr) : QObject(parent) {}

private:
    qreal m_line = 3;
    qreal m_thin = 2.5;
    qreal m_hair = 2.5;
    qreal m_keyShadow = 4;
    qreal m_smallShadow = 3;
    qreal m_shadow = 6;
    qreal m_keyRadius = 14;
    qreal m_rowRadius = 12;
    qreal m_itemRadius = 18;
    qreal m_cardRadius = 26;
    qreal m_sectionSpacing = 0.9;
    int m_navKeyWidth = 44;
    int m_navKeyHeight = 40;
    int m_navBarHeight = 64;
    int m_tabBarHeight = 60;
    int m_tabHeight = 40;
    int m_crumbHeight = 30;
    int m_pathHeight = 44;
    int m_rowHeight = 36;
    int m_barHeight = 10;
    int m_paneHeaderHeight = 44;
    int m_statusHeight = 42;
    int m_actionKeyHeight = 54;
    int m_previewWidth = 340;
    int m_previewHeight = 200;
    int m_chipHeight = 26;
    int m_shortcutHeight = 22;
    qreal m_shortcutRadius = 7;
    qreal m_shortcutLine = 2;
    int m_checkSize = 24;
};

class TokensSingleton : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(atlas::config::RoundingTokens* rounding READ rounding CONSTANT)
    Q_PROPERTY(atlas::config::SpacingTokens* spacing READ spacing CONSTANT)
    Q_PROPERTY(atlas::config::PaddingTokens* padding READ padding CONSTANT)
    Q_PROPERTY(atlas::config::AnimCurves* anim READ anim CONSTANT)
    Q_PROPERTY(atlas::config::FontTokens* font READ font CONSTANT)
    Q_PROPERTY(atlas::config::SizeTokens* sizes READ sizes CONSTANT)
    Q_PROPERTY(atlas::config::MochiTokens* mochi READ mochi CONSTANT)

public:
    MochiTokens* mochi() const { return m_mochi; }

    RoundingTokens* rounding() const { return m_rounding; }
    SpacingTokens* spacing() const { return m_spacing; }
    PaddingTokens* padding() const { return m_padding; }
    AnimCurves* anim() const { return m_anim; }
    FontTokens* font() const { return m_font; }
    SizeTokens* sizes() const { return m_sizes; }

    void loadTokensFile(const QString& filePath);
    void loadShellConfigFile(const QString& filePath);
    void reload();

    // Switches the TTY look on or off: square corners, one monospace face
    // (preferredMono when installed) and motion in a few hard frames.
    void setTty(bool tty, const QString& preferredMono);

    // MochiFile: Cindy-Dots "mochi" yazilari (govde Zen Maru Gothic, buyuk basliklar
    // Mochiy Pop One). TTY aciksa TTY kazanir.
    void setMochi(bool mochi);

    static TokensSingleton* instance();
    static TokensSingleton* create(QQmlEngine* = nullptr, QJSEngine* = nullptr) {
        return instance();
    }

private:
    explicit TokensSingleton(QObject* parent = nullptr);
    RoundingTokens* m_rounding = nullptr;
    SpacingTokens* m_spacing = nullptr;
    PaddingTokens* m_padding = nullptr;
    AnimCurves* m_anim = nullptr;
    FontTokens* m_font = nullptr;
    SizeTokens* m_sizes = nullptr;
    MochiTokens* m_mochi = nullptr;
    QFileSystemWatcher m_watcher;
    bool m_tty = false;
};

} // namespace atlas::config
