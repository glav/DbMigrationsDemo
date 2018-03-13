using DbUp;
using DbUp.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Demo.Migrations.Customisations
{
    class Migrator
    {
        public static int RunDbMigration(List<DatabaseDetails> databasesToMigrate)
        {
            var timeout = TimeSpan.FromSeconds(Config.GetTimeoutValue());

            try
            {
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
                        return -1;
                    }

                    bool functionsDirExist = System.IO.Directory.Exists(db.FunctionsDirectory);
                    bool viewsDirExist = System.IO.Directory.Exists(db.ViewsDirectory);
                    bool sprocsDirExist = System.IO.Directory.Exists(db.StoredProceduresDirectory);
                    bool nothingToMigrate = !functionsDirExist && !viewsDirExist && !sprocsDirExist;

                    if (nothingToMigrate)
                    {
                        Logger.LogMessage("Nothing detected in static assets to update/migrate.");
                        return 0;
                    }

                    Logger.LogMessage($"Database: [{db.DatabaseName}], updating static assets (functions, views, stored procedures");
                    var staticUpgraderConfig =
                        DeployChanges.To
                            .SqlDatabase(db.ConnectionString);

                    if (functionsDirExist) { staticUpgraderConfig = staticUpgraderConfig.WithScriptsFromFileSystem(db.FunctionsDirectory); }
                    if (viewsDirExist) { staticUpgraderConfig = staticUpgraderConfig.WithScriptsFromFileSystem(db.ViewsDirectory); }
                    if (sprocsDirExist) { staticUpgraderConfig = staticUpgraderConfig.WithScriptsFromFileSystem(db.StoredProceduresDirectory); }

                    var staticUpgrader = staticUpgraderConfig.WithExecutionTimeout(timeout)
                            .JournalTo(new NullJournal())
                            .LogToConsole()
                            .Build();


                    var resultStaticFiles = staticUpgrader.PerformUpgrade();
                    if (!resultStaticFiles.Successful)
                    {
                        Logger.LogMessage(resultStaticFiles.Error.Message, true);
                        return -1;
                    }

                    Logger.LogMessage(">> Performing POST DbMigration");
                    return RunPostScriptIfNotInDebugMode(db);



                }

                Logger.LogMessage("Success!");
            }
            catch (Exception ex)
            {
                Logger.LogMessage($"Error! {ex.Message}");
                return -1;
            }
            return 0;

        }

        private static int RunPostScriptIfNotInDebugMode(DatabaseDetails dbDetails)
        {
#if DEBUG
            Logger.LogMessage("In DEBUG mode, not executing POST creation script");
#else
            Logger.LogMessage("Not in DEBUG mode, about to execute POST creation script");
            var postCreator =
                DeployChanges.To
                    .SqlDatabase(dbDetails.ConnectionString)
                    .WithScriptsFromFileSystem(dbDetails.PostScriptsDirectory)
                    .JournalTo(new NullJournal())
                    .LogToConsole()
                    .Build();

            var postResult = postCreator.PerformUpgrade();
            if (!postResult.Successful)
            {
                Logger.LogMessage(postResult.Error.Message, true);
                return -1;
            }

#endif

            return 0;
        }

    }
}
