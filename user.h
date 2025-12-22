#ifndef USER_H
#define USER_H

#include <QObject>
#include <QString>
#include <QDateTime>

class User : public QObject {
    Q_OBJECT
    // 使用 Q_PROPERTY 使属性在 QML 中可见并可绑定
    Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString roleType READ roleType WRITE setRoleType NOTIFY roleTypeChanged)
    Q_PROPERTY(int status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(QString createdAt READ createdAt WRITE setCreatedAt NOTIFY createdAtChanged)

public:
    explicit User(QObject *parent = nullptr) : QObject(parent), m_status(1) {}

    // Getter 函数
    QString userId() const { return m_userId; }
    QString roleType() const { return m_roleType; } // 'admin', 'student', 'teacher'
    QString password() const { return m_password; }
    QString createdAt() const { return m_created_at; }
    int status() const { return m_status; }        // 1-正常, 0-封禁

    // Setter 函数（包含数据变化检查，防止多余更新）
    void setUserId(const QString &id) { if (m_userId != id) { m_userId = id; emit userIdChanged(); } }
    void setRoleType(const QString &role) { if (m_roleType != role) { m_roleType = role; emit roleTypeChanged(); } }
    void setStatus(int s) { if (m_status != s) { m_status = s; emit statusChanged(); } }
    void setPassword(const QString &pwd) { m_password = pwd; }
    void setCreatedAt(const QString &dt) { m_created_at = dt; }

signals:
    void userIdChanged();
    void passwordChanged();
    void createdAtChanged();
    void roleTypeChanged();
    void statusChanged();

protected:
    QString m_userId;
    QString m_password;
    QString m_roleType;
    int m_status;
    QString m_created_at;

};
#endif
