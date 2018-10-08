#include "mimehandler.h"
#include <QDesktopServices>
#include <QUrl>
#include <contentaction5/contentaction.h>

MimeHandler::MimeHandler(QObject *parent) : QObject(parent)
{
}

bool MimeHandler::openUrl(const QUrl &url, bool forcePlayer)
{
    QString param = url.toString();
    if (url.scheme() == "http" || url.scheme() == "https") {
        if (param.contains(".mp4") || param.contains(".avi") || forcePlayer) {
            QString desktop = ContentAction::defaultActionForMime("x-scheme-handler/rtsp").name() + ".desktop";
            ContentAction::Action action = ContentAction::Action::launcherAction(desktop, QStringList() << param);
            action.trigger();
            return true;
        }
    }

    return QDesktopServices::openUrl(url);
}
