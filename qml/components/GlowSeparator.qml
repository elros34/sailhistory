import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    width: parent.width
    height: Theme.paddingMedium
    property color recColor: Theme.highlightColor

    Rectangle {
        anchors.centerIn: parent
        rotation: 90
        width: 2
        height: parent.width
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "transparent";
            }
            GradientStop {
                position: 0.50;
                color: recColor
            }
            GradientStop {
                position: 1.00;
                color: "transparent";
            }
        }
    }
}
