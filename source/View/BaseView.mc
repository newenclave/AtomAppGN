using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class BaseView extends Ui.View {
    function initialize() {
        View.initialize();
    }

    function getTheme() {
        return App.getApp().getTheme();
    }

    static function getWidthPercents(dc, value) {
        return (dc.getWidth().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    static function getHeightPercents(dc, value) {
        return (dc.getHeight().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    function drawBg(dc) {
        var theme = self.getTheme();
        dc.setColor(theme.COLOR_BACKGROUND, theme.COLOR_FOREGROUND);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(theme.COLOR_FOREGROUND, theme.COLOR_BACKGROUND);
    }

    function findDrawable(id) {
        var drawable = Ui.View.findDrawableById(id);
        drawable.setColor(self.getTheme().COLOR_FOREGROUND);
        return drawable;
    }
}
