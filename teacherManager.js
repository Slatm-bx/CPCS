// teacherManager.js
.pragma library

// 教师功能列表
var teacherFunctions = [
    {id: "consultation_process", title: "咨询处理", icon: "🔄", filePath: "ConsultationProcess.qml"},
    {id: "consultation_records", title: "咨询记录", icon: "📋", filePath: "ConsultationRecords.qml"},
    {id: "personal_center", title: "个人中心", icon: "👤", filePath: "TPersonalCenter.qml"}
]

// 活动页面ID
var activePageId = null  // null表示首页

// 获取所有功能
function getFunctions() {
    return teacherFunctions
}

// 获取页面信息
function getPageInfo(pageId) {
    for (var i = 0; i < teacherFunctions.length; i++) {
        if (teacherFunctions[i].id === pageId) {
            return teacherFunctions[i]
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
    return "TeacherHome.qml"
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
        return {type: "home", title: "首页", filePath: "TeacherHome.qml"}
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
