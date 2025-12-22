import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: personalCenterPage
    color: "#f5f7fa"

    // 用户数据
    property string studentName: "张三"
    property string studentId: "202310001"
    property string college: "计算机科学与技术学院"
    property string major: "软件工程"
    property string grade: "2023级"
    property string avatar: "👨‍🎓"

    // 编辑弹窗状态
    property bool showEditDialog: false

    ScrollView {
        anchors.fill: parent
        clip: true

        Column {
            width: parent.width
            spacing: 16
            anchors.margins: 20

            // 顶部头像和信息
            Rectangle {
                width: parent.width
                height: 180
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    // 头像
                    Rectangle {
                        width: 90
                        height: 90
                        radius: 45
                        color: "#e3f2fd"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: personalCenterPage.avatar
                            font.pixelSize: 40
                        }
                    }

                    // 姓名
                    Text {
                        text: personalCenterPage.studentName
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1976d2"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 学号
                    Text {
                        text: "学号：" + personalCenterPage.studentId
                        font.pixelSize: 14
                        color: "#666"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // 个人信息卡片
            Rectangle {
                width: parent.width
                height: 160
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "个人信息"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                    }

                    // 学院信息
                    Row {
                        width: parent.width
                        spacing: 12

                        Text {
                            text: "🏫"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.college
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 专业信息
                    Row {
                        width: parent.width
                        spacing: 12

                        Text {
                            text: "📚"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.major
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 年级信息
                    Row {
                        width: parent.width
                        spacing: 12

                        Text {
                            text: "🎓"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.grade
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }
                }
            }

            // 统计卡片
            Rectangle {
                width: parent.width
                height: 240
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "使用统计"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                    }

                    // 统计行1
                    Row {
                        width: parent.width
                        spacing: 12

                        // 咨询统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#e8f5e9"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "💬"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "心理咨询"
                                    font.pixelSize: 14
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "6 次"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 测试统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#e3f2fd"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "📊"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "心理测试"
                                    font.pixelSize: 14
                                    color: "#1976d2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "3 次"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#1976d2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    // 统计行2
                    Row {
                        width: parent.width
                        spacing: 12

                        // 文献统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#fff3e0"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "📚"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "文献阅读"
                                    font.pixelSize: 14
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "8 篇"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 时长统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#f3e5f5"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "⏱️"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "咨询时长"
                                    font.pixelSize: 14
                                    color: "#7b1fa2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "250 分钟"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#7b1fa2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }

            // 编辑资料按钮
            Rectangle {
                width: parent.width
                height: 50
                radius: 8
                color: "#1976d2"

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "✏️"
                        font.pixelSize: 18
                        color: "white"
                    }

                    Text {
                        text: "编辑个人资料"
                        font.pixelSize: 16
                        color: "white"
                        font.bold: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        showEditDialog = true
                    }
                }
            }
        }
    }

    // 编辑资料弹窗
    Rectangle {
        id: editDialog
        anchors.fill: parent
        color: "#80000000"  // 半透明黑色背景
        visible: showEditDialog

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // 点击背景关闭弹窗
            }
        }

        // 弹窗内容
        Rectangle {
            id: dialogContent
            width: 400
            height: 500
            radius: 12
            color: "white"
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 15

                // 标题
                Text {
                    text: "编辑个人资料"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#1976d2"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // 姓名
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "姓名"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: nameInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.studentName
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 学号
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "学号"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: idInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.studentId
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 学院
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "学院"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: collegeInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.college
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 专业
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "专业"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: majorInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.major
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 年级
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "年级"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: gradeInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.grade
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 头像
                Column {
                    width: parent.width
                    spacing: 5

                    Text {
                        text: "头像表情"
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 6
                        border.color: "#ccc"
                        border.width: 1

                        TextInput {
                            id: avatarInput
                            anchors.fill: parent
                            anchors.margins: 10
                            text: personalCenterPage.avatar
                            font.pixelSize: 16
                            color: "#333"
                            clip: true
                        }
                    }
                }

                // 按钮区域
                Row {
                    width: parent.width
                    height: 45
                    spacing: 15

                    // 取消按钮
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 45
                        radius: 8
                        color: cancelMouseArea.containsMouse ? "#f5f5f5" : "white"
                        border.color: "#ccc"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "取消"
                            font.pixelSize: 16
                            color: "#666"
                        }

                        MouseArea {
                            id: cancelMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                showEditDialog = false
                            }
                        }
                    }

                    // 保存按钮
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 45
                        radius: 8
                        color: saveMouseArea.containsMouse ? "#1565c0" : "#1976d2"

                        Text {
                            anchors.centerIn: parent
                            text: "保存"
                            font.pixelSize: 16
                            color: "white"
                            font.bold: true
                        }

                        MouseArea {
                            id: saveMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                // 保存修改
                                personalCenterPage.studentName = nameInput.text
                                personalCenterPage.studentId = idInput.text
                                personalCenterPage.college = collegeInput.text
                                personalCenterPage.major = majorInput.text
                                personalCenterPage.grade = gradeInput.text
                                personalCenterPage.avatar = avatarInput.text

                                showEditDialog = false
                                console.log("个人资料已更新")
                            }
                        }
                    }
                }
            }
        }
    }
}
