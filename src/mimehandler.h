#ifndef MIMEHANDLER_H
#define MIMEHANDLER_H

#include <QObject>

class MimeHandler : public QObject
{
    Q_OBJECT
public:
    explicit MimeHandler(QObject *parent = nullptr);

    Q_INVOKABLE bool openUrl(const QUrl &url, bool forcePlayer = false);

signals:

public slots:
};

#endif // MIMEHANDLER_H
