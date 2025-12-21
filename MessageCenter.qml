import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: messageCenterPage
    color: "#e8f5e8"

    // 消息数据模型 - 只包含预约消息
    ListModel {
        id: messageModel

        ListElement {
            messageId: "msg1"
            title: "线下咨询预约成功"
            content: "您已成功预约张教授的线下咨询"
            time: "今天 15:30"
            counselor: "张教授"
            appointmentTime: "2023-12-22 14:00-15:00"
            read: false
            icon: "✅"
        }

        ListElement {
            messageId: "msg2"
            title: "线下咨询预约成功"
            content: "您已成功预约李老师的线下咨询"
            time: "昨天 09:15"
            counselor: "李老师"
            appointmentTime: "2023-12-25 10:00-11:00"
            read: true
            icon: "✅"
        }

        ListElement {
            messageId: "msg3"
            title: "线下咨询预约失败"
            content: "您预约的时间段已被占用，预约失败"
            time: "12月19日 14:20"
            counselor: "王医生"
            appointmentTime: "2023-12-23 16:00-17:00"
            read: true
            icon: "❌"
        }

        ListElement {
            messageId: "msg4"
            title: "线下咨询预约成功"
            content: "您已成功预约刘老师的线下咨询"
            time: "12月18日 11:45"
            counselor: "刘老师"
            appointmentTime: "2023-12-28 15:00-16:00"
            read: true
            icon: "✅"
        }

        ListElement {
            messageId: "msg5"
            title: "线下咨询预约失败"
            content: "导师临时有事，预约已取消"
            time: "12月17日 16:30"
            counselor: "陈老师"
            appointmentTime: "2023-12-24 11:00-12:00"
            read: true
            icon: "❌"
        }

        ListElement {
            messageId: "msg6"
            title: "线下咨询预约成功"
            content: "您已成功预约赵老师的线下咨询"
            time: "12月16日 13:10"
            counselor: "赵老师"
            appointmentTime: "2023-12-29 09:30-10:30"
            read: true
            icon: "✅"
        }

        ListElement {
            messageId: "msg7"
            title: "线下咨询预约失败"
            content: "系统维护中，预约未成功"
            time: "12月15日 10:25"
            counselor: "周老师"
            appointmentTime: "2023-12-26 14:30-15:30"
            read: true
            icon: "❌"
        }

        ListElement {
            messageId: "msg8"
            title: "线下咨询预约成功"
            content: "您已成功预约吴老师的线下咨询"
            time: "12月14日 16:40"
            counselor: "吴老师"
            appointmentTime: "2023-12-30 16:00-17:00"
            read: true
            icon: "✅"
        }

        ListElement {
            messageId: "msg9"
            title: "线下咨询预约失败"
            content: "超过可预约时间范围"
            time: "12月13日 08:55"
            counselor: "郑老师"
            appointmentTime: "2023-12-31 18:00-19:00"
            read: true
            icon: "❌"
        }

        ListElement {
            messageId: "msg10"
            title: "线下咨询预约成功"
            content: "您已成功预约孙老师的线下咨询"
            time: "12月12日 14:15"
            counselor: "孙老师"
            appointmentTime: "2024-01-02 10:00-11:00"
            read: true
            icon: "✅"
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // 标题
        Text {
            text: "预约消息通知"
            font.pixelSize: 24
            font.bold: true
            color: "#388e3c"
        }

        // 消息列表
        ListView {
            id: messageListView
            width: parent.width
            height: parent.height - 50
            spacing: 15
            clip: true
            model: messageModel

            delegate: Rectangle {
                id: messageItem
                width: messageListView.width
                height: 160
                radius: 10
                color: model.read ? "white" : "#f1f8e9"
                border.color: model.read ? "#e0e0e0" : "#4caf50"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    // 消息图标
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: model.icon === "✅" ? "#4caf50" : "#f44336"

                        Text {
                            anchors.centerIn: parent
                            text: model.icon
                            font.pixelSize: 22
                            color: "white"
                        }

                        // 未读红点
                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: "#f44336"
                            visible: !model.read
                            anchors.top: parent.top
                            anchors.right: parent.right
                        }
                    }

                    // 消息内容
                    Column {
                        width: parent.width - 130
                        spacing: 10

                        // 标题和时间
                        Row {
                            width: parent.width
                            spacing: 15

                            Text {
                                text: model.title
                                font.pixelSize: 18
                                font.bold: true
                                color: model.icon === "✅" ? "#4caf50" : "#f44336"
                            }

                            Item {
                                width: parent.width - model.title.length * 9 - 120
                            }

                            Text {
                                text: model.time
                                font.pixelSize: 14
                                color: "#999"
                            }
                        }

                        // 消息内容
                        Text {
                            text: model.content
                            font.pixelSize: 16
                            color: "#333"
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        // 预约详情
                        Row {
                            width: parent.width
                            spacing: 25

                            Text {
                                text: "导师：" + model.counselor
                                font.pixelSize: 15
                                color: "#666"
                            }

                            Text {
                                text: "时间：" + model.appointmentTime
                                font.pixelSize: 15
                                color: "#666"
                            }
                        }
                    }

                    // 删除按钮 - 已修改为红色"❌"
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: "#ffeaea"
                        border.color: "#ff6b6b"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "❌"
                            font.pixelSize: 20
                            color: "#ff4444"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // 从模型中删除当前项
                                messageModel.remove(index)
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        messageModel.setProperty(index, "read", true)
                        console.log("查看消息：" + model.title)
                    }
                }
            }

            // 没有消息时的提示
            Rectangle {
                width: messageListView.width
                height: 200
                visible: messageModel.count === 0

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    Text {
                        text: "📭"
                        font.pixelSize: 40
                    }

                    Text {
                        text: "暂无预约消息"
                        font.pixelSize: 18
                        color: "#666"
                        font.bold: true
                    }

                    Text {
                        text: "当您进行线下预约后，相关通知会在这里显示"
                        font.pixelSize: 14
                        color: "#999"
                    }
                }
            }
        }
    }
}
