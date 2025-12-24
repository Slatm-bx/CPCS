import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import psychological

Rectangle {
    id:cr
    color: "#f8fafc"

    property int currentIndex: -1
    property bool isEditing: false

    // 获取状态颜色
    function getStatusColor(isCompleted) {
        return isCompleted ? "#10b981" : "#f59e0b"  // 绿色和琥珀色
    }

    // 获取状态文本
    function getStatusText(isCompleted) {
        return isCompleted ? "已完成" : "待完成"
    }

    // 获取时长显示文本
    function getDurationText(duration) {
        if (duration <= 0) return "未记录"
        if (duration < 60) return duration + "分钟"
        return Math.floor(duration / 60) + "小时" + (duration % 60 > 0 ? duration % 60 + "分钟" : "")
    }

    // 加载模拟数据
    function loadMockData() {
        consultationLogModel.loadMockData()
    }

    function loadFromDatabase() {
        // 获取当前教师ID
        var teacherId = databaseHandler.getCurrentUserId()

        if (!teacherId) {
            console.error("无法获取教师ID")
            showToast("无法获取教师信息", "error")
            return
        }

        console.log("正在加载教师", teacherId, "的咨询记录")

        // 从数据库获取教师的咨询记录
        var logs = databaseHandler.getConsultationLogsForTeacher(teacherId)

        // 将数据加载到模型中
        consultationLogModel.loadFromDatabaseForTeacher(logs)
    }


    // 启动编辑模式
    function startEditing(index) {
        if (index < 0) return

        var log = consultationLogModel.getLog(index)
        currentIndex = index
        isEditing = true
    }

    // 取消编辑
    function cancelEdit() {
        isEditing = false
    }

    // 显示提示消息
    function showToast(message, type) {
        toast.message = message
        toast.type = type
        toast.show()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 顶部标题栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "white"

            // 底部边框
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#e2e8f0"
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24

                // 标题
                Column {
                    spacing: 2

                    Label {
                        text: "咨询记录"
                        font.pixelSize: 22
                        font.bold: true
                        color: "#1e293b"
                    }

                    Label {
                        text: "管理您的心理咨询历史记录"
                        font.pixelSize: 13
                        color: "#64748b"
                    }
                }

                Item { Layout.fillWidth: true }

                // 统计卡片
                RowLayout {
                    spacing: 12

                    // 总记录数
                    Rectangle {
                        width: 100
                        height: 56
                        radius: 12
                        color: "#f1f5f9"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Label {
                                text: consultationLogModel.count
                                font.pixelSize: 20
                                font.bold: true
                                color: "#334155"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label {
                                text: "总记录"
                                font.pixelSize: 12
                                color: "#64748b"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // 已完成
                    Rectangle {
                        width: 100
                        height: 56
                        radius: 12
                        color: "#d1fae5"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Label {
                                text: consultationLogModel.completedCount
                                font.pixelSize: 20
                                font.bold: true
                                color: "#065f46"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label {
                                text: "已完成"
                                font.pixelSize: 12
                                color: "#059669"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // 待完成
                    Rectangle {
                        width: 100
                        height: 56
                        radius: 12
                        color: "#fef3c7"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Label {
                                text: consultationLogModel.count - consultationLogModel.completedCount
                                font.pixelSize: 20
                                font.bold: true
                                color: "#92400e"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label {
                                text: "待完成"
                                font.pixelSize: 12
                                color: "#d97706"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // 刷新按钮
                    RoundButton {
                        text: "刷新"
                        Material.foreground: Material.primaryColor
                        Material.background: "transparent"
                        font.pixelSize: 14
                        radius: 8
                        implicitWidth: 100
                        implicitHeight: 56
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: loadFromDatabase()
                    }
                }
            }
        }

        // 主要内容区
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing:5
            anchors.margins: 16

            // 左侧：记录列表
            Rectangle {
                id: listPanel
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.6
                color: "white"
                radius: 12
                clip: true

                // 简单边框
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 12
                    border.color: "#e2e8f0"
                    border.width: 1
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // 列表标题
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20

                            Label {
                                text: "咨询记录列表"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#1e293b"
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                text: consultationLogModel.count + " 条"
                                font.pixelSize: 13
                                color: "#64748b"
                            }
                        }
                    }

                    // 列表内容
                    ListView {
                        id: logListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 8
                        boundsBehavior: Flickable.StopAtBounds

                        model: ConsultationLogModel {
                            id: consultationLogModel

                            onDataLoaded: {
                                console.log("数据加载完成:", success, message)
                            }
                        }

                        delegate: Item {
                            width: logListView.width
                            height: 120

                            // 卡片背景
                            Rectangle {
                                id: cardBg
                                anchors.fill: parent
                                anchors.margins: 4
                                radius: 10
                                color: index === currentIndex ? "#e0f2fe" : "white"
                                border.color: index === currentIndex ? "#0ea5e9" : "#e2e8f0"
                                border.width: 1

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onEntered: {
                                        if (index !== currentIndex) {
                                            cardBg.color = "#f8fafc"
                                        }
                                    }
                                    onExited: {
                                        if (index !== currentIndex) {
                                            cardBg.color = "white"
                                        }
                                    }
                                    onClicked: {
                                        currentIndex = index
                                        isEditing = false
                                    }
                                }
                            }

                            // 卡片内容
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                // 上半部分：学生信息、咨询师和状态
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    // 学生信息
                                    Column {
                                        spacing: 2
                                        Layout.fillWidth: true

                                        Label {
                                            text: databaseHandler.getStudentName(model.studentId)+"("+model.studentId+")"
                                            font.pixelSize: 15
                                            font.bold: true
                                            color: "#1e293b"
                                            elide: Text.ElideRight
                                            maximumLineCount: 1
                                            Layout.fillWidth: true
                                        }

                                        Label {
                                            text: "咨询师：" + model.counselor
                                            font.pixelSize: 12
                                            color: "#64748b"
                                        }

                                        Label {
                                            text: "电话：" + model.phoneNumber
                                            font.pixelSize: 12
                                            color: "#64748b"
                                        }
                                    }

                                    // 状态标签
                                    Rectangle {
                                        width: 65
                                        height: 24
                                        radius: 12
                                        color: getStatusColor(model.isCompleted)

                                        Label {
                                            anchors.centerIn: parent
                                            text: getStatusText(model.isCompleted)
                                            color: "white"
                                            font.pixelSize: 11
                                            font.bold: true
                                        }
                                    }
                                }

                                // 下半部分：预约信息和查看详情按钮
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 16

                                    // 预约信息
                                    Column {
                                        spacing: 4

                                        Row {
                                            spacing: 8
                                            Label {
                                                text: "日期：" + model.consultationDate
                                                font.pixelSize: 13
                                                color: "#334155"
                                            }
                                            Label {
                                                text: "时段：" + model.consultationSlot
                                                font.pixelSize: 13
                                                color: "#334155"
                                            }
                                        }

                                        Label {
                                            text: "咨询类型：" + model.type
                                            font.pixelSize: 13
                                            color: "#334155"
                                        }
                                    }

                                    Item { Layout.fillWidth: true }

                                    // 查看详情按钮
                                    Button {
                                        text: "查看详情"
                                        font.pixelSize: 12
                                        padding: 6
                                        implicitWidth: 80

                                        background: Rectangle {
                                            radius: 6
                                            color: parent.hovered ? "#e0f2fe" : "transparent"
                                            border.color: "#0ea5e9"
                                            border.width: 1
                                        }

                                        contentItem: Label {
                                            text: parent.text
                                            font: parent.font
                                            color: "#0ea5e9"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: {
                                            currentIndex = index
                                            isEditing = false
                                        }
                                    }
                                }
                            }
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6

                            contentItem: Rectangle {
                                implicitWidth: 6
                                implicitHeight: 100
                                radius: 3
                                color: "#cbd5e1"
                            }
                        }

                        // 空状态
                        Label {
                            anchors.centerIn: parent
                            text: "暂无咨询记录"
                            font.pixelSize: 14
                            color: "#94a3b8"
                            visible: consultationLogModel.count === 0
                        }
                    }
                }
            }

            // 右侧：详情/编辑面板
            Rectangle {
                id: detailPanel
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "white"
                radius: 12
                clip: true

                // 简单边框
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 12
                    border.color: "#e2e8f0"
                    border.width: 1
                }

                Loader {
                    id: panelLoader
                    anchors.fill: parent
                    anchors.margins: 10

                    sourceComponent: {
                        if (isEditing) return editComponent
                        if (currentIndex >= 0) return detailComponent
                        return emptyComponent
                    }
                }
            }
        }
    }

    // ========== 组件定义 ==========

    // 空状态组件
    Component {
        id: emptyComponent

        Column {
            spacing: 16
            anchors.centerIn: parent

            // 使用Unicode图标替代图片
            Rectangle {
                width: 120
                height: 120
                radius: 60
                color: "#f1f5f9"
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    anchors.centerIn: parent
                    text: "📋"
                    font.pixelSize: 50
                }
            }

            Column {
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    text: "选择一条记录查看详情"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#64748b"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: "从左侧列表选择咨询记录以查看详细信息"
                    font.pixelSize: 14
                    color: "#94a3b8"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // 详情查看组件
    Component {
        id: detailComponent

        ColumnLayout {
            spacing: 16

            // 标题和操作按钮
            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "咨询详情"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#1e293b"
                }

                Item { Layout.fillWidth: true }

                // 状态标签
                Rectangle {
                    width: 70
                    height: 28
                    radius: 14
                    color: getStatusColor(consultationLogModel.getLog(currentIndex).isCompleted)

                    Label {
                        anchors.centerIn: parent
                        text: getStatusText(consultationLogModel.getLog(currentIndex).isCompleted)
                        color: "white"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
            }

            // 分隔线
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#e2e8f0"
            }

            // 可滚动内容
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: detailContent.height
                clip: true

                ColumnLayout {
                    id: detailContent
                    width: parent.width
                    spacing: 20

                    // 咨询时长
                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "咨询时长"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#1e293b"
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                text: getDurationText(consultationLogModel.getLog(currentIndex).duration)
                                font.pixelSize: 15
                                color: "#334155"
                                font.bold: true
                            }
                        }
                    }

                    // 咨询摘要
                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        RowLayout {
                            Label {
                                text: "咨询摘要"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#1e293b"
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                text: consultationLogModel.getLog(currentIndex).summary ? "" : "未填写"
                                font.pixelSize: 13
                                color: "#94a3b8"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.min(120, summaryText.height + 24)
                            radius: 8
                            color: "#f8fafc"
                            border.color: "#e2e8f0"
                            border.width: 1

                            ScrollView {
                                anchors.fill: parent
                                anchors.margins: 12

                                TextArea {
                                    id: summaryText
                                    width: parent.width
                                    text: consultationLogModel.getLog(currentIndex).summary || "暂无摘要"
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 14
                                    color: "#334155"
                                    readOnly: true
                                    selectByMouse: true
                                    background: null
                                }
                            }
                        }
                    }

                    // 学生自我评价
                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        RowLayout {
                            Label {
                                text: "学生自我评价"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#1e293b"
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                text: consultationLogModel.getLog(currentIndex).selfEvaluation ? "" : "未填写"
                                font.pixelSize: 13
                                color: "#94a3b8"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.min(120, evaluationText.height + 24)
                            radius: 8
                            color: "#f8fafc"
                            border.color: "#e2e8f0"
                            border.width: 1

                            ScrollView {
                                anchors.fill: parent
                                anchors.margins: 12

                                TextArea {
                                    id: evaluationText
                                    width: parent.width
                                    text: consultationLogModel.getLog(currentIndex).selfEvaluation || "暂无评价"
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 14
                                    color: "#334155"
                                    readOnly: true
                                    selectByMouse: true
                                    background: null
                                }
                            }
                        }
                    }

                    // 操作按钮 - 只保留一个"填写记录"按钮
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        RowLayout {
                            anchors.fill: parent
                            spacing: 12

                            Item { Layout.fillWidth: true }

                            Button {
                                text: "填写记录"
                                font.pixelSize: 14
                                padding: 10
                                implicitWidth: 120

                                background: Rectangle {
                                    radius: 8
                                    color: "#3b82f6"
                                }

                                contentItem: Label {
                                    text: parent.text
                                    font: parent.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: startEditing(currentIndex)

                                visible: !consultationLogModel.getLog(currentIndex).isCompleted
                            }
                        }
                    }
                }
            }
        }
    }

    // 编辑组件（填写记录页面）
    Component {
        id: editComponent
        ColumnLayout {
            spacing: 16

            // 为每个编辑区域的外层矩形添加id
            property var durationRect: null
            property var summaryRect: null
            property var evaluationRect: null

            Component.onCompleted: {
                // 当组件创建时，填充当前记录的数据
                if (currentIndex >= 0) {
                    var log = consultationLogModel.getLog(currentIndex)
                    if (log) {
                        durationEdit.text = log.duration > 0 ? log.duration : ""
                        summaryEdit.text = log.summary || ""
                        evaluationEdit.text = log.selfEvaluation || ""
                    }
                }
            }

            // 标题
            Label {
                text: "填写咨询记录"
                font.pixelSize: 18
                font.bold: true
                color: "#1e293b"
                Layout.alignment: Qt.AlignHCenter
            }

            // 分隔线
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#e2e8f0"
            }

            // 基本信息
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 16
                rowSpacing: 12

                DetailRow {
                    label: "学生"
                    value: {
                        var log = consultationLogModel.getLog(currentIndex)
                        return log.studentName + " (" + log.studentId + ")"
                    }
                }

                DetailRow {
                    label: "咨询类型"
                    value: consultationLogModel.getLog(currentIndex).type
                }

                DetailRow {
                    label: "咨询日期"
                    value: consultationLogModel.getLog(currentIndex).consultationDate
                }

                DetailRow {
                    label: "咨询时段"
                    value: consultationLogModel.getLog(currentIndex).consultationSlot
                }
            }

            // 咨询时长
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                Label {
                    text: "咨询时长（分钟）*"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#334155"
                }

                Rectangle {
                    id: durationRect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    border.color: durationEdit.activeFocus ? "#3b82f6" : "#d1d5db"
                    border.width: 2
                    radius: 10

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 4

                        TextArea {
                            id: durationEdit
                            color: "#000000"
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            font.pixelSize: 14
                            placeholderText: "请输入咨询时长，如：50"
                            background: null
                            inputMethodHints: Qt.ImhDigitsOnly

                            onFocusChanged: {
                                durationRect.border.color = focus ? "#3b82f6" : "#d1d5db"
                            }
                        }
                    }
                }

                Label {
                    text: "请输入整数"
                    font.pixelSize: 12
                    color: "#6b7280"
                }
            }

            // 咨询摘要
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                Label {
                    text: "咨询摘要 *"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#334155"
                }

                Rectangle {
                    id: summaryRect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    border.color: summaryEdit.activeFocus ? "#3b82f6" : "#d1d5db"
                    border.width: 2
                    radius: 10

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 4

                        TextArea {
                            id: summaryEdit
                            color: "#000000"
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            font.pixelSize: 14
                            placeholderText: "请描述咨询过程、关键问题和解决方案..."
                            background: null

                            onFocusChanged: {
                                summaryRect.border.color = focus ? "#3b82f6" : "#d1d5db"
                            }
                        }
                    }
                }

                Label {
                    text: "已输入 " + summaryEdit.text.length + " 字符"
                    font.pixelSize: 12
                    color: "#6b7280"
                }
            }

            // 学生自我评价
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                Label {
                    text: "学生自我评价"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#334155"
                }

                Rectangle {
                    id: evaluationRect
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    border.color: evaluationEdit.activeFocus ? "#3b82f6" : "#d1d5db"
                    border.width: 2
                    radius: 10

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 4

                        TextArea {
                            id: evaluationEdit
                            color: "#000000"
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            font.pixelSize: 14
                            placeholderText: "记录学生的自我评价、感受或反馈..."
                            background: null

                            onFocusChanged: {
                                evaluationRect.border.color = focus ? "#3b82f6" : "#d1d5db"
                            }
                        }
                    }
                }

                Label {
                    text: "已输入 " + evaluationEdit.text.length + " 字符"
                    font.pixelSize: 12
                    color: "#6b7280"
                }
            }

            // 操作按钮
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "取消"
                    Layout.fillWidth: true
                    padding: 12
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 6
                        color: parent.hovered ? "#f3f4f6" : "#ffffff"
                        border.color: "#d1d5db"
                        border.width: 1
                    }

                    contentItem: Label {
                        text: parent.text
                        font: parent.font
                        color: "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        isEditing = false
                    }
                }

                Button {
                    text: "保存记录"
                    Layout.fillWidth: true
                    padding: 12
                    font.pixelSize: 14
                    enabled: true  // 添加启用状态控制

                    background: Rectangle {
                        radius: 6
                        color: parent.enabled ? "#3b82f6" : "#93c5fd"  // 禁用时使用浅蓝色
                    }

                    contentItem: Label {
                        text: parent.text
                        font: parent.font
                        color: parent.enabled ? "white" : "#f8fafc"  // 禁用时使用浅色
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        // 直接在点击时验证
                        var duration = durationEdit.text.trim()
                        var summary = summaryEdit.text.trim()
                        var evaluation = evaluationEdit.text.trim()

                        // 检查是否都填写了
                        if (duration === "" || summary === "" || evaluation === "") {
                            showToast("请填写所有必填字段", "error")
                            return
                        }

                        // 检查时长是否为有效数字
                        var durationNum = parseInt(duration)
                        if (isNaN(durationNum) || durationNum <= 0 || durationNum > 480) {
                            showToast("时长必须是1-480之间的整数", "error")
                            return
                        }

                        // 保存记录
                        if (currentIndex < 0) {
                            cancelEdit()
                            return
                        }

                        // 获取当前记录
                        var log = consultationLogModel.getLog(currentIndex)

                        // 更新记录信息
                        log.duration = durationNum
                        log.summary = summary
                        log.selfEvaluation = evaluation
                        log.isCompleted = true
                        var consultationId = log.consultationId

                        // 调用模型更新方法
                        consultationLogModel.updateLog(currentIndex, log)

                        //调用数据库管理器更新数据库
                        var success = databaseHandler.updateConsultationLog(
                                consultationId,  // 咨询记录ID
                                durationNum,     // 时长
                                summary,         // 摘要
                                evaluation,      // 自我评价
                                true             // 已完成
                            )

                        if (success) {
                            showToast("记录已保存", "success")
                        } else {
                            showToast("保存到数据库失败", "error")
                        }

                        // 退出编辑模式
                        isEditing = false
                    }
                }
            }
        }
    }

    // 详情行组件
    component DetailRow: RowLayout {
        property string label
        property string value
        property color valueColor: "#334155"
        property int labelWidth: 80

        spacing: 8

        Label {
            text: label
            font.pixelSize: 13
            color: "#64748b"
            Layout.preferredWidth: labelWidth
        }

        Label {
            text: value
            font.pixelSize: 13
            font.bold: true
            color: valueColor
            Layout.fillWidth: true
        }
    }

    // 简单的Toast组件
    Rectangle {
        id: toast
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: 200
        height: 50
        radius: 8
        color: "#334155"
        opacity: 0
        visible: opacity > 0

        property string message: ""
        property string type: "info" // info, success, error

        function show() {
            toast.opacity = 1
            timer.start()
        }

        Label {
            anchors.centerIn: parent
            text: toast.message
            color: "white"
            font.pixelSize: 14
        }

        Timer {
            id: timer
            interval: 2000
            onTriggered: {
                toast.opacity = 0
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
    }

    // 组件加载完成
    Component.onCompleted: {
        console.log("咨询记录界面初始化完成")
        loadFromDatabase()
    }
}
