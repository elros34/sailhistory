#include "historyitem.h"
#include <QDebug>

HistoryItem::HistoryItem(int id,
                         const QString &url,
                         const QString &title,
                         const QString &favIcon,
                         int visitedCount,
                         int date, QString hDate,
                         QObject *parent) :
    QObject(parent),
    m_id(id),
    m_url(url),
    m_title(title),
    m_favIcon(favIcon),
    m_visitedCount(visitedCount),
    m_date(date),
    m_hDate(hDate)
{

}

int HistoryItem::id() const
{
    return m_id;
}

QString HistoryItem::url() const
{
    return m_url;
}

QString HistoryItem::title() const
{
    return m_title;
}

QString HistoryItem::favIcon() const
{
    return m_favIcon;
}

int HistoryItem::visitedCount() const
{
    return m_visitedCount;
}

int HistoryItem::date() const
{
    return m_date;
}

QString HistoryItem::toString()
{
    QString props = "id: " + QString::number(m_id) + "\nurl: " + m_url + "\ntitle: " + m_title +
            "\nfavIcon: " + m_favIcon + "\nvisitedCount: " + QString::number(m_visitedCount)
            + "\ndate: " + QString::number(m_date) + "\nhDate: " + m_hDate + "\n";
    return props;
}

QString HistoryItem::hDate() const
{
    return m_hDate;
}
