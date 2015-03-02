#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "hebdate.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("HebrewCalendar"));

    qmlRegisterType<HDate>(uri, 1, 0, "HDate");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}

