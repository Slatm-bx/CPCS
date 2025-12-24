#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

class TeacherMessageModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    explicit TeacherMessageModel(QObject *parent = nullptr);
    enum TeacherMessageRoles {
        TMIdRole = Qt::UserRole + 1,
        TeacherIdRole,
        StudentIdRole,
        StudentNameRole,
        AppointDateRole,
        AppointSlotRole,
        IsReadRole,
        IsPassRole,
        PhoneNumberRole,
        ConsultTypeRole,
        ProblemRole,
        StatusRole // 用于显示状态文本
    };

    // QAbstractListModel接口
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 模拟数据方法
    Q_INVOKABLE void loadMockData();
    // 获取单条数据
    Q_INVOKABLE QVariantMap getMessage(int index) const;

    //数据加载方法
    Q_INVOKABLE void loadFromVariantList(const QVariantList &data); // 从QVariantList加载
    // 数据操作方法
    Q_INVOKABLE void markAsRead(int index);
    Q_INVOKABLE void setAppointmentStatus(int index, int status); // 0:待处理, 1:通过, 2:拒绝

signals:
    void countChanged();                                   // 添加这个信号声明
    void dataLoaded(bool success, const QString &message); // 数据加载完成信号

private:
    struct TeacherMessage
    {
        QString tmId;
        QString teacherId;
        QString studentId;
        QString studentName;
        QString appointDate;
        QString appointSlot;
        bool isRead;
        int isPass; // 0:待处理, 1:通过, 2:拒绝
        QString phoneNumber;
        QString consultType;
        QString problem;
    };

    QVector<TeacherMessage> m_messages;
};
