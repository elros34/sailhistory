import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaListView {
        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: "History"
        }

        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: {
                    pageStack.push("About.qml")
                }
            }

            MenuItem {
                text: "Refresh"
                onClicked: {
                    historyModel.refresh()
                }
            }
            //TODO: select manual range (date picker)
        }

        model: historyModel.rangeList()

        Connections {
            target: historyModel
            onRangeListChanged: {
                listView.model = historyModel.rangeList()
            }
        }


        delegate: ListItem {
            contentHeight: Theme.itemSizeSmall

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin * 2
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                color: Theme.primaryColor
                text: modelData.name
                maximumLineCount: 1
                truncationMode: TruncationMode.Fade
            }

            property HistoryPage historyPage
            onClicked: {
                if (!historyPage) {
                    historyPage = pageStack.pushAttached("HistoryPage.qml")
                }
                historyPage.title = modelData.name
                historyPage.startDate = modelData.start
                historyPage.endDate = modelData.end
                historyFilter.setDateTimeRange(historyPage.startDate, historyPage.endDate)
                historyFilter.search("")
                pageStack.navigateForward()
            }


        }

        VerticalScrollDecorator {
            flickable: listView
        }
    }
}

