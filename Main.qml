import QtQuick
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: mainWindow
    width: 600
    height: 800
    visible: true
    title: "心理咨询系统"

    property string currentRole: ""  // 记录当前登录角色

    // 窗口居中函数
    function centerWindow() {
        mainWindow.x = (Screen.desktopAvailableWidth - mainWindow.width) / 2
        mainWindow.y = (Screen.desktopAvailableHeight - mainWindow.height) / 2
    }

    // 登录成功跳转
    function loginSuccess(role) {
        currentRole = role
        mainWindow.width = 1820
        mainWindow.height = 1024

        switch(role) {
            case "student":
                stackView.push(studentPage)
                break
            case "teacher":
                 stackView.push(teacherPage)
                break
            case "admin":
                stackView.push(adminPage)
                break
        }
        centerWindow()
    }

    // 退出登录
    function logout() {
        mainWindow.width = 600
        mainWindow.height = 800
        currentRole = ""
        stackView.clear()
        stackView.push(loginPage)
        centerWindow()
    }

    Component.onCompleted: {
        centerWindow()
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: loginPage
        // 页面切换动画 - 淡入淡出
           pushEnter: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 0
                   to: 1
                   duration: 300
               }
           }
           pushExit: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 1
                   to: 0
                   duration: 300
               }
           }
           popEnter: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 0
                   to: 1
                   duration: 300
               }
           }
           popExit: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 1
                   to: 0
                   duration: 300
               }
           }
    }

    // 加载各个页面
    Component { id: loginPage; Login {} }
    Component { id: studentPage; StudentPage {} }
    Component { id: teacherPage; TeacherPage {} }
    Component { id: adminPage; AdminPage {} }
}
