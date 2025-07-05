using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MoRS.ManagementSystem.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class FixUserDeletionConstraint : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_DomainUsers_BookedByUserId",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_DomainUsers_BookedByUserId",
                table: "Appointments",
                column: "BookedByUserId",
                principalTable: "DomainUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_DomainUsers_BookedByUserId",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_DomainUsers_BookedByUserId",
                table: "Appointments",
                column: "BookedByUserId",
                principalTable: "DomainUsers",
                principalColumn: "Id");
        }
    }
}
