// dialogManager.js - 弹窗和交互逻辑管理
// 所有业务逻辑集中在这里，QML 只负责 UI 展示

// ==========================================
// 用户账户管理逻辑
// ==========================================

// 模拟用户数据库
var userDatabase = {
    "2025001": { password: "123456", name: "张小明", dept: "计算机学院" },
    "T8002": { password: "password123", name: "王老师", dept: "心理教育中心" }
};

// 切换密码显示/隐藏
function togglePassword(userId, isHidden) {
    if (isHidden) {
        return userDatabase[userId]?.password || "***";
    } else {
        return "●●●●●●●";
    }
}

// 获取当前密码
function getCurrentPassword(userId) {
    return userDatabase[userId]?.password || "";
}

// 验证密码
function validatePassword(newPass, confirmPass) {
    if (newPass && confirmPass && newPass !== confirmPass) {
        return { valid: false, message: "两次输入的密码不一致！" };
    }
    
    if (newPass && newPass.length < 6) {
        return { valid: false, message: "新密码长度不能少于6个字符！" };
    }
    
    return { valid: true, message: "验证通过" };
}

// 更新用户密码
function updateUserPassword(userId, newPassword) {
    if (userDatabase[userId]) {
        userDatabase[userId].password = newPassword;
        console.log("密码已更新:", userId, "->", newPassword);
        return true;
    }
    return false;
}

// 搜索用户
function searchUser(keyword, role) {
    console.log("搜索关键字:", keyword, "角色:", role);
    // 实际项目中这里会调用后端 API
    return [];
}

// 删除用户
function deleteUser(userId) {
    if (userDatabase[userId]) {
        delete userDatabase[userId];
        console.log("用户已删除:", userId);
        return true;
    }
    return false;
}

// 封禁用户
function banUser(userId) {
    console.log("用户已封禁:", userId);
    // 实际项目中更新数据库状态
    return true;
}

// ==========================================
// 问卷管理逻辑
// ==========================================

var questionCounter = 1;

// 创建新题目
function createNewQuestion() {
    questionCounter++;
    return {
        questionNumber: questionCounter,
        questionText: "",
        questionType: "yesno"
    };
}

// 获取选项预览文本
function getOptionsPreview(typeIndex) {
    switch(typeIndex) {
        case 0: return "○ 是    ○ 否";
        case 1: return "☐ 选项A    ☐ 选项B    ☐ 选项C";
        case 2: return "1️⃣ 很不同意  2️⃣ 不同意  3️⃣ 一般  4️⃣ 同意  5️⃣ 很同意";
        case 3: return "自定义选项 (可在文本框中输入)";
        default: return "";
    }
}

// 验证问卷数据
function validateSurvey(title, description, questions) {
    if (!title || title.trim() === "") {
        return { valid: false, message: "请输入问卷标题！" };
    }
    
    if (questions.length === 0) {
        return { valid: false, message: "至少需要一道题目！" };
    }
    
    return { valid: true, message: "验证通过" };
}

// 发布问卷
function publishSurvey(surveyData) {
    console.log("发布问卷:", JSON.stringify(surveyData));
    // 实际项目中调用后端 API
    return true;
}

// ==========================================
// 文章管理逻辑
// ==========================================

// 验证文章数据
function validateArticle(title, content) {
    if (!title || title.trim() === "") {
        return { valid: false, message: "请输入文章标题！" };
    }
    
    return { valid: true, message: "验证通过" };
}

// 发布文章
function publishArticle(articleData) {
    console.log("发布文章:", articleData.title);
    // 实际项目中调用后端 API
    return true;
}

// 保存草稿
function saveDraft(articleData) {
    console.log("保存草稿:", articleData.title);
    // 实际项目中调用后端 API
    return true;
}

// 删除文章
function deleteArticle(articleId) {
    console.log("删除文章:", articleId);
    return true;
}

// ==========================================
// 记录存档管理逻辑
// ==========================================

// 验证访问权限
function verifyAccessPermission(password, recordId) {
    const ADMIN_PASSWORD = "admin123";
    
    if (password === ADMIN_PASSWORD) {
        console.log("访问记录:", recordId);
        return {
            success: true,
            message: "身份验证成功。正在加载咨询记录...\n(此处将进入加密阅读模式)"
        };
    } else {
        return {
            success: false,
            message: "密码错误！\n非法访问记录已被系统审计模块记录。"
        };
    }
}

// ==========================================
// 工具函数
// ==========================================

// 格式化日期
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 生成唯一 ID
function generateUniqueId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// 导出所有函数
// 在 QML 中使用: import "dialogManager.js" as DialogManager
