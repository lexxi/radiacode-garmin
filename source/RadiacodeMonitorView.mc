
import Toybox.Graphics;
import Toybox.WatchUi;

class RadiacodeMonitorView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var x = w / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // DOSISLEISTUNG
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, h * 16 / 100,
            Graphics.FONT_SMALL,
            "DOSISLEISTUNG",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Dosisleistung: Wert und Einheit nebeneinander
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x + 35, h * 33 / 100,
            Graphics.FONT_NUMBER_MEDIUM,
            "0.124",
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.drawText(
            x + 40, h * 39 / 100,
            Graphics.FONT_SMALL,
            "\u00B5Sv/h",
            Graphics.TEXT_JUSTIFY_LEFT
        );

        // DOSIS
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, h * 59 / 100,
            Graphics.FONT_SMALL,
            "DOSIS",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Dosis: Wert und Einheit nebeneinander
        dc.drawText(
            x + 20, h * 74 / 100,
            Graphics.FONT_LARGE,
            "0.86",
            Graphics.TEXT_JUSTIFY_RIGHT
        );
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x + 25, h * 77 / 100,
            Graphics.FONT_SMALL,
            "\u00B5Sv",
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}
