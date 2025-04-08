using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class EmailService(IMapper mapper, IEmailRepository repository) :
    BaseService<Email, EmailResponse, CreateEmailRequest, EmptyDto>(mapper, repository),
    IEmailService
{

}
