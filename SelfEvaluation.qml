import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: psychologicalAssessmentPage
    color: "#f8fcfd"  // 非常浅的蓝白色

    // 测试界面状态
    property bool isTesting: false
    property string currentTestType: "" // "depression" 或 "anxiety"
    property int currentQuestionIndex: 0
    property var userAnswers: [] // 存储用户答案

    // 抑郁测试题目数据 - 保持你原来的格式
    ListModel {
        id: depressionQuestions
        ListElement {
            questionId: 1
            questionText: "做事时提不起兴趣或没有乐趣"
            option1: "完全没有"; score1: 0
            option2: "有几天"; score2: 1
            option3: "一半以上的日子"; score3: 2
            option4: "几乎每天"; score4: 3
        }
        ListElement {
            questionId: 2
            questionText: "感到心情低落、沮丧或绝望"
            option1: "完全没有"; score1: 0
            option2: "有几天"; score2: 1
            option3: "一半以上的日子"; score3: 2
            option4: "几乎每天"; score4: 3
        }
        ListElement {
            questionId: 3
            questionText: "入睡困难、睡不安稳或睡眠过多"
            option1: "完全没有"; score1: 0
            option2: "有几天"; score2: 1
            option3: "一半以上的日子"; score3: 2
            option4: "几乎每天"; score4: 3
        }
        ListElement {
            questionId: 4
            questionText: "感觉疲倦或没有精力"
            option1: "完全没有"; score1: 0
            option2: "有几天"; score2: 1
            option3: "一半以上的日子"; score3: 2
            option4: "几乎每天"; score4: 3
        }
        ListElement {
            questionId: 5
            questionText: "觉得自己很糟或很失败，或让家人失望"
            option1: "完全没有"; score1: 0
            option2: "有几天"; score2: 1
            option3: "一半以上的日子"; score3: 2
            option4: "几乎每天"; score4: 3
        }
    }

    // 模拟测试数据 - 保持你原来的
    ListModel {
        id: testHistoryModel
        ListElement {
            testName: "抑郁自评量表(SDS)"
            testType: "抑郁测试"
            date: "2023-12-20"
            score: 48
            result: "轻度抑郁"
            status: "已完成"
        }
        ListElement {
            testName: "焦虑自评量表(SAS)"
            testType: "焦虑测试"
            date: "2023-12-15"
            score: 56
            result: "中度焦虑"
            status: "已完成"
        }
    }

    // 开始测试函数
    function startTest(testType) {
        currentTestType = testType

        // 初始化答案数组
        userAnswers = []
        for (var i = 0; i < depressionQuestions.count; i++) {
            userAnswers.push(-1) // -1表示未选择
        }

        currentQuestionIndex = 0
        isTesting = true
    }

    // 选择答案
    function selectAnswer(score) {
        userAnswers[currentQuestionIndex] = score
    }

    // 下一题
    function nextQuestion() {
        if (currentQuestionIndex < depressionQuestions.count - 1) {
            currentQuestionIndex++
        }
    }

    // 上一题
    function previousQuestion() {
        if (currentQuestionIndex > 0) {
            currentQuestionIndex--
        }
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
        var result = ""
        if (totalScore <= 4) {
            result = "轻度抑郁"
        } else if (totalScore <= 9) {
            result = "中度抑郁"
        } else {
            result = "重度抑郁"
        }

        console.log("测试完成！总分：" + totalScore + "分，结果：" + result)

        // 添加到历史记录
        testHistoryModel.insert(0, {
            testName: "抑郁自评量表(SDS)",
            testType: "抑郁测试",
            date: new Date().toLocaleDateString(),
            score: totalScore,
            result: result,
            status: "已完成"
        })

        // 返回主界面
        isTesting = false
    }

    // 主界面 - 保持你原来的设计
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
            color: "#2e7d8f"  // 深蓝绿色
            width: parent.width
            horizontalAlignment: Text.AlignLeft
        }

        // 快速测试卡片 - 保持你原来的设计
        Rectangle {
            width: parent.width
            height: 140
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

                // 测试类型选择 - 保持你原来的设计
                Row {
                    width: parent.width
                    height: 70
                    spacing: 15

                    // 抑郁测试
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 70
                        radius: 10
                        color: mouseArea1.containsMouse ? "#e8f4f8" : "#f5fafc"
                        border.color: "#b2dfdb"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "😔"
                                font.pixelSize: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "抑郁测试"
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2e7d8f"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            id: mouseArea1
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: startTest("depression")
                        }
                    }

                    // 焦虑测试
                    Rectangle {
                        width: (parent.width - 15) / 2
                        height: 70
                        radius: 10
                        color: mouseArea2.containsMouse ? "#e8f4f8" : "#f5fafc"
                        border.color: "#b2dfdb"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "😰"
                                font.pixelSize: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "焦虑测试"
                                font.pixelSize: 14
                                font.bold: true
                                color: "#2e7d8f"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            id: mouseArea2
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                console.log("开始焦虑测试")
                                // 可以在这里添加焦虑测试的逻辑
                            }
                        }
                    }
                }
            }
        }

        // 历史记录标题 - 保持你原来的设计
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
                Layout.fillWidth: true
            }

            Text {
                text: "共" + testHistoryModel.count + "条记录"
                font.pixelSize: 13
                color: "#888"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // 历史记录列表 - 保持你原来的设计
        ListView {
            width: parent.width
            height: parent.height - 220
            clip: true
            spacing: 10
            model: testHistoryModel

            delegate: Rectangle {
                width: parent.width
                height: 100
                radius: 10
                color: "white"
                border.color: "#e0f2f1"
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // 测试图标
                    Rectangle {
                        width: 50
                        height: 50
                        radius: 25
                        color: {
                            if (score < 40) return "#81c9b8"
                            else if (score < 55) return "#ffb566"
                            else return "#ff8a80"
                        }
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: score < 40 ? "😊" : (score < 55 ? "😐" : "😔")
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
                                color: {
                                    if (score < 40) return "#e8f5f2"
                                    else if (score < 55) return "#fff5e8"
                                    else return "#ffebee"
                                }
                                border.color: {
                                    if (score < 40) return "#4caf93"
                                    else if (score < 55) return "#ff9800"
                                    else return "#f44336"
                                }
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: score + "分"
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: {
                                        if (score < 40) return "#4caf93"
                                        else if (score < 55) return "#ff9800"
                                        else return "#f44336"
                                    }
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
                            color: score < 40 ? "#4caf93" : (score < 55 ? "#ff9800" : "#f44336")
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

            // 空状态提示 - 保持你原来的设计
            Rectangle {
                width: parent.width
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

            // 顶部标题栏 - 保持你原来的风格
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
                            text: "抑郁自评量表(SDS)"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#2e7d8f"
                        }

                        Text {
                            text: "第" + (currentQuestionIndex + 1) + "/" + depressionQuestions.count + "题"
                            font.pixelSize: 12
                            color: "#888"
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            // 进度条 - 保持你原来的风格
            Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: "#e0f2f1"

                Rectangle {
                    width: parent.width * ((currentQuestionIndex + 1) / depressionQuestions.count)
                    height: parent.height
                    radius: 2
                    color: "#2e7d8f"
                    Behavior on width { NumberAnimation { duration: 200 } }
                }
            }

            // 问题卡片 - 保持你原来的风格
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                radius: 10
                color: "white"
                border.color: "#e0f2f1"
                border.width: 1

                Text {
                    anchors.fill: parent
                    anchors.margins: 20
                    text: depressionQuestions.get(currentQuestionIndex).questionText
                    font.pixelSize: 20
                    color: "#333"
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
            }
            // 在问题卡片后添加一个占位符控制间距
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 15  // 控制问题卡片和选项区域之间的间距
            }

            // 选项区域 - 保持你原来的风格
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 280  // 添加固定高度
                spacing: 8

                // 选项A
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score1
                           ? "#d0e4f0" : (option1MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score1
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
                            color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score1
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "A"
                                color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score1
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: depressionQuestions.get(currentQuestionIndex).option1
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
                        onClicked: selectAnswer(depressionQuestions.get(currentQuestionIndex).score1)
                    }
                }

                // 选项B
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score2
                           ? "#d0e4f0" : (option2MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score2
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
                            color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score2
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "B"
                                color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score2
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: depressionQuestions.get(currentQuestionIndex).option2
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
                        onClicked: selectAnswer(depressionQuestions.get(currentQuestionIndex).score2)
                    }
                }

                // 选项C
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score3
                           ? "#d0e4f0" : (option3MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score3
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
                            color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score3
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "C"
                                color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score3
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: depressionQuestions.get(currentQuestionIndex).option3
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
                        onClicked: selectAnswer(depressionQuestions.get(currentQuestionIndex).score3)
                    }
                }

                // 选项D
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 10
                    color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score4
                           ? "#d0e4f0" : (option4MouseArea.containsMouse ? "#f5fafc" : "white")
                    border.color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score4
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
                            color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score4
                                   ? "#2e7d8f" : "#e0f2f1"

                            Text {
                                anchors.centerIn: parent
                                text: "D"
                                color: userAnswers[currentQuestionIndex] === depressionQuestions.get(currentQuestionIndex).score4
                                       ? "white" : "#2e7d8f"
                                font.bold: true
                            }
                        }

                        Text {
                            text: depressionQuestions.get(currentQuestionIndex).option4
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
                        onClicked: selectAnswer(depressionQuestions.get(currentQuestionIndex).score4)
                    }
                }
            }

            // 底部按钮 - 保持你原来的风格
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
                        text: currentQuestionIndex < depressionQuestions.count - 1 ? "下一题 →" : "提交测试"
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
                            if (currentQuestionIndex < depressionQuestions.count - 1) {
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
}
