import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: registerPage
    width: 400
    height: 650
    color: "#f5f7fa"
    radius: 12

    signal backToLogin()
    signal registerSuccess(string username)

    property string currentUserType: "student"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 15

        // 返回按钮
        RowLayout {
            Button {
                text: "← 返回"
                flat: true
                onClicked: registerPage.backToLogin()
            }

            Item { Layout.fillWidth: true }
        }

        // 标题
        Text {
            text: "用户注册"
            font.pixelSize: 24
            font.bold: true
            color: "#333"
            Layout.alignment: Qt.AlignHCenter
        }

        // 注册表单
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15

            // 用户类型
            ColumnLayout {
                spacing: 5

                Text {
                    text: "注册身份"
                    font.pixelSize: 14
                    color: "#333"
                }

                RowLayout {
                    spacing: 15

                    RadioButton {
                        id: regStudentRadio
                        text: "学生"
                        checked: true
                        onCheckedChanged: if (checked) registerPage.currentUserType = "student"
                    }

                    RadioButton {
                        id: regTeacherRadio
                        text: "老师"
                        onCheckedChanged: if (checked) registerPage.currentUserType = "teacher"
                    }
                }
            }

            // 学号/工号
            ColumnLayout {
                spacing: 5

                Text {
                    id: idLabel
                    text: registerPage.currentUserType === "student" ? "学号" : "工号"
                    font.pixelSize: 14
                    color: "#333"
                }

                TextField {
                    id: userIdInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: registerPage.currentUserType === "student" ? "请输入学号" : "请输入工号"
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        border.color: parent.activeFocus ? "#4a90e2" : "#ddd"
                    }
                }
            }

            // 姓名
            ColumnLayout {
                spacing: 5

                Text {
                    text: "姓名"
                    font.pixelSize: 14
                    color: "#333"
                }

                TextField {
                    id: nameInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: "请输入真实姓名"
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        border.color: parent.activeFocus ? "#4a90e2" : "#ddd"
                    }
                }
            }

            // 邮箱
            ColumnLayout {
                spacing: 5

                Text {
                    text: "邮箱"
                    font.pixelSize: 14
                    color: "#333"
                }

                TextField {
                    id: emailInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: "请输入邮箱"
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        border.color: parent.activeFocus ? "#4a90e2" : "#ddd"
                    }
                }
            }

            // 密码
            ColumnLayout {
                spacing: 5

                Text {
                    text: "密码"
                    font.pixelSize: 14
                    color: "#333"
                }

                TextField {
                    id: regPasswordInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: "请输入密码"
                    echoMode: TextInput.Password
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        border.color: parent.activeFocus ? "#4a90e2" : "#ddd"
                    }
                }
            }

            // 确认密码
            ColumnLayout {
                spacing: 5

                Text {
                    text: "确认密码"
                    font.pixelSize: 14
                    color: "#333"
                }

                TextField {
                    id: confirmPasswordInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    placeholderText: "请再次输入密码"
                    echoMode: TextInput.Password
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        border.color: parent.activeFocus ? "#4a90e2" : "#ddd"
                    }
                }
            }
        }

        // 注册按钮
        Button {
            id: registerButton
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            text: "注册"
            font.pixelSize: 16
            font.bold: true

            background: Rectangle {
                radius: 8
                color: registerButton.down ? "#27ae60" : "#2ecc71"
            }

            contentItem: Text {
                text: registerButton.text
                font: registerButton.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                // 验证表单
                if (!validateForm()) return

                registerButton.enabled = false
                registerButton.text = "注册中..."

                // 模拟注册过程
                registerTimer.start()
            }
        }

        // 错误提示
        Text {
            id: registerErrorLabel
            Layout.alignment: Qt.AlignHCenter
            color: "#e74c3c"
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }

        // 协议说明
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "注册即表示同意《用户协议》和《隐私政策》"
            font.pixelSize: 10
            color: "#666"
        }
    }

    // 表单验证函数
    function validateForm() {
        if (userIdInput.text === "") {
            registerErrorLabel.text = "请输入" + idLabel.text
            return false
        }
        if (nameInput.text === "") {
            registerErrorLabel.text = "请输入姓名"
            return false
        }
        if (emailInput.text === "") {
            registerErrorLabel.text = "请输入邮箱"
            return false
        }
        if (regPasswordInput.text === "") {
            registerErrorLabel.text = "请输入密码"
            return false
        }
        if (regPasswordInput.text !== confirmPasswordInput.text) {
            registerErrorLabel.text = "两次输入的密码不一致"
            return false
        }
        return true
    }

    // 模拟注册计时器
    Timer {
        id: registerTimer
        interval: 2000
        onTriggered: {
            // 模拟注册成功
            var success = true

            if (success) {
                registerErrorLabel.color = "#2ecc71"
                registerErrorLabel.text = "注册成功！正在跳转..."
                registerSuccess(userIdInput.text)
            } else {
                registerErrorLabel.color = "#e74c3c"
                registerErrorLabel.text = "注册失败，请稍后重试"
                registerButton.enabled = true
                registerButton.text = "注册"
            }
        }
    }

    Component.onCompleted: {
        console.log("注册页面加载完成")
        userIdInput.forceActiveFocus()
    }
}
