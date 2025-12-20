import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "pageswitching.js" as Pages

Rectangle {
    id: teacherPage
    color: "#fff3e0"  // 浅橙色背景

    // 页面标题
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        text: "教师主页"
        font.pixelSize: 32
        font.bold: true
        color: "#ef6c00"
    }

    // 当前用户显示
    Text {
        anchors.top: titleText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        text: "当前身份：教师"
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
        text: "这里将放置教师功能模块"
        color: "#777"
        font.pixelSize: 16
    }
}
