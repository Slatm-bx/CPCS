import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: teacherPersonalCenterPage
    color: "#f5f7fa"

    // 教师数据 - 从数据库加载
    property string teacherName: ""
    property string teacherId: ""
    property string department: ""
    property string title: ""
    property string specialty: ""
    property string avatar: "👤"

    // 统计信息
    property int consultationCount: 0
    property int studentCount: 0
    property int avgDuration: 0
    property int satisfactionScore: 0

    // 编辑弹窗状态
    property bool showEditDialog: false

    // 页面加载时获取数据
    Component.onCompleted: {
        loadTeacherData();
        loadStatistics();
    }

    // 加载教师信息
    function loadTeacherData() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler对象不存在");
            return;
        }

        var currentId = databaseHandler.getCurrentUserId();
        if (!currentId) {
            console.log("错误：未获取到教师ID");
            return;
        }

        teacherId = currentId;
        console.log("正在获取教师ID：" + teacherId + " 的信息");

        // 从数据库获取教师信息
        var profile = databaseHandler.getTeacherProfile(teacherId);

        if (profile) {
            teacherName = profile.realName || "教师";
            department = profile.department || "";
            title = profile.title || "";
            specialty = profile.specialty || "";
            avatar = profile.avatar || "👨‍🏫";

            console.log("教师信息加载完成：" + teacherName);
        }
    }

    // 加载统计信息
    function loadStatistics() {
        if (!databaseHandler || !teacherId) {
            return;
        }

        var stats = databaseHandler.getTeacherStatistics(teacherId);

        if (stats) {
            consultationCount = stats.consultationCount || 0;
            studentCount = stats.studentCount || 0;
            avgDuration = stats.avgDuration || 0;
            satisfactionScore = stats.satisfactionScore || 0;

            console.log("统计信息加载完成：咨询" + consultationCount + "次，学生" + studentCount + "人");
        }
    }

    // 保存编辑的信息
    function saveProfile() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler不存在");
            return;
        }

        // 从输入框获取数据
        var newName = nameInput.text;
        var newDepartment = departmentInput.text;
        var newTitle = titleInput.text;
        var newSpecialty = specialtyInput.text;

        // 保存到数据库
        var success = databaseHandler.updateTeacherProfile(
            teacherId,
            newName,
            newDepartment,
            newTitle,
            newSpecialty
        );

        if (success) {
            // 更新页面显示
            teacherName = newName;
            department = newDepartment;
            title = newTitle;
            specialty = newSpecialty;

            console.log("教师资料保存成功");
        } else {
            console.log("教师资料保存失败");
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Column {
            width: parent.width
            spacing: 16
            anchors.margins: 20

            // 顶部头像和信息
            Rectangle {
                width: parent.width
                height: 180
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    // 头像
                    Rectangle {
                        width: 90
                        height: 90
                        radius: 45
                        color: "#e3f2fd"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: teacherPersonalCenterPage.avatar
                            font.pixelSize: 40
                        }
                    }

                    // 姓名
                    Text {
                        text: teacherPersonalCenterPage.teacherName || "加载中..."
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1976d2"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 职称
                    Text {
                        text: teacherPersonalCenterPage.title ? "职称：" + teacherPersonalCenterPage.title : "职称：未设置"
                        font.pixelSize: 14
                        color: "#666"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // 个人信息卡片
            Rectangle {
                width: parent.width
                height: 160
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "个人信息"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                    }

                    // 部门信息
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: department !== ""

                        Text {
                            text: "🏢"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: teacherPersonalCenterPage.department
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 职称信息
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: title !== ""

                        Text {
                            text: "🎖️"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: teacherPersonalCenterPage.title
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 专业方向
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: specialty !== ""

                        Text {
                            text: "🎯"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: teacherPersonalCenterPage.specialty
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 无信息提示
                    Text {
                        text: "暂无个人信息，请点击下方按钮编辑"
                        font.pixelSize: 14
                        color: "#999"
                        visible: department === "" && title === "" && specialty === ""
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // 统计卡片
            Rectangle {
                width: parent.width
                height: 240
                radius: 12
                color: "white"
                border.color: "#e0e0e0"
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "工作统计"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                    }

                    // 统计行1
                    Row {
                        width: parent.width
                        spacing: 12

                        // 咨询统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#e8f5e9"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "💬"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "咨询次数"
                                    font.pixelSize: 14
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: teacherPersonalCenterPage.consultationCount + " 次"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 学生统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#e3f2fd"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "👨‍🎓"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "咨询学生"
                                    font.pixelSize: 14
                                    color: "#1976d2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: teacherPersonalCenterPage.studentCount + " 人"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#1976d2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    // 统计行2
                    Row {
                        width: parent.width
                        spacing: 12

                        // 平均时长
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#fff3e0"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "⏱️"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "平均时长"
                                    font.pixelSize: 14
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: teacherPersonalCenterPage.avgDuration + " 分钟"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 满意度
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#f3e5f5"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "⭐"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "满意度"
                                    font.pixelSize: 14
                                    color: "#7b1fa2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: teacherPersonalCenterPage.satisfactionScore + " 分"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#7b1fa2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }

            // 编辑资料按钮
            Rectangle {
                width: parent.width
                height: 50
                radius: 8
                color: "#1976d2"

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "✏️"
                        font.pixelSize: 18
                        color: "white"
                    }

                    Text {
                        text: "编辑个人资料"
                        font.pixelSize: 16
                        color: "white"
                        font.bold: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // 设置编辑对话框的初始值
                        nameInput.text = teacherName;
                        departmentInput.text = department;
                        titleInput.text = title;
                        specialtyInput.text = specialty;
                        showEditDialog = true;
                    }
                }
            }
        }
    }

    // 编辑资料弹窗
    Rectangle {
        id: editDialog
        anchors.fill: parent
        color: "#80000000"
        visible: showEditDialog

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // 点击背景不关闭，防止误操作
            }
        }

        // 弹窗内容
        Rectangle {
            id: dialogContent
            width: 420
            height: 500
            radius: 12
            color: "white"
            anchors.centerIn: parent

            Flickable {
                anchors.fill: parent
                anchors.margins: 20
                contentHeight: editColumn.height
                clip: true

                Column {
                    id: editColumn
                    width: parent.width
                    spacing: 12

                    // 标题
                    Text {
                        text: "编辑教师资料"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#1976d2"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 姓名
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "姓名"
                            font.pixelSize: 14
                            color: "#666"
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            radius: 6
                            border.color: "#ccc"
                            border.width: 1

                            TextInput {
                                id: nameInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 部门
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "部门"
                            font.pixelSize: 14
                            color: "#666"
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            radius: 6
                            border.color: "#ccc"
                            border.width: 1

                            TextInput {
                                id: departmentInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 职称
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "职称"
                            font.pixelSize: 14
                            color: "#666"
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            radius: 6
                            border.color: "#ccc"
                            border.width: 1

                            TextInput {
                                id: titleInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 专业方向
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "专业方向"
                            font.pixelSize: 14
                            color: "#666"
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            radius: 6
                            border.color: "#ccc"
                            border.width: 1

                            TextInput {
                                id: specialtyInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 按钮区域
                    Row {
                        width: parent.width
                        height: 45
                        spacing: 15
                        topPadding: 10

                        // 取消按钮
                        Rectangle {
                            width: (parent.width - 15) / 2
                            height: 45
                            radius: 8
                            color: cancelMouseArea.containsMouse ? "#f5f5f5" : "white"
                            border.color: "#ccc"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "取消"
                                font.pixelSize: 16
                                color: "#666"
                            }

                            MouseArea {
                                id: cancelMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    showEditDialog = false
                                }
                            }
                        }

                        // 保存按钮
                        Rectangle {
                            width: (parent.width - 15) / 2
                            height: 45
                            radius: 8
                            color: saveMouseArea.containsMouse ? "#1565c0" : "#1976d2"

                            Text {
                                anchors.centerIn: parent
                                text: "保存"
                                font.pixelSize: 16
                                color: "white"
                                font.bold: true
                            }

                            MouseArea {
                                id: saveMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    saveProfile();
                                    showEditDialog = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
