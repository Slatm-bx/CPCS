#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantMap>
#include <QVariantList>
#include "user.h"

class DatabaseHandler : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseHandler(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap verifyLogin(const QString &userId,
                                        const QString &password,
                                        const QString &roleType);

    Q_INVOKABLE QString getCurrentUserId() const;
    Q_INVOKABLE QString getCurrentRole() const;
    Q_INVOKABLE void logout();

    // --- 管理员用户CRUD 操作 ---
    QList<User*> getAllUsers();
    bool deleteUser(const QString& userId);
    // 插入新用户 (同时写入 users 和 profile 表)
    bool addNewUser(const QString& id, const QString& name, const QString& pwd, const QString& role, const QString& dept, const QString& gender = "", const QString& entryYear = "");
    // 更新用户信息
    bool updateUserInfo(const QString& id, const QString& name, const QString& dept, int status, const QString& newPwd = "", const QString& gender = "", const QString& entryYear = "");
    // 搜索用户 (支持 ID 或 姓名)
    QList<User*> searchUsers(const QString& keyword);

    // --- 管理员文章CRUD 操作 (QVariantList方式) ---
    Q_INVOKABLE QVariantList getAllArticles();
    Q_INVOKABLE bool addArticle(const QString& title, const QString& summary,
                                const QString& author, const QString& content);
    Q_INVOKABLE bool updateArticle(int articleId, const QString& title,
                                   const QString& summary, const QString& content);
    Q_INVOKABLE bool deleteArticle(int articleId);
    Q_INVOKABLE QVariantMap getArticleById(int articleId);


    // --------学生用户添加的操作--------
    // 新增：获取当前用户姓名
    Q_INVOKABLE QString getCurrentUserName() const;  // 添加这一行

    // 新增：获取心理咨询师列表
    Q_INVOKABLE QVariantList getTeachers();

    // 新增：提交教师预约消息
    Q_INVOKABLE bool submitTeacherAppointment(const QString &teacherId,
                                              const QString &studentId,
                                              const QString &studentName,
                                              const QString &appointDate,
                                              const QString &appointSlot,
                                              const QString &phoneNumber,
                                              const QString &consultType,
                                              const QString &problem);

    //获取日志
    Q_INVOKABLE QVariantList getConsultationLogs(const QString &studentId);

    //获取心理文献
    Q_INVOKABLE QVariantList getPsychologicalLiterature();
    Q_INVOKABLE bool incrementReadCount(int articleId);

    // 新增：获取学生的预约消息
    Q_INVOKABLE QVariantList getStudentAppointmentMessages(const QString &studentId);
    // 新增：标记消息为已读
    Q_INVOKABLE bool markMessageAsRead(int messageId);
    // 新增：删除学生消息
    Q_INVOKABLE bool deleteStudentMessage(int messageId);

    // 获取学生个人信息
    Q_INVOKABLE QVariantMap getStudentProfile(const QString &studentId);
    // 更新学生个人信息
    Q_INVOKABLE bool updateStudentProfile(const QString &studentId,
                                          const QString &realName,
                                          const QString &college,
                                          const QString &major,
                                          int entryYear,
                                          const QString &gender = "");
    // 获取学生统计信息
    Q_INVOKABLE QVariantMap getStudentStatistics(const QString &studentId);

    // 获取所有测试类型
    Q_INVOKABLE QVariantList getPsychologicalTestTypes();
    // 获取特定类型的测试题目
    Q_INVOKABLE QVariantList getPsychologicalTestQuestions(const QString &testType);
    // 保存测试结果
    Q_INVOKABLE bool saveTestResult(const QString &studentId,
                                    const QString &testName,
                                    const QString &testType,
                                    const QString &date,
                                    int score,
                                    const QString &result,
                                    const QString &status);
    // 获取测试历史记录
    Q_INVOKABLE QVariantList getTestHistory(const QString &studentId);

    // --- 管理员咨询监管操作 ---
    // 获取所有咨询记录（关联学生姓名）
    Q_INVOKABLE QVariantList getAllConsultationLogs();

    // --- 心理测试问卷管理操作 ---
    // 获取所有测试卷
    Q_INVOKABLE QVariantList getAllPsychologicalTests();
    // 新增测试卷
    Q_INVOKABLE bool addPsychologicalTest(const QString &type, 
                                          const QString &p1, const QString &p2, 
                                          const QString &p3, const QString &p4, 
                                          const QString &p5);
    // 删除测试卷
    Q_INVOKABLE bool deletePsychologicalTest(int anTestId);

private:
    bool openDatabase();
    QSqlDatabase m_database;
    QString m_currentUserId;
    QString m_currentRole;
    QString m_currentUserName;
};

#endif // DATABASEHANDLER_H
