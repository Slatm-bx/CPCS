#include "teachermessagemodel.h"

#include <QDebug>

TeacherMessageModel::TeacherMessageModel(QObject *parent) : QAbstractListModel(parent)
{
    // 初始化模拟数据
    loadMockData();
}

int TeacherMessageModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_messages.size();
}

QVariant TeacherMessageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_messages.size()) return QVariant();

    const TeacherMessage &message = m_messages.at(index.row());

    switch (role) {
    case TMIdRole:
        return message.tmId;
    case TeacherIdRole:
        return message.teacherId;
    case StudentIdRole:
        return message.studentId;
    case StudentNameRole:
        return message.studentName;
    case AppointDateRole:
        return message.appointDate;
    case AppointSlotRole:
        return message.appointSlot;
    case IsReadRole:
        return message.isRead;
    case IsPassRole:
        return message.isPass;
    case PhoneNumberRole:
        return message.phoneNumber;
    case ConsultTypeRole:
        return message.consultType;
    case ProblemRole:
        return message.problem;
    case StatusRole: {
        if (message.isPass == 0)
            return "待处理";
        else if (message.isPass == 1)
            return "已通过";
        else
            return "已拒绝";
    }
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TeacherMessageModel::roleNames() const
{
    static QHash<int, QByteArray> roles = {{TMIdRole, "tmId"},
                                           {TeacherIdRole, "teacherId"},
                                           {StudentIdRole, "studentId"},
                                           {StudentNameRole, "studentName"},
                                           {AppointDateRole, "appointDate"},
                                           {AppointSlotRole, "appointSlot"},
                                           {IsReadRole, "isRead"},
                                           {IsPassRole, "isPass"},
                                           {PhoneNumberRole, "phoneNumber"},
                                           {ConsultTypeRole, "consultType"},
                                           {ProblemRole, "problem"},
                                           {StatusRole, "status"}};
    return roles;
}

void TeacherMessageModel::loadMockData()
{
    beginResetModel();

    m_messages.clear();

    //0待处理，1通过，2不通过
    // 添加模拟数据
    m_messages.append(
        {"1", "T001", "S001", "张三", "2023-12-22", "14:00-15:00", false, 0, "110110110", "焦虑", "不开心"});

    m_messages.append(
        {"2", "T002", "S002", "李四", "2023-12-25", "10:00-11:00", true, 1, "123456789", "抑郁", "没有食欲"});

    // 添加更多模拟数据
    m_messages.append(
        {"3", "T001", "S003", "王五", "2023-12-23", "09:00-10:00", false, 0, "13800138000", "学习压力", "失眠多梦"});

    m_messages.append(
        {"4", "T001", "S004", "赵六", "2023-12-24", "15:00-16:00", true, 2, "13900139000", "人际关系", "与同学矛盾"});

    endResetModel();
    emit countChanged();
}

void TeacherMessageModel::markAsRead(int index)
{
    if (index < 0 || index >= m_messages.size()) return;

    if (!m_messages[index].isRead) {
        m_messages[index].isRead = true;
        QModelIndex modelIndex = createIndex(index, 0);
        emit dataChanged(modelIndex, modelIndex, {IsReadRole});
    }
}

void TeacherMessageModel::setAppointmentStatus(int index, int status)
{
    if (index < 0 || index >= m_messages.size()) return;

    if (m_messages[index].isPass != status) {
        m_messages[index].isPass = status;
        QModelIndex modelIndex = createIndex(index, 0);
        emit dataChanged(modelIndex, modelIndex, {IsPassRole, StatusRole});
    }
}

QVariantMap TeacherMessageModel::getMessage(int index) const
{
    QVariantMap message;
    if (index >= 0 && index < m_messages.size()) {
        const TeacherMessage &msg = m_messages.at(index);
        message["tmId"] = msg.tmId;
        message["studentId"] = msg.studentId;
        message["studentName"] = msg.studentName;
        message["appointDate"] = msg.appointDate;
        message["appointSlot"] = msg.appointSlot;
        message["isRead"] = msg.isRead;
        message["isPass"] = msg.isPass;
        message["phoneNumber"] = msg.phoneNumber;
        message["consultType"] = msg.consultType;
        message["problem"] = msg.problem;
    }
    return message;
}

//
void TeacherMessageModel::loadFromVariantList(const QVariantList &data)
{
    beginResetModel();
    m_messages.clear();

    for (const QVariant &item : data) {
        QVariantMap map = item.toMap();

        TeacherMessage message;
        message.tmId = map.value("TM_id").toString();
        message.teacherId = map.value("teacher_id").toString();
        message.studentId = map.value("student_id", "").toString();
        message.studentName = map.value("studentName").toString();
        message.appointDate = map.value("appointDate").toString();
        message.appointSlot = map.value("appoint_slot").toString();

        // 处理 is_read 字段
        QVariant isReadVar = map.value("is_read");
        if (isReadVar.typeId() == QMetaType::Bool) {
            message.isRead = isReadVar.toBool();
        } else if (isReadVar.typeId() == QMetaType::Int) {
            message.isRead = isReadVar.toInt() != 0;
        } else {
            message.isRead = isReadVar.toString().toInt() != 0;
        }

        // 处理 is_pass 字段
        QVariant isPassVar = map.value("is_pass");
        if (isPassVar.typeId() == QMetaType::Int) {
            message.isPass = isPassVar.toInt();
        } else {
            message.isPass = isPassVar.toString().toInt();
        }

        message.phoneNumber = map.value("phoneNumber").toString();
        message.consultType = map.value("consultType").toString();
        message.problem = map.value("problem").toString();

        // 如果没有 studentId，使用 studentName 或其他字段
        if (message.studentId.isEmpty()) {
            message.studentId = "S" + QString("%1").arg(m_messages.size() + 1, 3, 10, QChar('0'));
        }

        m_messages.append(message);
    }

    endResetModel();
    emit countChanged();
    emit dataLoaded(true, QString("成功加载%1条数据").arg(m_messages.size()));
}
