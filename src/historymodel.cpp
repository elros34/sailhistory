#include "historymodel.h"
#include "historyitem.h"
#include <QDebug>
#include <QSqlRecord>
#include <QElapsedTimer>
#include <QDateTime>
#include <QTimer>

HistoryModel::HistoryModel()
{
    QTimer::singleShot(0, this, SLOT(initHistoryModel()));
}

HistoryModel::~HistoryModel()
{
    qDeleteAll(m_list);
    m_list.clear();
}

void HistoryModel::initHistoryModel()
{
    QElapsedTimer t;
    t.start();
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("/home/nemo/.local/share/org.sailfishos/sailfish-browser/sailfish-browser.sqlite");
    db.open();

    QSqlQuery query;
    query.setForwardOnly(true);
    query.exec("SELECT * FROM browser_history ORDER BY date DESC");


    QList<QVariant> rangeList = createRangeList();

    beginResetModel();
    qDeleteAll(m_list);
    m_list.clear();

    while(query.next()) {
        HistoryItem *historyItem;
        int epoch = query.value(5).toInt();
        QDateTime dateTime = QDateTime::fromTime_t(epoch);

        if (!query.value(3).isNull())
            qDebug() << "wow, report it:" << query.value(3);

        historyItem = new HistoryItem(query.value(0).toInt(),
                                      query.value(1).toString(),
                                      query.value(2).toString(),
                                      query.value(3).toString(),
                                      query.value(4).toInt(),
                                      epoch,
                                      dateTime.toString("hh:mm:ss, dd/MM/yyyy"),
                                      this);
        //qDebug().noquote() << historyItem->toString();
        m_list.append(historyItem);


        for (int i = 0; i < rangeList.length(); ++i) {
            QVariantMap map = rangeList[i].toMap();
            int end = map["end"].toInt();
            int start = map["start"].toInt();

            if (epoch < end && epoch >= start) {
                m_rangeList.append(map);
                rangeList.removeAt(i);
                --i;
            }
        }
    }
    endResetModel();
    qSort(m_rangeList.begin(), m_rangeList.end(), lessThan);

    emit rangeListChanged();

    qDebug() << "size: " << m_list.size();
    qDebug() << "elapsed: " << t.elapsed();
}

QList<QVariant> HistoryModel::createRangeList()
{
    QVariantMap map;
    m_rangeList.clear();

    QList<QVariant> rangeList;

    QDateTime dtbeginCurrentDay = QDateTime::currentDateTime();
    dtbeginCurrentDay.setTime(QTime()); //midnight
    map["name"] = "Today";
    map["start"] = dtbeginCurrentDay.toTime_t();
    map["end"] = dtbeginCurrentDay.addDays(2).toTime_t();
    map["index"] = 0;
    rangeList.append(map);

    map.clear();
    map["name"] = "Yesterday";
    map["start"] = dtbeginCurrentDay.addDays(-1).toTime_t();
    map["end"] = dtbeginCurrentDay.toTime_t();
    map["index"] = 1;
    rangeList.append(map);

    map.clear();
    map["name"] = "Last 7 days";
    map["start"] = dtbeginCurrentDay.addDays(-7).toTime_t();
    map["end"] = dtbeginCurrentDay.addDays(2).toTime_t();
    map["index"] = 2;
    rangeList.append(map);

    map.clear();
    map["name"] = "This month";
    QDate date = dtbeginCurrentDay.date();
    QDateTime dtbeginCurrentMonth = dtbeginCurrentDay.addDays(-date.day());

    map["start"] = dtbeginCurrentMonth.toTime_t();
    map["end"] = dtbeginCurrentDay.addDays(2).toTime_t();
    map["index"] = 3;
    rangeList.append(map);

    int i = 0;


    QLocale locale = QLocale(QLocale::English, QLocale::UnitedStates);
    while (++i <= 5) {
        map.clear();
        map["name"] = locale.toString(dtbeginCurrentMonth.addMonths(-i + 1), "MMMM");
        map["start"] = dtbeginCurrentMonth.addMonths(-i).toTime_t();
        map["end"] = dtbeginCurrentMonth.addMonths(-i + 1).toTime_t();
        map["index"] = 3 + i;
        rangeList.append(map);
    }

    map.clear();
    map["name"] = "Older than 6 months";
    map["start"] = 0;
    map["end"] = dtbeginCurrentMonth.addMonths(-5).toTime_t();
    map["index"] = 9;
    rangeList.append(map);

    map.clear();
    map["name"] = "Whole history";
    map["start"] = -1;
    map["end"] = -1;
    map["index"] = 10;
    m_rangeList.append(map);

    //qDebug() << "rangeList: " << rangeList;
    return rangeList;
}

QVariant HistoryModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (!index.isValid() || row > m_list.length()) {
        return QVariant();
    }

    if (role == IdRole) {
        return m_list.at(row)->id();
    } else if (role == UrlRole) {
        return m_list.at(row)->url();
    } else if (role == TitleRole) {
        return m_list.at(row)->title();
    } else if (role == FavIconRole) {
        return m_list.at(row)->favIcon();
    } else if (role == VisitedCountRole) {
        return m_list.at(row)->visitedCount();
    } else if (role == DateRole) {
        return m_list.at(row)->date();
    } else if (role == HDateRole) {
        return m_list.at(row)->hDate();
    } else {
        return QVariant();
    }
}

int HistoryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_list.length();
}

QHash<int, QByteArray> HistoryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[UrlRole] = "url";
    roles[TitleRole] = "title";
    roles[FavIconRole] = "favorite_icon"; // NULL
    roles[VisitedCountRole] = "visited_count";
    roles[DateRole] = "date";
    roles[HDateRole] = "hDate";
    return roles;
}

QList<QVariant> HistoryModel::rangeList() const
{
    return m_rangeList;
}

void HistoryModel::refresh()
{
    initHistoryModel();
}

void HistoryModel::remove(int i, const QString &id)
{
    if (id.isEmpty())
        return;

    qDebug() << "removeById: " << id;

    beginRemoveRows(QModelIndex(), i, i);
    m_list.takeAt(i)->deleteLater();
    endRemoveRows();

    QSqlQuery query;
    query.setForwardOnly(true);
    query.exec("DELETE FROM browser_history WHERE id = " + id);
}

bool HistoryModel::lessThan(const QVariant &a, const QVariant &b)
{
    return a.toMap()["index"].toInt() < b.toMap()["index"].toInt();
}
