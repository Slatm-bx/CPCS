// MentalLiterature.qml - 科普文章管理面板 (QVariantList版本)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "white"
    radius: 8

    // 信号
    signal showArticleDialog()
    signal showEditArticleDialog(int articleId, string title, string summary, string content)

    // 本地 ListModel 存储文章数据
    ListModel {
        id: articleListModel
    }

    // 从数据库加载文章到 ListModel
    function refreshArticles() {
        articleListModel.clear()
        var articles = databaseHandler.getAllArticles()
        for (var i = 0; i < articles.length; i++) {
            articleListModel.append(articles[i])
        }
        console.log("📚 刷新文章列表，共", articleListModel.count, "篇")
    }

    // 删除文章
    function deleteArticle(articleId) {
        if (databaseHandler.deleteArticle(articleId)) {
            refreshArticles()
        }
    }

    // 页面加载时刷新数据
    Component.onCompleted: {
        refreshArticles()
    }

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
                text: "🔄 刷新"
                Layout.preferredWidth: 80

                background: Rectangle {
                    color: parent.pressed ? "#2980b9" : (parent.hovered ? "#3498db" : "#3498db")
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: refreshArticles()
            }

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
                    anchors.verticalCenter: parent.verticalCenter

                    Text { text: "标题"; Layout.preferredWidth: 250; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "作者"; Layout.preferredWidth: 100; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "发布时间"; Layout.preferredWidth: 100; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "阅读量"; Layout.preferredWidth: 80; font.weight: Font.DemiBold; color: "#34495e" }
                    Text { text: "操作"; Layout.fillWidth: true; font.weight: Font.DemiBold; color: "#34495e" }
                }
            }

            // 使用本地 ListModel
            model: articleListModel

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
                    anchors.verticalCenter: parent.verticalCenter

                    // 标题
                    Text {
                        text: model.title
                        Layout.preferredWidth: 250
                        elide: Text.ElideRight
                        font.pixelSize: 14
                    }

                    // 作者
                    Text {
                        text: model.author
                        Layout.preferredWidth: 100
                        font.pixelSize: 14
                        color: "#666"
                    }

                    // 发布时间
                    Text {
                        text: model.date
                        Layout.preferredWidth: 100
                        font.pixelSize: 14
                        color: "#666"
                    }

                    // 阅读量
                    Text {
                        text: model.readCount
                        Layout.preferredWidth: 80
                        font.pixelSize: 14
                        color: "#666"
                    }

                    // 操作按钮
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        // 编辑按钮
                        Text {
                            text: "✏️"
                            font.pixelSize: 18
                            color: "#3498db"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.showEditArticleDialog(
                                        model.articleId,
                                        model.title,
                                        model.summary,
                                        model.content
                                    )
                                }
                            }
                        }

                        // 删除按钮
                        Text {
                            text: "🗑️"
                            font.pixelSize: 18
                            color: "#e74c3c"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    deleteConfirmDialog.articleId = model.articleId
                                    deleteConfirmDialog.articleTitle = model.title
                                    deleteConfirmDialog.open()
                                }
                            }
                        }
                    }
                }
            }

            // 空列表提示
            Text {
                anchors.centerIn: parent
                text: "暂无文章，点击「发布新文章」添加"
                font.pixelSize: 16
                color: "#999"
                visible: articleListView.count === 0
            }
        }
    }

    // 删除确认弹窗
    Dialog {
        id: deleteConfirmDialog
        anchors.centerIn: parent
        width: 400
        height: 180
        modal: true
        title: "确认删除"

        property int articleId: 0
        property string articleTitle: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            Text {
                text: "确定要删除文章「" + deleteConfirmDialog.articleTitle + "」吗？"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "此操作不可撤销！"
                font.pixelSize: 12
                color: "#e74c3c"
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true

                Item { Layout.fillWidth: true }

                Button {
                    text: "取消"
                    onClicked: deleteConfirmDialog.close()
                }

                Button {
                    text: "确认删除"

                    background: Rectangle {
                        color: parent.pressed ? "#c0392b" : "#e74c3c"
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        root.deleteArticle(deleteConfirmDialog.articleId)
                        deleteConfirmDialog.close()
                    }
                }
            }
        }
    }
}
