#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "DatabaseHandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 创建数据库处理器
    DatabaseHandler dbHandler;
    QQmlApplicationEngine engine;
    // 将数据库处理器暴露给QML
    engine.rootContext()->setContextProperty("databaseHandler", &dbHandler);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("psychological", "Main");

    return app.exec();
}
