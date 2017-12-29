#include "historyfilter.h"
#include <QAbstractItemModel>
#include <QDebug>

HistoryFilter::HistoryFilter(QObject *parent) :
    QSortFilterProxyModel(parent)
{

}

bool HistoryFilter::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    QModelIndex sourceIndex = sourceModel()->index(source_row, 0, source_parent);

    static const int dateRole = sourceModel()->roleNames().key("date");
    static const int titleRole = sourceModel()->roleNames().key("title");
    static const int urlRole = sourceModel()->roleNames().key("url");

    if (sourceIndex.isValid()) {
        int epoch = sourceIndex.data(dateRole).toInt();
        QString title = sourceIndex.data(titleRole).toString();
        QString url = sourceIndex.data(urlRole).toString();

        if ((m_endDate == -1) ||
            (epoch < m_endDate && epoch >= m_startDate)) {
            if (m_search.isEmpty() ||
                title.contains(m_search, Qt::CaseInsensitive) ||
                url.contains(m_search, Qt::CaseInsensitive)) {
                return true;
            }
        }
    }

    return false;
}

void HistoryFilter::setDateTimeRange(int startDate, int endDate)
{
    if ((m_startDate != startDate) || (m_endDate != endDate)) {
        m_startDate = startDate;
        m_endDate = endDate;
        invalidateFilter();
    }
}

int HistoryFilter::sourceModelIndex(int i)
{
    QModelIndex proxyIndex = index(i, 0, QModelIndex());
    QModelIndex sourceIndex = mapToSource(proxyIndex);
    qDebug() << sourceIndex.data(sourceModel()->roleNames().key("title")).toString();
    return sourceIndex.row();
}

void HistoryFilter::search(const QString &search)
{
    qDebug() << "search: " << search;
    if (search != m_search) {
        m_search = search;
        invalidateFilter();
    }
}

