import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "pageswitching.js" as Pages

Rectangle {
    id: adminPage
    color: "#f3e5f5"  // 浅紫色背景

    // 页面标题
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        text: "管理员主页"
        font.pixelSize: 32
        font.bold: true
        color: "#6a1b9a"
    }

    // 当前用户显示
    Text {
        anchors.top: titleText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        text: "当前身份：管理员"
        font.pixelSize: 18
        color: "#555"
    }

    // 退出登录按钮 - 在页面中央
    Button {
        anchors.centerIn: parent
        width: 150
        height: 50
        text: "退出登录"
        font.pixelSize: 18

        onClicked: {
          Pages.logout()
        }
    }

    // 简单说明文字
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        text: "这里将放置管理员功能模块"
        color: "#777"
        font.pixelSize: 16
    }
}
