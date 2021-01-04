

class OperationsQueue {

    private var _queue;
    enum {
        POSITION_CALL = 0,
        POSITION_PARAMS = 1
    }

    function initialize() {
        self._queue = [];
    }

    function push(call, callParams, callback, callbackParams) {
        self._queue.add([
            [call, callParams],
            [callback, callbackParams]
        ]);
        return self.size() - 1;
    }

    function pushAndStart(call, callParams, callback, callbackParams) {
        if(self.push(call, callParams, callback, callbackParams) == 0) {
            System.println("Starting Queue!");
            self.callTop();
        }
    }

    function start() {
        self.callTop();
    }

    function callTop() {
        if(self.size() > 0) {
            var top = self._queue[0][0];
            return self.invokeCall(top[POSITION_CALL], top[POSITION_PARAMS]);
        } else {
            System.println("queue is emprty");
        }
        return null;
    }

    function callbackTop(params) {
        if(self.size() > 0) {
            var top = self._queue[0][1];
            return self.invoke(top[POSITION_CALL], top[POSITION_PARAMS], params);
        } else {
            System.println("callbacks are empty");
        }
        return null;
    }

    function size() {
        return self._queue.size();
    }

    function pop() {
        self._queue = self._queue.slice(1, self._queue.size());
    }

    function popAndCall() {
        self.pop();
        self.callTop();
    }

    function clear() {
        self._queue = [];
    }

    function invokeCall(meth, params) {
        return meth.invoke(params);
    }

    function invoke(meth, params, passed) {
        return meth.invoke(params, passed);
/*
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
*/
    }
}

