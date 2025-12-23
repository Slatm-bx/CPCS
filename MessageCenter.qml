import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: messageCenterPage
    color: "#e8f5e8"

    // 消息数据模型
    ListModel {
        id: messageModel
    }

    // 页面加载时获取消息
    Component.onCompleted: {
        loadMessages();
    }

    // 加载消息
    function loadMessages() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler对象不存在");
            return;
        }

        var studentId = databaseHandler.getCurrentUserId();
        if (!studentId) {
            console.log("错误：未获取到学生ID");
            return;
        }

        console.log("正在获取学生ID：" + studentId + " 的消息");

        // 从数据库获取消息
        var messages = databaseHandler.getStudentAppointmentMessages(studentId);

        // 清空并添加消息
        messageModel.clear();
        for (var i = 0; i < messages.length; i++) {
            var msg = messages[i];
            messageModel.append({
                messageId: msg.messageId,
                title: msg.title,
                content: msg.content,
                time: msg.time,
                counselor: msg.counselor,
                appointmentTime: msg.appointmentTime,
                read: msg.read,
                icon: msg.icon
            });
        }

        console.log("成功加载了" + messageModel.count + "条消息");
    }

    // 标记消息为已读
    function markMessageRead(messageId, index) {
        if (databaseHandler && databaseHandler.markMessageAsRead(messageId)) {
            messageModel.setProperty(index, "read", true);
        }
    }

    // 删除消息
    function deleteMessage(messageId, index) {
        console.log("尝试删除消息ID：" + messageId + "，索引：" + index);
        if (databaseHandler) {
            var success = databaseHandler.deleteStudentMessage(messageId);
            console.log("数据库删除结果：" + success);
            if (success) {
                messageModel.remove(index);
            }
        } else {
            console.log("databaseHandler不存在");
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

                // 主区域点击（查看消息）
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (!model.read) {
                            markMessageRead(model.messageId, index);
                        }
                        console.log("查看消息：" + model.title);
                    }
                }

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

                    // 删除按钮
                    Rectangle {
                        id: deleteButton
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
                                console.log("删除按钮被点击");
                                deleteMessage(model.messageId, index);
                            }
                        }
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
