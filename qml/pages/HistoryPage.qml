/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Joona Petrell <joona.petrell@jollamobile.com>
** 2017 elros34
** All rights reserved.
**
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string title
    property int startDate
    property int endDate

    property Item searchField
    property string searchString

    onSearchStringChanged: {
        listView.currentIndex = -1
        bottomBar.date = ""
        historyFilter.search(searchString)
    }

    focus: !searchField.visible
    Keys.onPressed: {
        if (!searchField.visible) {
            searchField.text = event.text
            searchField.show()
        }
    }

    SilicaListView {
        id: listView
        clip: true
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: bottomBar.top
        }

        header: Column {
            width: listView.width
            property alias searchField: searchField

            PageHeader {
                title: page.title
            }
            SearchField {
                id: searchField
                width: parent.width
                visible: false

                function show()
                {
                    listView.currentIndex = -1
                    bottomBar.date = ""
                    visible = true
                    listView.scrollToTop() // FIXME
                    forceActiveFocus()
                }

                function hide()
                {
                    visible = false
                    page.forceActiveFocus()
                    historyFilter.search("")
                }

                Binding {
                    target: page
                    property: "searchString"
                    value: searchField.text.toLowerCase().trim()
                }

                Component.onCompleted: {
                    page.searchField = searchField
                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: searchFieldVisible ? "Hide search" : "Search"
                property bool searchFieldVisible: searchField.visible
                onClicked: {
                    if (searchFieldVisible)
                        searchField.hide()
                    else
                        searchField.show()
                }
            }

            MenuItem {
                text: "Refresh"
                onClicked: {
                    historyModel.refresh()
                }
            }
        }

        model: historyFilter

        currentIndex: -1
        highlightMoveDuration: 0
        highlightFollowsCurrentItem: false

        delegate: ListItem {
            id: listItem
            contentHeight: Theme.itemSizeMedium
            property bool currentItem: index == listView.currentIndex

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    top: parent.top
                    topMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                color: currentItem ? Theme.highlightColor : Theme.primaryColor
                text: Theme.highlightText(model.title, page.searchString, currentItem ? Theme.primaryColor : Theme.secondaryHighlightColor)
                maximumLineCount: 1
                truncationMode: TruncationMode.Fade
            }
            Label {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    bottom: parent.bottom
                    bottomMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                color: index == listView.currentIndex ? Theme.secondaryHighlightColor : Theme.secondaryColor
                text: Theme.highlightText(model.url, page.searchString, currentItem ? Theme.primaryColor : Theme.secondaryHighlightColor)
                maximumLineCount: 1
                truncationMode: TruncationMode.Fade
            }

            RemorseItem {
                id: remorseItem
            }

            property DetailsPage detailsPage

            onClicked: {
                itemClicked()
            }
            onPressAndHold: {
                itemClicked()
            }

            function itemClicked()
            {
                listView.currentIndex = index
                bottomBar.date = model.hDate

                if (!detailsPage) {
                    detailsPage = pageStack.pushAttached("DetailsPage.qml")
                }
                detailsPage.date = model.hDate
                detailsPage.title = model.title
                detailsPage.url = model.url
            }


            menu: ContextMenu {
                MenuItem {
                    text: "Open url"
                    onClicked: {
                        Qt.openUrlExternally(model.url)
                    }
                }

                MenuItem {
                    text: "Remove"
                    onClicked: {
                        var p = bottomBar
                        remorseItem.execute(listItem, "Deleting", function () {
                            console.log("index: " + index)
                            var sourceIndex = historyFilter.sourceModelIndex(index)
                            console.log("sourceIndex: " + sourceIndex)
                            historyModel.remove(sourceIndex, model.id)
                            listView.currentIndex = -1
                            p.date = ""
                        }, 3000)
                    }
                }
                MenuItem {
                    text: "Copy url to clipboard"
                    onClicked: {
                        Clipboard.text = model.url
                    }
                }
            }
        }

        VerticalScrollDecorator {
            flickable: listView
        }
    }

    Item {
        id: bottomBar
        width: parent.width
        height: (date.length > 0) ? Theme.itemSizeSmall : 0
        anchors.bottom: parent.bottom

        PanelBackground {
            anchors.fill: parent
            position: Dock.Top
        }

        property string date

        Label {
            text: bottomBar.date
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignRight
            anchors {
                left: parent.left
                leftMargin: Theme.paddingMedium
                right: parent.right
                rightMargin: Theme.paddingMedium
                verticalCenter: parent.verticalCenter
            }
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Inactive) {
            searchField.hide()
        }
    }
}

