#ifndef HISTORYMODEL_H
#define HISTORYMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QSqlQuery>

class HistoryItem;
class HistoryModel : public QAbstractListModel
{
    Q_OBJECT
public:
    HistoryModel();
    ~HistoryModel();

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QList<QVariant> rangeList() const;
    Q_INVOKABLE void refresh();
    Q_INVOKABLE void remove(int i, const QString &id);

    static bool lessThan(const QVariant &a, const QVariant &b);

public:
    enum myRoles {
        IdRole = Qt::UserRole + 1,
        UrlRole,
        TitleRole,
        FavIconRole,
        VisitedCountRole,
        DateRole,
        HDateRole
    };

    QList<QVariant> m_rangeList;

signals:
    void rangeListChanged();

private slots:
    void initHistoryModel();

private:
    QList<HistoryItem*> m_list;

private:
    QList<QVariant> createRangeList();
};

#endif // HISTORYMODEL_H
