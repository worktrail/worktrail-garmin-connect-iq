
using Toybox.Application as App;
using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

var mailMethod;
var phoneMethod;
var crashOnMessage = false;

var status = new Status();

class Status {
    var isCurrent = false;
    var taskName = null;
    var taskIsBreak = false;
    var isWorking = false;
    
    function updateFromStatus(status) {
        isCurrent = true;
        taskName = status["task_name"];
        taskIsBreak = status["task_is_break"];
        isWorking = status["working"];
        System.println("working? " + isWorking + "  taskName: " + taskName);
    }
}

class WorkTrailApp extends App.AppBase {

    function initialize() {
        App.AppBase.initialize();

        mailMethod = method(:onMail);
        phoneMethod = method(:onPhone);
        if(Comm has :registerForPhoneAppMessages) {
            Comm.registerForPhoneAppMessages(phoneMethod);
        } else {
            Comm.setMailboxListener(mailMethod);
        }
        sendPing();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [new WorkTrailView(), new CommInputDelegate()];
    }

    function onMail(mailIter) {
        var mail;

        mail = mailIter.next();

        while(mail != null) {
            var i;
            for(i = (stringsSize - 1); i > 0; i -= 1) {
                strings[i] = strings[i-1];
            }
            strings[0] = mail.toString();
            page = 1;
            mail = mailIter.next();
        }

        Comm.emptyMailbox();
        Ui.requestUpdate();
    }

    function onPhone(msg) {
        var i;
        
        status.updateFromStatus(msg.data);

        Ui.requestUpdate();
    }

}