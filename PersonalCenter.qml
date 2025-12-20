import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: personalCenterPage
    color: "#f5f7fa"  // 浅灰色背景，更专业

    // 用户数据
    property string studentName: "张三"
    property string studentId: "202310001"
    property string college: "计算机科学与技术学院"
    property string major: "软件工程"
    property string grade: "2023级"
    property string avatar: "👨‍🎓"

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
                        color: "#e3f2fd"  // 浅蓝色背景
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
                        color: "#1976d2"  // 深蓝色
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
                            color: "#e8f5e9"  // 浅绿色

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
                                    color: "#388e3c"  // 深绿色
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
                            color: "#e3f2fd"  // 浅蓝色

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
                                    color: "#1976d2"  // 深蓝色
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
                            color: "#fff3e0"  // 浅橙色

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
                                    color: "#f57c00"  // 深橙色
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
                            color: "#f3e5f5"  // 浅紫色

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
                                    color: "#7b1fa2"  // 深紫色
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
                        console.log("编辑个人资料")
                    }
                }
            }
        }
    }
}
