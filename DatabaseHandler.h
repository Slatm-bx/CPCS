#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantMap>
#include <QVariantList>

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

private:
    bool openDatabase();
    QSqlDatabase m_database;
    QString m_currentUserId;
    QString m_currentRole;
};

#endif // DATABASEHANDLER_H
