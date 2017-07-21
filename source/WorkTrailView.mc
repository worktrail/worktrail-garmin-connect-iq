
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
        bitmapLogo.locX = dc.getWidth()/2 - bitmapLogo.width/2;
        bitmapLogo.locY = 2;
        bitmapLogo.draw(dc);

        if (dc.getWidth() > 150) {
            // For wider screens, we 4 lines are enough
            var y = 60;
            dc.drawText(dc.getWidth() / 2, y,  Gfx.FONT_LARGE, "WorkTrail", Gfx.TEXT_JUSTIFY_CENTER);
            y+=28;
            dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_SMALL, "Please connect your phone", Gfx.TEXT_JUSTIFY_CENTER);
            y+=18;
            dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_SMALL, "with WorkTrail installed.", Gfx.TEXT_JUSTIFY_CENTER);
            y+=18;
            dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_TINY, "https://worktrail.net/", Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            // Vivoactive HR has a narrower screen.
            var y = 60;
            dc.drawText(dc.getWidth() / 2, y,  Gfx.FONT_LARGE, "WorkTrail", Gfx.TEXT_JUSTIFY_CENTER);
            y+=28;
            dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_SMALL, "Please connect your\nphone with WorkTrail\ninstalled.", Gfx.TEXT_JUSTIFY_CENTER);
            y+=(18*5);
            dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_TINY, "https://worktrail.net/", Gfx.TEXT_JUSTIFY_CENTER);
        }

    }


    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        if (!status.isCurrent) {
            drawIntroPage(dc);
        } else {
            drawWithoutLogo(dc);
            //drawHorizontalVariant(dc);
            //drawVerticalVariant(dc);
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(0, dc.getHeight()-dc.getFontHeight(Gfx.FONT_TINY), Gfx.FONT_XTINY, "https://worktrail.net/", Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
    
    function drawWithoutLogo(dc) {
        drawWorkStatus(dc, 0, 0, dc.getWidth(), dc.getHeight());
    }
    
    /// Logo on the left
    function drawHorizontalVariant(dc) {
        bitmapLogo.locX = 0;
        bitmapLogo.locY = dc.getHeight()/2 - bitmapLogo.width/2;
        bitmapLogo.draw(dc);
        
        drawWorkStatus(dc, bitmapLogo.width + 5, 0, dc.getWidth() - bitmapLogo.width+5, dc.getHeight());
    }
    
    /// Logo on top, below status, task and "button"
    function drawVerticalVariant(dc) {
        System.println("Drawing bitmap? " + (bitmapLogo != null));
        bitmapLogo.locX = dc.getWidth()/2 - bitmapLogo.width/2;
        bitmapLogo.draw(dc);
        
        drawWorkStatus(dc, 0, 80, dc.getWidth(), dc.getHeight() - 80);
    }
    
    function drawWorkStatus(dc, x, y, width, height) {
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
        

        dc.setColor(statusColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + width / 2, y,  Gfx.FONT_LARGE, statusMsg, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        if (status.taskName != null) {
            dc.drawText(x + width / 2, y+30, Gfx.FONT_SMALL, status.taskName, Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        dc.setColor( 0xff55ff, Gfx.COLOR_RED);
        var dimensions = dc.getTextDimensions(actionButton, Gfx.FONT_MEDIUM);
        var ypos = y + 80;
        dc.fillRoundedRectangle(x + width/2 - dimensions[0]/2 - 20, ypos - 10, dimensions[0] + 40, dimensions[1]+20, 5);
        dc.setColor(Gfx.COLOR_BLACK, 0xff55ff);
        dc.drawText(x + width / 2, ypos, Gfx.FONT_MEDIUM, actionButton, Gfx.TEXT_JUSTIFY_CENTER);
        
        
    }


}