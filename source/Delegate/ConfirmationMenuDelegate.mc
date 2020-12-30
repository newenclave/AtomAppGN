using Toybox.WatchUi as Ui;

class ConfirmationMenuDelegate extends Ui.Menu2InputDelegate {

    private var _delegate;

    function initialize(delegate) {
        Menu2InputDelegate.initialize();
        self._delegate = delegate;
    }

    function onSelect(item) {
        switch(item.getId()) {
        case "ItemNo":
            Ui.popView(Ui.SLIDE_UP);
            break;
        case "ItemYes":
            Ui.popView(Ui.SLIDE_UP);
            self._delegate.onConfirmExit({});
            break;
        }
    }
}
