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


bool DatabaseHandler::addNewUser(const QString& id, const QString& name, const QString& pwd, const QString& role, const QString& dept) {
    if (!m_database.isOpen()) {
        qDebug() << "数据库未打开";
        return false;
    }

    // qDebug() << "开始添加新用户: DatabaseHandler.addNewUser" << id << name << role << dept;
    m_database.transaction(); // 开启事务,保证数据一致性

    // 1. 插入主表 users
    QSqlQuery query(m_database);

    // ✅ 修改：角色转换逻辑（处理"学生"/"老师"）
    QString roleType = (role == "老师" || role == "teacher") ? "teacher" : "student";
    // qDebug() << "角色转换:" << role << "->" << roleType;

    // 说明：使用占位符 ? 防止SQL注入
    query.prepare("INSERT INTO users (user_id, password, role_type, status) VALUES (?, ?, ?, 1)");
    query.addBindValue(id); // 第一个?替换为id
    query.addBindValue(pwd);
    query.addBindValue(roleType);


    if (!query.exec()) {
        m_database.rollback();
        qDebug() << "插入 users 表失败:" << query.lastError().text();
        qDebug() << "SQL:" << query.executedQuery();
        return false;
    }

    // 2. 插入详情表 (根据角色判断)
    if (role == "老师") {
        query.prepare("INSERT INTO teacher_profiles (user_id, real_name, department) VALUES (?, ?, ?)");
    } else {
        query.prepare("INSERT INTO student_profiles (user_id, real_name, college) VALUES (?, ?, ?)");
    }
    query.addBindValue(id);
    query.addBindValue(name);
    query.addBindValue(dept);

    if (!query.exec()) {
        qDebug() << "插入详情表失败:" << query.lastError().text();
        qDebug() << "SQL:" << query.executedQuery();
        m_database.rollback(); // 失败回滚
        return false;
    }

    m_database.commit(); // 提交事务
    return true;
}

bool DatabaseHandler::updateUserInfo(const QString& id, const QString& name, const QString& dept, int status, const QString& newPwd) {
    m_database.transaction();
    QSqlQuery query(m_database);

    // 1. 更新主表 (状态和可选的密码)
    QString sql = "UPDATE users SET status = ?";
    if (!newPwd.isEmpty()) sql += ", password = ?";
    sql += " WHERE user_id = ?";

    query.prepare(sql);
    query.addBindValue(status);
    if (!newPwd.isEmpty()) query.addBindValue(newPwd);
    query.addBindValue(id);

    if (!query.exec()) { 
        qDebug() << " 更新 users 表失败:" << query.lastError().text();
        qDebug() << "   SQL:" << query.executedQuery();
        m_database.rollback(); 
        return false; 
    }
    qDebug() << "✅ users 表更新成功";

    // 2. 更新详情表 (先尝试更新学生表，再尝试更新老师表)
    query.prepare("UPDATE student_profiles SET real_name = ?, college = ? WHERE user_id = ?");
    query.addBindValue(name);
    query.addBindValue(dept);
    query.addBindValue(id);
    bool studentUpdated = query.exec();
    if (!studentUpdated) {
        qDebug() << "更新 student_profiles 失败或该用户不是学生:" << query.lastError().text();
    }
    
    query.prepare("UPDATE teacher_profiles SET real_name = ?, department = ? WHERE user_id = ?");
    query.addBindValue(name);
    query.addBindValue(dept);
    query.addBindValue(id);
    bool teacherUpdated = query.exec();
    if (!teacherUpdated) {
        qDebug() << "更新 teacher_profiles 失败或该用户不是老师:" << query.lastError().text();
    }
    
    // 至少要有一个表更新成功
    if (!studentUpdated && !teacherUpdated) {
        qDebug() << "❌ 错误：该用户在学生表和老师表中都不存在！";
        m_database.rollback();
        return false;
    }
    
    m_database.commit();
    qDebug() << "✅ 详情表更新成功";
    
    // ✅ 添加：验证更新结果
    QSqlQuery verifyQuery(m_database);
    verifyQuery.prepare("SELECT user_id, password, status FROM users WHERE user_id = ?");
    verifyQuery.addBindValue(id);

    if (!verifyQuery.exec()) {
        qDebug() << "❌ 验证查询执行失败:" << verifyQuery.lastError().text();
    } else if (!verifyQuery.next()) {
        qDebug() << "❌ 验证查询无结果，用户可能不存在:" << id;
    } else {
        qDebug() << "✅ 验证更新结果:";
        qDebug() << "  用户ID:" << verifyQuery.value("user_id").toString();
        qDebug() << "  新密码:" << verifyQuery.value("password").toString();
        qDebug() << "  新状态:" << verifyQuery.value("status").toInt();
    }
    
    return true;
}

//通过关键字搜索用户（支持ID或姓名）
//待实现
QList<User*> DatabaseHandler::searchUsers(const QString& keyword) {
    QList<User*> list;
    
    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return list;
    }

    QString sql = "SELECT u.user_id, u.password, u.role_type, u.status, "
                  "s.real_name AS s_name, s.college, "
                  "t.real_name AS t_name, t.department "
                  "FROM users u "
                  "LEFT JOIN student_profiles s ON u.user_id = s.user_id "
                  "LEFT JOIN teacher_profiles t ON u.user_id = t.user_id "
                  "WHERE u.user_id LIKE ? OR s.real_name LIKE ? OR t.real_name LIKE ?";

    QSqlQuery query(m_database);
    query.prepare(sql);
    
    QString pattern = "%" + keyword + "%";
    query.addBindValue(pattern);
    query.addBindValue(pattern);
    query.addBindValue(pattern);

    if (!query.exec()) {
        qDebug() << "❌ 搜索失败:" << query.lastError().text();
        return list;
    }

    // 遍历结果集（与 getAllUsers 相同的逻辑）
    while (query.next()) {
        QString role = query.value("role_type").toString();
        User* user = nullptr;

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
            user = new User();
        }

        user->setUserId(query.value("user_id").toString());
        user->setPassword(query.value("password").toString());
        user->setRoleType(role);
        user->setStatus(query.value("status").toInt());
        list.append(user);
    }

    qDebug() << "🔍 搜索关键字:" << keyword << "结果数量:" << list.size();
    return list;
}

bool DatabaseHandler::deleteUser(const QString& userId) {
    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return false;
    }

    m_database.transaction();
    QSqlQuery query(m_database);

    // 1. 删除学生详情表
    query.prepare("DELETE FROM student_profiles WHERE user_id = ?");
    query.addBindValue(userId);
    query.exec(); // 不管成功失败（可能不是学生）

    // 2. 删除老师详情表
    query.prepare("DELETE FROM teacher_profiles WHERE user_id = ?");
    query.addBindValue(userId);
    query.exec(); // 不管成功失败（可能不是老师）

    // 3. 删除主表
    query.prepare("DELETE FROM users WHERE user_id = ?");
    query.addBindValue(userId);
    
    if (!query.exec()) {
        qDebug() << "❌ 删除用户失败:" << query.lastError().text();
        m_database.rollback();
        return false;
    }

    if (query.numRowsAffected() == 0) {
        qDebug() << "❌ 用户不存在:" << userId;
        m_database.rollback();
        return false;
    }

    m_database.commit();
    qDebug() << "✅ 用户已删除:" << userId;
    return true;
}