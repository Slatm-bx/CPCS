import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "pageswitching.js" as Pages
import "adminManager.js" as AdminMgr

Rectangle {
    id: adminPage
    color: "#f8f9fa"

    signal showAddUserDialog()
    signal showEditUserDialog(string userId, string userName, string userDept, string userRole, string gender, string entryYear)
    signal showSurveyDialog()
    signal showArticleDialog()

    // 第一行：顶部标题栏
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#ff9800"  // 管理员端使用橙色主题

        // 平台标题
        Text {
            text: "高校心理咨询平台 - 管理员端"
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
                text: "当前用户：管理员"
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
                    AdminMgr.reset()
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
                    text: "管理员功能菜单"
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
                    color: AdminMgr.activePageId === null ? "#fff3e0" : "white"  // 浅橙色

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        spacing: 12

                        // 首页图标
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 4
                            color: "#ff9800"  // 橙色
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
                            color: "#ff9800"
                            font.bold: true
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var homePath = AdminMgr.goHome()
                            contentLoader.source = homePath
                        }
                    }
                }

                // 其他功能项
                Repeater {
                    model: AdminMgr.getFunctions()

                    delegate: Rectangle {
                        id: menuItem
                        width: parent.width
                        height: 50
                        color: AdminMgr.isPageActive(modelData.id) ? "#fff3e0" : "white"

                        property var pageInfo: modelData

                        // 左侧激活指示条
                        Rectangle {
                            width: 4
                            height: parent.height
                            color: "#ff9800"
                            visible: AdminMgr.isPageActive(modelData.id)
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
                                color: AdminMgr.isPageActive(modelData.id) ? "#ff9800" : "#e9ecef"
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
                                color: AdminMgr.isPageActive(modelData.id) ? "#ff9800" : "#495057"
                                font.pixelSize: 15
                                font.bold: AdminMgr.isPageActive(modelData.id)
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: menuItemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: {
                                if (!AdminMgr.isPageActive(modelData.id)) {
                                    menuItem.color = "#f8f9fa"
                                }
                            }
                            onExited: {
                                if (!AdminMgr.isPageActive(modelData.id)) {
                                    menuItem.color = "white"
                                }
                            }
                            onClicked: {
                                var result = AdminMgr.openPage(modelData.id)
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
                source: "AdminHome.qml"

                onStatusChanged: {
                    if (status === Loader.Error) {
                        console.error("加载页面失败:", source)
                        source = "AdminHome.qml"
                    }
                }

                // 监听加载页面的信号并转发给 AdminPage
                Connections {
                    target: contentLoader.item

                    function onShowAddDialog() {
                        adminPage.showAddUserDialog()
                    }

                    function onShowEditDialog(userId, userName, userDept, userRole, gender, entryYear) {
                        adminPage.showEditUserDialog(userId, userName, userDept, userRole, gender, entryYear)
                    }

                    function onShowArticleDialog() {
                        adminPage.showArticleDialog()
                    }

                    function onShowEditArticleDialog(articleId, title, summary, content) {
                        dialogs.openEditArticleDialog(articleId, title, summary, content)
                    }

                    function onShowSurveyDialog() {
                        adminPage.showSurveyDialog()
                    }

                    function onShowConsultationDetailDialog(consultationId, studentName, counselor,
                                                             consultationDate, consultationType,
                                                             duration, phoneNumber, selfEvaluation, summary) {
                        dialogs.openConsultationDetailDialog(consultationId, studentName, counselor,
                                                              consultationDate, consultationType,
                                                              duration, phoneNumber, selfEvaluation, summary)
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
        homeMenuItem.color = AdminMgr.activePageId === null ? "#fff3e0" : "white"

        // 更新功能菜单项颜色
        for (var i = 0; i < menuColumn.children.length; i++) {
            var child = menuColumn.children[i]
            if (child.pageInfo) {
                var isActive = AdminMgr.isPageActive(child.pageInfo.id)
                child.color = isActive ? "#fff3e0" : "white"
            }
        }
    }

    // 初始化
    Component.onCompleted: {
        contentLoader.source = "AdminHome.qml"
    }

    // 弹窗管理器
    CustomDialogs {
        id: dialogs
        parentWindow:adminPage
    }

    // 监听文章发布信号，刷新列表
    Connections {
        target: dialogs

        function onArticlePublished() {
            // 如果当前加载的是 MentalLiterature 页面，刷新它
            if (contentLoader.item && contentLoader.item.refreshArticles) {
                contentLoader.item.refreshArticles()
            }
        }
    }

    // 连接信号到弹窗}
    Connections {
        target: adminPage
        function onShowAddUserDialog() {
            dialogs.openAddUserDialog()
        }
        function onShowEditUserDialog(userId, userName, userDept, userRole, gender, entryYear) {
            dialogs.openEditUserDialog(userId, userName, userDept, userRole, gender, entryYear)
        }
        function onShowSurveyDialog() {
            dialogs.openSurveyDialog()
        }
        function onShowArticleDialog() {
            dialogs.openArticleDialog()
        }
    }
}
