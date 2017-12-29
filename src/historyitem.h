#ifndef HISTORYITEM_H
#define HISTORYITEM_H

#include <QObject>

class HistoryItem : public QObject
{
    Q_OBJECT
public:
    explicit HistoryItem(int id,
                         const QString &url,
                         const QString &title,
                         const QString &favIcon,
                         int visitedCount,
                         int date,
                         QString hDate,
                         QObject *parent = 0);

    int id() const;
    QString url() const;
    QString title() const;
    QString favIcon() const;
    int visitedCount() const;
    int date() const;
    QString hDate() const;

    QString toString();

private:
    int m_id;
    QString m_url;
    QString m_title;
    QString m_favIcon;
    int m_visitedCount;
    int m_date;
    QString m_hDate;
};

#endif // HISTORYITEM_H
