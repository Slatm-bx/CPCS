import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: loginPage
    color: "#ffffff"

    // 背景渐变
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8fbff" }
            GradientStop { position: 1.0; color: "#e6f0ff" }
        }
    }

    // 顶部装饰线
    Rectangle {
        width: parent.width
        height: 5
        color: "#3498db"
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 25
        width: Math.min(parent.width * 0.85, 460)

        // 标题区域
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            // 爱心图标
            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50' viewBox='0 0 24 24' fill='%23e74c3c'><path d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/></svg>"
                sourceSize: Qt.size(50, 50)
            }

            // 主标题
            Text {
                text: "高校心理咨询系统"
                font.pixelSize: 32
                font.bold: true
                color: "#2c3e50"
                Layout.alignment: Qt.AlignHCenter
            }

            // 副标题
            Text {
                text: "University Counseling System"
                font.pixelSize: 14
                color: "#7f8c8d"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 登录表单卡片
        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 15
            height: 350
            radius: 12
            color: "white"
            border.color: "#e0e6ed"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                // 账号输入框
                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    Text {
                        text: "账 号"
                        font.pixelSize: 16
                        color: "#34495e"
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        border.color: usernameInput.focus ? "#3498db" : "#dce1e8"
                        border.width: 2
                        color: usernameInput.focus ? "#f8fbff" : "#ffffff"

                        TextField {
                            id: usernameInput
                            anchors.fill: parent
                            anchors.margins: 10
                            placeholderText: "请输入学号或工号"
                            font.pixelSize: 16
                            color: "#2c3e50"
                            placeholderTextColor: "#95a5a6"
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }
                }

                // 密码输入框
                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    Text {
                        text: "密 码"
                        font.pixelSize: 16
                        color: "#34495e"
                        font.bold: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        border.color: passwordInput.focus ? "#3498db" : "#dce1e8"
                        border.width: 2
                        color: passwordInput.focus ? "#f8fbff" : "#ffffff"

                        TextField {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.margins: 10
                            placeholderText: "请输入登录密码"
                            font.pixelSize: 16
                            echoMode: TextField.Password
                            color: "#2c3e50"
                            placeholderTextColor: "#95a5a6"
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }
                }

                // 角色选择 - 水平排列
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "选择身份"
                        font.pixelSize: 16
                        color: "#34495e"
                        font.bold: true
                    }

                    RowLayout {
                        spacing: 20
                        Layout.fillWidth: true

                        RadioButton {
                            id: studentRadio
                            text: "👨‍🎓 学 生"
                            checked: true
                            font.pixelSize: 15
                            contentItem: Text {
                                text: studentRadio.text
                                font: studentRadio.font
                                color: studentRadio.checked ? "#3498db" : "#7f8c8d"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: studentRadio.indicator.width + 12
                            }
                        }

                        RadioButton {
                            id: teacherRadio
                            text: "👨‍🏫 教 师"
                            font.pixelSize: 15
                            contentItem: Text {
                                text: teacherRadio.text
                                font: teacherRadio.font
                                color: teacherRadio.checked ? "#3498db" : "#7f8c8d"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: teacherRadio.indicator.width + 12
                            }
                        }

                        RadioButton {
                            id: adminRadio
                            text: "⚙️ 管理员"
                            font.pixelSize: 15
                            contentItem: Text {
                                text: adminRadio.text
                                font: adminRadio.font
                                color: adminRadio.checked ? "#3498db" : "#7f8c8d"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: adminRadio.indicator.width + 12
                            }
                        }
                    }
                }

                // 登录按钮
                Button {
                    id: loginButton
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    height: 52
                    text: "登  录"
                    font.pixelSize: 20
                    font.bold: true
                    hoverEnabled: true

                    background: Rectangle {
                        radius: 10
                        color: loginButton.down ? "#2980b9" : (loginButton.hovered ? "#5dade2" : "#3498db")
                        opacity: loginButton.enabled ? 1 : 0.6
                    }

                    contentItem: Text {
                        text: loginButton.text
                        font: loginButton.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        // 获取选择的角色
                        var role = ""
                        if (studentRadio.checked) role = "student"
                        else if (teacherRadio.checked) role = "teacher"
                        else if (adminRadio.checked) role = "admin"

                        // 检查是否有输入
                        if (usernameInput.text.trim() === "" || passwordInput.text.trim() === "") {
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
            }
        }

        // 错误提示
        Text {
            id: errorText
            Layout.alignment: Qt.AlignHCenter
            color: "#e74c3c"
            visible: false
            font.pixelSize: 14
            font.bold: true
        }

        // 底部提示
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 5
            text: "提示：输入任意账号密码即可登录"
            color: "#95a5a6"
            font.pixelSize: 13
        }
    }

    // 输入框获取焦点时清空错误提示
    Connections {
        target: usernameInput
        function onTextChanged() {
            errorText.visible = false
        }
    }

    Connections {
        target: passwordInput
        function onTextChanged() {
            errorText.visible = false
        }
    }
}
