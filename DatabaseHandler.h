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

private:
    bool openDatabase();
    QSqlDatabase m_database;
    QString m_currentUserId;
    QString m_currentRole;
};

#endif // DATABASEHANDLER_H
