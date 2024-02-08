
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;


var listener = new CommListener();

function sendPing() {
    Comm.transmit({"action" => "ping"}, null, listener);
}

class CommListener extends Comm.ConnectionListener {
    function initialize() {
        Comm.ConnectionListener.initialize();
    }

    function onComplete() {
        Sys.println("Transmit Complete");
    }

    function onError() {
        Sys.println("Transmit Failed");
    }
}

class ConfirmationDialogDelegate extends Ui.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }
    
    function onResponse(value) {
        if (value == 0) {
            System.println("User cancelled. nothing to do.");
        } else {
            System.println("User wants to quit.");
            Ui.popView(Ui.SLIDE_RIGHT);
        }
    }
}

class CommInputDelegate extends Ui.BehaviorDelegate {
    var listener = new CommListener();

    function initialize() {
        Ui.BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new Ui.Menu();
        var delegate;

        menu.addItem("Send Data", :sendData);
        menu.addItem("Set Listener", :setListener);
        delegate = new BaseMenuDelegate();
        Ui.pushView(menu, delegate, SLIDE_IMMEDIATE);

        return true;
    }
    
    // Detect Menu button input
    function onKey(event) {
        System.println(event.getKey()); // e.g. KEY_MENU = 7
        if (event.getKey() == Ui.KEY_ENTER) {
            if (status.isCurrent) {
                if (status.isWorking && !status.taskIsBreak) {
                    Comm.transmit({"action" => "stop"}, null, listener);
                } else {
                    Comm.transmit({"action" => "start"}, null, listener);
                }
                return true;
            }
        }
        if (Toybox.WatchUi has :EXTENDED_KEYS) {
            if (event.getKey() == Ui.KEY_LAP) {
                //return doPause();
                return false;
            }
        }
    }
    
    function doPause() {
        if (status.isCurrent) {
            if (status.isWorking) {
                Comm.transmit({"action" => "start_break"}, null, listener);
                return true;
            }
        }
        return false;
    }


    function onTap(event) {
        System.println("Tapped.");
        Ui.requestUpdate();
        if (!status.isCurrent) {
            sendPing();
            return true;
        } else {
            if (status.isWorking) {
                
            }
        }
        return false;
    }
    
    function onSelectable(event) {
        System.println("selectable: " + event.getInstance());
    }
    
    function onBack() {
        System.println("Back pressed.");
        if (doPause()) {
            return true;
        }
        var dialog = new Ui.Confirmation("Quit App?");
        Ui.pushView(dialog, new ConfirmationDialogDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
}

class BaseMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var menu = new Ui.Menu();
        var delegate = null;

        if(item == :sendData) {
            menu.addItem("Hello World.", :hello);
            menu.addItem("Ackbar", :trap);
            menu.addItem("Garmin", :garmin);
            delegate = new SendMenuDelegate();
        } else if(item == :setListener) {
            menu.setTitle("Listner Type");
            menu.addItem("Mailbox", :mailbox);
            if(Comm has :registerForPhoneAppMessages) {
                menu.addItem("Phone App", :phone);
            }
            menu.addItem("None", :none);
            menu.addItem("Crash if 'Hi'", :phoneFail);
            delegate = new ListnerMenuDelegate();
        }

        Ui.pushView(menu, delegate, SLIDE_IMMEDIATE);
    }
}

class SendMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var listener = new CommListener();

        if(item == :hello) {
            Comm.transmit("Hello World.", null, listener);
        } else if(item == :trap) {
            Comm.transmit("IT'S A TRAP!", null, listener);
        } else if(item == :garmin) {
            Comm.transmit("ConnectIQ", null, listener);
        }

        Ui.popView(SLIDE_IMMEDIATE);
    }
}

class ListnerMenuDelegate extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if(item == :mailbox) {
            Comm.setMailboxListener(mailMethod);
        } else if(item == :phone) {
            if(Comm has :registerForPhoneAppMessages) {
                Comm.registerForPhoneAppMessages(phoneMethod);
            }
        } else if(item == :none) {
            Comm.registerForPhoneAppMessages(null);
            Comm.setMailboxListener(null);
        } else if(item == :phoneFail) {
            crashOnMessage = true;
            Comm.registerForPhoneAppMessages(phoneMethod);
        }

        Ui.popView(SLIDE_IMMEDIATE);
    }
}

