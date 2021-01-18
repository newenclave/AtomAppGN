using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class MainView extends BaseView {

    function initialize() {
        BaseView.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    private function getWidthPercents(dc, value) {
        return (dc.getWidth().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    private function getHeightPercents(dc, value) {
        return (dc.getHeight().toFloat() * (value.toFloat() / 100.0)).toNumber();
    }

    private function drawSign(dc) {
        dc.setPenWidth(getWidthPercents(dc, 30));

        var center = [getWidthPercents(dc, 50), getHeightPercents(dc, 50)];
        dc.setColor(0x303000, Gfx.COLOR_BLACK);
        dc.fillCircle(center[0], center[1], dc.getWidth() / 2 + 2);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);

        dc.setColor(0x000000, Gfx.COLOR_BLUE);

        var max = getWidthPercents(dc, 30);
        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(30), Tools.convertDegreeValue(90));

        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_COUNTER_CLOCKWISE,
            Tools.convertDegreeValue(-30), Tools.convertDegreeValue(-90));

        dc.drawArc(center[0], center[1],
            max, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(150), Tools.convertDegreeValue(210));

        dc.fillCircle(center[0], center[1], getWidthPercents(dc, 10));
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

    function onHide() {
    }

    public static function getView() {
        return [new MainView(), new MainViewDelegate()];
    }
}
