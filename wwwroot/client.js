var term, websocket, containerId = '', command = '';

function getQueryVar(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) {
            return pair[1];
        }
    }

    return false;
}

containerId = getQueryVar('cid');
if (!containerId) {
    containerId = prompt('Container ID');
}

command = getQueryVar('cmd');
if (!command) {
    command = '/bin/bash';
}

websocket = new WebSocket("ws://" + window.location.hostname + ":" + window.location.port + window.location.pathname + "exec/" + containerId + ',' + window.btoa(command));

websocket.onopen = function (evt) {
    term = new Terminal({
        screenKeys: true,
        useStyle: true,
        cursorBlink: true,
    });

    term.writeln('\x1b[0;36mWelcome to container web terminal\x1b[0m');
    term.writeln('');

    term.onData(function (data) {
        websocket.send(data);
    });

    term.onTitleChange(function (title) {
        document.title = title;
    });

    term.open(document.getElementById('container-terminal'));
    term.focus();

    websocket.onmessage = function (evt) {
        term.write(evt.data);
    }

    websocket.onclose = function (evt) {
        term.writeln('');
        term.write("\x1b[0;31mSession terminated\x1b[0m");
        term.destroy();
    }

    websocket.onerror = function (evt) {
        if (typeof console.log == "function") {
            console.log(evt)
        }
    }
}