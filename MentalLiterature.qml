// ArticlePanel.qml - 科普文章管理面板
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "white"
    radius: 8

    // 信号：显示文章编辑弹窗
    signal showArticleDialog()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // 顶部工具栏
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "科普文章管理"
                font.pixelSize: 20
                font.bold: true
                color: "#2c3e50"
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "✏️ 发布新文章"
                Layout.preferredWidth: 140

                background: Rectangle {
                    color: parent.pressed ? "#229954" : (parent.hovered ? "#27ae60" : "#27ae60")
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: showArticleDialog()
            }
        }

        // 文章列表
        ListView {
            id: articleListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // 表头
            header: Rectangle {
                width: articleListView.width
                height: 50
                color: "#f9f9f9"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    spacing: 10

                    Text { text: "标题"; Layout.preferredWidth: 250; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "主题分类"; Layout.preferredWidth: 100; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "发布时间"; Layout.preferredWidth: 100; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "阅读量"; Layout.preferredWidth: 80; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "状态"; Layout.preferredWidth: 80; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "操作"; Layout.fillWidth: true; font.weight: Font.DemiBold; color: "#34495e" }
                }
            }

            model: ListModel {
                ListElement {
                    title: "如何应对期末考试焦虑？"
                    category: "压力管理"
                    publishDate: "2025-12-01"
                    views: "1,240"
                    status: "已发布"
                    isPublished: true
                }
                ListElement {
                    title: "建立健康的亲密关系指南"
                    category: "恋爱关系"
                    publishDate: "2025-11-28"
                    views: "856"
                    status: "草稿"
                    isPublished: false
                }
            }

            delegate: Rectangle {
                width: articleListView.width
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

                    // 标题
                    Text {
                        text: model.title
                        Layout.preferredWidth: 250
                        elide: Text.ElideRight
                        font.pixelSize: 14
                    }

                    // 分类标签
                    Rectangle {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 24
                        radius: 4
                        color: "#e1f5fe"

                        Text {
                            anchors.centerIn: parent
                            text: model.category
                            font.pixelSize: 12
                            color: "#0288d1"
                        }
                    }

                    // 发布时间
                    Text {
                        text: model.publishDate
                        Layout.preferredWidth: 100
                        font.pixelSize: 14
                        color: "#666"
                    }

                    // 阅读量
                    Text {
                        text: model.views
                        Layout.preferredWidth: 80
                        font.pixelSize: 14
                        color: "#666"
                    }

                    // 状态
                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 24
                        radius: 12
                        color: model.isPublished ? "#e3f9eb" : "#eee"

                        Text {
                            anchors.centerIn: parent
                            text: model.status
                            font.pixelSize: 12
                            color: model.isPublished ? "#27ae60" : "#666"
                        }
                    }

                    // 操作按钮
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        Text {
                            text: "✏️"
                            font.pixelSize: 18
                            color: "#3498db"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: showArticleDialog()
                            }
                        }

                        Text {
                            text: "🗑️"
                            font.pixelSize: 18
                            color: "#e74c3c"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: console.log("删除文章:", model.title)
                            }
                        }
                    }
                }
            }
        }
    }
}


// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Rectangle {
//     color: "#e3f2fd"  // 浅蓝色

//     Text {
//         anchors.centerIn: parent
//         text: "心理文献界面"
//         font.pixelSize: 24
//         font.bold: true
//         color: "#1976d2"
//     }
// }
