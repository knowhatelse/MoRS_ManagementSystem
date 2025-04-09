using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IEmailService :
    IAddService<EmailResponse, CreateEmailRequest>
{

}
