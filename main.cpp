#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QStandardPaths>
#include <QSqlDatabase>
#include <QtQml>

#include "databasebackup.h"
#include "SqlTableModel/sqltablemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<DatabaseBackup>("PersonalTypes", 1, 0, "DatabaseBackup");
    qmlRegisterType<SqlTableModel2>("PersonalTypes", 1, 0, "SqlTableModel");

    QString specificPath("BeFit");
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));
    if (!dir.exists(specificPath)) {
        dir.mkdir(specificPath);
    }

    QSqlDatabase db;
    if (dir.cd(specificPath)) {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(dir.absolutePath() + "/mainDatabase.sqlite");
        if (db.open()) {
            qDebug() << "Database opened!";
        }
    }

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
