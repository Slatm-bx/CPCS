import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: studentPage
    width: parent ? parent.width : 1024
    height: parent ? parent.height : 768

    // 接收的参数
    property string userName: ""

    // 定义信号
    signal logout()

    // 背景
    Rectangle {
        anchors.fill: parent
        color: "#f0f8ff"
    }

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "👨‍🎓 学生页面"
            font.pixelSize: 32
            font.bold: true
            color: "#333"
        }

        Text {
            text: "当前用户：" + studentPage.userName
            font.pixelSize: 20
            color: "#666"
        }

        Button {
            text: "退出登录"
            font.pixelSize: 16
            width: 120
            height: 40

            onClicked: {
                console.log("学生页面：触发退出信号")
                studentPage.logout()
            }
        }
    }

    Component.onCompleted: {
        console.log("学生页面创建完成，用户：" + userName, "尺寸:", width, "×", height)
    }
}
