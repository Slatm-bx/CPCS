#include "consultationlogmodel.h"
#include <QDebug>
#include <QTimer>

ConsultationLogModel::ConsultationLogModel(QObject *parent) : QAbstractListModel(parent) {}

int ConsultationLogModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_logs.size();
}

QVariant ConsultationLogModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_logs.size()) return QVariant();

    const ConsultationLog &log = m_logs.at(index.row());

    switch (role) {
    case ConsultationIdRole:
        return log.consultationId;
    case StudentIdRole:
        return log.studentId;
    case TeacherIdRole:
        return log.teacherId;
    // case StudentNameRole:
    //     return log.studentName;
    case ConsultationDateRole:
        return log.consultationDate;
    case ConsultationSlotRole:
        return log.consultationSlot;
    case CounselorRole:
        return log.counselor;
    case TypeRole:
        return log.type;
    case IsCompletedRole:
        return log.isCompleted;
    case DurationRole:
        return log.duration;
    case SummaryRole:
        return log.summary;
    case SelfEvaluationRole: // 注意：改名为 SelfEvaluationRole
        return log.selfEvaluation;
    case PhoneNumberRole:
        return log.phoneNumber;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ConsultationLogModel::roleNames() const
{
    static QHash<int, QByteArray> roles = {{ConsultationIdRole, "consultationId"},
                                           {StudentIdRole, "studentId"},
                                           {TeacherIdRole, "teacherId"},
                                           // {StudentNameRole, "studentName"},
                                           {ConsultationDateRole, "consultationDate"},
                                           {ConsultationSlotRole, "consultationSlot"},
                                           {CounselorRole, "counselor"},
                                           {TypeRole, "type"},
                                           {IsCompletedRole, "isCompleted"},
                                           {DurationRole, "duration"},
                                           {SummaryRole, "summary"},
                                           {SelfEvaluationRole, "selfEvaluation"}, // 注意：改名为 selfEvaluation
                                           {PhoneNumberRole, "phoneNumber"}};
    return roles;
}

void ConsultationLogModel::loadMockData()
{
    beginResetModel();

    m_logs.clear();

    // 模拟数据1：已完成的咨询
    ConsultationLog log1;
    log1.consultationId = "1";
    log1.studentId = "2021002";
    //log1.studentName = "李四";
    log1.teacherId = "T002";
    log1.consultationDate = "2023-12-25";
    log1.consultationSlot = "10:00-11:00";
    log1.counselor = "刘老师";
    log1.type = "抑郁";
    log1.isCompleted = true;
    log1.duration = 50;
    log1.summary = "讨论学业压力问题";
    log1.selfEvaluation = "情绪有所缓解"; // 注意：改名为 selfEvaluation
    log1.phoneNumber = "123456789";
    m_logs.append(log1);

    // 模拟数据2：未完成的咨询
    ConsultationLog log2;
    log2.consultationId = "2";
    log2.studentId = "2022001";
    //log2.studentName = "张三";
    log2.teacherId = "T002";
    log2.consultationDate = "2023-12-26";
    log2.consultationSlot = "10:00-11:00";
    log2.counselor = "刘老师";
    log2.type = "焦虑";
    log2.isCompleted = false;
    log2.duration = 0;
    log2.summary = "";
    log2.selfEvaluation = ""; // 注意：改名为 selfEvaluation
    log2.phoneNumber = "123456789";
    m_logs.append(log2);

    // 模拟数据3：未完成的咨询
    ConsultationLog log3;
    log3.consultationId = "3";
    log3.studentId = "2021002";
    //log3.studentName = "李四";
    log3.teacherId = "T002";
    log3.consultationDate = "2023-12-25";
    log3.consultationSlot = "10:00-11:00";
    log3.counselor = "刘老师";
    log3.type = "抑郁";
    log3.isCompleted = false;
    log3.duration = 0;
    log3.summary = "";
    log3.selfEvaluation = ""; // 注意：改名为 selfEvaluation
    log3.phoneNumber = "123456789";
    m_logs.append(log3);

    endResetModel();
    emit countChanged();
    emit completedCountChanged();
    emit dataLoaded(true, QString("成功加载%1条咨询记录").arg(m_logs.size()));
}

QVariantMap ConsultationLogModel::getLog(int index) const
{
    QVariantMap log;
    if (index >= 0 && index < m_logs.size()) {
        const ConsultationLog &item = m_logs.at(index);
        log["consultationId"] = item.consultationId;
        log["studentId"] = item.studentId;
        log["teacherId"] = item.teacherId;
        log["consultationDate"] = item.consultationDate;
        log["consultationSlot"] = item.consultationSlot;
        log["counselor"] = item.counselor;
        log["type"] = item.type;
        log["isCompleted"] = item.isCompleted;
        log["duration"] = item.duration;
        log["summary"] = item.summary;
        log["selfEvaluation"] = item.selfEvaluation; // 注意：改名为 selfEvaluation
        log["phoneNumber"] = item.phoneNumber;
    }
    return log;
}

int ConsultationLogModel::completedCount() const
{
    int count = 0;
    for (const auto &log : m_logs) {
        if (log.isCompleted) count++;
    }
    return count;
}

//
void ConsultationLogModel::updateLog(int index, const QVariantMap &logData)
{
    // 检查索引是否有效
    if (index < 0 || index >= m_logs.size()) {
        qWarning() << "Invalid index for updateLog:" << index;
        return;
    }

    // 开始更新模型数据
    beginResetModel(); // 使用 beginResetModel/endResetModel 来通知视图数据已更改

    // 更新指定索引的日志
    ConsultationLog &log = m_logs[index];

    // 更新各个字段（根据 QVariantMap 中的键值）
    if (logData.contains("duration")) { log.duration = logData["duration"].toInt(); }

    if (logData.contains("summary")) { log.summary = logData["summary"].toString(); }

    if (logData.contains("selfEvaluation")) { log.selfEvaluation = logData["selfEvaluation"].toString(); }

    if (logData.contains("isCompleted")) { log.isCompleted = logData["isCompleted"].toBool(); }

    // 可以继续添加其他需要更新的字段

    endResetModel(); // 结束模型重置

    // 发出数据变更信号
    emit dataChanged(createIndex(index, 0), createIndex(index, 0));

    // 发出自定义信号
    emit logUpdated(index);

    // 通知统计信息变更
    emit countChanged();
    emit completedCountChanged();

    qDebug() << "Log updated at index:" << index;
}
//获取数据库数据并加载
void ConsultationLogModel::loadFromDatabaseForTeacher(const QVariantList &logs)
{
    beginResetModel();
    m_logs.clear();

    for (const auto &logVar : logs) {
        QVariantMap logMap = logVar.toMap();
        ConsultationLog log;

        // 从 QVariantMap 中提取数据
        log.consultationId = logMap.value("consultationId").toString();
        log.studentId = logMap.value("studentId").toString();
        log.teacherId = logMap.value("teacherId").toString();

        log.consultationDate = logMap.value("consultationDate").toString();
        log.consultationSlot = logMap.value("consultationSlot").toString();
        log.counselor = logMap.value("counselor").toString();
        log.type = logMap.value("type").toString();
        log.isCompleted = logMap.value("isCompleted").toBool();
        log.duration = logMap.value("duration").toInt();
        log.summary = logMap.value("summary").toString();
        log.selfEvaluation = logMap.value("selfEvaluation").toString();
        log.phoneNumber = logMap.value("phoneNumber").toString();

        m_logs.append(log);
    }

    endResetModel();
    emit countChanged();
    emit completedCountChanged();

    if (m_logs.size() > 0) {
        emit dataLoaded(true, QString("成功加载%1条咨询记录").arg(m_logs.size()));
    } else {
        emit dataLoaded(false, "暂无咨询记录");
    }

    qDebug() << "从数据库为教师加载了" << m_logs.size() << "条咨询记录";
}
