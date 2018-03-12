using DbUp;
using DbUp.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Reflection;

namespace Demo.Migrations
{
    [ExcludeFromCodeCoverage]
    static class Program
    {
        static int Main(string[] args)
        {
            Logger.LogMessage("Performing DBMigration");

            var dbsToMigrate = DatabaseMigrationLocator.FindDatabaseDirectoriestoMigrate();

            if (dbsToMigrate.Count == 0)
            {
                Logger.LogMessage("No databases found to process.");
                return 0;
            }

            dbsToMigrate.ForEach(d =>
            {
                Logger.LogMessage($"Database: [{d.DatabaseName}], ConnectionString:{MaskedConnectionString(d.ConnectionString)} ");
            });

            Logger.LogMessage(">> Performing DbMigration");

            var migrateResult = RunDbMigration(dbsToMigrate);
            if (migrateResult < 0)
            {
                return migrateResult;
            }

            //LogMessage(">> Performing POST DbMigration");
            //return RunPostScriptIfNotInDebugMode(connectionString);

            return 0;
        }

        private static int GetTimeoutValue()
        {
            var configTimeoutVal = ConfigurationManager.AppSettings["ExecutionTimoutInSeconds"];
            int timeoutSeconds;
            if (!int.TryParse(configTimeoutVal, out timeoutSeconds))
            {
                timeoutSeconds = 30;
            }

            if (timeoutSeconds <= 0)
            {
                timeoutSeconds = 30;
            }

            Logger.LogMessage($">> Note: Execution timeout is set to {timeoutSeconds} seconds.");
            return timeoutSeconds;
        }

        private static int RunDbMigration(List<DatabaseDetails> databasesToMigrate)
        {
            var timeout = TimeSpan.FromSeconds(GetTimeoutValue());

            foreach (var db in databasesToMigrate)
            {
                Logger.LogMessage($"Database: [{db.DatabaseName}], migrating...");
                var upgrader =
                    DeployChanges.To
                        .SqlDatabase(db.ConnectionString)
                        .WithScriptsFromFileSystem(db.DirectoryForMigrationScripts)
                        .WithExecutionTimeout(timeout)
                        .LogToConsole()
                        .Build();

                var result = upgrader.PerformUpgrade();
                if (!result.Successful)
                {
                    Logger.LogMessage(result.Error.Message, true);
#if DEBUG
                    Console.ReadLine();
#endif
                    return -1;
                }

                Logger.LogMessage($"Database: [{db.DatabaseName}], updating static assets (functions, views, stored procedures");
                upgrader =
                    DeployChanges.To
                        .SqlDatabase(db.ConnectionString)
                        .WithScriptsFromFileSystem(db.FunctionsDirectory)
                        .WithScriptsFromFileSystem(db.ViewsDirectory)
                        .WithScriptsFromFileSystem(db.StoredProceduresDirectory)
                        .WithExecutionTimeout(timeout)
                        .LogToConsole()
                        .Build();

            }

            Logger.LogMessage("Success!");
            return 0;
        }

        private static string MaskedConnectionString(string connectionString)
        {
            var userIdPos = connectionString.ToLower(CultureInfo.InvariantCulture).IndexOf("user id", StringComparison.InvariantCultureIgnoreCase);
            var viewableConnectionString =
                    (userIdPos > 0)
                        ? connectionString.Substring(0, userIdPos - 1)
                        : connectionString;
            return viewableConnectionString;
        }


        private static int RunPostScriptIfNotInDebugMode(string connectionString)
        {
#if DEBUG
            Logger.LogMessage("In DEBUG mode, not executing user creation script");
#else
            LogMessage("Not in DEBUG mode, about to execute POST creation script");
            var postCreator =
                DeployChanges.To
                    .SqlDatabase(connectionString)
                    .WithScriptsFromFileSystem("PostScripts")
                    .JournalTo(new NullJournal())
                    .LogToConsole()
                    .Build();

            var postResult = postCreator.PerformUpgrade();
            if (!postResult.Successful)
            {
                LogMessage(postResult.Error.Message, true);
                return -1;
            }

#endif

            return 0;
        }

    }

}
