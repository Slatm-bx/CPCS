// adminManager.js
.pragma library

// 管理员功能列表
var adminFunctions = [
    {id: "student_management", title: "用户管理", icon: "👥", filePath: "UserManagement.qml"},
    {id: "consultation_supervision", title: "咨询监管", icon: "👁️", filePath: "ConsultationSupervision.qml"},
    {id: "mental_literature", title: "心理文献", icon: "📚", filePath: "MentalLiterature.qml"},
    {id: "psychological_tests", title: "心理测试", icon: "📊", filePath: "PsychologicalTests.qml"}
]

// 活动页面ID
var activePageId = null  // null表示首页

// 获取所有功能
function getFunctions() {
    return adminFunctions
}

// 获取页面信息
function getPageInfo(pageId) {
    for (var i = 0; i < adminFunctions.length; i++) {
        if (adminFunctions[i].id === pageId) {
            return adminFunctions[i]
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
    return "AdminHome.qml"
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
        return {type: "home", title: "首页", filePath: "AdminHome.qml"}
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
