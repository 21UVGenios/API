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
        response.WriteString($"Proyecto de Seguridad 2025 {guid}");
        return response;
    }
}
