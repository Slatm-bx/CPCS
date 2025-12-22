// pageswitching.js
.pragma library

// 获取主窗口对象
var mainWindow = null
var stackView = null

// 初始化函数
function initialize(window, stack) {
    mainWindow = window
    stackView = stack
}

// 窗口居中函数
function centerWindow() {
    if (mainWindow) {
        var screenWidth = mainWindow.screen ? mainWindow.screen.desktopAvailableWidth : 1920
        var screenHeight = mainWindow.screen ? mainWindow.screen.desktopAvailableHeight : 1080

        mainWindow.x = (screenWidth - mainWindow.width) / 2
        mainWindow.y = (screenHeight - mainWindow.height) / 2
    }
}

// 登录成功跳转
function loginSuccess(role) {
    if (!mainWindow || !stackView) return

    mainWindow.width = 1820
    mainWindow.height = 1024

    switch(role) {
        case "student":
            stackView.push("StudentPage.qml")
            break
        case "teacher":
            stackView.push("TeacherPage.qml")
            break
        case "admin":
            stackView.push("AdminPage.qml")
            break
    }
    centerWindow()
}

// 退出登录
function logout() {
    if (!mainWindow || !stackView) return

    // 清除数据库中的登录状态
    if (typeof databaseHandler !== 'undefined') {
        databaseHandler.logout()
    }

    mainWindow.width = 600
    mainWindow.height = 800
    stackView.clear()
    stackView.push("Login.qml")
    centerWindow()
}

// 获取当前登录的用户ID
function getCurrentUserId() {
    if (typeof databaseHandler !== 'undefined') {
        return databaseHandler.getCurrentUserId()
    }
    return ""
}

// 获取当前角色
function getCurrentRole() {
    if (typeof databaseHandler !== 'undefined') {
        return databaseHandler.getCurrentRole()
    }
    return ""
}
