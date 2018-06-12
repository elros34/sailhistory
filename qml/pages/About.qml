import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "About"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Sailhistory"
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
            }

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                wrapMode: Text.Wrap

                text: "History browser for sailfish-browser"
            }

            SectionHeader {
                text: "Author"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "elros34"
            }

            SectionHeader {
                text: "Donate"
            }

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                wrapMode: Text.Wrap
                text: "Donate if you like my applications"
            }
            Button {
                text: "PayPal Donate"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://paypal.me/sfoselro/5")
                }
            }

            SectionHeader {
                text: "Icon"
            }

            LinkedLabel {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                wrapMode: Text.Wrap
                text: "Original icon made by <a href=\"https://www.flaticon.com/authors/hadrien\" title=\"Hadrien\">Hadrien</a> from <a href=\"https://www.flaticon.com/\" title=\"Flaticon\">www.flaticon.com</a> is licensed by CC 3.0 BY"
            }


        }
    }
}
