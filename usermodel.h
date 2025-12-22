#ifndef USERMODEL_H
#define USERMODEL_H

#include <QAbstractListModel>
#include <QList>
#include "student.h"
#include "teacher.h"

class DatabaseHandler; // 前向声明，避免循环依赖

class UserModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum UserRoles {
        IdRole = Qt::UserRole + 1, // 从 UserRole+1 开始，避免与 Qt 内置角色冲突
        NameRole,
        PasswordRole,
        RoleRole,
        DeptRole,    // 对应 学院(学生) 或 部门(老师)
        StatusRole
    };
    explicit UserModel(DatabaseHandler *db, QObject *parent = nullptr);
    ~UserModel();

    // 重写QAbstractListModel的虚函数
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // --- 功能函数 ---
    // Q_INVOKABLE 让这个函数可以在 QML 中被直接调用 (比如点击刷新按钮)
    Q_INVOKABLE void refresh();

private:
    QList<User*> m_users;
    DatabaseHandler *m_db; // 持有数据库处理器指针
};

#endif // USERMODEL_H
