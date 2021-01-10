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

//    private function getWidthPercents(dc, value) {
//        return (dc.getWidth().toFloat() * (value.toFloat() / 100.0)).toNumber();
//    }
//
//    private function getHeightPercents(dc, value) {
//        return (dc.getHeight().toFloat() * (value.toFloat() / 100.0)).toNumber();
//    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
