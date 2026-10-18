import Toybox.Lang;
import Toybox.WatchUi;

class RadiacodeMonitorDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RadiacodeMonitorMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}