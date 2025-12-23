import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: psychologicalAssessmentPage
    color: "#f8fcfd"

    // 测试界面状态
    property bool isTesting: false
    property string currentTestType: ""
    property int currentQuestionIndex: 0
    property var userAnswers: []
    property var currentQuestions: []
    property int questionCount: 0

    // 测试历史数据模型
    ListModel {
        id: testHistoryModel
    }

    // 测试类型数据模型
    ListModel {
        id: testTypeModel
    }

    // 页面加载时获取历史记录和测试类型
    Component.onCompleted: {
        loadTestHistory();
        loadTestTypes();
    }

    // 加载测试历史记录
    function loadTestHistory() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler对象不存在");
            return;
        }

        var studentId = databaseHandler.getCurrentUserId();
        if (!studentId) {
            console.log("错误：未获取到学生ID");
            return;
        }

        console.log("正在加载学生ID：" + studentId + "的测试历史记录...");
        var history = databaseHandler.getTestHistory(studentId);

        testHistoryModel.clear();
        for (var i = 0; i < history.length; i++) {
            var record = history[i];
            testHistoryModel.append({
                testName: record.testName,
                testType: record.testType,
                date: record.date,
                score: record.score,
                result: record.result,
                status: record.status
            });
        }

        console.log("加载了" + testHistoryModel.count + "条测试历史记录");
    }

    // 加载测试类型
    function loadTestTypes() {
        if (!databaseHandler) {
            console.log("错误：databaseHandler对象不存在");
            return;
        }

        console.log("正在加载测试类型...");
        var types = databaseHandler.getPsychologicalTestTypes();

        testTypeModel.clear();
        for (var i = 0; i < types.length; i++) {
            var typeName = types[i];
            var icon = "📊";

            if (typeName.includes("抑郁")) {
                icon = "😔";
            } else if (typeName.includes("焦虑")) {
                icon = "😰";
            } else if (typeName.includes("压力")) {
                icon = "😥";
            } else if (typeName.includes("睡眠")) {
                icon = "😴";
            } else if (typeName.includes("社交")) {
                icon = "👥";
            } else if (typeName.includes("学习")) {
                icon = "📚";
            }

            testTypeModel.append({
                testType: typeName,
                icon: icon,
                description: getTestDescription(typeName)
            });
        }

        console.log("加载了" + testTypeModel.count + "种测试类型");
    }

    // 获取测试描述
    function getTestDescription(testType) {
        if (testType.includes("抑郁")) {
            return "评估抑郁症状严重程度";
        } else if (testType.includes("焦虑")) {
            return "评估焦虑症状严重程度";
        } else if (testType.includes("压力")) {
            return "评估压力水平";
        } else if (testType.includes("睡眠")) {
            return "评估睡眠质量";
        } else {
            return "心理评估测试";
        }
    }

    // 获取测试名称
    function getTestName(testType) {
        if (testType === "抑郁测试") {
            return "抑郁自评量表(SDS)";
        } else if (testType === "焦虑测试") {
            return "焦虑自评量表(SAS)";
        } else if (testType === "压力测试") {
            return "压力评估量表";
        } else if (testType === "睡眠测试") {
            return "睡眠质量评估";
        } else {
            return testType;
        }
    }

    // 开始测试函数
    function startTest(testType) {
        console.log("开始" + testType + "...");

        if (!databaseHandler) {
            console.log("错误：databaseHandler不存在");
            return;
        }

        currentTestType = testType;

        // 从数据库获取题目
        var questions = databaseHandler.getPsychologicalTestQuestions(testType);
        if (questions.length === 0) {
            console.log("未找到" + testType + "题目");
            return;
        }

        currentQuestions = questions;
        questionCount = questions.length;

        // 初始化答案数组
        userAnswers = []
        for (var i = 0; i < questionCount; i++) {
            userAnswers.push(-1)
        }

        currentQuestionIndex = 0
        isTesting = true
    }

    // 获取选项（根据测试类型）
    function getOptionsForQuestion(testType, questionIndex) {
        var question = currentQuestions[questionIndex];
        var options = {
            option1: "从不", score1: 0,
            option2: "很少", score2: 1,
            option3: "有时", score3: 2,
            option4: "经常", score4: 3
        };

        // 根据测试类型调整选项
        if (testType === "抑郁测试") {
            if (question.questionText.includes("兴趣") || question.questionText.includes("乐趣")) {
                options = {
                    option1: "完全没有", score1: 0,
                    option2: "有几天", score2: 1,
                    option3: "一半以上的日子", score3: 2,
                    option4: "几乎每天", score4: 3
                };
            }
        } else if (testType === "焦虑测试") {
            // 修复焦虑测试分数：从1-4改为0-3分
            options = {
                option1: "没有或很少时间", score1: 0,
                option2: "小部分时间", score2: 1,
                option3: "相当多时间", score3: 2,
                option4: "绝大部分或全部时间", score4: 3
            };
        } else if (testType === "压力测试") {
            options = {
                option1: "没有压力", score1: 0,
                option2: "轻度压力", score2: 1,
                option3: "中度压力", score3: 2,
                option4: "严重压力", score4: 3
            };
        } else if (testType === "睡眠测试") {
            options = {
                option1: "从无", score1: 0,
                option2: "<1次/周", score2: 1,
                option3: "1-2次/周", score3: 2,
                option4: "≥3次/周", score4: 3
            };
        }

        return options;
    }

    // 选择答案
    function selectAnswer(score) {
        if (currentQuestionIndex < userAnswers.length) {
            userAnswers[currentQuestionIndex] = score
        }
    }

    // 获取当前题目
    function getCurrentQuestion() {
        if (currentQuestions.length > 0 && currentQuestionIndex < currentQuestions.length) {
            return currentQuestions[currentQuestionIndex];
        }
        return null;
    }

    // 获取当前选项
    function getCurrentOptions() {
        var question = getCurrentQuestion();
        if (question) {
            return getOptionsForQuestion(currentTestType, currentQuestionIndex);
        }
        return { option1: "", score1: 0, option2: "", score2: 0, option3: "", score3: 0, option4: "", score4: 0 };
    }

    // 下一题
    function nextQuestion() {
        if (currentQuestionIndex < questionCount - 1) {
            currentQuestionIndex++
        }
    }

    // 上一题
    function previousQuestion() {
        if (currentQuestionIndex > 0) {
            currentQuestionIndex--
        }
    }

    // 计算测试结果
    function calculateResult(testType, totalScore) {
        var result = "";

        if (testType === "抑郁测试") {
            // 5题，每题0-3分，总分0-15分
            if (totalScore <= 4) {
                result = "无抑郁症状";
            } else if (totalScore <= 9) {
                result = "轻度抑郁";
            } else if (totalScore <= 14) {
                result = "中度抑郁";
            } else {
                result = "重度抑郁";
            }
        } else if (testType === "焦虑测试") {
            // 修复焦虑测试判断逻辑
            // 假设5题，每题0-3分，总分0-15分
            if (totalScore <= 4) {
                result = "无焦虑症状";
            } else if (totalScore <= 9) {
                result = "轻度焦虑";
            } else if (totalScore <= 14) {
                result = "中度焦虑";
            } else {
                result = "重度焦虑";
            }
        } else if (testType === "压力测试") {
            // 5题，每题0-3分，总分0-15分
            if (totalScore <= 4) {
                result = "无压力";
            } else if (totalScore <= 9) {
                result = "轻度压力";
            } else if (totalScore <= 14) {
                result = "中度压力";
            } else {
                result = "重度压力";
            }
        } else if (testType === "睡眠测试") {
            // 4题，每题0-3分，总分0-12分
            if (totalScore <= 3) {
                result = "睡眠质量良好";
            } else if (totalScore <= 7) {
                result = "睡眠质量一般";
            } else if (totalScore <= 10) {
                result = "睡眠质量较差";
            } else {
                result = "睡眠质量很差";
            }
        } else {
            // 通用判断逻辑
            var maxScore = questionCount * 3;
            if (totalScore <= Math.floor(maxScore * 0.3)) {
                result = "正常";
            } else if (totalScore <= Math.floor(maxScore * 0.5)) {
                result = "轻度";
            } else if (totalScore <= Math.floor(maxScore * 0.7)) {
                result = "中度";
            } else {
                result = "重度";
            }
        }

        return result;
    }

    // 提交测试
    function submitTest() {
        // 检查是否所有题目都答了
        for (var i = 0; i < userAnswers.length; i++) {
            if (userAnswers[i] === -1) {
                console.log("第" + (i+1) + "题未作答")
                return
            }
        }

        // 计算总分
        var totalScore = 0
        for (var i = 0; i < userAnswers.length; i++) {
            totalScore += userAnswers[i]
        }

        // 判断结果
        var result = calculateResult(currentTestType, totalScore);
        var testName = getTestName(currentTestType);

        console.log("测试完成！总分：" + totalScore + "分，结果：" + result)

        // 保存到数据库
        var currentDate = new Date();
        var dateStr = currentDate.toLocaleDateString();

        if (databaseHandler) {
            var studentId = databaseHandler.getCurrentUserId();
            if (studentId) {
                var success = databaseHandler.saveTestResult(
                    studentId,
                    testName,
                    currentTestType,
                    dateStr,
                    totalScore,
                    result,
                    "已完成"
                );

                if (success) {
                    console.log("测试结果已保存到数据库");
                    loadTestHistory();
                } else {
                    console.log("保存测试结果失败");
                }
            }
        }

        // 返回主界面
        isTesting = false
    }

    // 获取测试标题
    function getTestTitle() {
        return getTestName(currentTestType);
    }

    // 主界面
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        visible: !isTesting

        // 标题
        Text {
            text: "心理健康评估"
            font.pixelSize: 26
            font.bold: true
            color: "#2e7d8f"
            width: parent.width
            horizontalAlignment: Text.AlignLeft
        }

        // 快速测试卡片
        Rectangle {
            id: quickTestCard
            width: parent.width
            height: 160 + testTypeModel.count * 70  // 修复高度计算
            radius: 12
            color: "white"
            border.color: "#e0f2f1"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                Text {
                    text: "💡 快速心理测试"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#2e7d8f"
                }

                Text {
                    text: "选择测试类型开始评估"
                    font.pixelSize: 13
                    color: "#666"
                }

                // 测试类型选择
                Column {
                    width: parent.width
                    spacing: 15

                    Repeater {
                        model: testTypeModel
                        delegate: Item {
                            width: parent.width
                            height: 70

                            Rectangle {
                                width: parent.width
                                height: 70
                                radius: 10
                                color: testMouseArea.containsMouse ? "#e8f4f8" : "#f5fafc"
                                border.color: "#b2dfdb"
                                border.width: 1

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15

                                    Rectangle {
                                        width: 50
                                        height: 50
                                        radius: 25
                                        color: "#e0f2f1"
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: icon
                                            font.pixelSize: 22
                                        }
                                    }

                                    Column {
                                        width: parent.width - 75
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 5

                                        Text {
                                            text: testType
                                            font.pixelSize: 16
                                            font.bold: true
                                            color: "#2e7d8f"
                                        }

                                        Text {
                                            text: description
                                            font.pixelSize: 12
                                            color: "#666"
                                            width: parent.width
                                            elide: Text.ElideRight
                                        }
                                    }
                                }

                                MouseArea {
                                    id: testMouseArea
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: startTest(testType)
                                }
                            }
                        }
                    }
                }
            }
        }

        // 历史记录标题
        Row {
            width: parent.width
            height: 30
            spacing: 10

            Text {
                text: "📋 历史测试记录"
                font.pixelSize: 18
                font.bold: true
                color: "#2e7d8f"
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                width: parent.width - 200
            }

            Text {
                text: "共" + testHistoryModel.count + "条记录"
                font.pixelSize: 13
                color: "#888"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // 历史记录列表
        ListView {
            id: historyListView
            width: parent.width
            height: parent.height - y - 20  // 动态计算高度
            y: quickTestCard.height + 50  // 标题高度 + 间距
            clip: true
            spacing: 10
            model: testHistoryModel

            delegate: Rectangle {
                id: historyDelegate
                width: historyListView.width
                height: 100
                radius: 10
                color: "white"
                border.color: "#e0f2f1"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // 测试图标 - 修改为更合理的判断逻辑
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: getScoreColor(testType, score)
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: getScoreEmoji(testType, score)
                            font.pixelSize: 18
                            color: "white"
                        }
                    }

                    // 测试信息
                    Column {
                        width: parent.width - 130
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                text: testName
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333"
                            }

                            Rectangle {
                                width: 60
                                height: 20
                                radius: 10
                                color: getScoreBackgroundColor(testType, score)
                                border.color: getScoreBorderColor(testType, score)
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: score + "分"
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: getScoreTextColor(testType, score)
                                }
                            }
                        }

                        // 测试类型和日期
                        Row {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: "类型：" + testType
                                font.pixelSize: 13
                                color: "#666"
                            }

                            Text {
                                text: "日期：" + date
                                font.pixelSize: 13
                                color: "#999"
                            }
                        }

                        // 结果
                        Text {
                            text: "评估结果：" + result
                            font.pixelSize: 14
                            color: getResultColor(testType, result)
                            font.bold: true
                        }
                    }

                    // 状态标签
                    Rectangle {
                        width: 60
                        height: 24
                        radius: 12
                        color: "#e8f5f2"
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: status
                            font.pixelSize: 11
                            color: "#4caf93"
                            font.bold: true
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        console.log("查看测试详情：" + testName)
                    }
                }
            }

            // 空状态提示
            Rectangle {
                width: historyListView.width
                height: 200
                visible: testHistoryModel.count === 0

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    Text {
                        text: "📝"
                        font.pixelSize: 40
                    }

                    Text {
                        text: "暂无测试记录"
                        font.pixelSize: 16
                        color: "#888"
                        font.bold: true
                    }

                    Text {
                        text: "完成心理测试后会在这里显示历史记录"
                        font.pixelSize: 13
                        color: "#bbb"
                    }
                }
            }
        }
    }

    // 测试界面
    Rectangle {
        anchors.fill: parent
        color: "#f8fcfd"
        visible: isTesting

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // 顶部标题栏
            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 15

                    // 返回按钮
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 8
                        color: backMouseArea.containsMouse ? "#e8f4f8" : "white"
                        border.color: "#b2dfdb"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "←"
                            font.pixelSize: 18
                            color: "#2e7d8f"
                        }

                        MouseArea {
                            id: backMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: isTesting = false
                        }
                    }

                    ColumnLayout {
                        Text {
                            text: getTestTitle()
                            font.pixelSize: 18
                            font.bold: true
                            color: "#2e7d8f"
                        }

                        Text {
                            text: "第" + (currentQuestionIndex + 1) + "/" + questionCount + "题"
                            font.pixelSize: 12
                            color: "#888"
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            // 进度条
            Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: "#e0f2f1"

                Rectangle {
                    width: parent.width * ((currentQuestionIndex + 1) / questionCount)
                    height: parent.height
                    radius: 2
                    color: "#2e7d8f"
                    Behavior on width { NumberAnimation { duration: 200 } }
                }
            }

            // 问题卡片
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                radius: 10
                color: "white"
                border.color: "#e0f2f1"
                border.width: 1

                Text {
                    anchors.fill: parent
                    anchors.margins: 20
                    text: getCurrentQuestion() ? getCurrentQuestion().questionText : ""
                    font.pixelSize: 18
                    color: "#333"
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 15
            }

            // 选项区域
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                spacing: 8

                // 选项A
                Rectangle {
                    id: option1Rect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === getCurrentOptions().score1
                           ? "#d0e4f0" : (option1MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === getCurrentOptions().score1
                                  ? "#2e7d8f" : "#b2dfdb"
                    border.width: 2

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            color: userAnswers[currentQuestionIndex] === getCurrentOptions().score1
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "A"
                                color: userAnswers[currentQuestionIndex] === getCurrentOptions().score1
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: getCurrentOptions().option1
                            font.pixelSize: 16
                            color: "#333"
                        }

                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        id: option1MouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            selectAnswer(getCurrentOptions().score1)
                        }
                    }
                }

                // 选项B
                Rectangle {
                    id: option2Rect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === getCurrentOptions().score2
                           ? "#d0e4f0" : (option2MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === getCurrentOptions().score2
                                  ? "#2e7d8f" : "#b2dfdb"
                    border.width: 2

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            color: userAnswers[currentQuestionIndex] === getCurrentOptions().score2
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "B"
                                color: userAnswers[currentQuestionIndex] === getCurrentOptions().score2
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: getCurrentOptions().option2
                            font.pixelSize: 16
                            color: "#333"
                        }

                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        id: option2MouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            selectAnswer(getCurrentOptions().score2)
                        }
                    }
                }

                // 选项C
                Rectangle {
                    id: option3Rect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === getCurrentOptions().score3
                           ? "#d0e4f0" : (option3MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === getCurrentOptions().score3
                                  ? "#2e7d8f" : "#b2dfdb"
                    border.width: 2

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            color: userAnswers[currentQuestionIndex] === getCurrentOptions().score3
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "C"
                                color: userAnswers[currentQuestionIndex] === getCurrentOptions().score3
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: getCurrentOptions().option3
                            font.pixelSize: 16
                            color: "#333"
                        }

                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        id: option3MouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            selectAnswer(getCurrentOptions().score3)
                        }
                    }
                }

                // 选项D
                Rectangle {
                    id: option4Rect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === getCurrentOptions().score4
                           ? "#d0e4f0" : (option4MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === getCurrentOptions().score4
                                  ? "#2e7d8f" : "#b2dfdb"
                    border.width: 2

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            color: userAnswers[currentQuestionIndex] === getCurrentOptions().score4
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "D"
                                color: userAnswers[currentQuestionIndex] === getCurrentOptions().score4
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: getCurrentOptions().option4
                            font.pixelSize: 16
                            color: "#333"
                        }

                        Item { Layout.fillWidth: true }
                    }

                    MouseArea {
                        id: option4MouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            selectAnswer(getCurrentOptions().score4)
                        }
                    }
                }
            }

            // 底部按钮
            RowLayout {
                Layout.fillWidth: true
                height: 50
                spacing: 15

                // 上一题按钮
                Rectangle {
                    width: 100
                    height: 45
                    radius: 10
                    color: prevMouseArea.containsMouse ? "#e8f4f8" : "white"
                    border.color: "#b2dfdb"
                    border.width: 1
                    visible: currentQuestionIndex > 0

                    Text {
                        anchors.centerIn: parent
                        text: "← 上一题"
                        font.pixelSize: 14
                        color: "#2e7d8f"
                    }

                    MouseArea {
                        id: prevMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: previousQuestion()
                    }
                }

                Item { Layout.fillWidth: true }

                // 下一题/提交按钮
                Rectangle {
                    width: 100
                    height: 45
                    radius: 10
                    color: nextMouseArea.containsMouse ? "#3a8d9f" : "#2e7d8f"

                    Text {
                        anchors.centerIn: parent
                        text: currentQuestionIndex < questionCount - 1 ? "下一题 →" : "提交测试"
                        font.pixelSize: 14
                        color: "white"
                        font.bold: true
                    }

                    MouseArea {
                        id: nextMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            if (currentQuestionIndex < questionCount - 1) {
                                nextQuestion()
                            } else {
                                submitTest()
                            }
                        }
                    }
                }
            }
        }
    }

    // 辅助函数：根据分数获取颜色
    function getScoreColor(testType, score) {
        var maxScore = getMaxScore(testType);
        var percentage = score / maxScore;

        if (percentage < 0.3) {
            return "#81c9b8";  // 绿色 - 正常
        } else if (percentage < 0.5) {
            return "#ffb566";  // 黄色 - 轻度
        } else if (percentage < 0.7) {
            return "#ff8a80";  // 橙色 - 中度
        } else {
            return "#f44336";  // 红色 - 重度
        }
    }

    // 辅助函数：根据分数获取表情
    function getScoreEmoji(testType, score) {
        var maxScore = getMaxScore(testType);
        var percentage = score / maxScore;

        if (percentage < 0.3) {
            return "😊";  // 笑脸 - 正常
        } else if (percentage < 0.5) {
            return "😐";  // 中性 - 轻度
        } else if (percentage < 0.7) {
            return "😔";  // 悲伤 - 中度
        } else {
            return "😫";  // 痛苦 - 重度
        }
    }

    // 辅助函数：获取测试最大分数
    function getMaxScore(testType) {
        if (testType === "抑郁测试" || testType === "焦虑测试" || testType === "压力测试") {
            return 15;  // 5题 * 3分 = 15分
        } else if (testType === "睡眠测试") {
            return 12;  // 4题 * 3分 = 12分
        } else {
            return 10;  // 默认
        }
    }

    // 辅助函数：获取分数背景色
    function getScoreBackgroundColor(testType, score) {
        var maxScore = getMaxScore(testType);
        var percentage = score / maxScore;

        if (percentage < 0.3) {
            return "#e8f5f2";
        } else if (percentage < 0.5) {
            return "#fff5e8";
        } else if (percentage < 0.7) {
            return "#ffebee";
        } else {
            return "#fce4ec";
        }
    }

    // 辅助函数：获取分数边框色
    function getScoreBorderColor(testType, score) {
        var maxScore = getMaxScore(testType);
        var percentage = score / maxScore;

        if (percentage < 0.3) {
            return "#4caf93";
        } else if (percentage < 0.5) {
            return "#ff9800";
        } else if (percentage < 0.7) {
            return "#f44336";
        } else {
            return "#d32f2f";
        }
    }

    // 辅助函数：获取分数文字色
    function getScoreTextColor(testType, score) {
        var maxScore = getMaxScore(testType);
        var percentage = score / maxScore;

        if (percentage < 0.3) {
            return "#4caf93";
        } else if (percentage < 0.5) {
            return "#ff9800";
        } else if (percentage < 0.7) {
            return "#f44336";
        } else {
            return "#d32f2f";
        }
    }

    // 辅助函数：获取结果颜色
    function getResultColor(testType, result) {
        if (result.includes("无") || result.includes("正常") || result.includes("良好")) {
            return "#4caf93";  // 绿色
        } else if (result.includes("轻度")) {
            return "#ff9800";  // 橙色
        } else if (result.includes("中度")) {
            return "#f44336";  // 红色
        } else if (result.includes("重度") || result.includes("很差")) {
            return "#d32f2f";  // 深红
        } else {
            return "#333";
        }
    }
}
