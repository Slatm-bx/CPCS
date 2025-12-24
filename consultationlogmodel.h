#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>

class ConsultationLogModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(int completedCount READ completedCount NOTIFY completedCountChanged)

public:
    explicit ConsultationLogModel(QObject *parent = nullptr);

    enum ConsultationLogRoles {
        ConsultationIdRole = Qt::UserRole + 1,
        StudentIdRole,
        TeacherIdRole,
        ConsultationDateRole,
        ConsultationSlotRole,
        CounselorRole,
        TypeRole,
        IsCompletedRole,
        DurationRole,
        SummaryRole,
        SelfEvaluationRole,
        PhoneNumberRole
    };

    // QAbstractListModel接口
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 公共方法
    Q_INVOKABLE void loadMockData();                 //加载模拟数据
    Q_INVOKABLE QVariantMap getLog(int index) const; //得到一条日志

    // 统计数据
    Q_INVOKABLE int completedCount() const; //完成咨询的个数
    // 更新日志记录
    Q_INVOKABLE void updateLog(int index, const QVariantMap &logData);
    Q_INVOKABLE void loadFromDatabaseForTeacher(const QVariantList &logs); // 从数据库加载教师数据

signals:
    void countChanged();
    void completedCountChanged();
    void dataLoaded(bool success, const QString &message);
    void logUpdated(int index);

private:
    struct ConsultationLog
    {
        QString consultationId;
        QString studentId;
        QString teacherId;
        QString consultationDate;
        QString consultationSlot;
        QString counselor;
        QString type;
        bool isCompleted;
        int duration; // 分钟
        QString summary;
        QString selfEvaluation; // 注意：改名为 selfEvaluation
        QString phoneNumber;
    };

    QVector<ConsultationLog> m_logs;
};
