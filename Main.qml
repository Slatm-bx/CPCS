import QtQuick
import QtQuick.Controls
// import "pageswitching.js" as pageswitching

ApplicationWindow {
    id: mainWindow
    width: 600
    height: 800
    visible: true
    title: "心理咨询系统"

    // 窗口居中函数
   function centerWindow() {
       // 获取屏幕尺寸和窗口尺寸
       var screenWidth = Screen.desktopAvailableWidth
       var screenHeight = Screen.desktopAvailableHeight

       // 计算居中位置
       mainWindow.x = (screenWidth - mainWindow.width) / 2
       mainWindow.y = (screenHeight - mainWindow.height) / 2
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
                    duration: 500
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 500
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 500
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 500
                }
            }
        }

    // 登录页面
    Component {
        id: loginPage

        Rectangle {
            color: "lightblue"
            Button {
                text: "学生登录"
                onClicked: {
                    // 先调整窗口大小
                    mainWindow.width = 1820
                    mainWindow.height = 1024
                    centerWindow()  // 居中
                    // 再推入页面
                    stackView.push(studentPage)
                }
            }
            Button {
                text: "教师登录"
                onClicked: {
                    mainWindow.width = 1820
                    mainWindow.height = 1024
                    stackView.push(teacherPage)
                    centerWindow()  // 居中
                }
                anchors.top: parent.top
                anchors.topMargin: 50
            }
            Button {
                text: "管理员登录"
                onClicked: {
                    mainWindow.width = 1820
                    mainWindow.height = 1024
                    stackView.push(adminPage)
                    centerWindow()  // 居中
                }
                anchors.top: parent.top
                anchors.topMargin: 100
            }
        }
    }

    // 学生页面
    Component {
        id: studentPage

        Rectangle {
            color: "lightgreen"
            Text {
                text: "学生页面"
                anchors.centerIn: parent
            }
            Button {
                text: "返回登录页"
                onClicked: {
                    // 返回时调整回登录页大小
                    mainWindow.width = 600
                    mainWindow.height = 800
                    centerWindow()  // 居中
                    stackView.pop()
                }
            }
        }
    }

    // 教师页面
    Component {
        id: teacherPage

        Rectangle {
            color: "lightyellow"
            Text {
                text: "教师页面"
                anchors.centerIn: parent
            }
            Button {
                text: "返回登录页"
                onClicked: {
                    mainWindow.width = 600
                    mainWindow.height = 800
                    centerWindow()  // 居中
                    stackView.pop()
                }
            }
        }
    }

    // 管理员页面
    Component {
        id: adminPage

        Rectangle {
            color: "lightpink"
            Text {
                text: "管理员页面"
                anchors.centerIn: parent
            }
            Button {
                text: "返回登录页"
                onClicked: {
                    mainWindow.width = 600
                    mainWindow.height = 800
                    centerWindow()  // 居中
                    stackView.pop()
                }
            }
        }
    }
}
