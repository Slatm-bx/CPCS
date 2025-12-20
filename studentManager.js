// studentManager.js
.pragma library

// 学生功能列表
var studentFunctions = [
    {id: "counselor_chat", title: "心理导师咨询", icon: "💬", filePath: "CounselorChat.qml"},
    {id: "consultation_log", title: "咨询日志", icon: "📝", filePath: "ConsultationLog.qml"},
    {id: "health_library", title: "心理健康文献", icon: "📚", filePath: "MentalHealthLibrary.qml"},
    {id: "self_evaluation", title: "个人心理测试", icon: "📊", filePath: "SelfEvaluation.qml"},
    {id: "personal_center", title: "个人中心", icon: "👤", filePath: "PersonalCenter.qml"},
    {id: "message_center", title: "消息中心", icon: "✉️", filePath: "MessageCenter.qml"}
]

// 活动页面ID
var activePageId = null  // null表示首页

// 获取所有功能
function getFunctions() {
    return studentFunctions
}

// 获取页面信息
function getPageInfo(pageId) {
    for (var i = 0; i < studentFunctions.length; i++) {
        if (studentFunctions[i].id === pageId) {
            return studentFunctions[i]
        }
    }
    return null
}

// 打开页面
function openPage(pageId) {
    var pageInfo = getPageInfo(pageId)
    if (!pageInfo) return null

    activePageId = pageId

    return {
        pageId: pageId,
        filePath: pageInfo.filePath
    }
}

// 切换到首页
function goHome() {
    activePageId = null
    return "StudentHome.qml"
}

// 切换到指定页面（通过ID）
function switchToPageById(pageId) {
    var pageInfo = getPageInfo(pageId)
    if (pageInfo) {
        activePageId = pageId
        return pageInfo.filePath
    }
    return null
}

// 获取当前活动页面
function getActivePage() {
    if (activePageId === null) {
        return {type: "home", title: "首页", filePath: "StudentHome.qml"}
    } else {
        var pageInfo = getPageInfo(activePageId)
        if (pageInfo) {
            return pageInfo
        }
    }
    return null
}

// 检查页面是否激活
function isPageActive(pageId) {
    return activePageId === pageId
}

// 重置（退出登录时调用）
function reset() {
    activePageId = null
}
