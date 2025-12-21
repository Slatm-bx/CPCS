import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: counselorChatPage
    color: "#f0f8ff"

    property var currentCounselor: null
    property bool inChatRoom: false
    property bool showAppointmentDialog: false
    property var selectedCounselorForAppointment: null

    // 预约时间选项
    ListModel {
        id: timeSlotsModel
        ListElement { time: "09:00-10:00" }
        ListElement { time: "10:00-11:00" }
        ListElement { time: "11:00-12:00" }
        ListElement { time: "14:00-15:00" }
        ListElement { time: "15:00-16:00" }
        ListElement { time: "16:00-17:00" }
    }

    // 咨询类型选项
    ListModel {
        id: consultationTypesModel
        ListElement { type: "个体心理咨询"; duration: "50分钟" }
        ListElement { type: "情绪管理咨询"; duration: "50分钟" }
        ListElement { type: "学业压力咨询"; duration: "50分钟" }
        ListElement { type: "人际关系咨询"; duration: "50分钟" }
    }

    // 预约表单数据
    property string appointmentDate: Qt.formatDate(new Date(), "yyyy-MM-dd")
    property string selectedTime: ""
    property string selectedConsultationType: ""
    property string problemDescription: ""
    property string contactPhone: ""

    // 导师数据模型 - 简化到4位老师
    ListModel {
        id: counselorModel
        ListElement {
            counselorId: "counselor1"
            name: "张教授"
            title: "心理咨询师"
            avatar: "👨‍🏫"
            specialty: "焦虑情绪、压力管理"
            rating: "4.8"
            status: "在线"
            statusColor: "#4caf50"
            consultationTimes: "周一至周五 9:00-17:00"
        }
        ListElement {
            counselorId: "counselor2"
            name: "李老师"
            title: "心理辅导师"
            avatar: "👩‍🏫"
            specialty: "人际关系、自我成长"
            rating: "4.7"
            status: "在线"
            statusColor: "#4caf50"
            consultationTimes: "周二、周四 10:00-18:00"
        }
        ListElement {
            counselorId: "counselor3"
            name: "王医生"
            title: "临床心理医师"
            avatar: "👨‍⚕️"
            specialty: "抑郁情绪、睡眠问题"
            rating: "4.9"
            status: "忙碌"
            statusColor: "#ff9800"
            consultationTimes: "周三、周五 8:30-16:30"
        }
        ListElement {
            counselorId: "counselor4"
            name: "刘老师"
            title: "心理咨询师"
            avatar: "👩‍💼"
            specialty: "学业压力、职业规划"
            rating: "4.6"
            status: "离线"
            statusColor: "#9e9e9e"
            consultationTimes: "周一、周三 13:00-21:00"
        }
    }

    // 导师列表页面
    Rectangle {
        id: counselorListPage
        anchors.fill: parent
        visible: !inChatRoom && !showAppointmentDialog

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "心理导师列表"
                font.pixelSize: 26
                font.bold: true
                color: "#1976d2"
            }

            GridView {
                id: counselorGridView
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: parent.width / 2 - 10
                cellHeight: 270
                clip: true
                model: counselorModel

                delegate: Rectangle {
                    width: counselorGridView.cellWidth - 10
                    height: counselorGridView.cellHeight - 10
                    radius: 12
                    color: "white"
                    border.color: "#e3f2fd"
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 12

                        // 头像和状态
                        Rectangle {
                            width: parent.width
                            height: 70

                            Row {
                                spacing: 12

                                Rectangle {
                                    width: 55
                                    height: 55
                                    radius: 27.5
                                    color: "#e3f2fd"

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.avatar
                                        font.pixelSize: 22
                                    }

                                    Rectangle {
                                        width: 12
                                        height: 12
                                        radius: 6
                                        color: model.statusColor
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        border.width: 2
                                        border.color: "white"
                                    }
                                }

                                Column {
                                    spacing: 4
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        text: model.name
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "#1976d2"
                                    }

                                    Text {
                                        text: model.title
                                        font.pixelSize: 13
                                        color: "#666"
                                    }

                                    Row {
                                        spacing: 4
                                        Text {
                                            text: "★"
                                            color: "#ff9800"
                                            font.pixelSize: 13
                                        }
                                        Text {
                                            text: model.rating
                                            font.pixelSize: 13
                                            color: "#666"
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        Text {
                            text: "专长："
                            font.pixelSize: 13
                            color: "#666"
                        }

                        Text {
                            text: model.specialty
                            font.pixelSize: 14
                            color: "#1976d2"
                            font.bold: true
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        Text {
                            text: "时间："
                            font.pixelSize: 13
                            color: "#666"
                        }

                        Text {
                            text: model.consultationTimes
                            font.pixelSize: 13
                            color: "#888"
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        // 按钮区域
                        Rectangle {
                            width: (parent.width - 10)
                            height: 34
                            radius: 8
                            color: "#4caf50"

                            Text {
                                anchors.centerIn: parent
                                text: "线下预约"
                                color: "white"
                                font.pixelSize: 13
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    showAppointmentDialog = true
                                    selectedCounselorForAppointment = {
                                        name: model.name,
                                        title: model.title,
                                        avatar: model.avatar
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 预约对话框 - 简化版本
    Rectangle {
        id: appointmentDialog
        anchors.fill: parent
        color: "#f0f8ff"
        visible: showAppointmentDialog

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            // 返回按钮和标题
            RowLayout {
                spacing: 15

                // 返回按钮
                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: "#e3f2fd"

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        color: "#1976d2"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            showAppointmentDialog = false
                            resetAppointmentForm()
                        }
                    }
                }

                Text {
                    text: "咨询预约"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#1976d2"
                    Layout.fillWidth: true
                }
            }

            // 导师信息卡片
            Rectangle {
                Layout.fillWidth: true
                height: 80
                radius: 12
                color: "#e3f2fd"
                border.color: "#bbdefb"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: "white"

                        Text {
                            anchors.centerIn: parent
                            text: selectedCounselorForAppointment ? selectedCounselorForAppointment.avatar : "👨‍🏫"
                            font.pixelSize: 20
                        }
                    }

                    Column {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: selectedCounselorForAppointment ? selectedCounselorForAppointment.name : ""
                            font.pixelSize: 16
                            font.bold: true
                            color: "#1976d2"
                        }

                        Text {
                            text: selectedCounselorForAppointment ? selectedCounselorForAppointment.title : ""
                            font.pixelSize: 14
                            color: "#666"
                        }
                    }
                }
            }

            // 表单区域 - 不使用ScrollView，简化布局
            ColumnLayout {
                spacing: 15
                Layout.fillWidth: true
                Layout.fillHeight: true

                // 日期选择
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "预约日期"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    RowLayout {
                        spacing: 10

                        Rectangle {
                            width: 60
                            height: 36
                            radius: 8
                            color: "#e3f2fd"

                            Text {
                                anchors.centerIn: parent
                                text: "前一天"
                                color: "#1976d2"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var date = new Date(appointmentDate)
                                    date.setDate(date.getDate() - 1)
                                    appointmentDate = Qt.formatDate(date, "yyyy-MM-dd")
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 36
                            radius: 8
                            color: "#f5f5f5"
                            border.color: "#e0e0e0"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: appointmentDate
                                font.pixelSize: 15
                                color: "#333"
                            }
                        }

                        Rectangle {
                            width: 60
                            height: 36
                            radius: 8
                            color: "#e3f2fd"

                            Text {
                                anchors.centerIn: parent
                                text: "后一天"
                                color: "#1976d2"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var date = new Date(appointmentDate)
                                    date.setDate(date.getDate() + 1)
                                    appointmentDate = Qt.formatDate(date, "yyyy-MM-dd")
                                }
                            }
                        }
                    }
                }

                // 时间选择
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "选择时间"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: timeSlotsModel

                            Rectangle {
                                width: 95
                                height: 38
                                radius: 8
                                color: selectedTime === model.time ? "#1976d2" : "#f5f5f5"
                                border.color: selectedTime === model.time ? "#1565c0" : "#e0e0e0"
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: model.time
                                    color: selectedTime === model.time ? "white" : "#333"
                                    font.pixelSize: 13
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        selectedTime = model.time
                                    }
                                }
                            }
                        }
                    }
                }

                // 咨询类型选择
                // 咨询类型选择 - 修改这部分
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "咨询类型"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    // 使用Flow或Grid代替Row
                    Flow {
                        id: consultationTypeFlow
                        Layout.fillWidth: true
                        spacing: 10

                        // 计算每个项目的宽度
                        property int itemWidth: (parent.width - 20) / 2

                        Repeater {
                            model: consultationTypesModel

                            Rectangle {
                                width: consultationTypeFlow.itemWidth
                                height: 45
                                radius: 8
                                color: selectedConsultationType === model.type ? "#e3f2fd" : "#f5f5f5"
                                border.color: selectedConsultationType === model.type ? "#1976d2" : "#e0e0e0"
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 2

                                    Text {
                                        text: model.type
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: selectedConsultationType === model.type ? "#1976d2" : "#333"
                                        width: parent.width
                                        wrapMode: Text.Wrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    Text {
                                        text: model.duration
                                        font.pixelSize: 10
                                        color: selectedConsultationType === model.type ? "#1976d2" : "#666"
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        selectedConsultationType = model.type
                                    }
                                }
                            }
                        }
                    }
                }

                // 问题描述
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100

                    Text {
                        text: "问题描述（可选）"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 8
                        color: "#f5f5f5"
                        border.color: "#e0e0e0"
                        border.width: 1

                        TextArea {
                            anchors.fill: parent
                            anchors.margins: 8
                            placeholderText: "请简要描述你想要咨询的问题..."
                            font.pixelSize: 14
                            wrapMode: TextArea.Wrap
                            background: Rectangle {
                                color: "transparent"
                            }

                            onTextChanged: {
                                problemDescription = text
                            }
                        }
                    }
                }

                // 联系方式
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "联系电话"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        radius: 8
                        color: "#f5f5f5"
                        border.color: "#e0e0e0"
                        border.width: 1

                        TextField {
                            anchors.fill: parent
                            anchors.margins: 5
                            placeholderText: "请输入手机号码"
                            font.pixelSize: 14
                            background: Rectangle {
                                color: "transparent"
                            }

                            onTextChanged: {
                                contactPhone = text
                            }
                        }
                    }
                }
            }

            // 提交按钮
            Rectangle {
                id: submitButton
                Layout.fillWidth: true
                height: 48
                radius: 8
                color: canSubmit ? "#4caf50" : "#bdbdbd"

                property bool canSubmit: selectedTime !== "" &&
                                         selectedConsultationType !== "" &&
                                         contactPhone.length >= 11

                Text {
                    anchors.centerIn: parent
                    text: "提交预约"
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: submitButton.canSubmit
                    onClicked: {
                        submitAppointment()
                    }
                }
            }
        }
    }

    // 提交成功提示
    Rectangle {
        id: successDialog
        anchors.fill: parent
        color: "#80000000"
        visible: false
        z: 200

        Rectangle {
            width: 280
            height: 160
            radius: 12
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 8

                Text {
                    text: "✅"
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Text {
                    text: "预约成功！"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#4caf50"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Text {
                    text: "预约信息已提交\n请按时前往心理中心"
                    font.pixelSize: 13
                    color: "#666"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: "#4caf50"

                    Text {
                        anchors.centerIn: parent
                        text: "确定"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            successDialog.visible = false
                            showAppointmentDialog = false
                            resetAppointmentForm()
                        }
                    }
                }
            }
        }
    }

    // 函数：重置预约表单
    function resetAppointmentForm() {
        appointmentDate = Qt.formatDate(new Date(), "yyyy-MM-dd")
        selectedTime = ""
        selectedConsultationType = ""
        problemDescription = ""
        contactPhone = ""
    }

    // 函数：提交预约
    function submitAppointment() {
        console.log("=== 预约信息提交 ===")
        console.log("导师：" + (selectedCounselorForAppointment ? selectedCounselorForAppointment.name : ""))
        console.log("日期：" + appointmentDate)
        console.log("时间：" + selectedTime)
        console.log("咨询类型：" + selectedConsultationType)
        console.log("问题描述：" + problemDescription)
        console.log("联系电话：" + contactPhone)
        console.log("==================")

        // 显示成功提示
        successDialog.visible = true
    }
}
