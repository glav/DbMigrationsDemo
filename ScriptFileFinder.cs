using System;
using System.Diagnostics.CodeAnalysis;
using System.IO;

namespace Demo.Migrations
{
    [ExcludeFromCodeCoverage]
    public class ScriptFileFinder
    {
        public static string FindScriptFile(string fileName)
        {
            var possiblePaths = new[]
            {
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "..\\..\\SqlScripts", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "..\\SqlScripts", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "SqlScripts", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "Migrations", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "bin", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "..\\..\\Migrations", fileName),
                Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "..\\Migrations", fileName)
            };

            foreach (var potentialPath in possiblePaths)
            {
                System.Diagnostics.Trace.WriteLine(potentialPath);
                if (File.Exists(potentialPath))
                {
                    return potentialPath;
                }
            }

            return null;
        }
    }
}