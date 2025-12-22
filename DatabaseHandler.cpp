#include "DatabaseHandler.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

DatabaseHandler::DatabaseHandler(QObject *parent)
    : QObject(parent)
{
    openDatabase();
}

bool DatabaseHandler::openDatabase()
{
    if (m_database.isOpen()) {
        return true;
    }

    m_database = QSqlDatabase::addDatabase("QSQLITE", "psychological_connection");

    // 数据库路径 - 根据你的实际路径调整
    QString dbPath = "/run/media/root/shuju/xinlizixunxitong/psychological/database.db";

    // 检查数据库文件是否存在
    if (!QFile::exists(dbPath)) {
        qDebug() << "数据库文件不存在:" << dbPath;
        return false;
    }

    m_database.setDatabaseName(dbPath);

    if (!m_database.open()) {
        qDebug() << "无法打开数据库:" << m_database.lastError().text();
        return false;
    }

    qDebug() << "数据库连接成功";
    return true;
}

QVariantMap DatabaseHandler::verifyLogin(const QString &userId,
                                         const QString &password,
                                         const QString &roleType)
{
    QVariantMap result;

    if (!openDatabase()) {
        result["success"] = false;
        result["message"] = "数据库连接失败";
        return result;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT user_id, role_type, status FROM users "
                  "WHERE user_id = ? AND password = ? AND role_type = ?");
    query.addBindValue(userId);
    query.addBindValue(password);
    query.addBindValue(roleType);

    if (!query.exec()) {
        result["success"] = false;
        result["message"] = "查询失败: " + query.lastError().text();
        return result;
    }

    if (query.next()) {
        int status = query.value("status").toInt();

        if (status == 1) {
            // 登录成功
            m_currentUserId = query.value("user_id").toString();
            m_currentRole = query.value("role_type").toString();

            result["success"] = true;
            result["userId"] = m_currentUserId;
            result["roleType"] = m_currentRole;
        } else {
            result["success"] = false;
            result["message"] = "该账号已被禁用";
        }
    } else {
        result["success"] = false;
        result["message"] = "账号或密码错误";
    }

    return result;
}

QString DatabaseHandler::getCurrentUserId() const
{
    return m_currentUserId;
}

QString DatabaseHandler::getCurrentRole() const
{
    return m_currentRole;
}

void DatabaseHandler::logout()
{
    m_currentUserId.clear();
    m_currentRole.clear();
}
