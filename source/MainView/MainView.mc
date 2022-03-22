using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class MainView extends BaseView {

    private var _first as Bool = true;

    function initialize() {
        BaseView.initialize();
    }

    function startActivity() {
        var storedDev = App.getApp().getLastSavedDevice();
        if(null != storedDev) {
            App.getApp().getViewController().pushDeviceView(storedDev);
        } else {
            App.getApp().scanStart();
            App.getApp().getViewController().pushScanView(true, false);
        }
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        if(self._first) {
            if(!App.getApp().getPropertiesProvider().getShowSplash()) {
                self.startActivity();
            }
            Ui.requestUpdate();
            self._first = false;
        }
    }

    private function drawSign(dc) {

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        dc.setPenWidth(self.getWidthPercents(dc, 30));

        var center = [self.getWidthPercents(dc, 50), self.getHeightPercents(dc, 50)];

//        var color = Tools.getRandomColor(0x60, 0xA0);
//        System.println("Color: " + color.format("%02x"));
//        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.setColor(0x303000, Gfx.COLOR_BLACK);

        dc.fillCircle(center[0], center[1], dc.getWidth() / 2 + 2);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);

        dc.setColor(0x000000, Gfx.COLOR_BLUE);

        var max = self.getWidthPercents(dc, 30);
        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(30), Tools.convertDegreeValue(90));

        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_COUNTER_CLOCKWISE,
            Tools.convertDegreeValue(-30), Tools.convertDegreeValue(-90));

        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(150), Tools.convertDegreeValue(210));

        dc.fillCircle(center[0], center[1], self.getWidthPercents(dc, 10));
        dc.setPenWidth(1);
    }

    function onUpdate(dc) {

        self.drawSign(dc);

        var mainLabel = self.findDrawable("MainCenterText");
        var pressLable = self.findDrawable("MainPressMenuText");
        mainLabel.setColor(Gfx.COLOR_WHITE);
        pressLable.setColor(Gfx.COLOR_LT_GRAY);
        mainLabel.draw(dc);
        pressLable.draw(dc);
    }

    public static function getView() {
        return [new MainView(), new MainViewDelegate()];
    }
}
