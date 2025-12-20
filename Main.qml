import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "pageswitching.js" as Pages

ApplicationWindow {
    id: mainWindow
    width: 600
    height: 800
    visible: true
    title: "心理咨询系统"

    property string currentRole: ""  // 记录当前登录角色


    // 初始化JavaScript模块
    Component.onCompleted: {
        // 初始化JavaScript模块，传递mainWindow和stackView
        Pages.initialize(mainWindow, stackView)
        Pages.centerWindow()
        stackView.push("Login.qml")
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
