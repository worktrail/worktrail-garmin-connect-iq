
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Communications as Comm;
using Toybox.System as Sys;

class WorkTrailView extends Ui.View {
    var screenShape;
    var bitmapLogo;

    function initialize() {
        View.initialize();
        bitmapLogo = new Ui.Bitmap({
            :rezId=>Rez.Drawables.id_worktraillogo,
            :locX=>10,
            :locY=>10
        });
    }

    function onLayout(dc) {
        screenShape = Sys.getDeviceSettings().screenShape;
    }

    function drawIntroPage(dc) {
        if(Sys.SCREEN_SHAPE_ROUND == screenShape) {
            dc.drawText(dc.getWidth() / 2, 25,  Gfx.FONT_SMALL, "Communications", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 55, Gfx.FONT_SMALL, "Test", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 80,  Gfx.FONT_TINY,  "Connect a phone then", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 100,  Gfx.FONT_TINY,  "use the menu to send", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 120,  Gfx.FONT_TINY,  "strings to your phone", Gfx.TEXT_JUSTIFY_CENTER);
        } else if(Sys.SCREEN_SHAPE_SEMI_ROUND == screenShape) {
            dc.drawText(dc.getWidth() / 2, 20,  Gfx.FONT_MEDIUM, "Communications test", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 50,  Gfx.FONT_SMALL,  "Connect a phone", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 70,  Gfx.FONT_SMALL,  "Then use the menu to send", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 90,  Gfx.FONT_SMALL,  "strings to your phone", Gfx.TEXT_JUSTIFY_CENTER);
        } else if(dc.getWidth() > dc.getHeight()) {
            dc.drawText(10, 20,  Gfx.FONT_MEDIUM, "Communications test", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 50,  Gfx.FONT_SMALL,  "Connect a phone", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70,  Gfx.FONT_SMALL,  "Then use the menu to send", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90,  Gfx.FONT_SMALL,  "strings to your phone", Gfx.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(10, 20, Gfx.FONT_MEDIUM, "Communications test", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 40, Gfx.FONT_MEDIUM, "Test", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 70, Gfx.FONT_SMALL, "Connect a phone", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 90, Gfx.FONT_SMALL, "Then use the menu", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 110, Gfx.FONT_SMALL, "to send strings", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(10, 130, Gfx.FONT_SMALL, "to your phone", Gfx.TEXT_JUSTIFY_LEFT);
        }
    }


    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        if(page == 0) {
            drawIntroPage(dc);
        } else {
            var i;
            var y = 50;
            
            var statusColor;
            var statusMsg;
            var actionButton;
            
            if (!status.isWorking) {
                statusColor = Gfx.COLOR_RED;
                statusMsg = "Signed Out";
                actionButton = "Start";
            } else if (status.taskIsBreak) {
                statusColor = Gfx.COLOR_BLUE;
                statusMsg = "Break";
                actionButton = "Resume";
            } else {
                statusColor = Gfx.COLOR_GREEN;
                statusMsg = "Working";
                actionButton = "Stop";
            }
            
            //dc.drawBitmap(5, 20, bitmapLogo);
            System.println("Drawing bitmap? " + (bitmapLogo != null));
            bitmapLogo.locX = dc.getWidth()/2 - bitmapLogo.width/2;
            bitmapLogo.draw(dc);

            dc.setColor(statusColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, 80,  Gfx.FONT_LARGE, statusMsg, Gfx.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            if (status.taskName != null) {
                dc.drawText(dc.getWidth() / 2, 110, Gfx.FONT_SMALL, status.taskName, Gfx.TEXT_JUSTIFY_CENTER);
            }
            
            dc.setColor( /*Gfx.COLOR_PURPLE*/ 0x5500AA, Gfx.COLOR_RED);
            var dimensions = dc.getTextDimensions(actionButton, Gfx.FONT_MEDIUM);
            var ypos = 160;
            dc.fillRoundedRectangle(dc.getWidth()/2 - dimensions[0]/2 - 20, ypos - 10, dimensions[0] + 40, dimensions[1]+20, 5);
            dc.setColor(Gfx.COLOR_BLACK, /*Gfx.COLOR_PURPLE*/ 0x5500AA);
            dc.drawText(dc.getWidth() / 2, ypos, Gfx.FONT_MEDIUM, actionButton, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }


}