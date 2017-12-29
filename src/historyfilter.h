#ifndef HISTORYFILTER_H
#define HISTORYFILTER_H

#include <QObject>
#include <QSortFilterProxyModel>

class HistoryFilter : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    HistoryFilter(QObject *parent = 0);

    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const;

    Q_INVOKABLE void setDateTimeRange(int startDate, int endDate);
    Q_INVOKABLE int sourceModelIndex(int i);
    Q_INVOKABLE void search(const QString &name);

private:
    int m_startDate;
    int m_endDate;
    QString m_search;
    QObject *m_sourceItem;
};

#endif // HISTORYFILTER_H
