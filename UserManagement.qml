// AccountPanel.qml - 账户管理面板
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "dialogManager.js" as DialogManager

Rectangle {
    color: "white"
    radius: 8

    // 信号：显示弹窗
    signal showAddDialog()
    signal showEditDialog(string userId, string userName, string dept)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // 工具栏：搜索和添加按钮
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // 搜索框
            TextField {
                id: searchField
                Layout.preferredWidth: 250
                placeholderText: "搜索 ID 或 姓名..."

                background: Rectangle {
                    color: "white"
                    border.color: "#ddd"
                    border.width: 1
                    radius: 4
                }
            }

            // 角色筛选
            ComboBox {
                id: roleFilter
                Layout.preferredWidth: 120
                model: ["学生", "老师"]

                background: Rectangle {
                    color: "white"
                    border.color: "#ddd"
                    border.width: 1
                    radius: 4
                }
            }

            // 搜索按钮
            Button {
                text: "🔍 搜索"
                Layout.preferredWidth: 100

                background: Rectangle {
                    color: parent.pressed ? "#2980b9" : (parent.hovered ? "#3498db" : "#3498db")
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("搜索关键字:", searchField.text)
                }
            }

            Item { Layout.fillWidth: true }

            // 添加账户按钮
            Button {
                text: "➕ 添加账户"
                Layout.preferredWidth: 120

                background: Rectangle {
                    color: parent.pressed ? "#229954" : (parent.hovered ? "#27ae60" : "#27ae60")
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.Medium
                }

                onClicked: showAddDialog()
            }
        }

        // 用户表格
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: "#eee"
            border.width: 1
            radius: 4

            ListView {
                id: userListView
                anchors.fill: parent
                clip: true

                // 表头
                header: Rectangle {
                    width: userListView.width
                    height: 50
                    color: "#f9f9f9"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        spacing: 10

                        HeaderCell { text: "ID"; flex: 1 }
                        HeaderCell { text: "姓名"; flex: 1 }
                        HeaderCell { text: "密码"; flex: 1 }
                        HeaderCell { text: "角色"; flex: 1 }
                        HeaderCell { text: "学院/部门"; flex: 2 }
                        HeaderCell { text: "状态"; flex: 1 }
                        HeaderCell { text: "操作"; flex: 2 }
                    }
                }

                // 数据模型
                model: adminUserModel

                // 表格行
                delegate: Rectangle {
                    width: userListView.width
                    height: 60
                    color: index % 2 === 0 ? "white" : "#fafafa"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#eee"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        spacing: 10

                        // ID
                        Text {
                            text: model.id
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7
                            elide: Text.ElideRight
                        }

                        // 姓名
                        Text {
                            text: model.name
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7
                            elide: Text.ElideRight
                        }

                        // 密码（可点击显示/隐藏）
                        Text {
                            id: passwordText
                            text: password
                            color: "#3498db"
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7

                            property bool isHidden: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // 使用 JS 切换密码显示
                                    const result = DialogManager.togglePassword(
                                        passwordText.isHidden,
                                        model.password
                                    );

                                    passwordText.text = result.displayText;
                                    passwordText.color = result.color;
                                    passwordText.isHidden = result.isHidden;
                                }
                            }
                        }

                        // 角色
                        Text {
                            text: model.role
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7
                            elide: Text.ElideRight
                        }

                        // 学院/部门
                        Text {
                            text: model.dept
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7 * 2
                            elide: Text.ElideRight
                        }

                        // 状态徽章
                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 24
                            radius: 12
                            color: model.statusActive ? "#e3f9eb" : "#fee2e2"

                            Text {
                                anchors.centerIn: parent
                                text: model.status
                                font.pixelSize: 12
                                color: model.statusActive ? "#27ae60" : "#ef4444"
                            }
                        }

                        // 操作按钮
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredWidth: parent.width / 7 * 2
                            spacing: 10

                            // 编辑
                            Text {
                                text: "✏️"
                                font.pixelSize: 18
                                color: "#3498db"

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        showEditDialog(model.userId, model.userName, model.department)
                                    }
                                }
                            }

                            // 封禁
                            Text {
                                text: "🚫"
                                font.pixelSize: 18
                                color: "#f39c12"

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        console.log("封禁用户:", model.userId)
                                    }
                                }
                            }

                            // 删除
                            Text {
                                text: "🗑️"
                                font.pixelSize: 18
                                color: "#e74c3c"

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        console.log("删除用户:", model.userId)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 表头单元格组件
    component HeaderCell: Text {
        property real flex: 1
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width / 7 * flex
        text: ""
        font.pixelSize: 14
        font.weight: Font.DemiBold
        color: "#34495e"
        elide: Text.ElideRight
    }
}


// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Rectangle {
//     color: "#e0f2f1"  // 浅青绿色

//     Text {
//         anchors.centerIn: parent
//         text: "学生管理界面"
//         font.pixelSize: 24
//         font.bold: true
//         color: "#00695c"
//     }
// }
