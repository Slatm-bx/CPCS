#ifndef STUDENT_H
#define STUDENT_H
#include "user.h"

class Student : public User {
    Q_OBJECT
    Q_PROPERTY(QString realName READ realName WRITE setRealName NOTIFY realNameChanged)
    Q_PROPERTY(QString college READ college WRITE setCollege NOTIFY collegeChanged)
    Q_PROPERTY(QString gender READ gender WRITE setGender NOTIFY genderChanged)
    Q_PROPERTY(QString entryYear READ entryYear WRITE setEntryYear NOTIFY entryYearChanged)

public:
    explicit Student(QObject *parent = nullptr) : User(parent) {
        setRoleType("student"); // 构造时自动设置角色类型
    }

    QString realName() const { return m_realName; }
    QString college() const { return m_college; }
    QString gender() const { return m_gender;}
    QString entryYear() const { return m_entry_year;}

    void setRealName(const QString &name) { if (m_realName != name) { m_realName = name; emit realNameChanged(); } }
    void setCollege(const QString &c) { if (m_college != c) { m_college = c; emit collegeChanged(); } }
    void setGender(const QString &g) { if (m_gender != g) { m_gender = g; emit genderChanged(); } }
    void setEntryYear(const QString &year) { if (m_entry_year != year) { m_entry_year = year; emit entryYearChanged(); } }

signals:
    void realNameChanged();
    void collegeChanged();
    void genderChanged();
    void entryYearChanged();

private:
    QString m_realName;
    QString m_college;
    QString m_gender;
    QString m_entry_year;

};

#endif // STUDENT_H

