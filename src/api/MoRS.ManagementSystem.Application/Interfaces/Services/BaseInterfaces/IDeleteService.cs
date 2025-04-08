namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IDeleteService
{
    Task<bool> DeleteAsync(int id);
}
