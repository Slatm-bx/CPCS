// ConsultationProcess.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import psychological


Rectangle {
    id: root
    color: "#f5f7fa"

    property int currentIndex: -1
    property bool canProcess: false
    property string currentTeacherId: databaseHandler.getCurrentUserId()
    property string currentTeacherName:getTeacherName()
    // 状态文本颜色
    function getStatusColor(status) {
        switch(status) {
        case 0: return "#ff9800"  // 待处理 - 橙色
        case 1: return "#4caf50"  // 已通过 - 绿色
        case 2: return "#f44336"  // 已拒绝 - 红色
        default: return "#666666"
        }
    }

    // 更新是否可以处理的状态
    function updateCanProcess() {
        if (currentIndex >= 0) {
            var message = teacherMessageModel.getMessage(currentIndex);
            canProcess = message.isPass === 0;
        } else {
            canProcess = false;
        }
    }

    // 从数据库加载数据到模型
    function loadDataFromDatabase() {
        if (!currentTeacherId) {
            console.log("No teacher ID available");
            return;
        }

        console.log("Loading data for teacher:", currentTeacherId);

        // 调用 DatabaseHandler 的方法获取数据
        var data = databaseHandler.getTeacherMessages(currentTeacherId);
        if (data && data.length > 0) {
            // 将数据传递给模型
            teacherMessageModel.loadFromVariantList(data);
            console.log("Loaded", data.length, "records from database");
        } else {
            console.log("No data from database");
        }
    }

    // 处理查看详情（标记为已读）
    function handleViewDetails(index) {
        if (index < 0) return;

        currentIndex = index;

        // 1. 先更新模型（立即显示效果）
        teacherMessageModel.markAsRead(index);

        // 2. 再更新数据库
        var message = teacherMessageModel.getMessage(index);
        var tmId = message.tmId;
        var success = databaseHandler.updateMessageReadStatus(tmId, true);

        if (success) {
            console.log("Updated read status in database for message", tmId);
            // 3. 重新加载数据确保一致性（可选）
            // loadDataFromDatabase();
        } else {
            console.log("Failed to update read status in database");
        }

        updateCanProcess();
    }

    // 处理通过预约
    function handlePassAppointment(index) {
        if (index < 0) return false;

        // 获取当前消息的详细信息
        var message = teacherMessageModel.getMessage(index);
        var tmId = message.tmId;

        // 1. 先更新模型（立即显示效果）
        teacherMessageModel.setAppointmentStatus(index, 1);

        // 2. 更新教师消息表
        var success = databaseHandler.updateAppointmentStatus(tmId, 1);

        if (success) {
            console.log("Updated appointment status in database for message", tmId, "to passed");

            // 3. 向学生消息表插入记录
            var studentId = message.studentId;
            var teacherId = currentTeacherId;
            var teacherName = currentTeacherName;
            var appointDate = message.appointDate;
            var appointSlot = message.appointSlot;
            var consultType = message.consultType;
            var phoneNumber = message.phoneNumber;

            var insertSuccess = databaseHandler.insertStudentMessage(
                studentId, teacherId, teacherName, appointDate, appointSlot, 1
            );

            if (insertSuccess) {
                console.log("Successfully inserted student message record");

                // 4. 向咨询日志表插入记录（新增）
                var logSuccess = databaseHandler.insertConsultationLog(
                    studentId, teacherId, appointDate, appointSlot,
                    teacherName, consultType, phoneNumber
                );

                if (logSuccess) {
                    console.log("Successfully inserted consultation log record");
                } else {
                    console.log("Failed to insert consultation log record");
                }
            } else {
                console.log("Failed to insert student message record");
            }

            return true;
        }
    }
    // 处理拒绝预约
    function handleRejectAppointment(index) {
        if (index < 0) return false;

        // 获取当前消息的详细信息
        var message = teacherMessageModel.getMessage(index);
        var tmId = message.tmId;

        // 1. 先更新模型（立即显示效果）
        teacherMessageModel.setAppointmentStatus(index, 2);

        // 2. 更新教师消息表
        var success = databaseHandler.updateAppointmentStatus(tmId, 2);

        if (success) {
            console.log("Updated appointment status in database for message", tmId, "to rejected");

            // 3. 向学生消息表插入记录
            var studentId = message.studentId;
            var teacherId = currentTeacherId;
            var teacherName = currentTeacherName; // 获取教师姓名
            var appointDate = message.appointDate;
            var appointSlot = message.appointSlot;

            var insertSuccess = databaseHandler.insertStudentMessage(
                studentId, teacherId, teacherName, appointDate, appointSlot, 2
            );

            if (insertSuccess) {
                console.log("Successfully inserted student message record");
            } else {
                console.log("Failed to insert student message record");
            }

            return true;
        } else {
            console.log("Failed to update appointment status in database");
            // 如果数据库更新失败，可以回滚模型状态
            teacherMessageModel.setAppointmentStatus(index, 0);
            return false;
        }
    }

    // 修改获取教师姓名的函数
    function getTeacherName() {
        // 从数据库获取教师姓名
        var teacherName = databaseHandler.getTeacherName(currentTeacherId);
        if (teacherName) {
            return teacherName;
        } else {
            return "未知教师"; // 默认值
        }
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 标题栏 - 透明
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20

                Label {
                    text: "咨询处理"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#333333"
                    Layout.alignment: Qt.AlignVCenter
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: "刷新"
                    Material.foreground: Material.primaryColor
                    Material.background: "transparent"
                    font.pixelSize: 14
                    onClicked: {
                        // 刷新按钮：重新从数据库加载数据
                        loadDataFromDatabase();
                    }

                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        // 主要内容区
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            // 左侧列表区域
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.6
                color: "white"
                radius: 6
                border.color: "#e0e0e0"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    // 列表标题
                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "学生预约列表"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#333333"
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "共 " + teacherMessageModel.count + " 条记录"
                            color: "#666"
                            font.pixelSize: 13
                        }
                    }

                    // 表格标题
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        color: "#f8f9fa"
                        radius: 4
                        border.color: "#e0e0e0"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0

                            Label {
                                text: "学生信息"
                                font.bold: true
                                color: "#495057"
                                font.pixelSize: 13
                                Layout.preferredWidth: 150
                            }

                            Label {
                                text: "预约时间"
                                font.bold: true
                                color: "#495057"
                                font.pixelSize: 13
                                Layout.preferredWidth: 120
                            }

                            Label {
                                text: "咨询类型"
                                font.bold: true
                                color: "#495057"
                                font.pixelSize: 13
                                Layout.preferredWidth: 100
                            }

                            Label {
                                text: "状态"
                                font.bold: true
                                color: "#495057"
                                font.pixelSize: 13
                                Layout.preferredWidth: 80
                            }

                            Label {
                                text: "操作"
                                font.bold: true
                                color: "#495057"
                                font.pixelSize: 13
                                Layout.preferredWidth: 90
                            }
                        }
                    }

                    // 列表视图
                    ListView {
                        id: messageListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 2

                        model: TeacherMessageModel {
                            id: teacherMessageModel

                            // onDataLoaded: {
                            //     console.log("Data loaded in model:", message);
                            // }
                        }

                        delegate: Rectangle {
                            id: delegateItem
                            width: messageListView.width
                            height: 68
                            color: index === currentIndex ? "#e8f5e9" : "white"
                            border.color: index === currentIndex ? Material.primaryColor : "transparent"
                            border.width: index === currentIndex ? 1 : 0
                            radius: 4

                            property bool isRead: model.isRead
                            property int status: model.isPass

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 0

                                // 未读标记 - 只保留红点
                                Rectangle {
                                    visible: !isRead
                                    width: 6
                                    height: 6
                                    radius: 3
                                    color: "#ff5722"
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Item {
                                    visible: isRead
                                    width: 6
                                    height: 6
                                }

                                // 学生信息
                                Column {
                                    Layout.preferredWidth: 150
                                    spacing: 2
                                    Layout.alignment: Qt.AlignVCenter

                                    Label {
                                        text: model.studentName + " (" + model.studentId + ")"
                                        font.bold: true
                                        font.pixelSize: 13
                                    }

                                    Label {
                                        text: "电话: " + model.phoneNumber
                                        font.pixelSize: 11
                                        color: "#666"
                                    }
                                }

                                // 预约时间
                                Column {
                                    Layout.preferredWidth: 120
                                    spacing: 2
                                    Layout.alignment: Qt.AlignVCenter

                                    Label {
                                        text: model.appointDate
                                        font.pixelSize: 12
                                        color: "#333"
                                    }

                                    Label {
                                        text: model.appointSlot
                                        font.pixelSize: 11
                                        color: Material.primaryColor
                                    }
                                }

                                // 咨询类型
                                Label {
                                    text: model.consultType
                                    font.pixelSize: 12
                                    color: "#d81b60"
                                    Layout.preferredWidth: 100
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                // 状态 - 无背景框，只显示文字
                                Label {
                                    text: model.status
                                    color: getStatusColor(status)
                                    font.pixelSize: 12
                                    font.bold: true
                                    Layout.preferredWidth: 80
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                // 操作 - 只有查看详情，无矩形框
                                Item {
                                    Layout.preferredWidth: 90
                                    Layout.alignment: Qt.AlignVCenter
                                    height: parent.height

                                    Text {
                                        anchors.centerIn: parent
                                        text: "查看详情"
                                        color: Material.primaryColor
                                        font.pixelSize: 12
                                        font.bold: true

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                // 调用处理查看详情的函数
                                                handleViewDetails(index);
                                            }
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // 点击整行也调用处理查看详情的函数
                                    handleViewDetails(index);
                                }
                                cursorShape: Qt.PointingHandCursor
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6
                            contentItem: Rectangle {
                                implicitWidth: 6
                                implicitHeight: 100
                                radius: 3
                                color: "#cccccc"
                            }
                        }
                    }
                }
            }

            // 右侧详情区域
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "white"
                radius: 6
                border.color: "#e0e0e0"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 16

                    Label {
                        text: "预约详情"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#e0e0e0"
                    }

                    ColumnLayout {
                        spacing: 20
                        visible: currentIndex >= 0
                        Layout.alignment: Qt.AlignTop

                        DetailItem {
                            label: "学生姓名："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).studentName : ""
                        }

                        DetailItem {
                            label: "学号："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).studentId : ""
                        }

                        DetailItem {
                            label: "联系电话："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).phoneNumber : ""
                        }

                        DetailItem {
                            label: "预约日期："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).appointDate : ""
                        }

                        DetailItem {
                            label: "预约时段："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).appointSlot : ""
                        }

                        DetailItem {
                            label: "咨询类型："
                            value: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).consultType : ""
                        }

                        // 主要问题
                        ColumnLayout {
                            spacing: 6
                            Layout.fillWidth: true

                            Label {
                                text: "主要问题："
                                font.bold: true
                                font.pixelSize: 13
                                color: "#666"
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                color: "#f9f9f9"
                                border.color: "#e0e0e0"
                                border.width: 1
                                radius: 4

                                Flickable {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    contentWidth: width
                                    contentHeight: problemText.height
                                    clip: true

                                    Text {
                                        id: problemText
                                        width: parent.width
                                        text: currentIndex >= 0 ? teacherMessageModel.getMessage(currentIndex).problem : ""
                                        wrapMode: Text.WordWrap
                                        font.pixelSize: 13
                                        color: "#333"
                                        lineHeight: 1.4
                                    }

                                    ScrollBar.vertical: ScrollBar {
                                        policy: ScrollBar.AsNeeded
                                        width: 6
                                    }
                                }
                            }
                        }
                    }

                    // 无选择时的提示
                    Label {
                        text: "请从左侧列表选择一条预约记录"
                        font.pixelSize: 14
                        color: "#999"
                        Layout.alignment: Qt.AlignCenter
                        visible: currentIndex < 0
                        Layout.fillHeight: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    // 操作按钮组
                    RowLayout {
                        spacing: 12
                        visible: currentIndex >= 0
                        Layout.fillWidth: true

                        Button {
                            id: passButton
                            text: "通过预约"
                            Material.background: canProcess ? "#4caf50" : "#cccccc"
                            Material.foreground: canProcess ? "white" : "#999999"
                            Layout.fillWidth: true
                            flat: false
                            highlighted: canProcess
                            enabled: canProcess
                            onClicked: {
                                var success = handlePassAppointment(currentIndex);
                                if (success) {
                                    updateCanProcess();
                                }
                            }
                        }

                        Button {
                            id: rejectButton
                            text: "拒绝预约"
                            Material.background: canProcess ? "#f44336" : "#cccccc"
                            Material.foreground: canProcess ? "white" : "#999999"
                            Layout.fillWidth: true
                            flat: false
                            highlighted: canProcess
                            enabled: canProcess
                            onClicked: {
                                var success = handleRejectAppointment(currentIndex);
                                if (success) {
                                    updateCanProcess();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 详情项组件
    component DetailItem: RowLayout {
        property string label
        property string value

        spacing: 12

        Label {
            text: label
            font.bold: true
            color: "#666"
            font.pixelSize: 13
            Layout.preferredWidth: 90
        }

        Label {
            text: value
            color: "#333"
            font.pixelSize: 13
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }

    // 组件加载完成时加载数据
    Component.onCompleted: {
        console.log("ConsultationProcess component completed, loading data...");
        loadDataFromDatabase();
    }

    // 监听数据库操作结果
    Connections {
        target: teacherMessageModel
        function onDataLoaded(success, message) {
            console.log("Model data loaded:", success, message);
            if (currentIndex >= 0) {
                updateCanProcess();
            }
        }
    }
}
