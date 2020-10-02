import QtQuick 2.6
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
                text: "Authors"
            }

            Row {
                width: column.width
                height: codeLabel.height
                leftPadding: Theme.paddingMedium
                spacing: Theme.paddingMedium
                Label {
                    id: codeLabel
                    text: "Code"
                    color: Theme.highlightColor
                }
                Label {
                    text: "elros34 - BSD"
                }
            }
            Row {
                width: column.width
                height: codeLabel.height
                leftPadding: Theme.paddingMedium
                spacing: Theme.paddingMedium
                Label {
                    id: codeLabel2
                    text: "Code"
                    color: Theme.highlightColor
                }
                Label {
                    text: "Jolla Ltd. - BSD"
                }
            }

            Item {
                width: column.width
                height: Math.max(iconLabel.height, iconLabel2.height)
                Label {
                    id: iconLabel
                    text: "Icon"
                    color: Theme.highlightColor
                    anchors {
                        left: parent.left
                        leftMargin: Theme.paddingMedium
                    }
                }
                Label {
                    id: iconLabel2
                    text: "based on Hadrien (CC 3.0 BY) design"
                    anchors {
                        left: iconLabel.right
                        leftMargin: Theme.paddingMedium
                        right: parent.right
                    }
                    wrapMode: Text.Wrap
                }
                BackgroundItem {
                    width: column.width
                    height: parent.height
                    onClicked: {
                        Qt.openUrlExternally("https://www.flaticon.com/authors/hadrien")
                    }
                }
            }
        }
    }
}
