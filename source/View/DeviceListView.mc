using Toybox.WatchUi as Ui;

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

    function onUpdate(dc) {
        BaseView.onUpdate(dc);
    }
}
