using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using System.Net;

public class UVGFunction
{
    [Function("GetProjectGuid")]
    public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        var response = req.CreateResponse(HttpStatusCode.OK);
        var guid = Guid.NewGuid();
        var content = $"Proyecto de Seguridad 2025 {guid}";
    
        using var writer = new StreamWriter(response.Body);
        writer.Write(content);
        writer.Flush();
    
        return response;
    }
}
