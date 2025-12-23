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

//-----------  管理员数据库操作 ---------
//----------- 管理员用户管理操作 --------
// 2. 【查】查询并输出所有用户信息（关联查询）
QList<User*> DatabaseHandler::getAllUsers() {
    // QSqlQuery query("SELECT u.user_id, u.role_type, u.status, s.real_name, s.college "
    //                 "FROM users u "
    //                 "LEFT JOIN student_profiles s ON u.user_id = s.user_id");
    QList<User*> list;
    QString sql = "SELECT u.user_id, u.password, u.role_type, u.status, "
                  "s.real_name AS s_name, s.college, s.gender, s.entry_year, "
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
            s->setGender(query.value("gender").toString());
            s->setEntryYear(query.value("entry_year").toString());
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


bool DatabaseHandler::addNewUser(const QString& id, const QString& name, const QString& pwd, const QString& role, const QString& dept, const QString& gender, const QString& entryYear) {
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
        query.addBindValue(id);
        query.addBindValue(name);
        query.addBindValue(dept);
    } else {
        query.prepare("INSERT INTO student_profiles (user_id, real_name, college, gender, entry_year) VALUES (?, ?, ?, ?, ?)");
        query.addBindValue(id);
        query.addBindValue(name);
        query.addBindValue(dept);
        query.addBindValue(gender);
        query.addBindValue(entryYear);
    }

    if (!query.exec()) {
        qDebug() << "插入详情表失败:" << query.lastError().text();
        qDebug() << "SQL:" << query.executedQuery();
        m_database.rollback(); // 失败回滚
        return false;
    }

    m_database.commit(); // 提交事务
    return true;
}

bool DatabaseHandler::updateUserInfo(const QString& id, const QString& name, const QString& dept, int status, const QString& newPwd, const QString& gender, const QString& entryYear) {
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
    qDebug() << "users 表更新成功";

    // 2. 更新详情表 (先尝试更新学生表，再尝试更新老师表)
    query.prepare("UPDATE student_profiles SET real_name = ?, college = ?, gender = ?, entry_year = ? WHERE user_id = ?");
    query.addBindValue(name);
    query.addBindValue(dept);
    query.addBindValue(gender);
    query.addBindValue(entryYear);
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
        qDebug() << "错误：该用户在学生表和老师表中都不存在！";
        m_database.rollback();
        return false;
    }

    m_database.commit();
    qDebug() << "详情表更新成功";

    // ✅ 添加：验证更新结果
    QSqlQuery verifyQuery(m_database);
    verifyQuery.prepare("SELECT user_id, password, status FROM users WHERE user_id = ?");
    verifyQuery.addBindValue(id);

    if (!verifyQuery.exec()) {
        qDebug() << "验证查询执行失败:" << verifyQuery.lastError().text();
    } else if (!verifyQuery.next()) {
        qDebug() << "验证查询无结果，用户可能不存在:" << id;
    } else {
        qDebug() << "验证更新结果:";
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
        qDebug() << "数据库未打开";
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
        qDebug() << "搜索失败:" << query.lastError().text();
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

    qDebug() << "搜索关键字:" << keyword << "结果数量:" << list.size();
    return list;
}

bool DatabaseHandler::deleteUser(const QString& userId) {
    if (!m_database.isOpen()) {
        qDebug() << "数据库未打开";
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
        qDebug() << "删除用户失败:" << query.lastError().text();
        m_database.rollback();
        return false;
    }

    if (query.numRowsAffected() == 0) {
        qDebug() << "用户不存在:" << userId;
        m_database.rollback();
        return false;
    }

    m_database.commit();
    qDebug() << "用户已删除:" << userId;
    return true;
}
// ==========================================
// 管理员文章相关操作 (QVariantList方式)
// ==========================================

QVariantList DatabaseHandler::getAllArticles()
{
    QVariantList list;

    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return list;
    }

    QSqlQuery query(m_database);
    QString sql = "SELECT articleId, title, summary, author, date, readCount, content "
                  "FROM psychologicalLiterature ORDER BY date DESC";

    if (!query.exec(sql)) {
        qDebug() << "❌ 查询文章失败:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap article;
        article["articleId"] = query.value("articleId").toInt();
        article["title"]     = query.value("title").toString();
        article["summary"]   = query.value("summary").toString();
        article["author"]    = query.value("author").toString();
        article["date"]      = query.value("date").toString();
        article["readCount"] = query.value("readCount").toInt();
        article["content"]   = query.value("content").toString();
        list.append(article);
    }

    qDebug() << "获取文章列表，共" << list.count() << "篇";
    return list;
}

bool DatabaseHandler::addArticle(const QString& title, const QString& summary,
                                 const QString& author, const QString& content)
{
    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("INSERT INTO psychologicalLiterature (title, summary, author, date, readCount, content) "
                  "VALUES (?, ?, ?, date('now'), 0, ?)");
    query.addBindValue(title);
    query.addBindValue(summary);
    query.addBindValue(author);
    query.addBindValue(content);

    if (!query.exec()) {
        qDebug() << "❌ 添加文章失败:" << query.lastError().text();
        return false;
    }

    qDebug() << "✅ 文章添加成功:" << title;
    return true;
}

bool DatabaseHandler::updateArticle(int articleId, const QString& title,
                                    const QString& summary, const QString& content)
{
    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("UPDATE psychologicalLiterature SET title = ?, summary = ?, content = ? "
                  "WHERE articleId = ?");
    query.addBindValue(title);
    query.addBindValue(summary);
    query.addBindValue(content);
    query.addBindValue(articleId);

    if (!query.exec()) {
        qDebug() << "❌ 更新文章失败:" << query.lastError().text();
        return false;
    }

    if (query.numRowsAffected() == 0) {
        qDebug() << "❌ 文章不存在:" << articleId;
        return false;
    }

    qDebug() << "✅ 文章更新成功:" << articleId;
    return true;
}

bool DatabaseHandler::deleteArticle(int articleId)
{
    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM psychologicalLiterature WHERE articleId = ?");
    query.addBindValue(articleId);

    if (!query.exec()) {
        qDebug() << "❌ 删除文章失败:" << query.lastError().text();
        return false;
    }

    if (query.numRowsAffected() == 0) {
        qDebug() << "❌ 文章不存在:" << articleId;
        return false;
    }

    qDebug() << "✅ 文章删除成功:" << articleId;
    return true;
}

QVariantMap DatabaseHandler::getArticleById(int articleId)
{
    QVariantMap article;

    if (!m_database.isOpen()) {
        qDebug() << "❌ 数据库未打开";
        return article;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT articleId, title, summary, author, date, readCount, content "
                  "FROM psychologicalLiterature WHERE articleId = ?");
    query.addBindValue(articleId);

    if (!query.exec()) {
        qDebug() << "❌ 查询文章失败:" << query.lastError().text();
        return article;
    }

    if (query.next()) {
        article["articleId"] = query.value("articleId").toInt();
        article["title"]     = query.value("title").toString();
        article["summary"]   = query.value("summary").toString();
        article["author"]    = query.value("author").toString();
        article["date"]      = query.value("date").toString();
        article["readCount"] = query.value("readCount").toInt();
        article["content"]   = query.value("content").toString();
    }

    return article;
}


// ---------------------------------学生端操作-----------------------------------------
QVariantList DatabaseHandler::getTeachers()
{
    QVariantList teachersList;

    // 使用已有的数据库连接
    if (!m_database.isOpen() && !openDatabase()) {
        qDebug() << "数据库连接失败，无法获取教师列表";
        return teachersList;
    }

    QSqlQuery query(m_database);
    QString sql = "SELECT user_id, real_name, department, title, specialty "
                  "FROM teacher_profiles "
                  "WHERE real_name IS NOT NULL AND real_name != '' "
                  "ORDER BY "
                  "CASE "
                  "  WHEN title LIKE '%教授%' THEN 1 "
                  "  WHEN title LIKE '%博士%' THEN 2 "
                  "  WHEN title LIKE '%主任%' THEN 3 "
                  "  WHEN title LIKE '%医师%' THEN 4 "
                  "  WHEN title LIKE '%咨询师%' THEN 5 "
                  "  WHEN title LIKE '%辅导员%' THEN 6 "
                  "  ELSE 7 "
                  "END, "
                  "real_name";

    if (!query.exec(sql)) {
        qDebug() << "查询教师数据失败:" << query.lastError().text();
        return teachersList;
    }

    int count = 0;
    while (query.next()) {
        QVariantMap teacher;

        // 直接从数据库获取数据
        teacher["userId"] = query.value("user_id").toString();
        teacher["realName"] = query.value("real_name").toString();
        teacher["department"] = query.value("department").toString();
        teacher["title"] = query.value("title").toString();
        teacher["specialty"] = query.value("specialty").toString();

        teachersList.append(teacher);
        count++;
    }

    qDebug() << "成功获取" << count << "位心理咨询师";
    return teachersList;
}

bool DatabaseHandler::submitTeacherAppointment(const QString &teacherId,
                                               const QString &studentId,
                                               const QString &studentName,
                                               const QString &appointDate,
                                               const QString &appointSlot,
                                               const QString &phoneNumber,
                                               const QString &consultType,
                                               const QString &problem)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法提交预约";
        return false;
    }

    // 开始事务
    m_database.transaction();

    try {
        QSqlQuery query(m_database);

        // 修改SQL，直接使用TEXT类型的teacher_id和student_id
        query.prepare("INSERT INTO teacherMessage (teacher_id, studentName, appointDate, appoint_slot, "
                      "phoneNumber, consultType, problom, is_read, is_pass, student_id) "
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

        // 直接使用TEXT类型，不需要转换
        query.addBindValue(teacherId);                  // teacher_id (TEXT)
        query.addBindValue(studentName);               // studentName (TEXT)
        query.addBindValue(appointDate);               // appointDate (TEXT)
        query.addBindValue(appointSlot);               // appoint_slot (TEXT)
        query.addBindValue(phoneNumber);               // phoneNumber (TEXT)
        query.addBindValue(consultType);               // consultType (TEXT)
        query.addBindValue(problem.isEmpty() ? QVariant() : problem); // problom (TEXT)
        query.addBindValue(0);                         // is_read = 0 (未读)
        query.addBindValue(1);                         // is_pass = 1 (未通过，待审核)
        query.addBindValue(studentId);                 // student_id (TEXT)

        if (!query.exec()) {
            qDebug() << "插入教师预约消息失败:" << query.lastError().text();
            m_database.rollback();
            return false;
        }

        // 获取刚刚插入的记录ID
        int lastId = query.lastInsertId().toInt();

        // 提交事务
        m_database.commit();

        qDebug() << "教师预约消息提交成功，记录ID:" << lastId;
        qDebug() << "教师ID (TEXT):" << teacherId;
        qDebug() << "学生ID (TEXT):" << studentId;
        qDebug() << "学生姓名:" << studentName;
        qDebug() << "预约日期:" << appointDate;
        qDebug() << "预约时段:" << appointSlot;
        qDebug() << "联系电话:" << phoneNumber;
        qDebug() << "咨询类型:" << consultType;
        qDebug() << "问题描述:" << (problem.isEmpty() ? "未填写" : problem);

        return true;

    } catch (const std::exception &e) {
        m_database.rollback();
        qDebug() << "提交预约时发生异常:" << e.what();
        return false;
    }
}

QString DatabaseHandler::getCurrentUserName() const
{
    // 如果当前用户ID为空，返回空字符串
    if (m_currentUserId.isEmpty() || m_currentRole.isEmpty()) {
        return "";
    }

    // 如果之前已经获取过姓名，直接返回
    if (!m_currentUserName.isEmpty()) {
        return m_currentUserName;
    }

    // 根据角色从对应的表中获取真实姓名
    QString realName = "";
    if (m_currentRole == "student") {
        // 从学生表中获取
        QSqlQuery query(m_database);
        query.prepare("SELECT real_name FROM student_profiles WHERE user_id = ?");
        query.addBindValue(m_currentUserId);
        if (query.exec() && query.next()) {
            realName = query.value(0).toString();
        }
    } else if (m_currentRole == "teacher") {
        // 从教师表中获取
        QSqlQuery query(m_database);
        query.prepare("SELECT real_name FROM teacher_profiles WHERE user_id = ?");
        query.addBindValue(m_currentUserId);
        if (query.exec() && query.next()) {
            realName = query.value(0).toString();
        }
    }

    // 如果获取不到，使用用户ID作为默认
    if (realName.isEmpty()) {
        realName = m_currentUserId;
    }

    return realName;
}

QVariantList DatabaseHandler::getConsultationLogs(const QString &studentId)
{
    QVariantList logsList;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取咨询日志";
        return logsList;
    }

    QSqlQuery query(m_database);

    // 查询学生的咨询日志，关联教师姓名
    QString sql = "SELECT "
                  "cl.consultation_id, "
                  "cl.student_id, "
                  "cl.teacher_id, "
                  "cl.consultationDate, "
                  "cl.consultation_slot, "
                  "cl.counselor, "
                  "cl.type, "
                  "cl.is_completed, "
                  "cl.duration, "
                  "cl.summary, "            // 咨询总结
                  "cl.selfevaluation, "     // 自我评价（改为selfevaluation）
                  "cl.phoneNumber, "
                  "tp.real_name as teacher_name, "
                  "tp.title as teacher_title "
                  "FROM consultationLog cl "
                  "LEFT JOIN teacher_profiles tp ON cl.teacher_id = tp.user_id "
                  "WHERE cl.student_id = ? "
                  "ORDER BY cl.consultationDate DESC, cl.consultation_slot";

    query.prepare(sql);
    query.addBindValue(studentId);

    if (!query.exec()) {
        qDebug() << "查询咨询日志失败:" << query.lastError().text();
        return logsList;
    }

    int count = 0;
    while (query.next()) {
        QVariantMap log;

        log["consultationId"] = query.value("consultation_id").toInt();
        log["studentId"] = query.value("student_id").toString();
        log["teacherId"] = query.value("teacher_id").toString();
        log["consultationDate"] = query.value("consultationDate").toString();
        log["consultationSlot"] = query.value("consultation_slot").toString();
        log["counselor"] = query.value("counselor").toString();
        log["consultationType"] = query.value("type").toString();
        log["isCompleted"] = query.value("is_completed").toBool();
        log["duration"] = query.value("duration").toInt();
        log["summary"] = query.value("summary").toString();     // 咨询总结
        log["selfEvaluation"] = query.value("selfevaluation").toString();   // 自我评价（改为selfevaluation）
        log["phoneNumber"] = query.value("phoneNumber").toString();
        log["teacherName"] = query.value("teacher_name").toString();
        log["teacherTitle"] = query.value("teacher_title").toString();

        logsList.append(log);
        count++;
    }

    qDebug() << "成功获取" << count << "条咨询日志";
    return logsList;
}

QVariantList DatabaseHandler::getPsychologicalLiterature()
{
    QVariantList articlesList;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取心理健康文献";
        return articlesList;
    }

    QSqlQuery query(m_database);

    // 查询心理健康文献
    QString sql = "SELECT "
                  "articleId, "
                  "title, "
                  "summary, "
                  "author, "
                  "date, "
                  "readCount, "
                  "content "
                  "FROM psychologicalLiterature "
                  "ORDER BY date DESC, readCount DESC";

    if (!query.exec(sql)) {
        qDebug() << "查询心理健康文献失败:" << query.lastError().text();
        return articlesList;
    }

    // 预定义图标和颜色（因为没有存储在数据库中）
    QStringList icons = {"📚", "📋", "💭", "😔", "😴", "❤️", "🧠", "🌟", "🎯", "🌈"};
    QStringList colors = {"#2196f3", "#4caf50", "#ff9800", "#9c27b0", "#795548",
                          "#e91e63", "#009688", "#673ab7", "#ff5722", "#00bcd4"};

    int count = 0;
    while (query.next()) {
        QVariantMap article;

        int articleId = query.value("articleId").toInt();
        QString title = query.value("title").toString();
        QString summary = query.value("summary").toString();
        QString author = query.value("author").toString();
        QString date = query.value("date").toString();
        int readCount = query.value("readCount").toInt();
        QString content = query.value("content").toString();

        // 随机分配图标和颜色（因为数据库中没有存储）
        int randomIndex = count % icons.size();

        article["articleId"] = articleId;
        article["title"] = title;
        article["summary"] = summary;
        article["author"] = author;
        article["date"] = date;
        article["readCount"] = readCount;
        article["content"] = content;
        article["icon"] = icons.at(randomIndex);
        article["color"] = colors.at(randomIndex);

        articlesList.append(article);
        count++;

        qDebug() << "加载文献:" << title << "作者:" << author << "阅读量:" << readCount;
    }

    qDebug() << "成功获取" << count << "篇心理健康文献";
    return articlesList;
}

bool DatabaseHandler::incrementReadCount(int articleId)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法更新阅读量";
        return false;
    }

    QSqlQuery query(m_database);

    // 更新阅读量
    query.prepare("UPDATE psychologicalLiterature SET readCount = readCount + 1 WHERE articleId = ?");
    query.addBindValue(articleId);

    if (!query.exec()) {
        qDebug() << "更新阅读量失败:" << query.lastError().text();
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "文章" << articleId << "阅读量+1";
        return true;
    }

    return false;
}

// 在现有方法后面添加：

QVariantList DatabaseHandler::getStudentAppointmentMessages(const QString &studentId)
{
    QVariantList messagesList;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败";
        return messagesList;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT SM_id, teacherName, appointDate, appoint_slot, is_read, is_pass, teacher_id "
                  "FROM studentMessage WHERE student_id = ? ORDER BY SM_id DESC");
    query.addBindValue(studentId);

    if (!query.exec()) {
        qDebug() << "查询消息失败:" << query.lastError().text();
        return messagesList;
    }

    while (query.next()) {
        QVariantMap message;
        int messageId = query.value("SM_id").toInt();
        QString teacherName = query.value("teacherName").toString();
        QString appointDate = query.value("appointDate").toString();
        QString appointSlot = query.value("appoint_slot").toString();
        bool isRead = query.value("is_read").toInt() == 1;
        bool isPass = query.value("is_pass").toInt() == 1;
        QString teacherId = query.value("teacher_id").toString();

        // 根据 is_pass 判断预约状态
        QString icon = isPass ? "✅" : "❌";
        QString title = isPass ? "线下咨询预约成功" : "线下咨询预约失败";
        QString content = isPass ?
                              QString("您已成功预约%1的线下咨询").arg(teacherName) :
                              QString("您预约%1的线下咨询未通过").arg(teacherName);
        QString timeStr = appointDate + " " + appointSlot;

        message["messageId"] = messageId;
        message["teacherName"] = teacherName;
        message["appointDate"] = appointDate;
        message["appointSlot"] = appointSlot;
        message["isRead"] = isRead;
        message["isPass"] = isPass;
        message["icon"] = icon;
        message["title"] = title;
        message["content"] = content;
        message["time"] = timeStr;
        message["counselor"] = teacherName;
        message["appointmentTime"] = timeStr;
        message["read"] = isRead;
        message["teacherId"] = teacherId;

        messagesList.append(message);
    }

    qDebug() << "获取到" << messagesList.size() << "条学生消息";
    return messagesList;
}

// 标记消息为已读
bool DatabaseHandler::markMessageAsRead(int messageId)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("UPDATE studentMessage SET is_read = 1 WHERE SM_id = ?");
    query.addBindValue(messageId);
    return query.exec();
}

// 删除学生消息
bool DatabaseHandler::deleteStudentMessage(int messageId)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM studentMessage WHERE SM_id = ?");
    query.addBindValue(messageId);
    return query.exec();
}

// 获取学生个人信息
QVariantMap DatabaseHandler::getStudentProfile(const QString &studentId)
{
    QVariantMap profile;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取学生信息";
        return profile;
    }

    QSqlQuery query(m_database);
    // 修改SQL查询，不再查询username字段
    query.prepare("SELECT real_name, college, major, entry_year, gender "
                  "FROM student_profiles "
                  "WHERE user_id = ?");
    query.addBindValue(studentId);

    if (!query.exec()) {
        qDebug() << "查询学生信息失败:" << query.lastError().text();
        return profile;
    }

    if (query.next()) {
        profile["realName"] = query.value("real_name").toString();
        profile["college"] = query.value("college").toString();
        profile["major"] = query.value("major").toString();
        profile["entryYear"] = query.value("entry_year").toInt();
        profile["gender"] = query.value("gender").toString();

        // 计算年级
        int entryYear = query.value("entry_year").toInt();
        if (entryYear > 0) {
            profile["grade"] = QString("%1级").arg(entryYear);
        } else {
            profile["grade"] = "未知年级";
        }

        // 性别对应的头像
        QString gender = query.value("gender").toString();
        if (gender == "男") {
            profile["avatar"] = "👨‍🎓";
        } else if (gender == "女") {
            profile["avatar"] = "👩‍🎓";
        } else {
            profile["avatar"] = "👤";
        }

        qDebug() << "获取到学生信息:" << profile["realName"].toString();
    } else {
        qDebug() << "学生信息不存在，创建默认信息";
        // 如果学生信息不存在，创建默认记录
        QSqlQuery insertQuery(m_database);
        insertQuery.prepare("INSERT INTO student_profiles (user_id, real_name) "
                            "VALUES (?, '新用户')");
        insertQuery.addBindValue(studentId);
        if (insertQuery.exec()) {
            profile["realName"] = "新用户";
            profile["avatar"] = "👤";
            profile["college"] = "";
            profile["major"] = "";
            profile["grade"] = "";
        }
    }

    return profile;
}

// 更新学生个人信息
bool DatabaseHandler::updateStudentProfile(const QString &studentId,
                                           const QString &realName,
                                           const QString &college,
                                           const QString &major,
                                           int entryYear,
                                           const QString &gender)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法更新学生信息";
        return false;
    }

    QSqlQuery query(m_database);

    // 检查记录是否存在
    query.prepare("SELECT COUNT(*) FROM student_profiles WHERE user_id = ?");
    query.addBindValue(studentId);
    if (!query.exec() || !query.next()) {
        qDebug() << "检查学生记录失败";
        return false;
    }

    int count = query.value(0).toInt();

    if (count > 0) {
        // 更新现有记录
        query.prepare("UPDATE student_profiles SET "
                      "real_name = ?, college = ?, major = ?, entry_year = ?, gender = ? "
                      "WHERE user_id = ?");
        query.addBindValue(realName);
        query.addBindValue(college);
        query.addBindValue(major);
        query.addBindValue(entryYear);
        query.addBindValue(gender);
        query.addBindValue(studentId);
    } else {
        // 插入新记录
        query.prepare("INSERT INTO student_profiles (user_id, real_name, college, major, entry_year, gender) "
                      "VALUES (?, ?, ?, ?, ?, ?)");
        query.addBindValue(studentId);
        query.addBindValue(realName);
        query.addBindValue(college);
        query.addBindValue(major);
        query.addBindValue(entryYear);
        query.addBindValue(gender);
    }

    if (!query.exec()) {
        qDebug() << "更新学生信息失败:" << query.lastError().text();
        return false;
    }

    qDebug() << "学生信息更新成功";
    return true;
}

// 获取学生统计信息
QVariantMap DatabaseHandler::getStudentStatistics(const QString &studentId)
{
    QVariantMap stats;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取统计信息";
        return stats;
    }

    QSqlQuery query(m_database);

    // 咨询次数
    query.prepare("SELECT COUNT(*) FROM consultationLog WHERE student_id = ?");
    query.addBindValue(studentId);
    if (query.exec() && query.next()) {
        stats["consultationCount"] = query.value(0).toInt();
    }

    // 文献阅读次数 - 如果articleReadLog表不存在，注释掉这部分
    // query.prepare("SELECT COUNT(*) FROM articleReadLog WHERE user_id = ?");
    // query.addBindValue(studentId);
    // if (query.exec() && query.next()) {
    //     stats["literatureReadCount"] = query.value(0).toInt();
    // }

    // 咨询总时长
    query.prepare("SELECT SUM(duration) FROM consultationLog WHERE student_id = ?");
    query.addBindValue(studentId);
    if (query.exec() && query.next()) {
        int totalMinutes = query.value(0).toInt();
        stats["totalMinutes"] = totalMinutes;
    }

    // 心理测试次数 - 如果testRecords表不存在，注释掉这部分
    // query.prepare("SELECT COUNT(*) FROM testRecords WHERE student_id = ?");
    // query.addBindValue(studentId);
    // if (query.exec() && query.next()) {
    //     stats["testCount"] = query.value(0).toInt();
    // }

    // 设置默认值（如果没有数据）
    stats["consultationCount"] = stats.contains("consultationCount") ? stats["consultationCount"].toInt() : 0;
    stats["literatureReadCount"] = stats.contains("literatureReadCount") ? stats["literatureReadCount"].toInt() : 0;
    stats["totalMinutes"] = stats.contains("totalMinutes") ? stats["totalMinutes"].toInt() : 0;
    stats["testCount"] = stats.contains("testCount") ? stats["testCount"].toInt() : 0;

    qDebug() << "获取统计信息: 咨询" << stats["consultationCount"].toInt()
             << "次，文献" << stats["literatureReadCount"].toInt()
             << "篇，时长" << stats["totalMinutes"].toInt() << "分钟";

    return stats;
}

// 获取所有测试类型
QVariantList DatabaseHandler::getPsychologicalTestTypes()
{
    QVariantList testTypes;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取测试类型";
        return testTypes;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT DISTINCT type FROM PsychologicalTest");

    if (!query.exec()) {
        qDebug() << "查询测试类型失败:" << query.lastError().text();
        return testTypes;
    }

    while (query.next()) {
        QString type = query.value("type").toString();
        if (!type.isEmpty()) {
            testTypes.append(type);
        }
    }

    qDebug() << "获取到" << testTypes.size() << "种测试类型";
    return testTypes;
}

// 获取特定类型的测试题目
QVariantList DatabaseHandler::getPsychologicalTestQuestions(const QString &testType)
{
    QVariantList questionsList;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取测试题目";
        return questionsList;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT type, p1, p2, p3, p4, p5 FROM PsychologicalTest WHERE type = ?");
    query.addBindValue(testType);

    if (!query.exec()) {
        qDebug() << "查询测试题目失败:" << query.lastError().text();
        return questionsList;
    }

    if (query.next()) {
        // 解析题目，每个测试有5个题目
        QString testTypeName = query.value("type").toString();
        qDebug() << "找到测试类型：" << testTypeName;

        for (int i = 1; i <= 5; i++) {
            QVariantMap question;
            question["questionId"] = i;
            QString questionText = query.value("p" + QString::number(i)).toString();
            question["questionText"] = questionText;
            question["testType"] = testTypeName; // 传递测试类型到QML

            questionsList.append(question);
            qDebug() << "加载题目" << i << ":" << questionText;
        }
    } else {
        qDebug() << "未找到" << testType << "的测试题目";
    }

    qDebug() << "获取到" << questionsList.size() << "个" << testType << "题目";
    return questionsList;
}

// 保存测试结果
bool DatabaseHandler::saveTestResult(const QString &studentId,
                                     const QString &testName,
                                     const QString &testType,
                                     const QString &date,
                                     int score,
                                     const QString &result,
                                     const QString &status)
{
    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法保存测试结果";
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("INSERT INTO testRecords (student_id, testName, testType, date, score, result, status) "
                  "VALUES (?, ?, ?, ?, ?, ?, ?)");

    query.addBindValue(studentId);
    query.addBindValue(testName);
    query.addBindValue(testType);
    query.addBindValue(date);
    query.addBindValue(score);
    query.addBindValue(result);
    query.addBindValue(status);

    if (!query.exec()) {
        qDebug() << "保存测试结果失败:" << query.lastError().text();
        return false;
    }

    qDebug() << "测试结果保存成功: " << testName
             << ", 学生ID:" << studentId
             << ", 分数:" << score
             << ", 结果:" << result;
    return true;
}

// 获取测试历史记录
QVariantList DatabaseHandler::getTestHistory(const QString &studentId)
{
    QVariantList historyList;

    if (!openDatabase()) {
        qDebug() << "数据库连接失败，无法获取测试历史";
        return historyList;
    }

    QSqlQuery query(m_database);

    query.prepare("SELECT testName, testType, date, score, result, status "
                  "FROM testRecords "
                  "WHERE student_id = ? "
                  "ORDER BY date DESC");

    query.addBindValue(studentId);

    if (!query.exec()) {
        qDebug() << "查询测试历史失败:" << query.lastError().text();
        return historyList;
    }

    while (query.next()) {
        QVariantMap record;
        record["testName"] = query.value("testName").toString();
        record["testType"] = query.value("testType").toString();
        record["date"] = query.value("date").toString();
        record["score"] = query.value("score").toInt();
        record["result"] = query.value("result").toString();
        record["status"] = query.value("status").toString();

        historyList.append(record);
    }

    qDebug() << "获取到" << historyList.size() << "条测试历史记录";
    return historyList;
}
