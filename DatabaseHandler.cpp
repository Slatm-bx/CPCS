#include "DatabaseHandler.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include "student.h"
#include "teacher.h"

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
    QString dbPath = "database.db";

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


// 3. 【改】修改用户状态
bool DatabaseHandler::updateUserStatus(const QString& userId, int newStatus) {
    QSqlQuery query;
    query.prepare("UPDATE users SET status = ? WHERE user_id = ?");
    query.addBindValue(newStatus);
    query.addBindValue(userId);

    if (query.exec()) {
        qDebug() << "用户" << userId << "状态已更新为:" << newStatus;
        return true;
    }
    qDebug() << "更新失败:" << query.lastError().text();
    return false;
}

// 4. 【删】删除用户（由于设置了 CASCADE，对应详情表记录也会被删）
bool DatabaseHandler::deleteUser(const QString& userId) {
    QSqlQuery query;
    query.prepare("DELETE FROM users WHERE user_id = ?");
    query.addBindValue(userId);

    if (query.exec()) {
        qDebug() << "用户" << userId << "及其关联详情已成功删除";
        return true;
    }
    qDebug() << "删除失败:" << query.lastError().text();
    return false;
}

// 2. 【查】查询并输出所有用户信息（关联查询）
QList<User*> DatabaseHandler::getAllUsers() {
    // QSqlQuery query("SELECT u.user_id, u.role_type, u.status, s.real_name, s.college "
    //                 "FROM users u "
    //                 "LEFT JOIN student_profiles s ON u.user_id = s.user_id");
    QList<User*> list;
    QString sql = "SELECT u.user_id, u.password, u.role_type, u.status, "
                    "s.real_name AS s_name, s.college, "
                    "t.real_name AS t_name, t.department "
                    "FROM users u "
                    "LEFT JOIN student_profiles s ON u.user_id = s.user_id "
                    "LEFT JOIN teacher_profiles t ON u.user_id = t.user_id;";

    QSqlQuery query(m_database);
    if (!query.exec(sql)) {
        qDebug() << "SQL 执行失败:" << query.lastError().text();
    }

    //  遍历结果集，通过“工厂模式”创建实体
    while (query.next()) {
        QString role = query.value("role_type").toString();
        User* user = nullptr;

        // 根据角色类型创建具体的子类对象
        if (role == "student") {
            Student* s = new Student();
            s->setRealName(query.value("s_name").toString());
            s->setCollege(query.value("college").toString());
            user = s;
        } else if (role == "teacher") {
            Teacher* t = new Teacher();
            t->setRealName(query.value("t_name").toString());
            t->setDepartment(query.value("department").toString());
            user = t;
        } else {
            user = new User(); // 管理员或其他角色
        }

        // 填充共有属性
        user->setUserId(query.value("user_id").toString());
        user->setPassword(query.value("password").toString());
        user->setRoleType(role);
        user->setStatus(query.value("status").toInt());
        list.append(user);
    }

    // 测试： 遍历打印
    // for (User* u : list) {
    //     qDebug() << "用户ID:" << u->userId()
    //              << "角色:" << u->roleType()
    //              << "状态:" << u->status();
    //     if (u->roleType() == "student") {
    //         Student* s = static_cast<Student*>(u);
    //         qDebug() << "  姓名:" << s->realName()
    //                  << "学院:" << s->college();
    //     } else if (u->roleType() == "teacher") {
    //         Teacher* t = static_cast<Teacher*>(u);
    //         qDebug() << "  姓名:" << t->realName()
    //                  << "部门:" << t->department();
    //     }
    // }
    return list;
}