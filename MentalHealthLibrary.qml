import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: libraryPage
    color: "#e3f2fd"

    property var currentArticle: null
    property bool showDetail: false

    // 文章数据模型
    ListModel {
        id: articleModel

        ListElement {
            articleId: "article1"
            title: "《大学生焦虑情绪的识别与应对》"
            summary: "本文详细介绍了大学生焦虑情绪的常见表现、识别方法和应对策略，帮助同学们更好地理解和管理自己的情绪。"
            author: "王教授"
            date: "2023-10-15"
            readCount: "1234"
            icon: "📚"
            color: "#2196f3"
            content: "焦虑情绪是大学生常见的心理问题之一。主要表现为：

1. 身体症状：心悸、出汗、颤抖、呼吸急促
2. 情绪症状：紧张、担心、恐惧、烦躁
3. 行为症状：回避、拖延、易怒、坐立不安

应对策略：
1. 深呼吸练习：每天进行5-10分钟的深呼吸练习
2. 正念冥想：关注当下，减少对未来的担忧
3. 时间管理：合理安排学习任务，避免拖延
4. 适度运动：每周进行3-4次有氧运动
5. 寻求支持：与朋友、家人或心理咨询师交流

如果焦虑情绪持续影响生活，建议及时寻求专业帮助。"
        }

        ListElement {
            articleId: "article2"
            title: "《压力管理的五个有效方法》"
            summary: "介绍了深呼吸、正念冥想、时间管理、运动放松等五种有效的压力管理技巧，帮助同学们更好地应对学业和生活压力。"
            author: "李博士"
            date: "2023-09-28"
            readCount: "987"
            icon: "📋"
            color: "#4caf50"
            content: "压力是大学生活中不可避免的一部分，但我们可以通过以下方法来管理：

方法一：深呼吸法
- 找一个安静的地方坐下
- 深吸气4秒，屏住呼吸7秒，缓慢呼气8秒
- 重复5-10次

方法二：正念冥想
- 每天抽出10分钟进行冥想
- 专注于呼吸，观察自己的思绪但不做评判
- 可以使用冥想APP辅助

方法三：时间管理
- 使用番茄工作法：25分钟工作，5分钟休息
- 制定每日计划，优先处理重要任务
- 避免多任务处理，专注于单一任务

方法四：运动放松
- 每周进行150分钟中等强度运动
- 尝试瑜伽、太极等放松性运动
- 运动时专注于身体感受

方法五：社交支持
- 与朋友分享压力感受
- 参加校园社团活动
- 寻求学长学姐的经验分享

记住，适度的压力有助于成长，过度的压力需要管理。"
        }

        ListElement {
            articleId: "article3"
            title: "《如何建立健康的人际关系》"
            summary: "探讨了大学生人际关系的特点、常见问题以及建立健康人际关系的实用建议，帮助同学们更好地与人相处。"
            author: "张教授"
            date: "2023-09-10"
            readCount: "856"
            icon: "💭"
            color: "#ff9800"
            content: "建立健康的人际关系对大学生活至关重要：

一、人际关系的重要性
1. 提供情感支持
2. 促进个人成长
3. 增强归属感
4. 缓解压力

二、常见问题
1. 室友矛盾：生活习惯不同
2. 同学竞争：学业压力
3. 社交焦虑：害怕与人交往
4. 沟通障碍：表达不清晰

三、实用建议
1. 学会倾听：真正理解他人
2. 表达清晰：直接但不伤人
3. 尊重差异：接受多样性
4. 保持边界：保护个人空间
5. 主动交往：参加社团活动

四、冲突处理
1. 冷静沟通
2. 换位思考
3. 寻求妥协
4. 必要时寻求第三方调解

健康的人际关系需要时间和努力，但回报是值得的。"
        }

        ListElement {
            articleId: "article4"
            title: "《抑郁情绪的早期识别与干预》"
            summary: "详细介绍了抑郁情绪的早期症状、自我评估方法和寻求专业帮助的途径，提高同学们的心理健康意识。"
            author: "心理中心"
            date: "2023-08-25"
            readCount: "721"
            icon: "😔"
            color: "#9c27b0"
            content: "抑郁情绪的早期识别非常重要：

一、早期症状（持续两周以上）
情绪方面：
1. 持续的情绪低落
2. 对以前喜欢的事情失去兴趣
3. 容易哭泣或情绪波动
4. 感到无望或无助

身体方面：
1. 睡眠障碍（失眠或过度睡眠）
2. 食欲变化（暴食或食欲不振）
3. 疲劳乏力
4. 身体不适但无医学原因

认知方面：
1. 注意力难以集中
2. 记忆力下降
3. 决策困难
4. 自我评价过低

二、自我评估方法
1. PHQ-9抑郁筛查量表
2. 记录情绪日记
3. 观察行为变化
4. 倾听他人反馈

三、干预措施
1. 心理教育：了解抑郁症
2. 规律生活：保持作息规律
3. 适度运动：释放内啡肽
4. 社交活动：避免孤立
5. 专业帮助：心理咨询

四、何时寻求帮助
1. 症状持续两周以上
2. 影响学习和生活
3. 有自伤或自杀想法
4. 家人朋友建议

记住，抑郁情绪不等于抑郁症，但需要重视。"
        }

        ListElement {
            articleId: "article5"
            title: "《睡眠质量与心理健康》"
            summary: "分析了睡眠质量对心理健康的影响，提供了改善睡眠质量的实用建议，帮助同学们拥有更好的休息。"
            author: "刘医师"
            date: "2023-08-10"
            readCount: "654"
            icon: "😴"
            color: "#795548"
            content: "良好睡眠对心理健康至关重要：

一、睡眠与心理健康的关系
1. 睡眠不足增加焦虑和抑郁风险
2. 睡眠质量影响情绪调节能力
3. 睡眠问题可能导致认知功能下降
4. 良好睡眠有助于压力缓解

二、大学生常见睡眠问题
1. 熬夜学习或玩手机
2. 睡眠时间不规律
3. 睡眠环境不佳
4. 睡前过度兴奋

三、改善睡眠质量的建议
环境方面：
1. 保持卧室安静、黑暗、凉爽
2. 使用舒适的床垫和枕头
3. 避免在床上玩手机或学习

习惯方面：
1. 固定作息时间（包括周末）
2. 睡前1小时避免使用电子设备
3. 避免睡前大量进食或饮水
4. 建立睡前放松仪式（如阅读、冥想）

饮食方面：
1. 避免下午后饮用咖啡因
2. 晚餐不宜过饱或过饿
3. 可以饮用温牛奶或洋甘菊茶

运动方面：
1. 规律运动但避免睡前剧烈运动
2. 白天适当接触阳光
3. 睡前可进行轻度伸展

四、如果失眠严重
1. 记录睡眠日记
2. 咨询校医院医生
3. 学习放松技巧
4. 必要时短期使用助眠药物

记住，睡眠是重要的心理健康维护方式。"
        }

        ListElement {
            articleId: "article6"
            title: "《自我关怀与心理成长》"
            summary: "讲述了自我关怀的重要性，提供了自我关怀的具体方法，帮助同学们在成长过程中更好地爱护自己。"
            author: "陈老师"
            date: "2023-07-20"
            readCount: "543"
            icon: "❤️"
            color: "#e91e63"
            content: "自我关怀是心理健康的基石：

一、什么是自我关怀
1. 对自己友善而不是苛责
2. 认识到困难是人生的一部分
3. 用正念的态度观察自己的情绪

二、自我关怀的重要性
1. 减少焦虑和抑郁
2. 提高抗压能力
3. 增强自我效能感
4. 促进人际关系

三、自我关怀练习
情绪关怀：
1. 承认自己的感受：'我现在感到难过是正常的'
2. 给自己温暖的安慰话语
3. 允许自己有情绪波动

身体关怀：
1. 注意身体的需要（休息、营养）
2. 进行放松练习（深呼吸、冥想）
3. 给自己按摩或泡个热水澡

心理关怀：
1. 挑战不合理的自我批评
2. 给自己积极的肯定
3. 庆祝小的成就

四、培养自我关怀的习惯
1. 每天花5分钟进行自我关怀冥想
2. 写自我关怀日记
3. 设立自我关怀的目标
4. 寻找自我关怀的榜样

五、常见误区
1. 自我关怀不等于自私
2. 自我关怀不等于放纵
3. 自我关怀需要练习
4. 自我关怀可以寻求支持

记住，你值得被善待，尤其是被自己善待。"
        }
    }

    // 文章列表视图（预览界面）
    ListView {
        id: articleListView
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        model: articleModel
        clip: true
        visible: !showDetail

        delegate: Rectangle {
            width: parent.width
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
                    color: model.color

                    Text {
                        anchors.centerIn: parent
                        text: model.icon
                        font.pixelSize: 36
                    }
                }

                // 右侧内容区域
                Column {
                    width: parent.width - 140
                    spacing: 10

                    // 标题
                    Text {
                        text: model.title
                        width: parent.width
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1976d2"
                        wrapMode: Text.WordWrap
                    }

                    // 摘要
                    Text {
                        text: model.summary
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
                            text: "作者：" + model.author
                            font.pixelSize: 12
                            color: "#888"
                        }

                        Text {
                            text: "发布时间：" + model.date
                            font.pixelSize: 12
                            color: "#888"
                        }

                        Text {
                            text: "阅读量：" + model.readCount
                            font.pixelSize: 12
                            color: "#888"
                        }
                    }

                    // 阅读按钮
                    Rectangle {
                        width: 100
                        height: 35
                        radius: 6
                        color: model.color

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
                                    articleId: model.articleId,
                                    title: model.title,
                                    summary: model.summary,
                                    author: model.author,
                                    date: model.date,
                                    readCount: model.readCount,
                                    icon: model.icon,
                                    color: model.color,
                                    content: model.content
                                }
                                showDetail = true
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
}
