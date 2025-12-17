import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: loginPage
    width: parent ? parent.width : 400
    height: parent ? parent.height : 600

    // 定义信号
    signal loginSuccess(string userType, string username)

    // 当前选中的用户类型
    property string currentUserType: "student"

    // 背景
    Rectangle {
        anchors.fill: parent
        color: "#f0f8ff"
    }

    // 登录表单容器（居中显示）
    Rectangle {
        width: 350
        height: 450
        anchors.centerIn: parent
        color: "white"
        radius: 10
        border.color: "#ddd"
        border.width: 1

        Column {
            anchors.centerIn: parent
            width: 300
            spacing: 20

            // 标题
            Text {
                text: "心理咨询系统"
                font.pixelSize: 24
                font.bold: true
                color: "#333"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 分隔线
            Rectangle {
                width: parent.width
                height: 1
                color: "#eee"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 用户类型选择
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "选择身份："
                    font.pixelSize: 14
                    color: "#666"
                }

                Row {
                    spacing: 15

                    RadioButton {
                        id: studentRadio
                        text: "学生"
                        checked: true
                        onCheckedChanged: if (checked) loginPage.currentUserType = "student"
                    }

                    RadioButton {
                        id: teacherRadio
                        text: "老师"
                        onCheckedChanged: if (checked) loginPage.currentUserType = "teacher"
                    }

                    RadioButton {
                        id: adminRadio
                        text: "管理员"
                        onCheckedChanged: if (checked) loginPage.currentUserType = "admin"
                    }
                }
            }

            // 用户名输入
            Column {
                width: parent.width
                spacing: 5

                Text {
                    text: "用户名："
                    font.pixelSize: 14
                    color: "#666"
                }

                TextField {
                    id: usernameInput
                    width: parent.width
                    height: 35
                    placeholderText: "输入用户名"
                    font.pixelSize: 14
                }
            }

            // 密码输入
            Column {
                width: parent.width
                spacing: 5

                Text {
                    text: "密码："
                    font.pixelSize: 14
                    color: "#666"
                }

                TextField {
                    id: passwordInput
                    width: parent.width
                    height: 35
                    placeholderText: "输入密码"
                    echoMode: TextInput.Password
                    font.pixelSize: 14
                }
            }

            // 错误提示
            Text {
                id: errorText
                color: "#e74c3c"
                font.pixelSize: 12
                height: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 登录按钮
            Button {
                id: loginButton
                width: parent.width
                height: 40
                text: "登录"
                font.pixelSize: 16

                background: Rectangle {
                    radius: 5
                    color: loginButton.down ? "#3a7bc8" : "#4a90e2"
                }

                contentItem: Text {
                    text: loginButton.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    if (usernameInput.text === "" || passwordInput.text === "") {
                        errorText.text = "用户名和密码不能为空"
                        return
                    }

                    errorText.text = ""
                    console.log("触发登录成功信号")
                    loginPage.loginSuccess(loginPage.currentUserType, usernameInput.text)
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("登录页面创建完成，尺寸:", width, "×", height)
        usernameInput.forceActiveFocus()
    }
}
