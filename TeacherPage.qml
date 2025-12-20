import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "pageswitching.js" as Pages
import "teacherManager.js" as TeacherMgr

Rectangle {
    id: teacherPage
    color: "#f8f9fa"

    // 第一行：顶部标题栏
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#4caf50"  // 教师端使用绿色主题

        // 平台标题
        Text {
            text: "高校心理咨询平台 - 教师端"
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
                text: "当前用户：教师"
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
                    TeacherMgr.reset()
                    Pages.logout()
                }
            }
        }
    }

    // 主体内容区域
    Rectangle {
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#ffffff"

        // 左边：功能列
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
                    text: "教师功能菜单"
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
                id: menuColumn
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
                    color: TeacherMgr.activePageId === null ? "#e8f5e8" : "white"  // 浅绿色

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 12

                        // 首页图标
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 4
                            color: "#4caf50"  // 绿色
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
                            color: "#4caf50"
                            font.bold: true
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var homePath = TeacherMgr.goHome()
                            contentLoader.source = homePath
                        }
                    }
                }

                // 其他功能项
                Repeater {
                    model: TeacherMgr.getFunctions()

                    delegate: Rectangle {
                        id: menuItem
                        width: parent.width
                        height: 50
                        color: TeacherMgr.isPageActive(modelData.id) ? "#e8f5e8" : "white"

                        property var pageInfo: modelData

                        // 左侧激活指示条
                        Rectangle {
                            width: 4
                            height: parent.height
                            color: "#4caf50"
                            visible: TeacherMgr.isPageActive(modelData.id)
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
                                color: TeacherMgr.isPageActive(modelData.id) ? "#4caf50" : "#e9ecef"
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: modelData.icon
                                    anchors.centerIn: parent
                                    font.pixelSize: 14
                                }
                            }

                            // 功能文字
                            Text {
                                text: modelData.title
                                color: TeacherMgr.isPageActive(modelData.id) ? "#4caf50" : "#495057"
                                font.pixelSize: 15
                                font.bold: TeacherMgr.isPageActive(modelData.id)
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: menuItemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: {
                                if (!TeacherMgr.isPageActive(modelData.id)) {
                                    menuItem.color = "#f8f9fa"
                                }
                            }
                            onExited: {
                                if (!TeacherMgr.isPageActive(modelData.id)) {
                                    menuItem.color = "white"
                                }
                            }
                            onClicked: {
                                var result = TeacherMgr.openPage(modelData.id)
                                if (result && result.filePath) {
                                    contentLoader.source = result.filePath
                                }
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
                source: "TeacherHome.qml"

                onStatusChanged: {
                    if (status === Loader.Error) {
                        console.error("加载页面失败:", source)
                        source = "TeacherHome.qml"
                    }
                }
            }
        }
    }

    // 定时器：更新菜单项颜色
    Timer {
        id: updateTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: updateMenuView()
    }

    // 函数：更新菜单项颜色
    function updateMenuView() {
        // 更新首页菜单项颜色
        homeMenuItem.color = TeacherMgr.activePageId === null ? "#e8f5e8" : "white"

        // 更新功能菜单项颜色
        for (var i = 0; i < menuColumn.children.length; i++) {
            var child = menuColumn.children[i]
            if (child.pageInfo) {
                var isActive = TeacherMgr.isPageActive(child.pageInfo.id)
                child.color = isActive ? "#e8f5e8" : "white"
            }
        }
    }

    // 初始化
    Component.onCompleted: {
        contentLoader.source = "TeacherHome.qml"
    }
}
