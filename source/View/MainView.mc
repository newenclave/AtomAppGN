using Toybox.WatchUi as Ui;

class MainView extends BaseView {

    function initialize() {
        BaseView.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    function onHide() {
    }

}
