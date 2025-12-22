// CustomDialogs.qml - 所有模态弹窗集合
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "dialogManager.js" as DialogManager

Item {
    id: root
    
    property var parentWindow
    
    // 公共函数：打开各种弹窗
    function openAddUserDialog() {
        addUserDialog.open()
    }
    
    function openEditUserDialog(userId, userName, userDept) {
        editUserDialog.userId = userId
        editUserDialog.userName = userName
        editUserDialog.userDept = userDept
        editUserDialog.open()
    }
    
    function openSurveyDialog() {
        surveyDialog.open()
    }
    
    function openArticleDialog() {
        articleDialog.open()
    }
    
    // ==========================================
    // 1. 添加新用户弹窗
    // ==========================================
    Dialog {
        id: addUserDialog
        anchors.centerIn: parent
        width: 450
        height: 400
        modal: true
        title: "添加新账户"
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 15
            
            // 账户ID
            ColumnLayout {
                spacing: 5
                
                Text { text: "账户 ID"; font.pixelSize: 13 }
                TextField {
                    id: newUserId
                    Layout.fillWidth: true
                    placeholderText: "请输入学号或工号"
                }
            }
            
            // 姓名
            ColumnLayout {
                spacing: 5
                
                Text { text: "姓名"; font.pixelSize: 13 }
                TextField {
                    id: newUserName
                    Layout.fillWidth: true
                    placeholderText: "请输入姓名"
                }
            }
            
            // 角色
            ColumnLayout {
                spacing: 5
                
                Text { text: "角色"; font.pixelSize: 13 }
                ComboBox {
                    id: newUserRole
                    Layout.fillWidth: true
                    model: ["学生", "老师"]
                }
            }
            
            // 初始密码
            ColumnLayout {
                spacing: 5
                
                Text { text: "初始密码"; font.pixelSize: 13 }
                TextField {
                    id: newUserPassword
                    Layout.fillWidth: true
                    text: "123456"
                    echoMode: TextInput.Password
                }
            }
            
            Item { Layout.fillHeight: true }
            
            // 按钮
            RowLayout {
                Layout.fillWidth: true
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "取消"
                    onClicked: addUserDialog.close()
                }
                
                Button {
                    text: "保存"
                    highlighted: true
                    
                    background: Rectangle {
                        color: parent.pressed ? "#229954" : "#27ae60"
                        radius: 4
                    }
                    
                    onClicked: {
                        console.log("创建账户:", newUserId.text, newUserName.text)
                        addUserDialog.close()
                    }
                }
            }
        }
    }
    
    // ==========================================
    // 2. 修改账户弹窗（含密码管理）
    // ==========================================
    Dialog {
        id: editUserDialog
        anchors.centerIn: parent
        width: 600
        height: 650
        modal: true
        title: "修改账户信息"
        
        property string userId: ""
        property string userName: ""
        property string userDept: ""
        
        ScrollView {
            anchors.fill: parent
            clip: true
            
            ColumnLayout {
                width: editUserDialog.width - 40
                spacing: 15
                
                // 账户ID（不可修改）
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "账户 ID (不可修改)"; font.pixelSize: 13 }
                    TextField {
                        id: editUserId
                        Layout.fillWidth: true
                        text: editUserDialog.userId
                        enabled: false
                        
                        background: Rectangle {
                            color: "#f5f5f5"
                            border.color: "#ddd"
                            border.width: 1
                            radius: 4
                        }
                    }
                }
                
                // 姓名
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "姓名"; font.pixelSize: 13 }
                    TextField {
                        id: editUserName
                        Layout.fillWidth: true
                        text: editUserDialog.userName
                    }
                }
                
                // 学院/部门
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "学院/部门"; font.pixelSize: 13 }
                    TextField {
                        id: editUserDept
                        Layout.fillWidth: true
                        text: editUserDialog.userDept
                    }
                }
                
                // 状态
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "状态"; font.pixelSize: 13 }
                    ComboBox {
                        id: editUserStatus
                        Layout.fillWidth: true
                        model: ["正常", "封禁"]
                    }
                }
                
                // 分割线
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#eee"
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                }
                
                // 密码管理区域
                Text {
                    text: "密码管理"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: "#2c3e50"
                }
                
                // 当前密码
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "当前密码"; font.pixelSize: 13 }
                    
                    RowLayout {
                        spacing: 10
                        
                        TextField {
                            id: currentPasswordField
                            Layout.fillWidth: true
                            placeholderText: "点击按钮查看"
                            enabled: false
                            echoMode: showPasswordBtn.checked ? TextInput.Normal : TextInput.Password
                            
                            background: Rectangle {
                                color: "#f5f5f5"
                                border.color: "#ddd"
                                border.width: 1
                                radius: 4
                            }
                        }
                        
                        Button {
                            id: showPasswordBtn
                            text: checked ? "👁️ 隐藏" : "👁️ 查看"
                            checkable: true
                            
                            background: Rectangle {
                                color: parent.pressed ? "#2980b9" : "#3498db"
                                radius: 4
                            }
                            
                            onCheckedChanged: {
                                if (checked) {
                                    // 模拟显示密码
                                    currentPasswordField.text = "123456"
                                } else {
                                    currentPasswordField.text = ""
                                }
                            }
                        }
                    }
                }
                
                // 新密码
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "新密码"; font.pixelSize: 13 }
                    TextField {
                        id: newPasswordField
                        Layout.fillWidth: true
                        placeholderText: "留空保持不变"
                        echoMode: TextInput.Password
                    }
                }
                
                // 确认新密码
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "确认新密码"; font.pixelSize: 13 }
                    TextField {
                        id: confirmPasswordField
                        Layout.fillWidth: true
                        placeholderText: "留空保持不变"
                        echoMode: TextInput.Password
                    }
                }
                
                // 提示信息
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: "#fff3cd"
                    border.color: "#ffc107"
                    border.width: 0
                    radius: 4
                    
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 4
                        color: "#ffc107"
                        radius: 4
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Text {
                            text: "ℹ️"
                            font.pixelSize: 16
                        }
                        
                        Text {
                            text: "如需重置密码，请输入新密码后保存。"
                            font.pixelSize: 13
                            color: "#856404"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // 按钮区域
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    
                    Item { Layout.fillWidth: true }
                    
                    Button {
                        text: "取消"
                        onClicked: editUserDialog.close()
                    }
                    
                    Button {
                        text: "保存修改"
                        highlighted: true
                        
                        background: Rectangle {
                            color: parent.pressed ? "#229954" : "#27ae60"
                            radius: 4
                        }
                        
                        onClicked: {
                            // 使用 JS 验证密码
                            const result = DialogManager.validatePassword(
                                newPasswordField.text,
                                confirmPasswordField.text
                            );
                            
                            if (!result.valid) {
                                passwordErrorDialog.errorMessage = result.message;
                                passwordErrorDialog.open();
                                return;
                            }
                            
                            // 更新密码
                            if (newPasswordField.text) {
                                DialogManager.updateUserPassword(editUserId.text, newPasswordField.text);
                            }
                            
                            console.log("更新账户:", editUserId.text);
                            editUserDialog.close();
                        }
                    }
                }
            }
        }
    }
    
    // ==========================================
    // 3. 创建问卷弹窗
    // ==========================================
    Dialog {
        id: surveyDialog
        anchors.centerIn: parent
        width: 800
        height: 600
        modal: true
        title: "创建新心理问卷"
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 15
            
            // 问卷标题
            ColumnLayout {
                spacing: 5
                
                Text { text: "问卷标题"; font.pixelSize: 13 }
                TextField {
                    id: surveyTitle
                    Layout.fillWidth: true
                    placeholderText: "例如：2025级新生入学适应性量表"
                }
            }
            
            // 问卷说明
            ColumnLayout {
                spacing: 5
                
                Text { text: "问卷说明"; font.pixelSize: 13 }
                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    
                    TextArea {
                        id: surveyDescription
                        placeholderText: "请输入问卷的指导语、适用人群及注意事项..."
                        wrapMode: TextArea.Wrap
                    }
                }
            }
            
            // 题目设置区域
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "题目设置"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "➕ 添加题目"
                    
                    background: Rectangle {
                        color: parent.pressed ? "#229954" : "#27ae60"
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
                        questionListModel.append({
                            "questionNumber": questionListModel.count + 1,
                            "questionText": "",
                            "questionType": "是/否"
                        })
                    }
                }
            }
            
            // 题目列表
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                ListView {
                    id: questionListView
                    spacing: 10
                    
                    model: ListModel {
                        id: questionListModel
                        
                        ListElement {
                            questionNumber: 1
                            questionText: ""
                            questionType: "是/否"
                        }
                    }
                    
                    delegate: Rectangle {
                        width: questionListView.width
                        height: 220
                        color: "#fafafa"
                        border.color: "#ccc"
                        border.width: 1
                        radius: 4
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 10
                            
                            // 题目标题和删除按钮
                            RowLayout {
                                Layout.fillWidth: true
                                
                                Text {
                                    text: "题目 " + model.questionNumber
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: "#2c3e50"
                                }
                                
                                Item { Layout.fillWidth: true }
                                
                                Button {
                                    text: "🗑️"
                                    flat: true
                                    
                                    onClicked: {
                                        if (questionListModel.count > 1) {
                                            questionListModel.remove(index)
                                        } else {
                                            minQuestionDialog.open()
                                        }
                                    }
                                }
                            }
                            
                            // 问题描述
                            ColumnLayout {
                                spacing: 3
                                
                                Text { text: "问题描述"; font.pixelSize: 12; color: "#666" }
                                TextField {
                                    Layout.fillWidth: true
                                    placeholderText: "请输入问题内容..."
                                }
                            }
                            
                            // 题目类型
                            ColumnLayout {
                                spacing: 3
                                
                                Text { text: "题目类型"; font.pixelSize: 12; color: "#666" }
                                ComboBox {
                                    id: questionTypeCombo
                                    Layout.fillWidth: true
                                    model: ["单选题 (是/否)", "多选题", "李克特量表 (1-5分)", "自定义选项"]
                                }
                            }
                            
                            // 选项预览
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 60
                                color: "#f9f9f9"
                                radius: 4
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: DialogManager.getOptionsPreview(questionTypeCombo.currentIndex)
                                    font.pixelSize: 12
                                    color: "#666"
                                }
                            }
                        }
                    }
                }
            }
            
            // 底部按钮
            RowLayout {
                Layout.fillWidth: true
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "取消"
                    onClicked: surveyDialog.close()
                }
                
                Button {
                    text: "发布问卷"
                    highlighted: true
                    
                    background: Rectangle {
                        color: parent.pressed ? "#229954" : "#27ae60"
                        radius: 4
                    }
                    
                    onClicked: {
                        // 使用 JS 验证和发布问卷
                        const result = DialogManager.validateSurvey(
                            surveyTitle.text,
                            questionListModel.count
                        );
                        
                        if (!result.valid) {
                            // 根据错误类型显示不同提示
                            if (result.message.includes("标题")) {
                                // 创建或显示标题错误弹窗
                                console.error(result.message);
                            } else if (result.message.includes("题目")) {
                                minQuestionDialog.open();
                            }
                            return;
                        }
                        
                        console.log("发布问卷:", surveyTitle.text);
                        surveyDialog.close();
                    }
                }
            }
        }
    }
    
    // ==========================================
    // 4. 发布文章弹窗
    // ==========================================
    Dialog {
        id: articleDialog
        anchors.centerIn: parent
        width: 800
        height: 650
        modal: true
        title: "发布科普文章"
        
        ScrollView {
            anchors.fill: parent
            clip: true
            
            ColumnLayout {
                width: articleDialog.width - 40
                spacing: 15
                
                // 文章标题
                ColumnLayout {
                    spacing: 5
                    
                    Text { text: "文章标题"; font.pixelSize: 13 }
                    TextField {
                        id: articleTitle
                        Layout.fillWidth: true
                        placeholderText: "请输入吸引人的标题"
                    }
                }
                
                // 分类和封面图
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        
                        Text { text: "分类"; font.pixelSize: 13 }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ["压力管理", "人际交往", "自我认知", "情绪调节", "睡眠卫生"]
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        
                        Text { text: "封面图链接 (可选)"; font.pixelSize: 13 }
                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "https://example.com/image.jpg"
                        }
                    }
                }
                
                // 工具栏
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: "#f9f9f9"
                    border.color: "#ddd"
                    border.width: 1
                    radius: 4
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 15
                        
                        Text { text: "𝐁"; font.pixelSize: 16; font.bold: true }
                        Text { text: "𝐼"; font.pixelSize: 16; font.italic: true }
                        Text { text: "≡"; font.pixelSize: 16 }
                        Text { text: "🔗"; font.pixelSize: 14 }
                        Text { text: "🖼️"; font.pixelSize: 14 }
                    }
                }
                
                // 文章内容
                ColumnLayout {
                    spacing: 0
                    
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300
                        
                        TextArea {
                            id: articleContent
                            placeholderText: "# 这里开始撰写文章内容...\n\n## 小标题\n正文内容..."
                            wrapMode: TextArea.Wrap
                            font.family: "monospace"
                        }
                    }
                }
                
                // 按钮区域
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    
                    Button {
                        text: "💾 存为草稿"
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#666"
                        }
                        
                        onClicked: {
                            console.log("保存草稿:", articleTitle.text)
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Button {
                        text: "取消"
                        onClicked: articleDialog.close()
                    }
                    
                    Button {
                        text: "正式发布"
                        highlighted: true
                        
                        background: Rectangle {
                            color: parent.pressed ? "#229954" : "#27ae60"
                            radius: 4
                        }
                        
                        onClicked: {
                            // 使用 JS 验证和发布
                            const result = DialogManager.publishArticle(
                                articleTitle.text,
                                articleContent.text
                            );
                            
                            if (!result.valid) {
                                emptyTitleDialog.open();
                                return;
                            }
                            
                            console.log("发布文章:", articleTitle.text);
                            articleDialog.close();
                        }
                    }
                }
            }
        }
    }
    
    // ==========================================
    // 辅助弹窗
    // ==========================================
    
    // 密码错误提示
    MessageDialog {
        id: passwordErrorDialog
        title: "⚠️ 密码验证失败"
        property string errorMessage: ""
        text: errorMessage
        buttons: MessageDialog.Ok
    }
    
    // 题目数量限制提示
    MessageDialog {
        id: minQuestionDialog
        title: "⚠️ 操作限制"
        text: "至少需要保留一道题目！"
        buttons: MessageDialog.Ok
    }
    
    // 标题为空提示
    MessageDialog {
        id: emptyTitleDialog
        title: "⚠️ 内容不完整"
        text: "请输入文章标题！"
        buttons: MessageDialog.Ok
    }
}
