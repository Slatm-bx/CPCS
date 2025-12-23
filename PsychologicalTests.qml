import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: psychologicalTestsPage
    color: "#f8f9fa"

    // 测试卷数据列表
    property var testsList: []

    // 页面加载时获取数据
    Component.onCompleted: {
        refreshData()
    }

    // 刷新数据函数
    function refreshData() {
        testsList = databaseHandler.getAllPsychologicalTests()
        console.log("获取到测试卷数量:", testsList.length)
    }

    // 顶部标题栏
    Rectangle {
        id: pageHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: "#ffffff"
        border.color: "#e9ecef"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            // 标题
            Text {
                text: "📋 心理测试问卷管理"
                font.pixelSize: 24
                font.bold: true
                color: "#2c3e50"
            }

            Item { Layout.fillWidth: true }

            // 新增问卷按钮
            Button {
                text: "+ 新增问卷"
                Layout.preferredWidth: 120
                Layout.preferredHeight: 36

                background: Rectangle {
                    color: parent.down ? "#27ae60" : "#2ecc71"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: addTestDialog.open()
            }

            // 刷新按钮
            Button {
                text: "🔄 刷新"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36

                background: Rectangle {
                    color: parent.down ? "#2980b9" : "#3498db"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: refreshData()
            }
        }
    }

    // 统计信息栏
    Rectangle {
        id: statsBar
        anchors.top: pageHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "#e8f5e9"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            Text {
                text: "共 " + testsList.length + " 份测试问卷"
                font.pixelSize: 14
                color: "#2e7d32"
            }

            Item { Layout.fillWidth: true }
        }
    }

    // 表头
    Rectangle {
        id: tableHeader
        anchors.top: statsBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 15
        height: 45
        color: "#3498db"
        radius: 6

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 10

            Text {
                text: "问卷ID"
                Layout.preferredWidth: 80
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "问卷类型"
                Layout.preferredWidth: 150
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "第一题题目"
                Layout.fillWidth: true
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignLeft
            }

            Text {
                text: "操作"
                Layout.preferredWidth: 100
                font.pixelSize: 14
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // 测试卷列表
    ScrollView {
        id: scrollView
        anchors.top: tableHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        anchors.topMargin: 5
        clip: true

        Column {
            width: scrollView.width
            spacing: 5

            Repeater {
                model: testsList

                delegate: Rectangle {
                    width: scrollView.width - 15
                    height: 60
                    color: index % 2 === 0 ? "#ffffff" : "#fafafa"
                    radius: 4
                    border.color: "#e9ecef"
                    border.width: 1

                    property var testData: modelData

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        spacing: 10

                        // 问卷ID
                        Text {
                            text: testData.anTestId || "-"
                            Layout.preferredWidth: 80
                            font.pixelSize: 13
                            color: "#495057"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // 问卷类型
                        Rectangle {
                            Layout.preferredWidth: 150
                            Layout.preferredHeight: 30
                            color: getTypeColor(testData.type)
                            radius: 4

                            Text {
                                anchors.centerIn: parent
                                text: testData.type || "-"
                                font.pixelSize: 12
                                color: "white"
                                font.bold: true
                            }

                            function getTypeColor(type) {
                                if (type === "焦虑测试") return "#e67e22"
                                if (type === "抑郁测试") return "#9b59b6"
                                if (type === "压力测试") return "#e74c3c"
                                if (type === "情绪测试") return "#3498db"
                                return "#95a5a6"
                            }
                        }

                        // 第一题题目（截取前50字）
                        Text {
                            Layout.fillWidth: true
                            text: testData.p1 ? (testData.p1.length > 50 ? testData.p1.substring(0, 50) + "..." : testData.p1) : "-"
                            font.pixelSize: 13
                            color: "#495057"
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                        }

                        // 删除按钮
                        Button {
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 32
                            text: "删除"

                            background: Rectangle {
                                color: parent.down ? "#c0392b" : "#e74c3c"
                                radius: 4
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                deleteConfirmDialog.testId = testData.anTestId
                                deleteConfirmDialog.testType = testData.type
                                deleteConfirmDialog.open()
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        z: -1

                        onEntered: parent.color = "#e3f2fd"
                        onExited: parent.color = index % 2 === 0 ? "#ffffff" : "#fafafa"
                    }
                }
            }

            // 无数据提示
            Rectangle {
                width: scrollView.width - 15
                height: 100
                visible: testsList.length === 0
                color: "#f8f9fa"
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "📭 暂无测试问卷"
                    font.pixelSize: 16
                    color: "#6c757d"
                }
            }
        }
    }

    // ==========================================
    // 新增问卷弹窗
    // ==========================================
    Dialog {
        id: addTestDialog
        anchors.centerIn: parent
        width: 700
        height: 650
        modal: true
        title: "新增心理测试问卷"

        ScrollView {
            anchors.fill: parent
            clip: true

            ColumnLayout {
                width: addTestDialog.width - 40
                spacing: 15

                // 问卷类型
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "问卷类型 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    ComboBox {
                        id: testTypeCombo
                        Layout.fillWidth: true
                        editable: true
                        model: ["焦虑测试", "抑郁测试", "压力测试", "情绪测试", "人际关系测试", "自信心测试"]
                        
                        Component.onCompleted: {
                            currentIndex = 0
                        }
                    }
                }

                // 分隔线
                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: "#e9ecef"
                }

                // 题目1
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "第一题 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    TextArea {
                        id: question1Input
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        placeholderText: "请输入第一题题目内容..."
                        wrapMode: TextArea.Wrap
                        font.pixelSize: 13
                    }
                }

                // 题目2
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "第二题 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    TextArea {
                        id: question2Input
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        placeholderText: "请输入第二题题目内容..."
                        wrapMode: TextArea.Wrap
                        font.pixelSize: 13
                    }
                }

                // 题目3
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "第三题 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    TextArea {
                        id: question3Input
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        placeholderText: "请输入第三题题目内容..."
                        wrapMode: TextArea.Wrap
                        font.pixelSize: 13
                    }
                }

                // 题目4
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "第四题 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    TextArea {
                        id: question4Input
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        placeholderText: "请输入第四题题目内容..."
                        wrapMode: TextArea.Wrap
                        font.pixelSize: 13
                    }
                }

                // 题目5
                ColumnLayout {
                    spacing: 5

                    Text {
                        text: "第五题 *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#2c3e50"
                    }

                    TextArea {
                        id: question5Input
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        placeholderText: "请输入第五题题目内容..."
                        wrapMode: TextArea.Wrap
                        font.pixelSize: 13
                    }
                }
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            // 验证输入
            var type = testTypeCombo.editText.trim()
            var p1 = question1Input.text.trim()
            var p2 = question2Input.text.trim()
            var p3 = question3Input.text.trim()
            var p4 = question4Input.text.trim()
            var p5 = question5Input.text.trim()

            if (!type) {
                errorDialog.text = "请输入问卷类型！"
                errorDialog.open()
                return
            }

            if (!p1 || !p2 || !p3 || !p4 || !p5) {
                errorDialog.text = "请填写全部5道题目！"
                errorDialog.open()
                return
            }

            // 调用数据库添加
            var success = databaseHandler.addPsychologicalTest(type, p1, p2, p3, p4, p5)

            if (success) {
                successDialog.text = "测试问卷添加成功！"
                successDialog.open()
                
                // 清空输入
                testTypeCombo.currentIndex = 0
                question1Input.text = ""
                question2Input.text = ""
                question3Input.text = ""
                question4Input.text = ""
                question5Input.text = ""
                
                // 刷新列表
                refreshData()
            } else {
                errorDialog.text = "添加失败，请重试！"
                errorDialog.open()
            }
        }

        onRejected: {
            // 清空输入
            testTypeCombo.currentIndex = 0
            question1Input.text = ""
            question2Input.text = ""
            question3Input.text = ""
            question4Input.text = ""
            question5Input.text = ""
        }
    }

    // ==========================================
    // 删除确认弹窗
    // ==========================================
    Dialog {
        id: deleteConfirmDialog
        anchors.centerIn: parent
        width: 400
        height: 200
        modal: true
        title: "确认删除"

        property int testId: 0
        property string testType: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 20

            Text {
                text: "⚠️ 确定要删除以下测试问卷吗？"
                font.pixelSize: 16
                font.bold: true
                color: "#e74c3c"
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "#fff3cd"
                radius: 4
                border.color: "#ffc107"
                border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: "问卷ID: " + deleteConfirmDialog.testId
                        font.pixelSize: 13
                        color: "#856404"
                    }

                    Text {
                        text: "类型: " + deleteConfirmDialog.testType
                        font.pixelSize: 13
                        color: "#856404"
                    }
                }
            }

            Text {
                text: "此操作不可恢复！"
                font.pixelSize: 12
                color: "#6c757d"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: {
            var success = databaseHandler.deletePsychologicalTest(deleteConfirmDialog.testId)

            if (success) {
                successDialog.text = "测试问卷删除成功！"
                successDialog.open()
                refreshData()
            } else {
                errorDialog.text = "删除失败，请重试！"
                errorDialog.open()
            }
        }
    }

    // ==========================================
    // 成功提示弹窗
    // ==========================================
    Dialog {
        id: successDialog
        anchors.centerIn: parent
        width: 300
        height: 150
        modal: true
        title: "成功"

        property string text: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 20

            Text {
                text: "✅"
                font.pixelSize: 48
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: successDialog.text
                font.pixelSize: 14
                color: "#27ae60"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        standardButtons: Dialog.Ok
    }

    // ==========================================
    // 错误提示弹窗
    // ==========================================
    Dialog {
        id: errorDialog
        anchors.centerIn: parent
        width: 300
        height: 150
        modal: true
        title: "错误"

        property string text: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 20

            Text {
                text: "❌"
                font.pixelSize: 48
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: errorDialog.text
                font.pixelSize: 14
                color: "#e74c3c"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        standardButtons: Dialog.Ok
    }
}

