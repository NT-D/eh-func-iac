using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Azure.EventHubs;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace EhFuncIac
{
    public static class FilterFunction
    {
        [FunctionName("FilterFunction")]
        public static async Task Run(
            [EventHubTrigger("%FilterEventHubName%", Connection = "FilterEventHubNamespaceConnectionString")] EventData[] events,
            [EventHub("%LabelEventHubName%", Connection = "LabelEventHubNamespaceConnectionString")] IAsyncCollector<Thermometer> labelHub,
            ILogger log
            )
        {
            var exceptions = new List<Exception>();
            var sendMessageTasks = new List<Task>();

            foreach (EventData eventData in events)
            {
                try
                {
                    string messageBody = Encoding.UTF8.GetString(eventData.Body.Array, eventData.Body.Offset, eventData.Body.Count);

                    // Replace these two lines with your processing logic.
                    log.LogInformation($"C# Event Hub trigger function processed a message: {messageBody}");

                    // TODO: Can separate to create option 
                    var options = new JsonSerializerOptions
                    {
                        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                    };
                    sendMessageTasks.Add(labelHub.AddAsync(JsonSerializer.Deserialize<Thermometer>(messageBody, options)));
                }
                catch (Exception e)
                {
                    // We need to keep processing the rest of the batch - capture this exception and continue.
                    // Also, consider capturing details of the message that failed processing so it can be processed again later.
                    exceptions.Add(e);
                }
            }

            await Task.WhenAll(sendMessageTasks);

            // Once processing of the batch is complete, if any messages in the batch failed processing throw an exception so that there is a record of the failure.
            if (exceptions.Count > 1)
                throw new AggregateException(exceptions);

            if (exceptions.Count == 1)
                throw exceptions.Single();
        }
    }
}
