import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: consultationLogPage
    color: "#e8eaf6"

    property string currentUserId: databaseHandler.getCurrentUserId()
    property bool isLoading: false
    property int totalConsultations: 0
    property int completedConsultations: 0
    property int notCompletedConsultations: 0

    // 咨询日志数据模型
    ListModel {
        id: consultationLogModel
    }

    Component.onCompleted: {
        loadConsultationLogs()
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
                        text: totalConsultations + " 次"
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
                        text: completedConsultations + " 次"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#4caf50"
                    }
                }

                // 未完成次数
                Column {
                    spacing: 5

                    Text {
                        text: "未完成"
                        font.pixelSize: 12
                        color: "#666"
                    }

                    Text {
                        text: notCompletedConsultations + " 次"
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
                                    text: model.consultationDate || "未指定"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#5c6bc0"
                                }

                                Text {
                                    text: (model.consultationSlot || "未指定") + " (" + (model.duration ? model.duration + "分钟" : "未记录") + ")"
                                    font.pixelSize: 12
                                    color: "#666"
                                }
                            }

                            // 导师信息
                            Column {
                                spacing: 2

                                Text {
                                    text: "导师：" + (model.teacherName || "未知咨询师")
                                    font.pixelSize: 14
                                    color: "#333"
                                }

                                Text {
                                    text: "类型：" + (model.consultationType || "未指定")
                                    font.pixelSize: 12
                                    color: "#666"
                                }
                            }

                            // 状态标签
                            Rectangle {
                                width: 60
                                height: 24
                                radius: 4
                                color: model.status === "已完成" ? "#4caf50" : "#ff9800"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.status || "未完成"
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

                        // 咨询总结（summary字段）- 显示在上面
                        Column {
                            width: parent.width
                            spacing: 2

                            Text {
                                text: "咨询总结："
                                font.pixelSize: 13
                                color: "#666"
                                font.bold: true
                            }

                            Text {
                                text: model.summary || "暂无总结"
                                font.pixelSize: 14
                                color: "#333"
                                width: parent.width
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }

                        // 自我评价（selfEvaluation字段）- 显示在咨询总结下面
                        Column {
                            width: parent.width
                            spacing: 2

                            Text {
                                text: "自我评价："
                                font.pixelSize: 13
                                color: "#666"
                                font.bold: true
                            }

                            Text {
                                text: model.selfEvaluation
                                font.pixelSize: 14
                                color: "#333"
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
                                    console.log("查看咨询日志详情：" + model.consultationId)
                                }
                            }
                        }

                        // 写评价按钮（仅对已完成且未评价的记录显示）
                        Rectangle {
                            width: 80
                            height: 36
                            radius: 8
                            color: "#ff9800"
                            visible: model.status === "已完成" && model.selfEvaluation <= 0

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
                                    console.log("为咨询写评价：" + model.consultationId)
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

    // 函数：加载咨询日志
    function loadConsultationLogs() {
        isLoading = true
        consultationLogModel.clear()
        totalConsultations = 0
        completedConsultations = 0
        notCompletedConsultations = 0

        timer.start()
    }

    Timer {
        id: timer
        interval: 100
        onTriggered: {
            try {
                var logs = databaseHandler.getConsultationLogs(currentUserId)

                consultationLogModel.clear()

                for (var i = 0; i < logs.length; i++) {
                    var log = logs[i]

                    // 统计信息
                    totalConsultations++

                    if (log.isCompleted) {
                        completedConsultations++
                    } else {
                        notCompletedConsultations++
                    }

                    // 根据数据库字段映射到页面显示
                    consultationLogModel.append({
                        consultationId: log.consultationId || 0,
                        consultationDate: log.consultationDate || "",
                        consultationSlot: log.consultationSlot || "",
                        teacherName: log.teacherName || "未知咨询师",
                        consultationType: log.consultationType || "未指定",
                        status: log.isCompleted ? "已完成" : "未完成",
                        duration: log.duration || 0,
                        summary: log.summary || "",          // 咨询总结
                        selfEvaluation: log.selfEvaluation || 0  // 自我评价分数
                    })

                    // 调试输出
                    console.log("加载记录", i, "咨询总结:", log.summary, "自我评价:", log.selfEvaluation)
                }

                console.log("加载了", consultationLogModel.count, "条咨询记录")
                console.log("统计：总计", totalConsultations, "次，已完成", completedConsultations, "次，未完成", notCompletedConsultations, "次")
            } catch (error) {
                console.log("加载咨询记录失败:", error)
            }

            isLoading = false
        }
    }
}
