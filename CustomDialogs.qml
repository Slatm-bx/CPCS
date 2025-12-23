// CustomDialogs.qml - 所有模态弹窗集合
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "dialogManager.js" as DialogManager

Item {
    id: root
    
    property var parentWindow

    // 文章发布/更新后的信号
    signal articlePublished()

    // 公共函数
    function openAddUserDialog() {
        addUserDialog.open()
    }

    function openEditUserDialog(userId, userName, userDept, userRole, gender, entryYear) {
        console.log("🔍 打开编辑弹窗 - userRole:", userRole, "userId:", userId, "gender:", gender, "entryYear:", entryYear)
        editUserDialog.userId = userId
        editUserDialog.userName = userName
        editUserDialog.userDept = userDept
        editUserDialog.userRole = userRole
        editUserDialog.userGender = gender || ""
        editUserDialog.userEntryYear = entryYear || ""
        console.log("🔍 设置后 editUserDialog.userRole:", editUserDialog.userRole)
        editUserDialog.open()
    }

    function openSurveyDialog() {
        surveyDialog.open()
    }

    function openArticleDialog() {
        articleDialog.openForAdd()
    }

    function openEditArticleDialog(articleId, title, summary, content) {
        articleDialog.openForEdit(articleId, title, summary, content)
    }

    // 打开咨询详情弹窗
    function openConsultationDetailDialog(consultationId, studentName, counselor,
                                          consultationDate, consultationType,
                                          duration, phoneNumber, selfEvaluation, summary) {
        consultationDetailDialog.consultationId = consultationId
        consultationDetailDialog.studentName = studentName
        consultationDetailDialog.counselor = counselor
        consultationDetailDialog.consultationDate = consultationDate
        consultationDetailDialog.consultationType = consultationType
        consultationDetailDialog.duration = duration
        consultationDetailDialog.phoneNumber = phoneNumber
        consultationDetailDialog.selfEvaluation = selfEvaluation
        consultationDetailDialog.summary = summary
        consultationDetailDialog.open()
    }

    // // 公共函数：打开各种弹窗
    // function openAddUserDialog() {
    //     addUserDialog.open()
    // }

    // function openEditUserDialog(userId, userName, userDept) {
    //     editUserDialog.userId = userId
    //     editUserDialog.userName = userName
    //     editUserDialog.userDept = userDept
    //     editUserDialog.open()
    // }

    // function openSurveyDialog() {
    //     surveyDialog.open()
    // }

    // function openArticleDialog() {
    //     articleDialog.open()
    // }

    // ==========================================
    // 1. 添加新用户弹窗（含学院/部门选择）
    // ==========================================
    Dialog {
        id: addUserDialog
        anchors.centerIn: parent
        width: 450
        height: 580
        modal: true
        title: "添加新账户"

        // 学院列表
        property var collegeList: [
            "计算机与信息科学学院",
            "地理学院",
            "化学学院",
            "生命科学学院",
            "数学科学学院",
            "物理学院",
            "经济管理学院",
            "文学院",
            "外国语学院",
            "美术学院",
            "马克思主义学院",
            "音乐学院",
            "体育学院",
            "教育科学学院"
        ]

        // 部门列表
        property var departmentList: [
            "心理咨询中心",
            "学生工作处",
            "教务处",
            "校医院",
            "后勤保障部",
            "招生就业处"
        ]

        // 入学年份列表
        property var entryYearList: ["2021", "2022", "2023", "2024", "2025"]

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

                    onCurrentTextChanged: {
                        if (currentText === "学生") {
                            newUserDept.model = addUserDialog.collegeList
                        } else {
                            newUserDept.model = addUserDialog.departmentList
                        }
                    }
                }
            }

            // 学院/部门（下拉选择）
            ColumnLayout {
                spacing: 5

                Text {
                    text: newUserRole.currentText === "学生" ? "学院" : "部门"
                    font.pixelSize: 13
                }
                ComboBox {
                    id: newUserDept
                    Layout.fillWidth: true
                    model: addUserDialog.collegeList
                    editable: true  // 允许手动输入
                }
            }

            // 性别（仅学生显示）
            ColumnLayout {
                spacing: 5
                visible: newUserRole.currentText === "学生"

                Text { text: "性别"; font.pixelSize: 13 }
                ComboBox {
                    id: newUserGender
                    Layout.fillWidth: true
                    model: ["男", "女"]
                }
            }

            // 入学年份（仅学生显示）
            ColumnLayout {
                spacing: 5
                visible: newUserRole.currentText === "学生"

                Text { text: "入学年份"; font.pixelSize: 13 }
                ComboBox {
                    id: newUserEntryYear
                    Layout.fillWidth: true
                    model: addUserDialog.entryYearList
                    editable: true  // 允许手动输入
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
                        console.log("创建账户:", newUserId.text, newUserName.text, newUserDept.currentText)
                        // 学生需要传递性别和入学年份
                        var gender = newUserRole.currentText === "学生" ? newUserGender.currentText : ""
                        var entryYear = newUserRole.currentText === "学生" ? newUserEntryYear.currentText : ""
                        adminUserModel.qmlAddUser(
                            newUserId.text,
                            newUserName.text,
                            newUserRole.currentText,
                            newUserPassword.text,
                            newUserDept.currentText,
                            gender,
                            entryYear
                        )
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
        height: 750
        modal: true
        title: "修改账户信息"
        
        property string userId: ""
        property string userName: ""
        property string userDept: ""
        property string userRole: ""
        property string userGender: ""
        property string userEntryYear: ""

        // 入学年份列表
        property var entryYearList: ["2021", "2022", "2023", "2024", "2025"]
        
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
                
                // 学院/部门（下拉选择）
                ColumnLayout {
                    spacing: 5
                    visible: editUserDialog.userRole !== "admin"//管理员不显示部门

                    Text { 
                        text: editUserDialog.userRole === "student" ? "学院" : 
                              editUserDialog.userRole === "teacher" ? "部门" : "学院/部门"
                        font.pixelSize: 13 
                    }
                    ComboBox {
                        id: editUserDept
                        Layout.fillWidth: true
                        editable: true  // 允许手动输入
                        enabled: editUserDialog.userRole !== "admin" //对管理员禁用，因为管理员不属于任何部门

                        // 根据角色动态设置列表
                        model: editUserDialog.userRole === "student" ? [
                            "计算机与信息科学学院",
                            "地理学院",
                            "化学学院",
                            "生命科学学院",
                            "数学科学学院",
                            "物理学院",
                            "经济管理学院",
                            "文学院",
                            "外国语学院",
                            "美术学院",
                            "马克思主义学院",
                            "音乐学院",
                            "体育学院",
                            "教育科学学院"
                        ] : editUserDialog.userRole === "teacher" ? [
                            "心理咨询中心",
                            "学生工作处",
                            "教务处",
                            "校医院",
                            "后勤保障部",
                            "招生就业处"
                        ] : ["请选择"]

                        // 设置当前值
                        Component.onCompleted: {
                            console.log("🔍 ComboBox 初始化 - userRole:", editUserDialog.userRole)
                            console.log("🔍 ComboBox model count:", editUserDept.count)
                            console.log("🔍 ComboBox model:", editUserDept.model)
                            editUserDept.editText = editUserDialog.userDept
                        }

                        //角色变化时更新当前值
                        Connections {
                            target: editUserDialog
                            function onUserDeptChanged() {
                                editUserDept.editText = editUserDialog.userDept
                            }
                            function onUserRoleChanged() {
                                console.log("🔍 userRole 变化:", editUserDialog.userRole)
                                console.log("🔍 新的 model count:", editUserDept.count)
                            }
                        }
                    }
                }

                // 性别（仅学生显示）
                ColumnLayout {
                    spacing: 5
                    visible: editUserDialog.userRole === "student"

                    Text { text: "性别"; font.pixelSize: 13 }
                    ComboBox {
                        id: editUserGender
                        Layout.fillWidth: true
                        model: ["男", "女"]

                        Component.onCompleted: {
                            // 设置初始值
                            var idx = editUserGender.find(editUserDialog.userGender)
                            if (idx >= 0) editUserGender.currentIndex = idx
                        }

                        Connections {
                            target: editUserDialog
                            function onUserGenderChanged() {
                                var idx = editUserGender.find(editUserDialog.userGender)
                                if (idx >= 0) editUserGender.currentIndex = idx
                            }
                        }
                    }
                }

                // 入学年份（仅学生显示）
                ColumnLayout {
                    spacing: 5
                    visible: editUserDialog.userRole === "student"

                    Text { text: "入学年份"; font.pixelSize: 13 }
                    ComboBox {
                        id: editUserEntryYear
                        Layout.fillWidth: true
                        model: editUserDialog.entryYearList
                        editable: true  // 允许手动输入

                        Component.onCompleted: {
                            editUserEntryYear.editText = editUserDialog.userEntryYear
                        }

                        Connections {
                            target: editUserDialog
                            function onUserEntryYearChanged() {
                                editUserEntryYear.editText = editUserDialog.userEntryYear
                            }
                        }
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
                            // if (newPasswordField.text) {
                            //     DialogManager.updateUserPassword(editUserId.text, newPasswordField.text);
                            // }
                            
                            console.log("更新账户:", editUserId.text);
                            // 调用 C++ 接口更新
                            // 学生需要传递性别和入学年份
                            var gender = editUserDialog.userRole === "student" ? editUserGender.currentText : ""
                            var entryYear = editUserDialog.userRole === "student" ? editUserEntryYear.editText : ""
                            adminUserModel.qmlUpdateUser(
                                editUserId.text,       // ID
                                editUserName.text,     // 姓名
                                editUserDept.editText,     // 部门
                                editUserStatus.currentText, // 状态文本 ("正常"/"封禁")
                                newPasswordField.text,  // 新密码 (为空则不改)
                                gender,                // 性别 (仅学生)
                                entryYear              // 入学年份 (仅学生)
                            )
                            editUserDialog.close()
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
    // 4. 发布/编辑文章弹窗（简化版 - QVariantList）
    // ==========================================
    Dialog {
        id: articleDialog
        anchors.centerIn: parent
        width: 800
        height: 550
        modal: true
        title: isEditMode ? "编辑文章" : "发布科普文章"

        property bool isEditMode: false
        property int editArticleId: 0

        function openForAdd() {
            isEditMode = false
            editArticleId =0 
            articleTitle.text = ""
            articleAuthor.text = ""
            articleSummary.text=""
            articleContent.text=""
            open()
        }
        
        function openForEdit(articleId, title, summary, content) {
            isEditMode = true
            editArticleId = articleId
            articleTitle.text = title
            articleSummary.text = summary
            articleContent.text = content
            // 从数据库获取作者信息
            //var article = databaseHandler.getArticleById(articleId)
            //if (article && article.author) {
            //    articleAuthor.text = article.author
            //}
            open()
        }

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
                        placeholderText: "请输入文章标题"
                    }
                }

                // 作者（仅新增时显示）
                ColumnLayout {
                    spacing: 5
                    visible: !articleDialog.isEditMode

                    Text { text: "作者"; font.pixelSize: 13 }
                    TextField {
                        id: articleAuthor
                        Layout.fillWidth: true
                        placeholderText: "请输入作者名称"
                    }
                }

                // 文章摘要
                ColumnLayout {
                    spacing: 5

                    Text { text: "文章摘要"; font.pixelSize: 13 }
                    TextField {
                        id: articleSummary
                        Layout.fillWidth: true
                        placeholderText: "简短描述文章内容"
                    }
                }

                // 文章内容
                ColumnLayout {
                    spacing: 5

                    Text { text: "文章内容"; font.pixelSize: 13 }
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 250

                        TextArea {
                            id: articleContent
                            placeholderText: "请输入文章正文内容..."
                            wrapMode: TextArea.Wrap
                            font.pixelSize: 14
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
                        onClicked: articleDialog.close()
                    }

                    Button {
                        text: articleDialog.isEditMode ? "保存修改" : "发布文章"
                        highlighted: true

                        background: Rectangle {
                            color: parent.pressed ? "#229954" : "#27ae60"
                            radius: 4
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (articleTitle.text.trim() === "") {
                                emptyTitleDialog.open()
                                return
                            }

                            if (articleDialog.isEditMode) {
                                // 编辑模式：更新文章
                                databaseHandler.updateArticle(
                                    articleDialog.editArticleId,
                                    articleTitle.text,
                                    articleSummary.text,
                                    articleContent.text,
                                    //articleAuthor.text
                                )
                            } else {
                                // 新增模式：发布文章
                                databaseHandler.addArticle(
                                    articleTitle.text,
                                    articleSummary.text,
                                    articleAuthor.text,
                                    articleContent.text
                                )
                            }

                            articleDialog.close()
                            
                            // 通知刷新列表
                            articlePublished()
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

    // ==========================================
    // 5. 咨询详情弹窗
    // ==========================================
    Dialog {
        id: consultationDetailDialog
        anchors.centerIn: parent
        width: 550
        height: 500
        modal: true
        title: "📋 咨询详情"

        // 咨询详情数据
        property int consultationId: 0
        property string studentName: ""
        property string counselor: ""
        property string consultationDate: ""
        property string consultationType: ""
        property int duration: 0
        property string phoneNumber: ""
        property string selfEvaluation: ""
        property string summary: ""

        ScrollView {
            anchors.fill: parent
            clip: true

            ColumnLayout {
                width: consultationDetailDialog.width - 40
                spacing: 15

                // 基本信息区域
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: infoColumn.implicitHeight + 30
                    color: "#fff3e0"
                    radius: 8

                    ColumnLayout {
                        id: infoColumn
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        Text {
                            text: "📌 基本信息"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#e65100"
                        }

                        GridLayout {
                            columns: 2
                            columnSpacing: 30
                            rowSpacing: 8
                            Layout.fillWidth: true

                            Text { text: "咨询ID："; color: "#666"; font.pixelSize: 13 }
                            Text { text: consultationDetailDialog.consultationId; color: "#333"; font.pixelSize: 13 }

                            Text { text: "学生姓名："; color: "#666"; font.pixelSize: 13 }
                            Text { text: consultationDetailDialog.studentName || "-"; color: "#333"; font.pixelSize: 13 }

                            Text { text: "咨询师："; color: "#666"; font.pixelSize: 13 }
                            Text { text: consultationDetailDialog.counselor || "-"; color: "#333"; font.pixelSize: 13 }

                            Text { text: "咨询日期："; color: "#666"; font.pixelSize: 13 }
                            Text { text: consultationDetailDialog.consultationDate || "-"; color: "#333"; font.pixelSize: 13 }

                            Text { text: "咨询类型："; color: "#666"; font.pixelSize: 13 }
                            Rectangle {
                                width: 80
                                height: 24
                                color: getTypeColor(consultationDetailDialog.consultationType)
                                radius: 4

                                Text {
                                    anchors.centerIn: parent
                                    text: consultationDetailDialog.consultationType || "-"
                                    font.pixelSize: 12
                                    color: "white"
                                }

                                function getTypeColor(type) {
                                    if (type === "个人咨询") return "#3498db"
                                    if (type === "团体辅导") return "#9b59b6"
                                    if (type === "危机干预") return "#e74c3c"
                                    if (type === "心理测评") return "#27ae60"
                                    return "#95a5a6"
                                }
                            }
                        }
                    }
                }

                // 联系方式和时长
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: contactColumn.implicitHeight + 30
                    color: "#e3f2fd"
                    radius: 8

                    ColumnLayout {
                        id: contactColumn
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        Text {
                            text: "📞 联系信息"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#1565c0"
                        }

                        GridLayout {
                            columns: 2
                            columnSpacing: 30
                            rowSpacing: 8
                            Layout.fillWidth: true

                            Text { text: "联系电话："; color: "#666"; font.pixelSize: 13 }
                            Text { 
                                text: consultationDetailDialog.phoneNumber || "未填写"
                                color: consultationDetailDialog.phoneNumber ? "#333" : "#999"
                                font.pixelSize: 13
                            }

                            Text { text: "咨询时长："; color: "#666"; font.pixelSize: 13 }
                            Text { 
                                text: consultationDetailDialog.duration > 0 ? 
                                      consultationDetailDialog.duration + " 分钟" : "未记录"
                                color: consultationDetailDialog.duration > 0 ? "#333" : "#999"
                                font.pixelSize: 13
                            }
                        }
                    }
                }

                // 学生反馈
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: feedbackColumn.implicitHeight + 30
                    color: "#f3e5f5"
                    radius: 8

                    ColumnLayout {
                        id: feedbackColumn
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        Text {
                            text: "💬 学生反馈（自评）"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#7b1fa2"
                        }

                        Text {
                            text: consultationDetailDialog.selfEvaluation || "暂无反馈"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            font.pixelSize: 13
                            color: consultationDetailDialog.selfEvaluation ? "#333" : "#999"
                            lineHeight: 1.4
                        }
                    }
                }

                // 咨询总结
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: summaryColumn.implicitHeight + 30
                    color: "#e8f5e9"
                    radius: 8

                    ColumnLayout {
                        id: summaryColumn
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        Text {
                            text: "📝 咨询总结"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#2e7d32"
                        }

                        Text {
                            text: consultationDetailDialog.summary || "暂无总结"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            font.pixelSize: 13
                            color: consultationDetailDialog.summary ? "#333" : "#999"
                            lineHeight: 1.4
                        }
                    }
                }

                // 关闭按钮
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "关闭"
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 36

                        background: Rectangle {
                            color: parent.down ? "#e67e22" : "#ff9800"
                            radius: 4
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: consultationDetailDialog.close()
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }
}
