// pageswitching.js
.pragma library

// 获取主窗口对象
var mainWindow = null
var stackView = null
var currentRole = ""

// 初始化函数
function initialize(window, stack) {
    mainWindow = window
    stackView = stack
}

// 窗口居中函数
function centerWindow() {
    if (mainWindow) {
        // 通过mainWindow的父级或直接计算
        var screenWidth = mainWindow.screen ? mainWindow.screen.desktopAvailableWidth : 1920
        var screenHeight = mainWindow.screen ? mainWindow.screen.desktopAvailableHeight : 1080

        mainWindow.x = (screenWidth - mainWindow.width) / 2
        mainWindow.y = (screenHeight - mainWindow.height) / 2
    }
}


// 登录成功跳转
function loginSuccess(role) {
    if (!mainWindow || !stackView) return

    currentRole = role
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

    mainWindow.width = 600
    mainWindow.height = 800
    currentRole = ""
    stackView.clear()
    stackView.push("Login.qml")
    centerWindow()
}

// 获取当前角色
function getCurrentRole() {
    return currentRole
}
