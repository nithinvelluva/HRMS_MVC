using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Script.Serialization;

namespace HrmsMvc.Models
{
    public class LoginModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Please enter username")]
        [Display(Name = "Username")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Please enter password")]
        [Display(Name = "Password")]
        public string Password { get; set; }

        public int UserType { get; set; }

        [Required(ErrorMessage = "Please enter your email to receive password reset link")]
        [RegularExpression(@"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage = "Enter a valid email id")]
        [Display(Name = "Please enter your email")]
        public string UserEmail { get; set; }

        [ScriptIgnore]
        [Required(ErrorMessage = "Please enter password again to confirm")]
        public string CnfrmPassword { get; set; }

        [ScriptIgnore]
        public string UserToken { get; set; }        
    }

    public class EmployeeModel
    {
        public int EmpID { get; set; }
        public string EmpName { get; set; }
        public string Gender { get; set; }
        public string UserName { get; set; }
        [ScriptIgnore]
        public string Password { get; set; }
        [ScriptIgnore]
        public string CnfrmPassword { get; set; }
        public string PhoneNumber { get; set; }
        public string EmailId { get; set; }
        public string UserRole { get; set; }
        public int DesigType { get; set; }
        public int Usertype { get; set; }
        public string Designation { get; set; }
        public string DateOfBirth { get; set; }
        public string UserPhotoPath { get; set; }

        public string ErrorString { get; set; }
        public bool NoMoreData { get; set; }
        public int RowCount { get; set; }
    }

    public class LeaveModel : EmployeeModel
    {
        public int _lvId { get; set; }
        public double _casualLeave { get; set; }
        public double _festiveLeave { get; set; }
        public double _sickLeave { get; set; }
        public string _fromdate { get; set; }
        public string _todate { get; set; }

        public string _leavedurationtype { get; set; }
        public int _leaveDurTypeInt { get; set; }
        public string _strLvType { get; set; }
        public int _leaveType { get; set; }
        public string _comments { get; set; }
        public bool _status { get; set; }
        public bool _rejected { get; set; }
        public bool _cancelled { get; set; }
        public string _leaveStatus { get; set; }

        public ArrayList RtrnArry { get; set; }
    }

    public class AttendanceModel : EmployeeModel
    {
        public string PunchinTime { get; set; }
        public string PunchoutTime { get; set; }
        public string Duration { get; set; }        
    }

    public class UserReportModel : EmployeeModel
    {
        public string Month { get; set; }
        public string Year { get; set; }
        public double TotalDays { get; set; }
        public double Holidays { get; set; }
        public double WorkingDays { get; set; }
        public double ActiveDays { get; set; }
        public double LeaveDays { get; set; }
        //public double WorkingHours { get; set; }
    }

    //public class SentQueryModel
    //{
    //    //public string QuerySubject { get; set; }
    //    //public string QueryBody { get; set; }
    //    //public string SenderEmail { get; set; }
    //    //public string Date { get; set; }
    //    //public bool IsRead { get; set; }
    //}

    public class DesignationModel
    {
        public int ID { get; set; }
        public string designation { get; set; }
    }

    public class EmployeeViewModel
    {
        [Display(Name = "Employee Details")]
        public List<EmployeeModel> EmployeeDetails { get; set; }

        [Display(Name = "Punch Details")]
        public List<EmployeeModel> PunchDetails { get; set; }

        [Display(Name = "Employee Id")]
        public string EmpId { get; set; }

        [Required(ErrorMessage = "Please enter First Name")]
        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Required(ErrorMessage = "Please Select gender")]
        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Required(ErrorMessage = "Please Select DateOfBirth")]
        [Display(Name = "Date Of Birth")]
        public string DateOfBirth { get; set; }

        [Required(ErrorMessage = "Please Select User Role")]
        [Display(Name = "User Role")]
        public System.Web.Mvc.SelectList UserRole { get; set; }

        [Required(ErrorMessage = "Please enter the Phone Number")]
        [Display(Name = "Phone Number")]
        public string PhoneNumber { get; set; }

        [Required(ErrorMessage = "Please enter the Email Id")]
        [Display(Name = "Email Id")]
        public string EmailId { get; set; }

        [Required(ErrorMessage = "Please enter the User Name")]
        [RegularExpression(@"^[^-\s][a-zA-Z0-9_\s-]+$")]
        [Display(Name = "User Name")]
        public string UserName { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm Password")]
        public string ConfirmPassword { get; set; }

        public EmployeeViewModel(List<EmployeeModel> empDetails, List<EmployeeModel> punchDetails)
        {
            EmployeeDetails = empDetails;
            PunchDetails = punchDetails;
        }
    }
}