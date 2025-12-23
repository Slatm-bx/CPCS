import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: personalCenterPage
    color: "#f5f7fa"

    // 用户数据 - 从数据库加载
    property string studentName: ""
    property string studentId: ""
    property string college: ""
    property string major: ""
    property string grade: ""
    property string avatar: "👤"

    // 统计信息
    property int consultationCount: 0
    property int testCount: 0
    property int literatureCount: 0
    property int totalMinutes: 0

    // 编辑弹窗状态
    property bool showEditDialog: false
    property string editGender: ""

    // 页面加载时获取数据
    Component.onCompleted: {
        loadStudentData();
        loadStatistics();
    }

    // 加载学生信息
    function loadStudentData() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler对象不存在");
            return;
        }

        var currentId = databaseHandler.getCurrentUserId();
        if (!currentId) {
            console.log("错误：未获取到学生ID");
            return;
        }

        studentId = currentId;
        console.log("正在获取学生ID：" + studentId + " 的信息");

        // 从数据库获取学生信息
        var profile = databaseHandler.getStudentProfile(studentId);

        if (profile) {
            studentName = profile.realName || "新用户";
            college = profile.college || "";
            major = profile.major || "";
            grade = profile.grade || "";
            avatar = profile.avatar || "👤";
            editGender = profile.gender || "";

            console.log("学生信息加载完成：" + studentName);
        }
    }

    // 加载统计信息
    function loadStatistics() {
        if (!databaseHandler || !studentId) {
            return;
        }

        var stats = databaseHandler.getStudentStatistics(studentId);

        if (stats) {
            consultationCount = stats.consultationCount || 0;
            testCount = stats.testCount || 0;
            literatureCount = stats.literatureReadCount || 0;
            totalMinutes = stats.totalMinutes || 0;

            console.log("统计信息加载完成：咨询" + consultationCount + "次");
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
        var newCollege = collegeInput.text;
        var newMajor = majorInput.text;

        // 解析年级，如"2023级" -> 2023
        var gradeText = gradeInput.text;
        var entryYear = 0;
        if (gradeText && gradeText.includes("级")) {
            var yearPart = gradeText.split("级")[0];
            entryYear = parseInt(yearPart);
            if (isNaN(entryYear)) entryYear = 0;
        }

        // 保存到数据库
        var success = databaseHandler.updateStudentProfile(
            studentId,
            newName,
            newCollege,
            newMajor,
            entryYear,
            editGender
        );

        if (success) {
            // 更新页面显示
            studentName = newName;
            college = newCollege;
            major = newMajor;
            grade = gradeInput.text;

            console.log("个人资料保存成功");
        } else {
            console.log("个人资料保存失败");
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
                            text: personalCenterPage.avatar
                            font.pixelSize: 40
                        }
                    }

                    // 姓名
                    Text {
                        text: personalCenterPage.studentName || "加载中..."
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1976d2"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 学号
                    Text {
                        text: "学号：" + (personalCenterPage.studentId || "未知")
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

                    // 学院信息
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: college !== ""

                        Text {
                            text: "🏫"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.college
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 专业信息
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: major !== ""

                        Text {
                            text: "📚"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.major
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 年级信息
                    Row {
                        width: parent.width
                        spacing: 12
                        visible: grade !== ""

                        Text {
                            text: "🎓"
                            font.pixelSize: 16
                            color: "#1976d2"
                        }

                        Text {
                            text: personalCenterPage.grade
                            font.pixelSize: 16
                            color: "#333"
                        }
                    }

                    // 无信息提示
                    Text {
                        text: "暂无个人信息，请点击下方按钮编辑"
                        font.pixelSize: 14
                        color: "#999"
                        visible: college === "" && major === "" && grade === ""
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
                        text: "使用统计"
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
                                    text: "心理咨询"
                                    font.pixelSize: 14
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: personalCenterPage.consultationCount + " 次"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#388e3c"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 测试统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#e3f2fd"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "📊"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "心理测试"
                                    font.pixelSize: 14
                                    color: "#1976d2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: personalCenterPage.testCount + " 次"
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

                        // 文献统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#fff3e0"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "📚"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "文献阅读"
                                    font.pixelSize: 14
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: personalCenterPage.literatureCount + " 篇"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#f57c00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 时长统计
                        Rectangle {
                            width: (parent.width - 12) / 2
                            height: 90
                            radius: 8
                            color: "#f3e5f5"

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "⏱️"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "咨询时长"
                                    font.pixelSize: 14
                                    color: "#7b1fa2"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: personalCenterPage.totalMinutes + " 分钟"
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
                        nameInput.text = studentName;
                        collegeInput.text = college;
                        majorInput.text = major;
                        gradeInput.text = grade;
                        genderCombo.currentIndex = getGenderIndex(editGender);
                        showEditDialog = true;
                    }
                }
            }
        }
    }

    // 获取性别选项索引
    function getGenderIndex(gender) {
        if (gender === "男") return 0;
        if (gender === "女") return 1;
        return 2; // 未知/不透露
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
            height: 550
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
                        text: "编辑个人资料"
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

                    // 学院
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "学院"
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
                                id: collegeInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 专业
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "专业"
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
                                id: majorInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 年级
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "年级（格式如：2023级）"
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
                                id: gradeInput
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 16
                                color: "#333"
                                clip: true
                            }
                        }
                    }

                    // 性别
                    Column {
                        width: parent.width
                        spacing: 5

                        Text {
                            text: "性别"
                            font.pixelSize: 14
                            color: "#666"
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            radius: 6
                            border.color: "#ccc"
                            border.width: 1

                            ComboBox {
                                id: genderCombo
                                anchors.fill: parent
                                anchors.margins: 5
                                model: ["男", "女", "不透露"]
                                onCurrentTextChanged: {
                                    editGender = currentText === "不透露" ? "" : currentText;
                                }
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
