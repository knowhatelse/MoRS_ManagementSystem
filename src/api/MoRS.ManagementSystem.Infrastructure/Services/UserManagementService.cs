using Microsoft.AspNetCore.Identity;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Identity;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using System.Threading.Tasks;
using System.Linq;

namespace MoRS.ManagementSystem.Infrastructure.Services
{
    public class UserManagementService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IUserRepository _userRepository;

        public UserManagementService(UserManager<ApplicationUser> userManager, IUserRepository userRepository)
        {
            _userManager = userManager;
            _userRepository = userRepository;
        }

        public async Task<User?> UpdateUserAsync(int userId, UpdateUserRequest request)
        {

            var appUser = await _userManager.FindByIdAsync(userId.ToString());
            if (appUser == null)
                return null;
            appUser.Name = request.Name;
            appUser.Surname = request.Surname;
            appUser.Email = request.Email;
            appUser.UserName = request.Email; 
            appUser.PhoneNumber = request.PhoneNumber;
            var identityResult = await _userManager.UpdateAsync(appUser);
            if (!identityResult.Succeeded)
                return null;

           
            var domainUser = await _userRepository.GetByIdAsync(userId);
            if (domainUser == null)
                return null;
            domainUser.Name = request.Name;
            domainUser.Surname = request.Surname;
            domainUser.Email = request.Email;
            domainUser.PhoneNumber = request.PhoneNumber;
            domainUser.IsRestricted = request.IsRestricted;
            domainUser.RoleId = request.RoleId;
            await _userRepository.UpdateAsync(domainUser);
            return domainUser;
        }

        public async Task<bool> DeleteUserAsync(int userId)
        {
            
            var appUser = await _userManager.FindByIdAsync(userId.ToString());
            if (appUser != null)
            {
                var identityResult = await _userManager.DeleteAsync(appUser);
                if (!identityResult.Succeeded)
                    return false;
            }
           
            var domainUser = await _userRepository.GetByIdAsync(userId);
            if (domainUser != null)
            {
                await _userRepository.DeleteAsync(domainUser);
            }
            return true;
        }

        public async Task<bool> UpdatePasswordAsync(int userId, string newPassword)
        {
            var appUser = await _userManager.FindByIdAsync(userId.ToString());
            if (appUser == null)
                return false;

           
            var hasPassword = await _userManager.HasPasswordAsync(appUser);
            IdentityResult result;
            if (hasPassword)
            {
                
                var removeResult = await _userManager.RemovePasswordAsync(appUser);
                if (!removeResult.Succeeded)
                    return false;
                result = await _userManager.AddPasswordAsync(appUser, newPassword);
            }
            else
            {
                result = await _userManager.AddPasswordAsync(appUser, newPassword);
            }
            return result.Succeeded;
        }
    }
}
