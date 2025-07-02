using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using RabbitMQ.Client;

namespace MoRS.ManagementSystem.Application.Events
{
    public class RabbitMqEventBus : IEventBus
    {
        private readonly ConnectionFactory _factory;

        public RabbitMqEventBus(string hostname = "localhost")
        {
            _factory = new ConnectionFactory { HostName = hostname };
        }

        public async Task PublishAsync<T>(string queueName, T message)
        {
            using var connection = await _factory.CreateConnectionAsync();
            using var channel = await connection.CreateChannelAsync();

            await channel.QueueDeclareAsync(
                queue: queueName,
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null
            );

            var json = JsonSerializer.Serialize(message);
            var body = Encoding.UTF8.GetBytes(json);

            await channel.BasicPublishAsync(
                exchange: "",
                routingKey: queueName,
                body: body
            );
        }
    }
}
