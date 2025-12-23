import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: consultationSupervisionPage
    color: "#f8f9fa"

    // 定义查看详情信号
    signal showConsultationDetailDialog(int consultationId, string studentName, string counselor,
                                        string consultationDate, string consultationType,
                                        int duration, string phoneNumber, string selfEvaluation, string summary)

    // 咨询记录数据列表
    property var consultationList: []

    // 页面加载时获取数据
    Component.onCompleted: {
        refreshData()
    }

    // 刷新数据函数
    function refreshData() {
        consultationList = databaseHandler.getAllConsultationLogs()
        console.log("获取到咨询记录数量:", consultationList.length)
    }

    // 顶部标题栏
    Rectangle {
        id: pageHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: "#ffffff"
        border.color: "#e9ecef"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            // 标题
            Text {
                text: "📋 咨询监管"
                font.pixelSize: 24
                font.bold: true
                color: "#2c3e50"
            }

            Item { Layout.fillWidth: true }

            // 刷新按钮
            Button {
                text: "🔄 刷新"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36

                background: Rectangle {
                    color: parent.down ? "#e67e22" : "#ff9800"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: refreshData()
            }
        }
    }

    // 统计信息栏
    Rectangle {
        id: statsBar
        anchors.top: pageHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "#fff3e0"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            Text {
                text: "共 " + consultationList.length + " 条咨询记录"
                font.pixelSize: 14
                color: "#e65100"
            }

            Item { Layout.fillWidth: true }
        }
    }

    // 表头
    Rectangle {
        id: tableHeader
        anchors.top: statsBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 15
        height: 45
        color: "#ff9800"
        radius: 6

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 10

            Text {
                text: "咨询ID"
                Layout.preferredWidth: 80
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "学生姓名"
                Layout.preferredWidth: 100
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "咨询师"
                Layout.preferredWidth: 100
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "咨询日期"
                Layout.preferredWidth: 120
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "咨询时段"
                Layout.preferredWidth: 100
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "咨询类型"
                Layout.preferredWidth: 100
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "状态"
                Layout.preferredWidth: 80
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "操作"
                Layout.fillWidth: true
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // 咨询记录列表
    ScrollView {
        id: scrollView
        anchors.top: tableHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        anchors.topMargin: 5
        clip: true

        Column {
            width: scrollView.width
            spacing: 5

            Repeater {
                model: consultationList

                delegate: Rectangle {
                    width: scrollView.width - 15
                    height: 50
                    color: index % 2 === 0 ? "#ffffff" : "#fafafa"
                    radius: 4
                    border.color: "#e9ecef"
                    border.width: 1

                    property var logData: modelData

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        spacing: 10

                        // 咨询ID
                        Text {
                            text: logData.consultationId || "-"
                            Layout.preferredWidth: 80
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 学生姓名
                        Text {
                            text: logData.studentName || logData.studentId || "-"
                            Layout.preferredWidth: 100
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 咨询师
                        Text {
                            text: logData.counselor || "-"
                            Layout.preferredWidth: 100
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 咨询日期
                        Text {
                            text: logData.consultationDate || "-"
                            Layout.preferredWidth: 120
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 咨询时段
                        Text {
                            text: logData.consultationSlot || "-"
                            Layout.preferredWidth: 100
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 咨询类型
                        Rectangle {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 28
                            color: getTypeColor(logData.consultationType)
                            radius: 4

                            Text {
                                anchors.centerIn: parent
                                text: logData.consultationType || "-"
                                font.pixelSize: 12
                                color: "white"
                            }

                            function getTypeColor(type) {
                                if (type === "个人咨询") return "#3498db"
                                if (type === "团体辅导") return "#9b59b6"
                                if (type === "危机干预") return "#e74c3c"
                                if (type === "心理测评") return "#27ae60"
                                return "#95a5a6"
                            }
                        }

                        // 咨询状态
                        Rectangle {
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 28
                            color: logData.isCompleted ? "#27ae60" : "#f39c12"
                            radius: 4

                            Text {
                                anchors.centerIn: parent
                                text: logData.isCompleted ? "已完成" : "进行中"
                                font.pixelSize: 12
                                color: "white"
                            }
                        }

                        // 操作按钮
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36

                            Button {
                                anchors.centerIn: parent
                                text: "查看详情"
                                width: 80
                                height: 30

                                background: Rectangle {
                                    color: parent.down ? "#2980b9" : "#3498db"
                                    radius: 4
                                }

                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.pixelSize: 12
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: {
                                    consultationSupervisionPage.showConsultationDetailDialog(
                                        logData.consultationId,
                                        logData.studentName || logData.studentId || "",
                                        logData.counselor || "",
                                        logData.consultationDate || "",
                                        logData.consultationType || "",
                                        logData.duration || 0,
                                        logData.phoneNumber || "",
                                        logData.selfEvaluation || "",
                                        logData.summary || ""
                                    )
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        z: -1

                        onEntered: parent.color = "#fff3e0"
                        onExited: parent.color = index % 2 === 0 ? "#ffffff" : "#fafafa"
                    }
                }
            }

            // 无数据提示
            Rectangle {
                width: scrollView.width - 15
                height: 100
                visible: consultationList.length === 0
                color: "#f8f9fa"
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "📭 暂无咨询记录"
                    font.pixelSize: 16
                    color: "#6c757d"
                }
            }
        }
    }
}
