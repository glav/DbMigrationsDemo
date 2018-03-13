using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Demo.Migrations.Customisations
{
    class Config
    {
        public static int GetTimeoutValue()
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
    }
}
