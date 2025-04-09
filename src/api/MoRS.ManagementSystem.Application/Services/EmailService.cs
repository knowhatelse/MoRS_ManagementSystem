using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class EmailService(IMapper mapper, IEmailRepository repository) :
    BaseService<Email, EmailResponse, CreateEmailRequest, EmptyDto, NoQuery>(mapper, repository),
    IEmailService
{

}
