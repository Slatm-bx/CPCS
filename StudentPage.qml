import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "pageswitching.js" as Pages

Rectangle {
    id: mainWindow
    color: "#f8f9fa"

    // 第一行：顶部标题栏
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#3498db"

        // 平台标题（在整个header的中央）
        Text {
            text: "高校心理咨询平台"
            color: "white"
            font.bold: true
            font.pixelSize: 22
            anchors.centerIn: parent
        }

        // 最右边：用户信息和退出按钮
        Row {
            spacing: 15
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            Label {
                text: "当前用户：张三"
                color: "white"
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "退出登录"
                anchors.verticalCenter: parent.verticalCenter
                width: 100
                height: 35

                background: Rectangle {
                    radius: 5
                    color: parent.down ? "#e74c3c" : "#c0392b"
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                     Pages.logout()
                }
            }
        }
    }

    // 第二行：页面标签栏
    Rectangle {
        id: tabBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 45
        color: "#ffffff"

        // 底部边框
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#dee2e6"
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 5

            // 首页标签（固定，不可关闭）
            Rectangle {
                id: homeTab
                width: 90
                height: 35
                radius: 4
                color: "#2ecc71"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "首页"
                    color: "white"
                    anchors.centerIn: parent
                    font.pixelSize: 14
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        contentLoader.source = "HomePage.qml"
                    }
                }
            }

            // 动态生成的页面标签
            ListView {
                id: dynamicTabs
                width: parent.width - 110
                height: 35
                orientation: ListView.Horizontal
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter

                model: ListModel {
                    id: tabModel
                }

                delegate: Rectangle {
                    width: 130
                    height: 35
                    radius: 4
                    color: "#e9ecef"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 5
                        spacing: 8

                        Text {
                            text: model.title
                            color: "#495057"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                        }

                        // 关闭按钮
                        Rectangle {
                            width: 16
                            height: 16
                            radius: 8
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "×"
                                color: "#6c757d"
                                font.pixelSize: 12
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    tabModel.remove(index)
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            contentLoader.source = model.source
                        }
                    }
                }
            }
        }
    }

    // 主体内容区域
    Rectangle {
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#ffffff"

        // 左边：功能列（包含首页）
        Rectangle {
            id: sidebar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 200
            color: "#f8f9fa"

            // 右边边框
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#dee2e6"
            }

            // 功能列标题
            Rectangle {
                id: sidebarHeader
                width: parent.width
                height: 50
                color: "#f1f3f4"

                Text {
                    text: "功能菜单"
                    color: "#495057"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                // 底部边框
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: "#dee2e6"
                }
            }

            // 功能列表
            Column {
                anchors.top: sidebarHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 0

                // 首页功能项
                Rectangle {
                    id: homeMenuItem
                    width: parent.width
                    height: 50
                    color: "#e8f4fd"  // 首页特殊背景色

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 12

                        // 首页图标
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 4
                            color: "#3498db"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "🏠"
                                anchors.centerIn: parent
                                font.pixelSize: 14
                            }
                        }

                        // 首页文字
                        Text {
                            text: "首页"
                            color: "#3498db"
                            font.bold: true
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            contentLoader.source = "HomePage.qml"
                        }
                    }
                }

                // 其他功能项
                Repeater {
                    model: ["功能1", "功能2", "功能3"]

                    delegate: Rectangle {
                        width: parent.width
                        height: 50
                        color: "white"

                        // 左侧激活指示条
                        Rectangle {
                            visible: false  // 默认隐藏，点击时显示
                            width: 4
                            height: parent.height
                            color: "#3498db"
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            spacing: 12

                            // 功能图标
                            Rectangle {
                                width: 30
                                height: 30
                                radius: 4
                                color: "#e9ecef"
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: "📋"
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                }
                            }

                            // 功能文字
                            Text {
                                text: modelData
                                color: "#495057"
                                font.pixelSize: 15
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: menuItemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: {
                                parent.color = "#f8f9fa"
                            }
                            onExited: {
                                parent.color = "white"
                            }
                            onClicked: {
                                // 创建新的页面标签
                                var newTab = {
                                    "title": modelData,
                                    "source": "FunctionPage.qml?name=" + modelData
                                }
                                tabModel.append(newTab)
                                contentLoader.source = newTab.source
                            }
                        }
                    }
                }

                // 填充剩余空间
                Item {
                    width: parent.width
                    Layout.fillHeight: true
                }
            }
        }

        // 右边：页面显示区域
        Rectangle {
            id: contentArea
            anchors.left: sidebar.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "#ffffff"

            // 页面加载器
            Loader {
                id: contentLoader
                anchors.fill: parent
                source: "HomePage.qml"
            }
        }
    }
}
