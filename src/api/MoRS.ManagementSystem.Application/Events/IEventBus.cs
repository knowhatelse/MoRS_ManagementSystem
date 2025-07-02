namespace MoRS.ManagementSystem.Application.Events;

public interface IEventBus
{
    Task PublishAsync<T>(string queueName, T message);
}
