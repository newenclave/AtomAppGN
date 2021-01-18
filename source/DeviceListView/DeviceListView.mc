using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class DeviceListView extends BaseView {

    function initialize() {
        BaseView.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.DeviceListLayout(dc));
    }

    function onShow() {
    }

    function onHide() {
    }

    function drawArc(dc, color) {
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var radius = dc.getWidth() / 2;

        dc.setPenWidth(12);
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius, Gfx.ARC_COUNTER_CLOCKWISE, 0, 0);
        dc.setPenWidth(1);

        dc.setColor(self.getTheme().COLOR_DARK, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius - 8, Gfx.ARC_COUNTER_CLOCKWISE, 0, 0);
    }

    function onUpdate(dc) {
        self.drawBg(dc);
        var curDev = App.getApp().getDeviceStorage().getCurrent();
        if(null != curDev) {
            var label = self.findDrawable("DeviceListDeviceName");
            label.setText(curDev.getName());
            label.draw(dc);
            self.drawArc(dc, curDev.getColor());
            self.drawLastUse(dc, curDev);
        }
    }

    function drawLastUse(dc, cur) {
        var useTime = self.findDrawable("DeviceListLastUsage");

        if(cur.getLastUse() == 0) {
            useTime.setText(Rez.Strings.text_never);
        } else {
            var moment = new Time.Moment(cur.getLastUse());
            var date = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
            var dateStr = date.year.format("%d") + "/"
                        + date.month.format("%02d") + "/"
                        + date.day.format("%02d") + " "
                        + date.hour.format("%02d") + ":"
                        + date.min.format("%02d")
                        ;

            useTime.setText(dateStr);
        }
        useTime.setColor(self.getTheme().COLOR_DARK);
        useTime.draw(dc);
    }
}
