import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: psychologicalAssessmentPage
    color: "#f8fcfd"  // 非常浅的蓝白色

    // 模拟测试数据
    ListModel {
        id: testHistoryModel
        ListElement {
            testName: "抑郁自评量表(SDS)"
            testType: "抑郁测试"
            date: "2023-12-20"
            score: 48
            result: "轻度抑郁"
            status: "已完成"
        }
        ListElement {
            testName: "焦虑自评量表(SAS)"
            testType: "焦虑测试"
            date: "2023-12-15"
            score: 56
            result: "中度焦虑"
            status: "已完成"
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // 标题
        Text {
            text: "心理健康评估"
            font.pixelSize: 26
            font.bold: true
            color: "#2e7d8f"  // 深蓝绿色
            width: parent.width
            horizontalAlignment: Text.AlignLeft
        }

        // 快速测试卡片
        Rectangle {
            width: parent.width
            height: 140
            radius: 12
            color: "white"
            border.color: "#e0f2f1"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                Text {
                    text: "💡 快速心理测试"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#2e7d8f"
                }

                Text {
                    text: "选择测试类型开始评估"
                    font.pixelSize: 13
                    color: "#666"
                }

                // 测试类型选择
                Row {
                    width: parent.width
                    height: 70
                    spacing: 15

                    // 抑郁测试
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 70
                        radius: 10
                        color: mouseArea1.containsMouse ? "#e8f4f8" : "#f5fafc"
                        border.color: "#b2dfdb"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "😔"
                                font.pixelSize: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "抑郁测试"
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2e7d8f"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            id: mouseArea1
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                console.log("开始抑郁测试")
                            }
                        }
                    }

                    // 焦虑测试
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 70
                        radius: 10
                        color: mouseArea2.containsMouse ? "#e8f4f8" : "#f5fafc"
                        border.color: "#b2dfdb"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "😰"
                                font.pixelSize: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "焦虑测试"
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2e7d8f"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            id: mouseArea2
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                console.log("开始焦虑测试")
                            }
                        }
                    }
                }
            }
        }

        // 历史记录标题
        Row {
            width: parent.width
            height: 30
            spacing: 10

            Text {
                text: "📋 历史测试记录"
                font.pixelSize: 18
                font.bold: true
                color: "#2e7d8f"
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                text: "共" + testHistoryModel.count + "条记录"
                font.pixelSize: 13
                color: "#888"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // 历史记录列表
        ListView {
            width: parent.width
            height: parent.height - 220
            clip: true
            spacing: 10
            model: testHistoryModel

            delegate: Rectangle {
                width: parent.width
                height: 100
                radius: 10
                color: "white"
                border.color: "#e0f2f1"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // 测试图标
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: {
                            if (score < 40) return "#81c9b8"
                            else if (score < 55) return "#ffb566"
                            else return "#ff8a80"
                        }
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: score < 40 ? "😊" : (score < 55 ? "😐" : "😔")
                            font.pixelSize: 18
                            color: "white"
                        }
                    }

                    // 测试信息
                    Column {
                        width: parent.width - 130
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                text: testName
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            Rectangle {
                                width: 60
                                height: 20
                                radius: 10
                                color: {
                                    if (score < 40) return "#e8f5f2"
                                    else if (score < 55) return "#fff5e8"
                                    else return "#ffebee"
                                }
                                border.color: {
                                    if (score < 40) return "#4caf93"
                                    else if (score < 55) return "#ff9800"
                                    else return "#f44336"
                                }
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: score + "分"
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: {
                                        if (score < 40) return "#4caf93"
                                        else if (score < 55) return "#ff9800"
                                        else return "#f44336"
                                    }
                                }
                            }
                        }

                        // 测试类型和日期
                        Row {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: "类型：" + testType
                                font.pixelSize: 13
                                color: "#666"
                            }

                            Text {
                                text: "日期：" + date
                                font.pixelSize: 13
                                color: "#999"
                            }
                        }

                        // 结果
                        Text {
                            text: "评估结果：" + result
                            font.pixelSize: 14
                            color: score < 40 ? "#4caf93" : (score < 55 ? "#ff9800" : "#f44336")
                            font.bold: true
                        }
                    }

                    // 状态标签
                    Rectangle {
                        width: 60
                        height: 24
                        radius: 12
                        color: "#e8f5f2"
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: status
                            font.pixelSize: 11
                            color: "#4caf93"
                            font.bold: true
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log("查看测试详情：" + testName)
                    }
                }
            }

            // 空状态提示
            Rectangle {
                width: parent.width
                height: 200
                visible: testHistoryModel.count === 0

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    Text {
                        text: "📝"
                        font.pixelSize: 40
                    }

                    Text {
                        text: "暂无测试记录"
                        font.pixelSize: 16
                        color: "#888"
                        font.bold: true
                    }

                    Text {
                        text: "完成心理测试后会在这里显示历史记录"
                        font.pixelSize: 13
                        color: "#bbb"
                    }
                }
            }
        }
    }
}
