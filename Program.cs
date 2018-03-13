using Demo.Migrations.Customisations;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;

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

            var migrateResult = Migrator.RunDbMigration(dbsToMigrate);
            if (migrateResult < 0)
            {
                return migrateResult;
            }

            return 0;
        }



        private static string MaskedConnectionString(string connectionString)
        {
            var userIdPos = connectionString.ToLower(CultureInfo.InvariantCulture).IndexOf("user=", StringComparison.InvariantCultureIgnoreCase);
            var viewableConnectionString =
                    (userIdPos > 0)
                        ? connectionString.Substring(0, userIdPos - 1)
                        : connectionString;
            return viewableConnectionString;
        }



    }

}
