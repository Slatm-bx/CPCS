import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: loginPage
    color: "#f0f0f0"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(parent.width * 0.8, 400)

        // 标题
        Text {
            text: "心理咨询系统登录"
            font.pixelSize: 24
            font.bold: true
            color: "#333"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 30
        }

        // 账号输入
        TextField {
            id: usernameInput
            Layout.fillWidth: true
            placeholderText: "输入账号"
            font.pixelSize: 16
            height: 40
        }

        // 密码输入
        TextField {
            id: passwordInput
            Layout.fillWidth: true
            placeholderText: "输入密码"
            font.pixelSize: 16
            echoMode: TextField.Password
            height: 40
        }

        // 角色选择 - 单选按钮
        GroupBox {
            title: "请选择身份"
            Layout.fillWidth: true

            Column {
                spacing: 10
                width: parent.width

                RadioButton {
                    id: studentRadio
                    text: "学生"
                    checked: true
                }
                RadioButton {
                    id: teacherRadio
                    text: "教师"
                }
                RadioButton {
                    id: adminRadio
                    text: "管理员"
                }
            }
        }

        // 登录按钮
        Button {
            Layout.fillWidth: true
            height: 45
            text: "登录"
            font.pixelSize: 18

            onClicked: {
                // 获取选择的角色
                var role = ""
                if (studentRadio.checked) role = "student"
                else if (teacherRadio.checked) role = "teacher"
                else if (adminRadio.checked) role = "admin"

                // 检查是否有输入
                if (usernameInput.text === "" || passwordInput.text === "") {
                    errorText.text = "请输入账号和密码"
                    errorText.visible = true
                    return
                }

                // 跳转到对应界面
                if (mainWindow) {
                    mainWindow.loginSuccess(role)
                }
            }
        }

        // 错误提示
        Text {
            id: errorText
            Layout.alignment: Qt.AlignHCenter
            color: "red"
            visible: false
            font.pixelSize: 14
        }
    }

    // 测试用提示文字
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        text: "提示：任意输入账号密码即可登录"
        color: "#666"
        font.pixelSize: 14
    }
}
