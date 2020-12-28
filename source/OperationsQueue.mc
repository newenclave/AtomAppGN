

class OperationsQueue {

    private var _queue;

    function initialize() {
        self._queue = [];
    }

    function push(call, callParams, callback, callbackParams) {
        self._queue.add([{
            :call => call,
            :params => callParams
        }, {
            :call => callback,
            :params => callbackParams
        }]);
        return self.size() - 1;
    }

    function callTop(params) {
        if(self.size() > 0) {
            var top = self._queue[0][0];
            params.addAll(top.get(:params));
            return self.invoke(top.get(:call), params);
        } else {
            System.println("callTop is emprty");
        }
        return null;
    }

    function callbackTop(params) {
        if(self.size() > 0) {
            var top = self._queue[0][1];
            params.addAll(top.get(:params));
            return self.invoke(top.get(:call), params);
        } else {
            System.println("callbackTop is emprty");
        }
        return null;
    }

    function size() {
        return self._queue.size();
    }

    function pop() {
        self._queue = self._queue.slice(1, self._queue.size());
    }

    function clear() {

    }

    function invoke(meth, params) {
        switch(params.size()) {
        case 0:
            return meth.invoke();
        case 1:
            return meth.invoke(params[0]);
        case 2:
            return meth.invoke(params[0], params[1]);
        case 3:
            return meth.invoke(params[0], params[1], params[2]);
        case 4:
            return meth.invoke(params[0], params[1], params[2], params[3]);
        case 5:
            return meth.invoke(params[0], params[1], params[2], params[3], params[4]);
        case 6:
            return meth.invoke(params[0], params[1], params[2], params[3], params[4], params[5]);
        case 7:
            return meth.invoke(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
        case 8:
            return meth.invoke(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[8]);
            break;
        default:
            System.println("Invalid params count " + params.size().toString());
        }
        return null;
    }
}

