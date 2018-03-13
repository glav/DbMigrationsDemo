using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Demo.Migrations
{
    public class DatabaseDetails
    {
        private const string StaticAssetsDirectoryName = "StaticAssets";
        public DatabaseDetails(string databaseDirectory)
        {
            DatabaseRootDirectory = databaseDirectory;
            SetupDirectoriesAndConnectionString();
        }

        private void SetupDirectoriesAndConnectionString()
        {
            DatabaseName = Path.GetFileName(DatabaseRootDirectory);
            var configEntry = ConfigurationManager.ConnectionStrings[DatabaseName];
            if (configEntry == null)
            {
                return;
            }
            ConnectionString = configEntry.ConnectionString;
            DirectoryForMigrationScripts = DatabaseRootDirectory + "\\Migrations";
            FunctionsDirectory = DatabaseRootDirectory + $"\\{StaticAssetsDirectoryName}\\Functions";
            ViewsDirectory = DatabaseRootDirectory + $"\\{StaticAssetsDirectoryName}\\Views";
            StoredProceduresDirectory = DatabaseRootDirectory + $"\\{StaticAssetsDirectoryName}\\StoredProcedures";
            PostScriptsDirectory = DatabaseRootDirectory + $"\\PostScripts";
        }

        public string DatabaseName { get; private set; }

        /// <summary>
        /// Root directory for the database
        /// </summary>
        public string DatabaseRootDirectory { get; private set; }

        /// <summary>
        /// Directory where the numbered migrations scripts are located
        /// </summary>
        public string DirectoryForMigrationScripts { get; private set; }

        /// <summary>
        /// The connection string for this database
        /// </summary>
        public string ConnectionString { get; private set; }

        /// <summary>
        /// Directory where the database functions are stored
        /// </summary>
        public string FunctionsDirectory { get; private set; }

        /// <summary>
        /// Directory where the database Views are stored
        /// </summary>
        public string ViewsDirectory { get; private set; }
        /// <summary>
        /// Directory where the database stored procedures are stored
        /// </summary>
        public string StoredProceduresDirectory { get; private set; }

        /// <summary>
        /// Directory where the scripts to run each time after the migrations are performed are stored
        /// </summary>
        public string PostScriptsDirectory { get; private set; }

    }
}
