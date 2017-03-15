using HrmsMvc.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class AdminController : Controller
    {
        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string ManageEmployee(string empName, string userName, string Gender, string Role, string Desig, string DateOfBirth, string EmailId, string Phone, string UserPhotoPath)
        {
            string errStr = string.Empty;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            if (string.IsNullOrEmpty(empName))
            {
                errStr = errStr + "1:";
            }
            if (string.IsNullOrEmpty(Gender))
            {
                errStr = errStr + "2:";
            }
            if (string.IsNullOrEmpty(Role) || (!string.IsNullOrEmpty(Role) && Convert.ToInt32(Role) <= 0))
            {
                errStr = errStr + "3:";
            }
            if (string.IsNullOrEmpty(Desig) || (!string.IsNullOrEmpty(Desig) && Convert.ToInt32(Desig) <= 0))
            {
                errStr = errStr + "D:";
            }
            if (string.IsNullOrEmpty(DateOfBirth))
            {
                errStr = errStr + "4:";
            }
            if (string.IsNullOrEmpty(userName))
            {
                errStr = errStr + "5:";
            }

            if (!string.IsNullOrEmpty(DateOfBirth))
            {
                TimeSpan ts = new TimeSpan();
                DateTime dob = new DateTime();
                if (DateTime.TryParse(DateOfBirth, out dob))
                {
                    ts = DateTime.Now - dob;
                    if (ts.TotalDays < 6570)
                    {
                        errStr = errStr + "9:";
                    }
                }
                else
                {
                    errStr = errStr + "IDOB:";
                }
            }

            if (string.IsNullOrEmpty(EmailId))
            {
                errStr = errStr + "EN:";
            }
            else if (!Helpers.Helper.RegexEmail.IsMatch(EmailId))
            {
                errStr = errStr + "ENV:";
            }

            if (string.IsNullOrEmpty(Phone))
            {
                errStr = errStr + "PN:";
            }
            if (!string.IsNullOrEmpty(Phone) && !Helpers.Helper.mobRgx.IsMatch(Phone))
            {
                errStr = errStr + "PNV:";
            }
            if (string.IsNullOrEmpty(errStr))
            {
                EmployeeModel em = new EmployeeModel();
                em.EmpName = empName;
                em.UserName = userName;
                em.Password = Helpers.Helper.HashPassword("hrms123");
                em.Usertype = Convert.ToInt32(Role);
                em.DesigType = Convert.ToInt32(Desig);
                em.Gender = Gender;
                em.DateOfBirth = DateOfBirth;
                em.PhoneNumber = Phone;
                em.EmailId = EmailId;
                em.UserPhotoPath = !string.IsNullOrEmpty(UserPhotoPath) ? UserPhotoPath : "";

                string rtrn = Db.AddEmployee(em);
                return serializer.Serialize(rtrn);
            }

            return serializer.Serialize(errStr);
        }

        // GET: Attendance
        [RequireHttps]
        public ActionResult Attendance()
        {
            //DataTable dt = Db.GetEmpPunchDetails();
            //EmployeeModel em = null;
            List<EmployeeModel> PunchDetails = new List<EmployeeModel>();
            //if (dt != null && dt.Rows.Count > 0)
            //{
            //    foreach (DataRow row in dt.Rows)
            //    {
            //        em = new EmployeeModel();
            //        em.EmpID = Convert.ToInt32(row["EmpId"].ToString());
            //        em.PunchinTime = row["PunchinTime"].ToString();
            //        em.PunchoutTime = row["PunchoutTime"].ToString();
            //        em.Duration = row["Duration"].ToString();

            //        PunchDetails.Add(em);
            //    }
            //}


            return View(new EmployeeViewModel(null, PunchDetails));
        }

        // GET: LeaveInfo
        [RequireHttps]
        public ActionResult LeaveInfo()
        {
            return View();
        }

        // GET: AdminDashboard
        [RequireHttps]
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult AdminDashboard()
        {
            int EmpID = (Session["UserId"] != null) ? Convert.ToInt32(Session["UserId"]) : 0;
            int UserType = (Session["Usertype"] != null) ? Convert.ToInt32(Session["Usertype"]) : 0;

            if (EmpID > 0 && UserType > 0)
            {
                ViewBag.EmpId = EmpID;
                ViewBag.UserType = UserType;

                List<DesignationModel> desigDetails = new List<DesignationModel>();

                DataTable dt = Db.getEmployeeDesignationList();

                foreach (DataRow dr in dt.Rows)
                {
                    desigDetails.Add(new DesignationModel
                    {
                        ID = int.Parse(dr["ID"].ToString()),
                        designation = dr["Designation"].ToString()
                    });
                }
                ViewBag.RoleList = new SelectList(Db.GetRoleSelectList(), "Value", "Text", "");
                ViewBag.desigList = new SelectList(desigDetails.Select(u => new SelectListItem
                {
                    Value = Convert.ToString(u.ID),
                    Text = u.designation
                }), "Value", "Text", "");

                return RedirectToAction("AdminDashboard","Admin");
            }
            else
            {
                return RedirectToAction("Login", "Login");
            }
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string RemoveEmployee(string EmpId)
        {
            JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

            if (!string.IsNullOrEmpty(EmpId))
            {
                int EmpID = Convert.ToInt32(EmpId);
                bool flag = Db.RemoveEmployee(EmpID);

                if (flag)
                {
                    return (serializer.Serialize("SUCCESS"));
                }
                else
                {
                    return (serializer.Serialize("ERROR"));
                }
            }

            return null;
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string GetEmployeeData(int BlockNumber = 1)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<EmployeeModel> empDetails = new List<EmployeeModel>();
            int BlockSize = 8;
            string JSONString = string.Empty;

            empDetails = Db.GetEmployeeDetails(BlockSize, BlockNumber);
            JSONString = serializer.Serialize(empDetails);
            return JSONString;
        }
    }
}