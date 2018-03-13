using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Demo.Migrations
{
    public class DatabaseMigrationLocator
    {
        public static List<DatabaseDetails> FindDatabaseDirectoriestoMigrate()
        {
            var dbList = new List<DatabaseDetails>();
            var path = AppDomain.CurrentDomain.BaseDirectory + "SqlScripts";

            Logger.LogMessage($"Searching for database directories in path [{path}] \n");

            if (!Directory.Exists(path))
            {
                return dbList;
            }

            var directoriesInPath = Directory.EnumerateDirectories(path).ToList();
            directoriesInPath.ForEach(d =>
            {
                var details = new DatabaseDetails(d);
                if (!string.IsNullOrWhiteSpace(details.ConnectionString))
                {
                    dbList.Add(details);
                }
            });
            return dbList;
        }
    }
}