import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: libraryPage
    color: "#e3f2fd"

    property var currentArticle: null
    property bool showDetail: false
    property bool isLoading: false

    // 文章数据模型
    ListModel {
        id: articleModel
    }

    Component.onCompleted: {
        loadPsychologicalLiterature()
    }

    // 文章列表视图（预览界面）
    ListView {
        id: articleListView
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        model: articleModel
        clip: true
        visible: !showDetail && !isLoading

        // 加载指示器
        BusyIndicator {
            anchors.centerIn: parent
            width: 50
            height: 50
            visible: isLoading
        }

        // 无数据提示
        footer: Rectangle {
            width: articleListView.width
            height: 300
            visible: !isLoading && articleModel.count === 0

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "📚"
                    font.pixelSize: 50
                }

                Text {
                    text: "暂无心理健康文献"
                    font.pixelSize: 18
                    color: "#666"
                    font.bold: true
                }

                Text {
                    text: "管理员正在努力更新中..."
                    font.pixelSize: 14
                    color: "#999"
                }
            }
        }

        delegate: Rectangle {
            width: ListView.view.width  // 改为这样访问ListView的宽度
            height: 160
            radius: 12
            color: "white"

            Row {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 20

                // 左侧图标区域
                Rectangle {
                    width: 120
                    height: 120
                    radius: 10
                    color: model.color || "#2196f3"

                    Text {
                        anchors.centerIn: parent
                        text: model.icon || "📚"
                        font.pixelSize: 36
                    }
                }

                // 右侧内容区域
                Column {
                    width: parent.width - 140
                    spacing: 10

                    // 标题
                    Text {
                        text: model.title || "无标题"
                        width: parent.width
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                        wrapMode: Text.WordWrap
                    }

                    // 摘要
                    Text {
                        text: model.summary || "暂无摘要"
                        width: parent.width
                        font.pixelSize: 14
                        color: "#666"
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                    }

                    // 底部信息栏
                    Row {
                        width: parent.width
                        spacing: 25

                        Text {
                            text: "作者：" + (model.author || "未知作者")
                            font.pixelSize: 12
                            color: "#888"
                        }

                        Text {
                            text: "发布时间：" + (model.date || "未知日期")
                            font.pixelSize: 12
                            color: "#888"
                        }

                        Text {
                            text: "阅读量：" + (model.readCount || 0)
                            font.pixelSize: 12
                            color: "#888"
                        }
                    }

                    // 阅读按钮
                    Rectangle {
                        width: 100
                        height: 35
                        radius: 6
                        color: model.color || "#2196f3"

                        Text {
                            anchors.centerIn: parent
                            text: "阅读全文"
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                currentArticle = {
                                    articleId: model.articleId || 0,
                                    title: model.title || "无标题",
                                    summary: model.summary || "暂无摘要",
                                    author: model.author || "未知作者",
                                    date: model.date || "未知日期",
                                    readCount: model.readCount || 0,
                                    icon: model.icon || "📚",
                                    color: model.color || "#2196f3",
                                    content: model.content || "暂无内容"
                                }
                                showDetail = true

                                // 更新阅读量
                                if (model.articleId) {
                                    databaseHandler.incrementReadCount(model.articleId)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 文章详情页面
    Rectangle {
        id: articleDetailPage
        anchors.fill: parent
        color: "white"
        visible: showDetail

        // 返回按钮 - 固定在左上角
        Rectangle {
            id: backButton
            x: 20
            y: 20
            width: 80
            height: 40
            radius: 8
            color: "#1976d2"

            Text {
                anchors.centerIn: parent
                text: "← 返回"
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    showDetail = false
                    // 注释掉这行，避免立即重新加载
                    // loadPsychologicalLiterature()
                }
            }
        }

        ScrollView {
            anchors.fill: parent
            anchors.topMargin: 80  // 为返回按钮留出空间
            anchors.margins: 20
            clip: true

            Column {
                width: parent.width
                spacing: 20

                // 文章标题
                Text {
                    width: parent.width
                    text: currentArticle ? currentArticle.title : ""
                    font.pixelSize: 24
                    font.bold: true
                    color: "#1976d2"
                    wrapMode: Text.WordWrap
                }

                // 文章信息栏
                Row {
                    width: parent.width
                    spacing: 30

                    Text {
                        text: "作者：" + (currentArticle ? currentArticle.author : "")
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Text {
                        text: "发布时间：" + (currentArticle ? currentArticle.date : "")
                        font.pixelSize: 14
                        color: "#666"
                    }

                    Text {
                        text: "阅读量：" + (currentArticle ? currentArticle.readCount : "")
                        font.pixelSize: 14
                        color: "#666"
                    }
                }

                // 分割线
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#e0e0e0"
                }

                // 文章内容
                Text {
                    width: parent.width
                    text: currentArticle ? currentArticle.content : ""
                    font.pixelSize: 16
                    color: "#333"
                    wrapMode: Text.WordWrap
                    lineHeight: 1.5
                }

                // 底部空白区域
                Item {
                    width: parent.width
                    height: 50
                }
            }
        }

        // 收藏按钮
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 30
            width: 120
            height: 45
            radius: 8
            color: "#ff9800"

            Row {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: "★"
                    color: "white"
                    font.pixelSize: 18
                }

                Text {
                    text: "收藏文章"
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("收藏文章：" + (currentArticle ? currentArticle.title : ""))
                }
            }
        }
    }

    // 函数：加载心理健康文献
    function loadPsychologicalLiterature() {
        isLoading = true
        articleModel.clear()

        timer.start()
    }

    Timer {
        id: timer
        interval: 100
        onTriggered: {
            try {
                var articles = databaseHandler.getPsychologicalLiterature()

                articleModel.clear()

                for (var i = 0; i < articles.length; i++) {
                    var article = articles[i]

                    articleModel.append({
                        articleId: article.articleId || 0,
                        title: article.title || "无标题",
                        summary: article.summary || "暂无摘要",
                        author: article.author || "未知作者",
                        date: article.date || "未知日期",
                        readCount: article.readCount || 0,
                        icon: article.icon || "📚",
                        color: article.color || "#2196f3",
                        content: article.content || "暂无内容"
                    })
                }

                console.log("加载了", articleModel.count, "篇心理健康文献")
            } catch (error) {
                console.log("加载心理健康文献失败:", error)
            }

            isLoading = false
        }
    }
}
