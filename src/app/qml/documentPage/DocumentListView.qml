/*
  Copyright (C) 2015 Stefano Verzegnassi

    This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../upstreamComponents"

MultipleSelectionListView {
    id: documentListView

    anchors { fill: parent; margins: units.gu(0.5) }
    clip: true

    property var _currentSwipedItem: null

    function _updateSwipeState(item)
    {
        if (item.swipping) {
            return
        }

        if (item.swipeState !== "Normal") {
            if (documentListView._currentSwipedItem !== item) {
                if (documentListView._currentSwipedItem) {
                    documentListView._currentSwipedItem.resetSwipe()
                }
                documentListView._currentSwipedItem = item
            }
        } else if (item.swipeState !== "Normal"
                   && documentListView._currentSwipedItem === item) {
            documentListView._currentSwipedItem = null
        }
    }

    listDelegate: DocumentListDelegate {
        id: delegate

        property var removalAnimation

        function remove() {
            removalAnimation.start()
        }

        selectionMode: documentListView.isInSelectionMode
        selected: documentListView.isSelected(delegate)

        onSwippingChanged: {
            _updateSwipeState(delegate)
        }

        onSwipeStateChanged: {
            _updateSwipeState(delegate)
        }

        ListView.onRemove: ScriptAction {
            script: {
                if (_currentSwipedItem
                        === delegate) {
                    _currentSwipedItem = null
                }
            }
        }

        removalAnimation: SequentialAnimation {
            alwaysRunToEnd: true

            PropertyAction {
                target: delegate
                property: "ListView.delayRemove"
                value: true
            }

            UbuntuNumberAnimation {
                target: delegate
                property: "height"
                to: 0
            }

            PropertyAction {
                target: delegate
                property: "ListView.delayRemove"
                value: false
            }

            ScriptAction {
                script: {
                    var filePath = d.folderModel.get(index, "filePath")
                    Storage.rm(filePath)
                }
            }
        }

        onItemClicked: {
            if(documentListView.isInSelectionMode) {
                if(!documentListView.selectItem(delegate)) {
                    documentListView.deselectItem(delegate)
                }
                return
            }

            else {
                file.path = model.path
            }
        }

        onItemPressAndHold: {
            if (!documentListView.isInSelectionMode) {
                documentListView.startSelection()
                documentListView.selectItem(delegate)
            }
        }
    }

    listModel: folderModel

    section.property: "dateDiff"
    section.delegate: ListItem.Header {
        text: {
            if (section == 0)
                return i18n.tr("Today")

            if (section == 1)
                return i18n.tr("Yesterday")

            if (section == 2)
                return i18n.tr("Earlier this week")

            if (section == 3)
                return i18n.tr("Earlier this month")

            return i18n.tr("Even more earlier...")
        }
    }

    Scrollbar {
        flickableItem: documentListView
        parent: documentListView.parent
    }

    Component.onCompleted: { if (DOC_VIEWER.pickModeEnabled) documentListView.startSelection(); }
}