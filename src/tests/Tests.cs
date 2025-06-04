using Xunit;
using System;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.Functions.Worker;
using Moq;
using System.Net;
using System.IO;
using System.Text;

namespace UVGenios.Tests
{
    public class UVGFunctionTests
    {
        [Fact]
        public async Task Run_Returns200WithMessageAndGuid()
        {
            // Arrange
            var context = new Mock<FunctionContext>();
            var reqMock = new Mock<HttpRequestData>(context.Object);

            var responseStream = new MemoryStream();
            var responseMock = new Mock<HttpResponseData>(context.Object);

            responseMock.SetupProperty(r => r.StatusCode);
            responseMock.SetupGet(r => r.Body).Returns(responseStream);

            reqMock.Setup(r => r.CreateResponse(HttpStatusCode.OK)).Returns(responseMock.Object);

            var function = new UVGFunction();

            // Act
            var result = function.Run(reqMock.Object);

            // Read body content
            result.Body.Position = 0;
            using var reader = new StreamReader(result.Body);
            var content = await reader.ReadToEndAsync();

            // Assert
            Assert.Equal(HttpStatusCode.OK, result.StatusCode);
            Assert.StartsWith("Proyecto de Seguridad 2025 ", content);

            var guidStr = content.Replace("Proyecto de Seguridad 2025 ", "").Trim();
            Assert.True(Guid.TryParse(guidStr, out _), "The response should contain a valid GUID.");
        }
    }
}
