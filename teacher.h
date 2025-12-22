#ifndef TEACHER_H
#define TEACHER_H
#include "user.h"

class Teacher: public User
{
    Q_OBJECT
    Q_PROPERTY(QString realName READ realName WRITE setRealName NOTIFY realNameChanged)
    Q_PROPERTY(QString department READ department WRITE setDepartment NOTIFY departmentChanged)
    Q_PROPERTY(QString specialty READ specialty WRITE setSpecialty NOTIFY specialtyChanged)
public:
    // Teacher();
    explicit Teacher(QObject *parent = nullptr) : User(parent) {
        setRoleType("teacher");
    }

    QString realName() const { return m_realName; }
    QString department() const { return m_department; }
    QString specialty() const { return m_specialty; }

    void setRealName(const QString &name) { m_realName = name; }
    void setDepartment(const QString &dept) { m_department = dept; }
    void setSpecialty(const QString &spec) { m_specialty = spec; }

signals:
    void realNameChanged();
    void departmentChanged();
    void specialtyChanged();

private:
    QString m_realName;
    QString m_department;
    QString m_specialty;
};

#endif // TEACHER_H
