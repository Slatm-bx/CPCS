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

    // --- CRUD 操作 ---
    bool addStudent(const QString& userId, const QString& password, const QString& name, const QString& college);
    QList<User*> getAllUsers();
    bool updateUserStatus(const QString& userId, int newStatus);
    bool deleteUser(const QString& userId);

private:
    bool openDatabase();
    QSqlDatabase m_database;
    QString m_currentUserId;
    QString m_currentRole;
};

#endif // DATABASEHANDLER_H
