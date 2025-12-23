import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: counselorChatPage
    color: "#f0f8ff"

    property bool isLoading: false
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

    // 导师数据模型
    ListModel {
        id: counselorModel
    }

    // 组件加载时从数据库获取数据
    Component.onCompleted: {
        loadTeachersFromDatabase()
    }

    // 导师列表页面
    Rectangle {
        id: counselorListPage
        anchors.fill: parent
        visible: !showAppointmentDialog

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // 标题和刷新按钮
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: "心理咨询师列表"
                    font.pixelSize: 26
                    font.bold: true
                    color: "#1976d2"
                    Layout.fillWidth: true
                }

                // 刷新按钮
                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: isLoading ? "#e0e0e0" : "#e3f2fd"

                    Text {
                        anchors.centerIn: parent
                        text: "↻"
                        color: isLoading ? "#999" : "#1976d2"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: !isLoading
                        onClicked: {
                            loadTeachersFromDatabase()
                        }
                    }
                }
            }

            // 加载指示器
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                visible: isLoading && counselorModel.count === 0
                color: "transparent"

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    BusyIndicator {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 40
                        height: 40
                    }

                    Text {
                        text: "正在加载心理咨询师数据..."
                        font.pixelSize: 14
                        color: "#666"
                    }
                }
            }

            // 无数据提示
            Text {
                Layout.alignment: Qt.AlignCenter
                text: "暂无可用的心理咨询师"
                font.pixelSize: 16
                color: "#999"
                visible: !isLoading && counselorModel.count === 0
            }

            // 导师网格列表 - 一行显示两个
            GridView {
                id: counselorGridView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: counselorModel
                visible: !isLoading && counselorModel.count > 0
                cellWidth: parent.width / 2 - 10
                cellHeight: 220

                delegate: Rectangle {
                    width: counselorGridView.cellWidth - 10
                    height: counselorGridView.cellHeight - 10
                    radius: 12
                    color: "white"
                    border.color: "#e3f2fd"
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        // 顶部：姓名和职称
                        Row {
                            width: parent.width
                            spacing: 8

                            // 图标
                            Rectangle {
                                width: 45
                                height: 45
                                radius: 22.5
                                color: "#e3f2fd"

                                Text {
                                    anchors.centerIn: parent
                                    text: {
                                        if (model.title && model.title.includes("教授")) return "👨‍🏫"
                                        if (model.title && model.title.includes("博士")) return "👨‍🎓"
                                        if (model.title && model.title.includes("医师")) return "👨‍⚕️"
                                        if (model.title && model.title.includes("老师")) return "👩‍🏫"
                                        return "👨‍💼"
                                    }
                                    font.pixelSize: 20
                                }
                            }

                            Column {
                                width: parent.width - 55
                                spacing: 2

                                Text {
                                    text: model.realName || "未命名"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#1976d2"
                                    width: parent.width
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: model.title || "心理咨询师"
                                    font.pixelSize: 12
                                    color: "#666"
                                    width: parent.width
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        // 部门信息
                        Text {
                            text: model.department ? "🏢 " + model.department : ""
                            font.pixelSize: 11
                            color: "#666"
                            width: parent.width
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            visible: model.department && model.department !== ""
                        }

                        // 分隔线
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#f0f0f0"
                            visible: model.department && model.department !== ""
                        }

                        // 专业方向
                        Column {
                            width: parent.width
                            spacing: 2

                            Text {
                                text: "📚 专业方向："
                                font.pixelSize: 11
                                color: "#888"
                                width: parent.width
                            }

                            Text {
                                text: model.specialty || "心理咨询与辅导"
                                font.pixelSize: 13
                                color: "#1976d2"
                                font.bold: true
                                width: parent.width
                                wrapMode: Text.Wrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                                lineHeight: 1.2
                            }
                        }

                        // 底部：预约按钮
                        Rectangle {
                            width: parent.width
                            height: 32
                            radius: 6
                            color: "#4caf50"

                            Text {
                                anchors.centerIn: parent
                                text: "预约咨询"
                                color: "white"
                                font.pixelSize: 13
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // 设置选中的咨询师并显示预约对话框
                                    selectedCounselorForAppointment = {
                                        userId: model.userId,           // 关键修改：保存教师ID
                                        name: model.realName,
                                        title: model.title,
                                        department: model.department,
                                        specialty: model.specialty
                                    }
                                    console.log("选择教师:", model.realName, "教师ID:", model.userId)
                                    showAppointmentDialog = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 预约对话框
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
                            text: selectedCounselorForAppointment ? (function() {
                                var title = selectedCounselorForAppointment.title || "";
                                if (title.includes("教授")) return "👨‍🏫";
                                if (title.includes("博士")) return "👨‍🎓";
                                if (title.includes("医师")) return "👨‍⚕️";
                                if (title.includes("老师")) return "👩‍🏫";
                                return "👨‍💼";
                            })() : "👨‍🏫"
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

                        Text {
                            text: selectedCounselorForAppointment && selectedCounselorForAppointment.department ?
                                  selectedCounselorForAppointment.department : ""
                            font.pixelSize: 12
                            color: "#888"
                            visible: selectedCounselorForAppointment && selectedCounselorForAppointment.department
                        }
                    }
                }
            }

            // 表单区域
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
                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: "咨询类型"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }

                    Flow {
                        id: consultationTypeFlow
                        Layout.fillWidth: true
                        spacing: 10

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
                            id: phoneInput
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

            // 提交按钮 - 最简单的逻辑
            Rectangle {
                id: submitButton
                Layout.fillWidth: true
                height: 48
                radius: 8
                color: "#4caf50"

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
                    onClicked: {
                        submitAppointment()  // 调用提交函数
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
            width: 320
            height: 200
            radius: 12
            color: "white"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Text {
                    text: "✅"
                    font.pixelSize: 30
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
                    text: "预约信息已成功提交"
                    font.pixelSize: 14
                    color: "#666"
                    horizontalAlignment: Text.AlignHCenter
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

    // 函数：从数据库加载心理咨询师
    function loadTeachersFromDatabase() {
        isLoading = true
        counselorModel.clear()

        timer.start()
    }

    Timer {
        id: timer
        interval: 100
        onTriggered: {
            try {
                var teachers = databaseHandler.getTeachers()

                counselorModel.clear()

                for (var i = 0; i < teachers.length; i++) {
                    var teacher = teachers[i]

                    counselorModel.append({
                        userId: teacher.userId || "",  // 确保这里有userId
                        realName: teacher.realName || "未命名",
                        department: teacher.department || "",
                        title: teacher.title || "心理咨询师",
                        specialty: teacher.specialty || "心理咨询与辅导"
                    })

                    console.log("加载教师:", teacher.realName, "ID:", teacher.userId) // 调试输出
                }

                console.log("从数据库加载了", counselorModel.count, "位心理咨询师")

                // 如果没有数据，可以在这里添加一个提示
                if (counselorModel.count === 0) {
                    console.log("数据库中没有心理咨询师数据")
                }
            } catch (error) {
                console.log("加载心理咨询师数据失败:", error)
            }

            isLoading = false
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
        console.log("选中的咨询师对象:", selectedCounselorForAppointment)
        console.log("导师：" + (selectedCounselorForAppointment ? selectedCounselorForAppointment.name : ""))
        console.log("导师ID：" + (selectedCounselorForAppointment ? selectedCounselorForAppointment.userId : "未获取到"))
        console.log("日期：" + appointmentDate)
        console.log("时间：" + selectedTime)
        console.log("咨询类型：" + selectedConsultationType)
        console.log("问题描述：" + (problemDescription || "未填写"))
        console.log("联系电话：" + contactPhone)
        console.log("==================")

        // 获取教师ID（直接从数据库返回的userId）
        var teacherId = ""
        if (selectedCounselorForAppointment && selectedCounselorForAppointment.userId) {
            teacherId = selectedCounselorForAppointment.userId
            console.log("成功获取教师ID:", teacherId)
        } else {
            console.error("无法获取教师ID，选中的咨询师对象:", selectedCounselorForAppointment)
            return
        }

        // 获取当前登录的学生ID和姓名
        var studentId = databaseHandler.getCurrentUserId()
        var studentName = databaseHandler.getCurrentUserName()

        if (!studentName || studentName === "") {
            studentName = "未知学生" // 如果无法获取姓名，使用默认值
        }

        // 调用数据库方法提交预约
        var success = databaseHandler.submitTeacherAppointment(
            teacherId,            // 教师ID
            studentId,            // 学生ID
            studentName,          // 学生姓名
            appointmentDate,      // 预约日期
            selectedTime,         // 预约时段
            contactPhone,         // 联系电话
            selectedConsultationType, // 咨询类型
            problemDescription    // 问题描述
        )

        if (success) {
            console.log("预约信息已成功保存到数据库")
            // 显示成功提示
            successDialog.visible = true
        } else {
            console.log("预约信息保存失败")
            // 可以在这里显示失败提示
        }
    }
}
