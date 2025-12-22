#include "usermodel.h"
#include "DatabaseHandler.h" // 假设你有单例或者全局访问点

// 构造函数初始化列表：将传入的 db 赋值给 m_db
UserModel::UserModel(DatabaseHandler *db, QObject *parent)
    : QAbstractListModel(parent), m_db(db)
{
    // 构造时自动加载一次数据
    if (m_db) {
        refresh();
    }

    // runTests();
}

UserModel::~UserModel() {
    qDeleteAll(m_users); // 记得手动清理指针内存！
    m_users.clear();
}

void UserModel::refresh() {
    if (!m_db) return;

    beginResetModel(); // 1. 告诉 View：我要大换血了

    // 清理旧数据
    qDeleteAll(m_users);
    m_users.clear();

    m_users = m_db->getAllUsers();

    endResetModel(); // 3. 告诉 View：更新完毕，请重绘
}

QVariant UserModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_users.size())
        return QVariant();

    User *user = m_users.at(index.row());

    switch (role) {
        case IdRole: return user->userId();
        case PasswordRole: return user->password();
        case RoleRole: return user->roleType();
        case StatusRole: return user->status();
        case NameRole: {
            // 多态处理：根据不同子类获取姓名
            if (auto s = qobject_cast<Student*>(user)) return s->realName();
            if (auto t = qobject_cast<Teacher*>(user)) return t->realName();
            return "系统管理员";
        }
        case DeptRole: {
            // 多态处理：返回 学院 或 部门
            if (auto s = qobject_cast<Student*>(user)) return s->college();
            if (auto t = qobject_cast<Teacher*>(user)) return t->department();
            return "-";
        }
    }
    return QVariant();
}

// 1. 告诉 QML 有多少行
int UserModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_users.size();
}

// 2. 告诉 QML 怎么称呼这些数据字段
QHash<int, QByteArray> UserModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[PasswordRole] = "password";
    roles[RoleRole] = "role";
    roles[DeptRole] = "dept";
    roles[StatusRole] = "status";
    return roles;
}


void UserModel::qmlAddUser(const QString& id, const QString& name, const QString& role, const QString& pwd) {
    // 1. 调用数据库执行插入
    // 注意：这里为了简化，默认“学院/部门”先留空或复用 name 字段，实际弹窗里应该加一个输入框
    if (m_db->addNewUser(id, name, pwd, role, "默认学院")) {
        // 2. 插入成功后，自动刷新列表显示最新数据
        refresh();
    } else {
        qDebug() << "添加失败";
    }
}

void UserModel::qmlUpdateUser(const QString& id, const QString& name, const QString& dept, const QString& statusText, const QString& newPwd) {
    int status = (statusText == "正常") ? 1 : 0;
    if (m_db->updateUserInfo(id, name, dept, status, newPwd)) {
        qDebug() << "更新成功，正在刷新列表";
        refresh(); // 刷新列表
    } else {
        qDebug() << "UserModel.qmlUpdateUser的updateUserInfo失败";
    }
}

void UserModel::qmlSearchUser(const QString& keyword) {
    beginResetModel();
    qDeleteAll(m_users); // 清理旧数据

    // 如果关键字为空，查所有；否则查过滤
    if (keyword.isEmpty()) {
        m_users = m_db->getAllUsers();
    } else {
        m_users = m_db->searchUsers(keyword);
    }

    endResetModel();
}

void UserModel::qmlDeleteUser(const QString& userId) {
    if (m_db->deleteUser(userId)) {
        qDebug() << "✅ 删除用户成功:" << userId;
        refresh(); // 刷新列表
    } else {
        qDebug() << "❌ 删除用户失败:" << userId;
    }
}

void UserModel::runTests() {
    qDebug() << "=== 开始测试 ===";
    
    qDebug() << "测试1: 添加新用户";
    qmlAddUser("TEST001", "测试学生", "学生", "pwd123");
    
    qDebug() << "测试2: 更新用户信息";
    qmlUpdateUser("TEST001", "测试学生更新", "新学院", "正常", "newpwd");
    
    // qDebug() << "测试3: 搜索用户";
    // qmlSearchUser("测试");
    
    qDebug() << "=== 测试完成 ===";
}