import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: teacherPage
    width: parent ? parent.width : 1024
    height: parent ? parent.height : 768

    property string userName: ""
    signal logout()

    Rectangle {
        anchors.fill: parent
        color: "#f0fff0"
    }

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "👨‍🏫 老师页面"
            font.pixelSize: 32
            font.bold: true
            color: "#333"
        }

        Text {
            text: "当前用户：" + teacherPage.userName
            font.pixelSize: 20
            color: "#666"
        }

        Button {
            text: "退出登录"
            font.pixelSize: 16
            width: 120
            height: 40

            onClicked: {
                console.log("老师页面：触发退出信号")
                teacherPage.logout()
            }
        }
    }
}
