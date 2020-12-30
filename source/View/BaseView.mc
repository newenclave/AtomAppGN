using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class BaseView extends Ui.View {
    function initialize() {
        View.initialize();
    }

    function getTheme() {
        return App.getApp().getTheme();
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
