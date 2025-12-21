import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: consultationLogPage
    color: "#e8eaf6"

    // 咨询日志数据模型
    ListModel {
        id: consultationLogModel

        ListElement {
            logId: "log1"
            date: "2023-12-18"
            time: "14:30-15:20"
            counselor: "张教授"
            type: "线上咨询"
            status: "已完成"
            statusColor: "#4caf50"
            duration: "50分钟"
            summary: "讨论学业压力问题，提供时间管理建议"
            evaluation: "有帮助，情绪有所缓解"
        }

        ListElement {
            logId: "log2"
            date: "2023-12-15"
            time: "10:00-10:50"
            counselor: "李老师"
            type: "线下咨询"
            status: "已完成"
            statusColor: "#4caf50"
            duration: "50分钟"
            summary: "人际关系困扰，学习沟通技巧"
            evaluation: "非常有用，学会了更好的沟通方式"
        }

        ListElement {
            logId: "log3"
            date: "2023-12-12"
            time: "16:00-16:50"
            counselor: "王医生"
            type: "线上咨询"
            status: "已完成"
            statusColor: "#4caf50"
            duration: "50分钟"
            summary: "睡眠质量改善咨询"
            evaluation: "睡眠有所改善，继续坚持"
        }

        ListElement {
            logId: "log4"
            date: "2023-12-08"
            time: "15:00-15:50"
            counselor: "刘老师"
            type: "线下咨询"
            status: "已取消"
            statusColor: "#f44336"
            duration: "50分钟"
            summary: "职业规划咨询（因故取消）"
            evaluation: ""
        }

        ListElement {
            logId: "log5"
            date: "2023-12-05"
            time: "11:00-11:50"
            counselor: "陈老师"
            type: "线上咨询"
            status: "已完成"
            statusColor: "#4caf50"
            duration: "50分钟"
            summary: "情绪管理，正念练习指导"
            evaluation: "学会了放松技巧，情绪更稳定"
        }

        ListElement {
            logId: "log6"
            date: "2023-12-01"
            time: "09:30-10:20"
            counselor: "赵老师"
            type: "线下咨询"
            status: "已完成"
            statusColor: "#4caf50"
            duration: "50分钟"
            summary: "家庭关系协调咨询"
            evaluation: "理解了家人立场，关系有所改善"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // 标题
        Text {
            text: "我的咨询日志"
            font.pixelSize: 24
            font.bold: true
            color: "#5c6bc0"
        }

        // 统计信息
        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: 10
            color: "white"
            border.color: "#c5cae9"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 20

                // 总咨询次数
                Column {
                    spacing: 5

                    Text {
                        text: "总咨询次数"
                        font.pixelSize: 12
                        color: "#666"
                    }

                    Text {
                        text: "6 次"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#5c6bc0"
                    }
                }

                // 完成次数
                Column {
                    spacing: 5

                    Text {
                        text: "已完成"
                        font.pixelSize: 12
                        color: "#666"
                    }

                    Text {
                        text: "5 次"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#4caf50"
                    }
                }

                // 线上/线下比例
                Column {
                    spacing: 5

                    Text {
                        text: "线上/线下"
                        font.pixelSize: 12
                        color: "#666"
                    }

                    Text {
                        text: "3 / 3"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#ff9800"
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }

        // 修改为 ListView
        ListView {
            id: logListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 15  // 卡片间距
            model: consultationLogModel

            // 滚动条设置（在右侧显示）
            ScrollBar.vertical: ScrollBar {
                width: 8
                policy: ScrollBar.AlwaysOn  // 总是显示滚动条
                active: true
            }

            delegate: Rectangle {
                width: logListView.width
                height: 160
                radius: 10
                color: "white"
                border.color: "#c5cae9"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 20

                    // 左侧：咨询信息
                    Column {
                        width: parent.width - 100
                        spacing: 8

                        // 第一行：基本信息
                        Row {
                            width: parent.width
                            spacing: 15

                            // 日期时间
                            Column {
                                spacing: 2

                                Text {
                                    text: model.date
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#5c6bc0"
                                }

                                Text {
                                    text: model.time + " (" + model.duration + ")"
                                    font.pixelSize: 12
                                    color: "#666"
                                }
                            }

                            // 导师信息
                            Column {
                                spacing: 2

                                Text {
                                    text: "导师：" + model.counselor
                                    font.pixelSize: 14
                                    color: "#333"
                                }

                                Text {
                                    text: "类型：" + model.type
                                    font.pixelSize: 12
                                    color: "#666"
                                }
                            }

                            // 状态标签
                            Rectangle {
                                width: 60
                                height: 24
                                radius: 4
                                color: model.statusColor

                                Text {
                                    anchors.centerIn: parent
                                    text: model.status
                                    color: "white"
                                    font.pixelSize: 12
                                    font.bold: true
                                }
                            }
                        }

                        // 分割线
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#e0e0e0"
                        }

                        // 咨询摘要
                        Column {
                            width: parent.width
                            spacing: 5

                            Text {
                                text: "咨询摘要："
                                font.pixelSize: 13
                                color: "#666"
                                font.bold: true
                            }

                            Text {
                                text: model.summary
                                font.pixelSize: 14
                                color: "#333"
                                width: parent.width
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }

                        // 自我评价
                        Column {
                            width: parent.width
                            spacing: 5
                            visible: model.evaluation !== ""

                            Text {
                                text: "自我评价："
                                font.pixelSize: 13
                                color: "#666"
                                font.bold: true
                            }

                            Text {
                                text: model.evaluation
                                font.pixelSize: 14
                                color: "#4caf50"
                                font.bold: true
                                width: parent.width
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }
                    }

                    // 右侧：查看详情按钮
                    Column {
                        width: 80
                        spacing: 5

                        // 查看详情按钮
                        Rectangle {
                            width: 80
                            height: 36
                            radius: 8
                            color: "#5c6bc0"

                            Text {
                                anchors.centerIn: parent
                                text: "查看详情"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("查看咨询日志详情：" + model.logId)
                                }
                            }
                        }

                        // 写评价按钮（仅对已完成且未评价的记录显示）
                        Rectangle {
                            width: 80
                            height: 36
                            radius: 8
                            color: "#ff9800"
                            visible: model.status === "已完成" && model.evaluation === ""

                            Text {
                                anchors.centerIn: parent
                                text: "写评价"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("为咨询写评价：" + model.logId)
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    // 可以添加点击事件
                }
            }

            // 没有记录时的提示
            footer: Rectangle {
                width: logListView.width
                height: 200
                visible: consultationLogModel.count === 0

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    Text {
                        text: "📝"
                        font.pixelSize: 40
                    }

                    Text {
                        text: "暂无咨询记录"
                        font.pixelSize: 18
                        color: "#666"
                        font.bold: true
                    }

                    Text {
                        text: "快去预约一次心理咨询吧！"
                        font.pixelSize: 14
                        color: "#999"
                    }
                }
            }
        }
    }
}
