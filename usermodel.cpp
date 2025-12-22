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