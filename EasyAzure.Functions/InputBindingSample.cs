using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace EasyAzure.Functions
{


    public class ToDoItem
    {
        public string Name { get; set; }
        public bool Completed { get; set; }

    }

    public static class InputBindingSample
    {


        //https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-azure-sql-output?tabs=in-process&pivots=programming-language-csharp

        // Visit https://aka.ms/sqlbindingsinput to learn how to use this input binding
    [FunctionName("InputBindingSample")]
         public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [Sql("SELECT * FROM [dbo].[table1]",
            CommandType = System.Data.CommandType.Text,
            ConnectionStringSetting = "ConnectionStrings:DefaultConnection")] IEnumerable<Object> result,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger with SQL Input Binding function processed a request.");

            return new OkObjectResult(result);
        }
    }

    public static class GetToDoItem
    {
        [FunctionName("GetToDoItem")]
        public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "gettodoitem")]
            HttpRequest req,
            [Sql("select [Id], [order], [title], [url], [completed] from dbo.ToDo where Id = @Id",
                CommandType = System.Data.CommandType.Text,
                Parameters = "@Id={Query.id}",
                ConnectionStringSetting = "SqlConnectionString")]
            IEnumerable<ToDoItem> toDoItem)
        {
            return new OkObjectResult(toDoItem.FirstOrDefault());
        }
    }

    public static class DeleteToDo
    {
        // delete all items or a specific item from querystring
        // returns remaining items
        // uses input binding with a stored procedure DeleteToDo to delete items and return remaining items
        [FunctionName("DeleteToDo")]
        public static IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "DeleteFunction")] HttpRequest req,
            ILogger log,
            [Sql("DeleteToDo", CommandType = System.Data.CommandType.StoredProcedure,
                Parameters = "@Id={Query.id}", ConnectionStringSetting = "SqlConnectionString")]
                IEnumerable<ToDoItem> toDoItems)
        {
            return new OkObjectResult(toDoItems);
        }
    }
}
