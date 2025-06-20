using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MoRS.ManagementSystem.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddDayOfOccurranceToAppointment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DayOfOccurrance",
                table: "Appointments",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DayOfOccurrance",
                table: "Appointments");
        }
    }
}
