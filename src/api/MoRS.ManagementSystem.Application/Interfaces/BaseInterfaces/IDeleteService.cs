namespace MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

public interface IDeleteService
{
    Task<bool> DeleteAsync(int id);
}
