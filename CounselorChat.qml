import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: counselorChatPage
    color: "#f0f8ff"  // 蓝白色背景

    property var currentCounselor: null
    property bool inChatRoom: false
    property bool showAppointmentDialog: false
    property var selectedCounselorForAppointment: null

    // 预约时间选项（简化，移除available状态）
    ListModel {
        id: timeSlotsModel

        ListElement { time: "09:00-10:00" }
        ListElement { time: "10:00-11:00" }
        ListElement { time: "11:00-12:00" }
        ListElement { time: "14:00-15:00" }
        ListElement { time: "15:00-16:00" }
        ListElement { time: "16:00-17:00" }
        ListElement { time: "17:00-18:00" }
    }

    // 咨询类型选项
    ListModel {
        id: consultationTypesModel

        ListElement { type: "个体心理咨询"; duration: "50分钟" }
        ListElement { type: "情绪管理咨询"; duration: "50分钟" }
        ListElement { type: "学业压力咨询"; duration: "50分钟" }
        ListElement { type: "人际关系咨询"; duration: "50分钟" }
        ListElement { type: "职业规划咨询"; duration: "60分钟" }
        ListElement { type: "家庭关系咨询"; duration: "90分钟" }
    }

    // 预约表单数据
    property string appointmentDate: Qt.formatDate(new Date(), "yyyy-MM-dd")
    property string selectedTime: ""
    property string selectedConsultationType: ""
    property string problemDescription: ""
    property string contactPhone: ""
    property string emergencyContact: ""

    // 导师数据模型
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

        ListElement {
            counselorId: "counselor5"
            name: "陈老师"
            title: "心理咨询师"
            avatar: "👨‍🏫"
            specialty: "情绪管理、正念训练"
            rating: "4.5"
            status: "在线"
            statusColor: "#4caf50"
            consultationTimes: "周一至周六 9:00-18:00"
        }

        ListElement {
            counselorId: "counselor6"
            name: "赵老师"
            title: "心理辅导师"
            avatar: "👩‍🏫"
            specialty: "家庭关系、情感困扰"
            rating: "4.8"
            status: "在线"
            statusColor: "#4caf50"
            consultationTimes: "周四、周日 10:00-20:00"
        }
    }

    // 导师列表页面 - 网格布局
    Rectangle {
        id: counselorListPage
        anchors.fill: parent
        visible: !inChatRoom && !showAppointmentDialog

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // 标题 - 增大字体
            Text {
                text: "心理导师列表"
                font.pixelSize: 26
                font.bold: true
                color: "#1976d2"
            }

            // 导师网格列表
            GridView {
                id: counselorGridView
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: parent.width / 2 - 10
                cellHeight: 300  // 减少高度，因为移除了办公地点
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
                        spacing: 12  // 增加间距

                        // 头像和状态
                        Rectangle {
                            width: parent.width
                            height: 80

                            Row {
                                spacing: 15

                                // 导师头像
                                Rectangle {
                                    width: 60
                                    height: 60
                                    radius: 30
                                    color: "#e3f2fd"

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.avatar
                                        font.pixelSize: 24
                                    }

                                    // 状态指示
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

                                // 姓名和职称
                                Column {
                                    spacing: 5
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        text: model.name
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#1976d2"
                                    }

                                    Text {
                                        text: model.title
                                        font.pixelSize: 14
                                        color: "#666"
                                    }

                                    // 评分
                                    Row {
                                        spacing: 5

                                        Text {
                                            text: "★"
                                            color: "#ff9800"
                                            font.pixelSize: 14
                                        }

                                        Text {
                                            text: model.rating
                                            font.pixelSize: 14
                                            color: "#666"
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        // 专长
                        Text {
                            text: "专长："
                            font.pixelSize: 14
                            color: "#666"
                            width: parent.width
                        }

                        Text {
                            text: model.specialty
                            font.pixelSize: 16
                            color: "#1976d2"
                            font.bold: true
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        // 咨询时间
                        Text {
                            text: "时间："
                            font.pixelSize: 14
                            color: "#666"
                            width: parent.width
                        }

                        Text {
                            text: model.consultationTimes
                            font.pixelSize: 14
                            color: "#888"
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        // 按钮区域
                        Row {
                            width: parent.width
                            spacing: 10

                            // 线上咨询按钮
                            Rectangle {
                                width: (parent.width - 10) / 2
                                height: 36
                                radius: 8
                                color: model.status !== "离线" ? "#1976d2" : "#bdbdbd"

                                Text {
                                    anchors.centerIn: parent
                                    text: "线上咨询"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    enabled: model.status !== "离线"
                                    onClicked: {
                                        currentCounselor = {
                                            counselorId: model.counselorId,
                                            name: model.name,
                                            title: model.title,
                                            avatar: model.avatar,
                                            specialty: model.specialty,
                                            status: model.status,
                                            consultationTimes: model.consultationTimes
                                        }
                                        inChatRoom = true
                                    }
                                }
                            }

                            // 线下预约按钮
                            Rectangle {
                                width: (parent.width - 10) / 2
                                height: 36
                                radius: 8
                                color: "#4caf50"

                                Text {
                                    anchors.centerIn: parent
                                    text: "线下预约"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        selectedCounselorForAppointment = {
                                            counselorId: model.counselorId,
                                            name: model.name,
                                            title: model.title,
                                            avatar: model.avatar,
                                            specialty: model.specialty
                                        }
                                        showAppointmentDialog = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 聊天室页面（保持不变，这里省略）

    // 线下预约对话框 - 模态窗口
    Rectangle {
        id: appointmentDialog
        anchors.fill: parent
        color: "#80000000"  // 半透明黑色背景
        visible: showAppointmentDialog
        z: 100

        // 预约窗口主体
        Rectangle {
            id: appointmentWindow
            width: Math.min(parent.width * 0.9, 600)
            height: Math.min(parent.height * 0.9, 650)  // 减少高度
            anchors.centerIn: parent
            radius: 16
            color: "white"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // 标题栏
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    // 关闭按钮
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: "#f5f5f5"

                        Text {
                            anchors.centerIn: parent
                            text: "×"
                            color: "#666"
                            font.pixelSize: 24
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
                        text: "线下咨询预约"
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1976d2"
                        Layout.fillWidth: true
                    }
                }

                // 滚动区域
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

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

                                // 导师头像
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

                                // 导师信息
                                Column {
                                    spacing: 5
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

                        // 预约日期
                        ColumnLayout {
                            spacing: 8

                            Text {
                                text: "预约日期"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            RowLayout {
                                spacing: 10

                                Button {
                                    text: "前一天"
                                    onClicked: {
                                        var date = new Date(appointmentDate)
                                        date.setDate(date.getDate() - 1)
                                        appointmentDate = Qt.formatDate(date, "yyyy-MM-dd")
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 40
                                    radius: 8
                                    color: "#f5f5f5"
                                    border.color: "#e0e0e0"
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: appointmentDate
                                        font.pixelSize: 16
                                        color: "#333"
                                    }
                                }

                                Button {
                                    text: "后一天"
                                    onClicked: {
                                        var date = new Date(appointmentDate)
                                        date.setDate(date.getDate() + 1)
                                        appointmentDate = Qt.formatDate(date, "yyyy-MM-dd")
                                    }
                                }
                            }
                        }

                        // 预约时间（简化版本）
                        ColumnLayout {
                            spacing: 8

                            Text {
                                text: "选择时间"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: 10

                                Repeater {
                                    model: timeSlotsModel

                                    Rectangle {
                                        width: 100
                                        height: 40
                                        radius: 8
                                        color: selectedTime === model.time ? "#1976d2" : "#f5f5f5"
                                        border.color: selectedTime === model.time ? "#1565c0" : "#e0e0e0"
                                        border.width: 1

                                        Text {
                                            anchors.centerIn: parent
                                            text: model.time
                                            color: selectedTime === model.time ? "white" : "#333"
                                            font.pixelSize: 14
                                            font.bold: selectedTime === model.time
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

                        // 咨询类型（修复ComboBox显示问题）
                        ColumnLayout {
                            spacing: 8

                            Text {
                                text: "咨询类型"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 50
                                radius: 8
                                color: "#f5f5f5"
                                border.color: "#e0e0e0"
                                border.width: 1

                                ComboBox {
                                    id: consultationTypeCombo
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    model: consultationTypesModel
                                    textRole: "type"
                                    font.pixelSize: 14

                                    // 修复：使用正确的信号处理方式
                                    onActivated: function(index) {
                                        selectedConsultationType = consultationTypesModel.get(index).type
                                    }

                                    background: Rectangle {
                                        color: "transparent"
                                        border.width: 0
                                    }

                                    popup: Popup {
                                        y: consultationTypeCombo.height
                                        width: consultationTypeCombo.width
                                        implicitHeight: contentItem.implicitHeight
                                        padding: 1

                                        contentItem: ListView {
                                            clip: true
                                            implicitHeight: contentHeight
                                            model: consultationTypeCombo.popup.visible ? consultationTypeCombo.delegateModel : null
                                            currentIndex: consultationTypeCombo.highlightedIndex

                                            ScrollIndicator.vertical: ScrollIndicator { }
                                        }

                                        background: Rectangle {
                                            color: "white"
                                            border.color: "#e0e0e0"
                                            radius: 4
                                        }
                                    }

                                    delegate: ItemDelegate {
                                        width: consultationTypeCombo.width
                                        text: model.type + " (" + model.duration + ")"
                                        font.pixelSize: 14
                                        highlighted: consultationTypeCombo.highlightedIndex === index
                                    }
                                }
                            }
                        }

                        // 问题描述
                        ColumnLayout {
                            spacing: 8

                            Text {
                                text: "问题简要描述"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                                radius: 8
                                color: "#f5f5f5"
                                border.color: "#e0e0e0"
                                border.width: 1

                                TextArea {
                                    id: problemDescriptionArea
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    placeholderText: "请简要描述你想要咨询的问题（可选）"
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

                            Text {
                                text: "联系方式"
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
                                    placeholderText: "紧急联系人及电话（可选）"
                                    font.pixelSize: 14
                                    background: Rectangle {
                                        color: "transparent"
                                    }

                                    onTextChanged: {
                                        emergencyContact = text
                                    }
                                }
                            }
                        }
                    }
                }

                // 底部按钮区域
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    // 取消按钮
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0.5
                        height: 45
                        radius: 8
                        color: "#f5f5f5"

                        Text {
                            anchors.centerIn: parent
                            text: "取消"
                            color: "#666"
                            font.pixelSize: 16
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

                    // 提交预约按钮
                    Rectangle {
                        id: submitButton
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0.5
                        height: 45
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
            width: 300
            height: 180
            radius: 16
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Text {
                    text: "✅"
                    font.pixelSize: 36
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Text {
                    text: "预约成功！"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#4caf50"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Text {
                    text: "预约信息已提交\n请按时前往心理中心"
                    font.pixelSize: 14
                    color: "#666"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: "#4caf50"

                    Text {
                        anchors.centerIn: parent
                        text: "确定"
                        color: "white"
                        font.pixelSize: 16
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
        emergencyContact = ""
        if (consultationTypeCombo) {
            consultationTypeCombo.currentIndex = -1
        }
        if (problemDescriptionArea) {
            problemDescriptionArea.text = ""
        }
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
        console.log("紧急联系人：" + emergencyContact)
        console.log("==================")

        // 显示成功提示
        successDialog.visible = true
    }
}
