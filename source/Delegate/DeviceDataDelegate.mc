using Toybox.WatchUi as Ui;
using Toybox.Attention;
using Toybox.Application as App;

class DeviceDataDelegate extends Ui.BehaviorDelegate {

    const INDEX_NONE = -1;
    const INDEX_MEASURING = 0;

    private var _deviceDataController;
    private var _views;
    private var _viewId;

    function initialize(deviceDataController) {
        BehaviorDelegate.initialize();
        self._deviceDataController = deviceDataController;
        self._views = [
            [new MeasuringView(deviceDataController), self]
        ];
        self._viewId = INDEX_NONE;
    }

    private function getApp() {
        return App.getApp();
    }

    function onConfirmExit(opts) {
        self._deviceDataController.stop();
        if(self._viewId != INDEX_NONE) {
            Ui.popView(Ui.SLIDE_DOWN);
        }
        self._views = [];
        self._deviceDataController = null;
        Ui.popView(Ui.SLIDE_DOWN);
    }

    function onBack() {
        if(App.getApp().getPropertiesProvider().getUseExtendedMode()) {
            Ui.popView(Ui.SLIDE_UP);
        } else {
            self.getApp().getViewController().pushConfirmationMenu(self);
        }
        return true;
    }

    function onMenu() {
        self.getApp().getViewController().pushDeviceMenu(self._deviceDataController);
        return true;
    }

    function onNextMode() {
        return true;
    }

    function onNextPage() {
        var lastPage = (self._views.size() - 1);
        if(self._viewId == INDEX_NONE) {
            self._viewId++;
            Ui.pushView(
                self._views[self._viewId][0],
                self._views[self._viewId][1],
                Ui.SLIDE_UP
            );
        } else if(self._viewId < lastPage) {
            self._viewId++;
            Ui.switchToView(
                self._views[self._viewId][0],
                self._views[self._viewId][1],
                Ui.SLIDE_UP
            );
        }
        return true;
    }

    function onPreviousMode() {
        return true;
    }

    function onPreviousPage() {
        if(self._viewId == 0) {
            self._viewId--;
            Ui.popView(Ui.SLIDE_DOWN);
        } else if(self._viewId > 0) {
            self._viewId--;
            Ui.switchToView(
                self._views[self._viewId][0],
                self._views[self._viewId][1],
                Ui.SLIDE_DOWN);
        }

        return true;
    }

    function onSelect() {
        switch(self._viewId) {
        case INDEX_NONE:
            if(self._viewId == INDEX_NONE) {
                var detailsView = new DeviceDetailsView(
                        self._deviceDataController,
                        self.getApp().getPropertiesProvider());
                Ui.pushView(detailsView, new DeviceDetailsDelegate(self._deviceDataController), Ui.SLIDE_LEFT);
            }
            break;
        case INDEX_MEASURING:
            if(self._deviceDataController.getReady()) {
                var md = self._deviceDataController.getMeasuringData();
                if(md.enabled) {
                    md.enabled = false;
                } else {
                    md.reset(self._deviceDataController, true);
                }
            }
            Ui.requestUpdate();
            break;
        }
        return true;
    }
}
