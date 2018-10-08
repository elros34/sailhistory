import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    property alias date: pageHeader.title
    property alias url: urlArea.text
    property alias title: titleLabel.text

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: column.width
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: "Copy url to clipboard"
                onClicked: {
                    Clipboard.text = page.url
                }
            }

            MenuItem {
                text: "Open url"
                onClicked: {
                    mimeHandler.openUrl(page.url)
                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                id: pageHeader
             }

            Label {
                id: titleLabel
                visible: text.length > 0
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                wrapMode: Text.WrapAnywhere
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
            }

            TextArea {
                id: urlArea
                visible: text.length > 0
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.WrapAnywhere
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingSmall
                    right: parent.right
                    rightMargin: Theme.paddingSmall
                }
            }
        }
    }
}
