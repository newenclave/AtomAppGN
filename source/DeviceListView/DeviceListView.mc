using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time;

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

    function drawTopArc(dc, color) {
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var radius = dc.getWidth() / 2;
        dc.setPenWidth(10);
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(270 + 20), Tools.convertDegreeValue(90 - 20));
        dc.setPenWidth(1);
    }

    function drawBottomArc(dc, color) {
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var radius = dc.getWidth() / 2;
        dc.setPenWidth(10);
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(90 + 15), Tools.convertDegreeValue(270 - 15));
        dc.setPenWidth(1);
    }

    function drawFullArc(dc, color) {

        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var radius = dc.getWidth() / 2;

        dc.setPenWidth(10);
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius, Gfx.ARC_CLOCKWISE, 0, 0);

        dc.setPenWidth(2);
        dc.setColor(self.getTheme().COLOR_DARK, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius - 6, Gfx.ARC_CLOCKWISE, 0, 0);

    }

    function drawArc(dc, color) {
        var center = [dc.getWidth() / 2, dc.getHeight() / 2];
        var radius = dc.getWidth() / 2;

        dc.setPenWidth(2);
        dc.setColor(self.getTheme().COLOR_DARK, Gfx.COLOR_BLACK);
        dc.drawLine(self.getWidthPercents(dc, 5),
                    self.getHeightPercents(dc, 34.5),
                    self.getWidthPercents(dc, 95),
                    self.getHeightPercents(dc, 34.5));

        dc.drawLine(self.getWidthPercents(dc, 5),
                    self.getHeightPercents(dc, 62.5),
                    self.getWidthPercents(dc, 95),
                    self.getHeightPercents(dc, 62.5));

        dc.setPenWidth(10);
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawArc(center[0], center[1], radius, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(270 - 15), Tools.convertDegreeValue(270 + 20));

        dc.drawArc(center[0], center[1], radius, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(90 - 20), Tools.convertDegreeValue(90 + 15));

        dc.setPenWidth(2);
        dc.setColor(self.getTheme().COLOR_DARK, Gfx.COLOR_BLACK);

        dc.drawArc(center[0], center[1], radius - 6, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(270 - 15), Tools.convertDegreeValue(270 + 20));

        dc.drawArc(center[0], center[1], radius - 6, Gfx.ARC_CLOCKWISE,
            Tools.convertDegreeValue(90 - 20), Tools.convertDegreeValue(90 + 15));
        dc.setPenWidth(1);
    }

    function onUpdate(dc) {
        self.drawBg(dc);
        var devStor = App.getApp().getDeviceStorage();
        var curDev = devStor.getCurrent();
        var label = self.findDrawable("DeviceListDeviceName");
        var counter = self.findDrawable("DeviceListDeviceCounter");

        if(null != curDev) {
            label.setText(curDev.getName());
            self.drawLastUse(dc, curDev);

//            self.drawFullArc(dc, curDev.getColor());
//            counter.setText((devStor.getCurrentId() + 1).toString() +
//                            "/" + devStor.getSize().toString());
//            counter.draw(dc);

            self.drawArc(dc, curDev.getColor());
            self.drawPrev(dc);
            self.drawNext(dc);
        } else {
            var usageLabel = self.findDrawable("DeviceListLastUsage");
            label.setText(App.loadResource(Rez.Strings.menu_text_no_devices));
            usageLabel.setText(App.loadResource(Rez.Strings.text_press_menu_to_add));
            usageLabel.setColor(self.getTheme().COLOR_DARK);
            usageLabel.draw(dc);
        }
        label.draw(dc);
    }

    function drawLastUse(dc, cur) {
        var useTime = self.findDrawable("DeviceListLastUsage");
        useTime.setText(self.timeToString(cur.getLastUse()));
        useTime.setColor(self.getTheme().COLOR_DARK);
        useTime.draw(dc);
    }

    function drawPrev(dc) {
        var dev = App.getApp().getDeviceStorage().getPrev();
        self.drawSecontary(dc,
            dev, "DeviceListDeviceNamePrev", "DeviceListLastUsagePrev");
        if(null != dev) {
            self.drawTopArc(dc, dev.getColor());
        }
    }

    function drawNext(dc) {
        var dev = App.getApp().getDeviceStorage().getNext();
        self.drawSecontary(dc,
            dev, "DeviceListDeviceNameNext", "DeviceListLastUsageNext");
        if(null != dev) {
            self.drawBottomArc(dc, dev.getColor());
        }
    }

    function drawSecontary(dc, dev, labelName, usageLabelName) {
        if(null != dev) {
            var label = self.findDrawable(labelName);
            var useTime = self.findDrawable(usageLabelName);
            useTime.setText(self.timeToString(dev.getLastUse()));
            useTime.setColor(self.getTheme().COLOR_DARK);
            label.setColor(self.getTheme().COLOR_DARK);
            label.setText(dev.getName());
            label.draw(dc);
            useTime.draw(dc);
        }
    }

    private function timeToString(time) {
        if(time == 0) {
            return App.loadResource(Rez.Strings.text_never);
        } else {
            var moment = new Time.Moment(time);
            var date = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
            var dateStr = date.year.format("%d") + "/"
                        + date.month.format("%02d") + "/"
                        + date.day.format("%02d") + " "
                        + date.hour.format("%02d") + ":"
                        + date.min.format("%02d")
                        ;
            return dateStr;
        }
    }
}
