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

    // --- 用户CRUD 操作 ---
    QList<User*> getAllUsers();
    bool deleteUser(const QString& userId);
    // 插入新用户 (同时写入 users 和 profile 表)
    bool addNewUser(const QString& id, const QString& name, const QString& pwd, const QString& role, const QString& dept);
    // 更新用户信息
    bool updateUserInfo(const QString& id, const QString& name, const QString& dept, int status, const QString& newPwd = "");
    // 搜索用户 (支持 ID 或 姓名)
    QList<User*> searchUsers(const QString& keyword);

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


private:
    bool openDatabase();
    QSqlDatabase m_database;
    QString m_currentUserId;
    QString m_currentRole;
    QString m_currentUserName;
};

#endif // DATABASEHANDLER_H
