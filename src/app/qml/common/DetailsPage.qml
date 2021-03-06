/*
 * Copyright (C) 2013-2016 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import DocumentViewer 1.0
import QtQml.Models 2.1

import "utils.js" as Utils

Page {
    id: detailsPage
    objectName: "detailsPage"

    header: PageHeader {
        title: i18n.tr("Details")
        flickable: view
    }

    ScrollView {
        anchors.fill: parent

        ListView {
            id: view
            anchors.fill: parent

            model: ObjectModel {
                SubtitledListItem {
                    text: i18n.tr("File")
                    subText: DocumentViewer.getFileNameFromPath(file.path)
                }

                SubtitledListItem {
                    text: i18n.tr("Location")
                    subText: DocumentViewer.getCanonicalPath(file.path)
                }

                SubtitledListItem {
                    text: i18n.tr("Size")
                    subText: Utils.printSize(i18n, file.info.size)
                }

                SubtitledListItem {
                    text: i18n.tr("Created")
                    subText: file.info.creationTime.toLocaleString(Qt.locale())
                }

                SubtitledListItem {
                    text: i18n.tr("Last modified")
                    subText: file.info.lastModified.toLocaleString(Qt.locale())
                }

                SubtitledListItem {
                    // Used by Autopilot tests
                    objectName: "mimetypeItem"
                    text: i18n.tr("MIME type")
                    subText: file.mimetype.name
                }
            }
        }
    }
}
