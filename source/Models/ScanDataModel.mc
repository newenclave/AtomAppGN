using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class ScanDataModel {

    private var _data;
    private var _index;

    function initialize() {
        self._data = [];
        self._index = 0;
    }

    function next() {
        if(self._data.size() > 0) {
            self._index++;
            if(self._data.size() == self._index) {
                self._index--;
            }
        }
    }

    function prev() {
        if(self._index > 0) {
            self._index--;
        }
    }

    function getNext() {
        return self.getElement(self._index + 1);
    }

    function getPrev() {
        return self.getElement(self._index - 1);
    }

    function getCur() {
        return self.getElement(self._index);
    }

    function add(value) {
        var newDev = true;
        for(var i = 0; i<_data.size(); i++) {
            if(_data[i].isSameDevice(value)) {
                newDev = false;
                self._data[i] = value;
                break;
            }
        }
        if(newDev) {
            self._data = self._data.add(value);
        }
    }

    public function getIndex() {
        return self._index;
    }

    public function getSize() {
        return self._data.size();
    }

    function clear() {
        self._data = [];
    }

    private function getElement(index) {
        if((index >= 0) && (index < self.getSize())) {
            return self._data[index];
        } else {
            return null;
        }
    }

}
