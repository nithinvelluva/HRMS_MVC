using HrmsMvc.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class UserController : Controller
    {
        #region UserDetails

        // GET: UserDetails
        [RequireHttps]
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult UserDetails()
        {
            int EmpID = (Session["UserId"] != null) ? Convert.ToInt32(Session["UserId"]) : 0;
            int UserType = (Session["Usertype"] != null) ? Convert.ToInt32(Session["Usertype"]) : 0;

            if (EmpID > 0 && UserType > 0)
            {
                ViewBag.EmpId = EmpID;
                ViewBag.UserType = UserType;

                if (UserType == 1)
                {
                    return RedirectToAction("AdminDashboard", "Admin");
                }
                else
                {
                    EmployeeModel em = new EmployeeModel();
                    DataTable dt = Db.GetEmployeeInfo(EmpID, null);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            em.EmpID = EmpID;
                            em.EmpName = row["EmpName"].ToString();
                            em.UserName = row["UserName"].ToString();

                            em.Gender = row["EmpGender"].ToString().TrimEnd();
                            em.PhoneNumber = row["EmpPhone"].ToString();
                            em.EmailId = row["EmpEmail"].ToString();
                            em.DateOfBirth = row["EmpDob"].ToString().Split(' ')[0];
                            em.UserPhotoPath = row["EmpPhotoPath"].ToString();
                            em.Designation = row["Designation"].ToString();
                            em.DesigType = Convert.ToInt32(row["EmpDesignation"].ToString());
                        }
                    }
                    ViewBag.EmpName = em.EmpName;
                    ViewBag.Gender = em.Gender;
                    ViewBag.EmpEmail = em.EmailId;
                    ViewBag.UserPhotoPath = em.UserPhotoPath;
                    ViewBag.LeaveTypes = new SelectList(Db.GetLeaveTypes(), "Value", "Text", "");
                    ViewBag.LeaveDurTypes = new SelectList(new SelectListItem[]
                    {
                        new SelectListItem { Text = "Full Day", Value = "1"},
                        new SelectListItem { Text = "Half Day", Value = "2"}
                    }, "Value", "Text", "");

                    ViewBag.YearList = new SelectList(new SelectListItem[]
                    {
                        new SelectListItem { Text = DateTime.Now.AddYears(-5).Year.ToString(), Value = DateTime.Now.AddYears(-5).Year.ToString()},
                        new SelectListItem { Text = DateTime.Now.AddYears(-4).Year.ToString(), Value = DateTime.Now.AddYears(-4).Year.ToString()},
                        new SelectListItem { Text = DateTime.Now.AddYears(-3).Year.ToString(), Value =  DateTime.Now.AddYears(-3).Year.ToString()},
                        new SelectListItem { Text = DateTime.Now.AddYears(-2).Year.ToString(), Value =  DateTime.Now.AddYears(-2).Year.ToString()},
                        new SelectListItem { Text = DateTime.Now.AddYears(-1).Year.ToString(), Value =  DateTime.Now.AddYears(-1).Year.ToString()},
                        new SelectListItem { Text = DateTime.Now.AddYears(0).Year.ToString(), Value =  DateTime.Now.AddYears(0).Year.ToString()}

                    }, "Value", "Text", "");

                    List<string> monthNames = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.MonthGenitiveNames.ToList();
                    monthNames.Remove("");

                    ViewBag.MonthList = new SelectList(new SelectListItem[]
                    {
                        new SelectListItem { Text = monthNames[0], Value = "1"},
                        new SelectListItem { Text = monthNames[1], Value = "2"},
                        new SelectListItem { Text = monthNames[2], Value = "3"},
                        new SelectListItem { Text = monthNames[3], Value = "4"},
                        new SelectListItem { Text = monthNames[4], Value = "5"},
                        new SelectListItem { Text = monthNames[5], Value = "6"},
                        new SelectListItem { Text = monthNames[6], Value = "7"},
                        new SelectListItem { Text = monthNames[7], Value = "8"},
                        new SelectListItem { Text = monthNames[8], Value = "9"},
                        new SelectListItem { Text = monthNames[9], Value = "10"},
                        new SelectListItem { Text = monthNames[10], Value = "11"},
                        new SelectListItem { Text = monthNames[11], Value = "12"}
                    }, "Value", "Text", "");

                    return View(em);
                }
            }
            else
            {
                return RedirectToAction("Login", "Login");
            }
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string getEmployeeInfo(string empId)
        {
            int EmpID = !string.IsNullOrEmpty(empId) ? Convert.ToInt32(empId) : 0;
            if (EmpID > 0)
            {
                DataTable dt = Db.GetEmployeeInfo(EmpID, null);
                if (dt != null && dt.Rows.Count > 0)
                {
                    EmployeeModel em = new EmployeeModel();
                    foreach (DataRow row in dt.Rows)
                    {
                        em.EmpID = EmpID;
                        em.EmpName = row["EmpName"].ToString();
                        em.UserName = row["UserName"].ToString();

                        em.Gender = row["EmpGender"].ToString().TrimEnd();
                        em.PhoneNumber = row["EmpPhone"].ToString();
                        em.EmailId = row["EmpEmail"].ToString();
                        em.DateOfBirth = row["EmpDob"].ToString().Split(' ')[0];
                        em.UserPhotoPath = row["EmpPhotoPath"].ToString();
                        em.Designation = row["Designation"].ToString();
                        em.DesigType = Convert.ToInt32(row["EmpDesignation"].ToString());
                    }

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    return serializer.Serialize(em);
                }
            }
            return null;
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string ProfileDetails(string Id, string firstName, string lastName, string empname, string dob, string gender, string role, string username, string cnfPwd, string email, string phone)
        {
            Regex RegexEmail = new Regex(@"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
            Regex mobRgx = new Regex(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$");

            //int Id = Convert.ToInt32(fm["EmpId"]);
            //string empName = fm["EmpName"];
            //string gender = fm["SelGender"];
            //string role = fm["UserRole"];
            //string dateOfBirth = fm["EmpDateOfBirth"];
            //string userName = fm["UserName"];
            //string password = fm["Password"];
            //string cnfrmPassword = fm["CnfrmPassword"];
            //string emailId = fm["EmailId"];
            //string phoneNumber = fm["PhoneNumber"];
            //string UserPhotoPath = fm["UserPhotoPath"];

            EmployeeModel em = null;
            string errStr = string.Empty;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            if (string.IsNullOrEmpty(firstName))
            {
                errStr = errStr + "1:";
            }
            if (string.IsNullOrEmpty(lastName))
            {
                errStr = errStr + "2:";
            }
            if (string.IsNullOrEmpty(gender))
            {
                errStr = errStr + "3:";
            }
            //if (string.IsNullOrEmpty(role) || (!string.IsNullOrEmpty(role) && Convert.ToInt32(role) <= 0))
            //{
            //    errStr = errStr + "3:";
            //}
            if (string.IsNullOrEmpty(dob))
            {
                errStr = errStr + "4:";
            }
            if (string.IsNullOrEmpty(username))
            {
                errStr = errStr + "5:";
            }
            //if (string.IsNullOrEmpty(password))
            //{
            //    errStr = errStr + "6:";
            //}
            if (string.IsNullOrEmpty(cnfPwd))
            {
                errStr = errStr + "7:";
            }
            //if (!string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(cnfPwd) && password != cnfPwd)
            //{
            //    errStr = errStr + "8:";
            //}
            if (!string.IsNullOrEmpty(dob))
            {
                TimeSpan ts = new TimeSpan();
                DateTime db = Convert.ToDateTime(dob);
                ts = DateTime.Now - db;
                if (ts.TotalDays < 6570)
                {
                    errStr = errStr + "9:";
                }
            }

            if (string.IsNullOrEmpty(email))
            {
                errStr = errStr + "EN:";
            }
            else if (!RegexEmail.IsMatch(email))
            {
                errStr = errStr + "ENV:";
            }

            if (string.IsNullOrEmpty(phone))
            {
                errStr = errStr + "PN:";
            }
            if (!string.IsNullOrEmpty(phone) && !mobRgx.IsMatch(phone))
            {
                errStr = errStr + "PNV:";
            }

            if (string.IsNullOrEmpty(errStr))
            {
                em = new EmployeeModel();
                em.EmpID = (!string.IsNullOrEmpty(Id)) ? Convert.ToInt32(Id) : 0;
                em.EmpName = empname;
                em.Gender = gender;
                em.UserName = username;
                em.Password = cnfPwd;
                em.PhoneNumber = "";
                em.EmailId = "";
                em.Usertype = Convert.ToInt32(role);
                em.DateOfBirth = dob;
                em.PhoneNumber = phone;
                em.EmailId = email;
                string UserPhotoPath = "";
                if (!string.IsNullOrEmpty(UserPhotoPath))
                {
                    em.UserPhotoPath = UserPhotoPath;
                }
                else
                {
                    em.UserPhotoPath = "";
                }
                if (Convert.ToInt32(Id) > 0)
                {
                    string rtrnStr = Db.UpdateProfile(em);

                    if (string.IsNullOrEmpty(rtrnStr))
                    {
                        em.ErrorString = "";
                    }
                    else
                    {
                        em.ErrorString = rtrnStr;
                    }

                    return serializer.Serialize(em);
                }
            }
            em = new EmployeeModel();
            em.ErrorString = errStr;
            return serializer.Serialize(em);
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string ChangeUserPassword(string empId, string currPwd, string nwPwd, string nwPwdCnfm)
        {
            string rtrnStr = "";
            try
            {
                int empid = !string.IsNullOrEmpty(empId) ? Convert.ToInt32(empId) : 0;
                if (empid <= 0)
                {
                    rtrnStr = "ERROR:";
                }

                if (string.IsNullOrEmpty(currPwd))
                {
                    rtrnStr = rtrnStr + "CP:";
                }
                if (string.IsNullOrEmpty(nwPwd))
                {
                    rtrnStr = rtrnStr + "NP:";
                }
                if (string.IsNullOrEmpty(nwPwdCnfm))
                {
                    rtrnStr = rtrnStr + "NPC:";
                }

                if (!string.IsNullOrEmpty(nwPwd) && !string.IsNullOrEmpty(nwPwdCnfm) && nwPwd != nwPwdCnfm)
                {
                    rtrnStr = rtrnStr + "NPM:";
                }

                if (string.IsNullOrEmpty(rtrnStr))
                {
                    rtrnStr = Db.UpdateUserPassword(empid, currPwd, nwPwd);                   
                }

                return rtrnStr;
            }
            catch (Exception ex)
            {
                return null;
            }
        }        
        #endregion

        #region Manage Attendance

        [RequireHttps]
        public ActionResult AttendanceDetails(int EmpId)
        {
            ViewBag.EmpId = EmpId;
            return View();
        }

        [RequireHttps]
        public string GetEmpPunchDetails(string empId, int timeoffset)
        {
            int EmpID = (!string.IsNullOrEmpty(empId)) ? Convert.ToInt32(empId) : 0;
            if (EmpID > 0)
            {
                AttendanceModel am = Helpers.Helper.convertDateTimeFormat(Db.GetEmployeeAttendanceDetails(EmpID));

                //TimeSpan offset = TimeSpan.FromMinutes(-timeoffset);

                //em.PunchinTime = (!string.IsNullOrEmpty(em.PunchinTime)) ?
                //    new DateTimeOffset(Convert.ToDateTime(em.PunchinTime)).ToOffset(offset).ToString("yyyy-MM-dd hh:mm:ss tt") : "";

                //em.PunchoutTime = (!string.IsNullOrEmpty(em.PunchoutTime)) ?
                //    new DateTimeOffset(Convert.ToDateTime(em.PunchoutTime)).ToOffset(offset).ToString("yyyy-MM-dd hh:mm:ss tt") : "";

                //em.PunchinTime = (!string.IsNullOrEmpty(em.PunchinTime)) ?
                //    new DateTimeOffset(Convert.ToDateTime(em.PunchinTime)).ToOffset(offset).ToString() : "";

                //em.PunchoutTime = (!string.IsNullOrEmpty(em.PunchoutTime)) ?
                //    new DateTimeOffset(Convert.ToDateTime(em.PunchoutTime)).ToOffset(offset).ToString() : "";

                return new JavaScriptSerializer().Serialize(am);
            }
            return null;
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string AddAttendance(string EmpId, string punchInTime, string punchOutTime, int type, int timeoffset)
        {
            int EmpID = (!string.IsNullOrEmpty(EmpId)) ? Convert.ToInt32(EmpId) : 0;
            bool flag = false;
            if (EmpID > 0)
            {
                AttendanceModel am = null;

                if (type == 1) //punchin
                {
                    am = new AttendanceModel();
                    am.EmpID = EmpID;
                    am.PunchinTime = DateTime.UtcNow.ToString();
                    flag = Db.AddAttendance(am, 1);
                }
                else if (type == 2) //punchout
                {
                    am = new AttendanceModel();
                    am.EmpID = EmpID;
                    am.PunchinTime = Db.GetEmployeeAttendanceDetails(EmpID).PunchinTime;
                    am.PunchoutTime = DateTime.UtcNow.ToString();
                    flag = Db.AddAttendance(am, 2);
                }

                if (flag)
                {
                    //em.PunchinTime = (!string.IsNullOrEmpty(em.PunchinTime)) ? Convert.ToDateTime(em.PunchinTime).ToString("yyyy-MM-dd hh:mm:ss tt") : "";
                    //em.PunchoutTime = (!string.IsNullOrEmpty(em.PunchoutTime)) ? Convert.ToDateTime(em.PunchoutTime).ToString("yyyy-MM-dd hh:mm:ss tt") : "";

                    //TimeSpan offset = TimeSpan.FromMinutes(-timeoffset);

                    //DateTimeOffset pin = (!string.IsNullOrEmpty(em.PunchinTime)) ?
                    //    new DateTimeOffset(Convert.ToDateTime(em.PunchinTime)).ToOffset(offset) : new DateTimeOffset();
                    //DateTimeOffset pout = (!string.IsNullOrEmpty(em.PunchoutTime)) ?
                    //    new DateTimeOffset(Convert.ToDateTime(em.PunchoutTime)).ToOffset(offset) : new DateTimeOffset();                      

                    //TimeZoneInfo cstZone = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");                  
                    //DateTime cstTime = (!string.IsNullOrEmpty(em.PunchinTime)) ?
                    //  TimeZoneInfo.ConvertTimeFromUtc(Convert.ToDateTime(em.PunchinTime), cstZone) : new DateTime();
                    //em.PunchinTime = cstTime.ToString("yyyy-MM-dd hh:mm:ss tt");

                    //cstTime = (!string.IsNullOrEmpty(em.PunchoutTime)) ?
                    //  TimeZoneInfo.ConvertTimeFromUtc(Convert.ToDateTime(em.PunchoutTime), cstZone) : new DateTime();

                    //em.PunchoutTime = cstTime.ToString("yyyy-MM-dd hh:mm:ss tt");

                    am = Helpers.Helper.convertDateTimeFormat(am);
                    am.ErrorString = "";
                }
                else
                {
                    am.ErrorString = "ERROR";
                }
                return new JavaScriptSerializer().Serialize(am);
            }
            return null;
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult SearchPunchDetails(string EmpId, string StartDate, string EndDate, int timeoffset)
        {
            try
            {
                int EmpID = (!string.IsNullOrEmpty(EmpId)) ? Convert.ToInt32(EmpId) : 0;
                if (EmpID > 0)
                {
                    var draw = Request.Form.GetValues("draw").FirstOrDefault();
                    var start = Request.Form.GetValues("start").FirstOrDefault();
                    var length = Request.Form.GetValues("length").FirstOrDefault();
                    string sortColumn = Request.Form.GetValues("order[0][column]")[0];
                    string sortColumnDir = Request.Form.GetValues("order[0][dir]")[0];

                    int pageSize = length != null ? Convert.ToInt32(length) : 0;
                    int skip = start != null ? Convert.ToInt32(start) : 0;
                    int totalRecords = 0;

                    List<AttendanceModel> attList = Db.GetEmpPunchDetails(EmpID, StartDate, EndDate, false, skip, pageSize);
                    if (attList != null && attList.Count > 0)
                    {
                        totalRecords = attList[0].RowCount;

                        //// Sorting.
                        //attList = SortByColumnWithOrder(sortColumn, sortColumnDir, attList);

                        //// Filter record count.
                        //int recFilter = attList.Count;

                        //var data = attList.Skip(skip).Take(pageSize).ToList();
                        var data = attList.ToList();

                        return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = data }, JsonRequestBehavior.AllowGet);
                    }
                }

                return Json(new { draw = 0, recordsFiltered = 0, recordsTotal = 0, data = new List<AttendanceModel>() }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { draw = 0, recordsFiltered = 0, recordsTotal = 0, data = new List<AttendanceModel>() }, JsonRequestBehavior.AllowGet);
            }
        }

        #endregion

        #region Manage Leaves

        [HttpPost]
        [RequireHttps]
        public ActionResult GetLeaveDetails(string EmpId, string UserType, string month, string year)
        {
            try
            {
                string rtrnStr = string.Empty;

                int empId = (!string.IsNullOrEmpty(EmpId)) ? Convert.ToInt32(EmpId) : 0;
                int userType = (!string.IsNullOrEmpty(UserType)) ? Convert.ToInt32(UserType) : 0;

                if (empId > 0 && userType > 0)
                {
                    LeaveModel lm = new LeaveModel();
                    var strtDate = Helpers.Helper.GetFirstDayOfMonth(Convert.ToInt32(month), Convert.ToInt32(year));
                    lm._fromdate = strtDate.ToString();
                    lm._todate = strtDate.AddMonths(1).AddDays(-1).ToString();

                    var draw = Request.Form.GetValues("draw").FirstOrDefault();
                    var start = Request.Form.GetValues("start").FirstOrDefault();
                    var length = Request.Form.GetValues("length").FirstOrDefault();

                    //Get Sort columns value
                    var sortColumn = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault();
                    var sortColumnDir = Request.Form.GetValues("order[0][dir]").FirstOrDefault();

                    int pageSize = length != null ? Convert.ToInt32(length) : 0;
                    int skip = start != null ? Convert.ToInt32(start) : 0;
                    int totalRecords = 0;

                    List<LeaveModel> lvList = Db.GetEmployeeLeaveDetails(empId, userType, lm, false, skip, pageSize);
                    if (lvList != null && lvList.Count > 0)
                    {
                        totalRecords = lvList[0].RowCount;
                        var data = lvList.ToList();
                        return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = data }, JsonRequestBehavior.AllowGet);
                    }
                }
                return Json(new { draw = 0, recordsFiltered = 0, recordsTotal = 0, data = new List<LeaveModel>() }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { draw = 0, recordsFiltered = 0, recordsTotal = 0, data = new List<LeaveModel>() }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string GetLeaveStatistics(string EmpId)
        {
            try
            {
                int EmpID = (!string.IsNullOrEmpty(EmpId)) ? Convert.ToInt32(EmpId) : 0;
                if (EmpID > 0)
                {
                    DataTable dt = Db.GetLeaveStatistics(EmpID);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        JavaScriptSerializer serializer = new JavaScriptSerializer();

                        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                        Dictionary<string, object> row;
                        foreach (DataRow dr in dt.Rows)
                        {
                            row = new Dictionary<string, object>();
                            foreach (DataColumn col in dt.Columns)
                            {
                                row.Add(col.ColumnName, dr[col]);
                            }
                            rows.Add(row);
                        }
                        var json = serializer.Serialize(rows);
                        return json;
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        [HttpPost]
        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public string AddLeave(string leaveId, string EmpId, string fromDate, string toDate, string leaveType, string leaveDurType, string comments, string LvTypStr, string usertype, string lvDurTypStr, bool isCancel)
        {
            try
            {
                string rtrnStr = string.Empty;
                int empId = (!string.IsNullOrEmpty(EmpId)) ? Convert.ToInt32(EmpId) : 0;
                if (empId > 0)
                {
                    if (string.IsNullOrEmpty(leaveType))
                    {
                        rtrnStr = rtrnStr + "1";
                    }

                    if (string.IsNullOrEmpty(fromDate))
                    {
                        rtrnStr = rtrnStr + "2";
                    }
                    if (string.IsNullOrEmpty(toDate))
                    {
                        rtrnStr = rtrnStr + "3";
                    }

                    if (!string.IsNullOrEmpty(fromDate) && (!string.IsNullOrEmpty(toDate)))
                    {
                        DateTime frmdt = Convert.ToDateTime(fromDate);
                        DateTime todt = Convert.ToDateTime(toDate);

                        if (todt < frmdt)
                        {
                            rtrnStr = rtrnStr + "4";
                        }
                    }

                    if (string.IsNullOrEmpty(leaveDurType))
                    {
                        rtrnStr = rtrnStr + "5";
                    }

                    if (string.IsNullOrEmpty(rtrnStr))
                    {
                        DateTime frmdt = Convert.ToDateTime(fromDate);
                        DateTime todt = Convert.ToDateTime(toDate);
                        string LeaveTypeStr = LvTypStr.TrimEnd();
                        bool flag = false;
                        ArrayList rtrnArr = new ArrayList();

                        rtrnArr = Db.CalculateLeaveStatistics(frmdt, todt, LeaveTypeStr, lvDurTypStr, empId);
                        if (rtrnArr != null)
                        {
                            flag = Convert.ToBoolean(rtrnArr[2]);
                        }

                        if (!flag)
                        {
                            rtrnStr = rtrnStr + "7"; //"No enough leaves"
                        }
                        else
                        {
                            LeaveModel lm = new LeaveModel();
                            lm.EmpID = empId;
                            lm._fromdate = fromDate;
                            lm._todate = toDate;
                            lm._leaveType = (!string.IsNullOrEmpty(leaveType)) ? Convert.ToInt32(leaveType) : 0; ;
                            lm._leavedurationtype = lvDurTypStr;
                            lm._comments = comments;
                            lm._status = false;
                            lm._rejected = false;
                            lm._strLvType = LeaveTypeStr;
                            lm._cancelled = isCancel;
                            lm.RtrnArry = rtrnArr;

                            if (string.IsNullOrEmpty(leaveId))
                            {
                                rtrnStr = Db.AddLeave(lm);
                            }
                            else
                            {
                                lm._lvId = Convert.ToInt32(leaveId);
                                rtrnStr = Db.UpdateLeave(lm, Convert.ToInt32(usertype));
                            }
                        }
                    }
                }
                return rtrnStr;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        [HttpPost]
        [RequireHttps]
        public string SentQuery(string SenterMail, string emailSubject, string emailBody)
        {
            try
            {
                string mailTo = "tnoreply001@gmail.com";
                string mailfrom = SenterMail;

                MailMessage email = new MailMessage();

                email.Subject = emailSubject;
                email.From = new MailAddress(mailfrom);
                email.To.Add(new MailAddress(mailTo));
                email.IsBodyHtml = true;
                email.Body = emailBody;

                SmtpClient client = new SmtpClient("smtp.gmail.com", 25);
                //client.Port = 25;
                client.EnableSsl = true;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                //client.Host = "smtp.gmail.com";
                client.Credentials = new NetworkCredential("tnoreply001@gmail.com", "#123Testuser");
                client.Timeout = 360000;
                client.Send(email);

                return "OK";
            }
            catch (Exception ex)
            {
                return null;
            }
            return null;
        }

        #endregion

        #region UserReports

        [RequireHttps]
        public string GetUserReport(int EmpId, string year, string month)
        {
            try
            {
                int Year = (!string.IsNullOrEmpty(year)) ? Convert.ToInt32(year) : 0;
                int Month = (!string.IsNullOrEmpty(month)) ? Convert.ToInt32(month) : 0;
                string rtrnStr = string.Empty;

                if (Year > 0 && Month > 0)
                {
                    var startDate = Helpers.Helper.GetFirstDayOfMonth(Month, Year);
                    var endDate = startDate.AddMonths(1).AddDays(-1);
                    LeaveModel lm = new LeaveModel();
                    lm._fromdate = startDate.ToString();
                    lm._todate = endDate.ToString();

                    List<AttendanceModel> punchList = Db.GetEmpPunchDetails(EmpId, startDate.ToString(), endDate.ToString(), true);
                    List<LeaveModel> lvList = Db.GetEmployeeLeaveDetails(EmpId, 2, lm, true);

                    if (lvList != null && punchList != null)
                    {
                        if (lvList.Count <= 0 && punchList.Count <= 0)
                        {
                            rtrnStr = null;
                        }
                        else
                        {
                            double lvcount = 0.0;
                            List<int> yearLst;
                            List<double> lvLst;
                            foreach (var item in lvList)
                            {
                                yearLst = (List<int>)item.RtrnArry[0];
                                lvLst = (List<double>)item.RtrnArry[1];

                                foreach (int yearItem in yearLst)
                                {
                                    if (yearItem == startDate.Year)
                                    {
                                        lvcount = lvcount + lvLst[yearLst.IndexOf(yearItem)];
                                    }
                                }
                            }

                            UserReportModel um = new UserReportModel();
                            um.TotalDays = DateTime.DaysInMonth(Year, Month);
                            um.Holidays = um.TotalDays - Helpers.Helper.GetBusinessDaysCount(startDate, endDate);
                            um.ActiveDays = (punchList != null && punchList.Count > 0) ? punchList.Count : 0;

                            //double InActiveDays = um.TotalDays - um.ActiveDays - um.Holidays - lvcount;
                            um.LeaveDays = lvcount;
                            um.WorkingDays = um.TotalDays - um.Holidays;
                            um.Month = month;
                            um.Year = year;

                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            rtrnStr = serializer.Serialize(um);
                        }
                    }
                }
                return rtrnStr;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

        #region Upload userphoto

        [RequireHttps]
        public ActionResult CapturePhoto()
        {
            return View();
        }

        #endregion

        /// <summary>
        /// Sort by column with order method.
        /// </summary>
        /// <param name="order">Order parameter</param>
        /// <param name="orderDir">Order direction parameter</param>
        /// <param name="data">Data parameter</param>
        /// <returns>Returns - Data</returns>
        private List<AttendanceModel> SortByColumnWithOrder(string order, string orderDir, List<AttendanceModel> data)
        {
            // Initialization.
            List<AttendanceModel> lst = new List<AttendanceModel>();
            try
            {
                switch (order)
                {
                    case "0":
                        lst = orderDir.Equals("DESC", StringComparison.CurrentCultureIgnoreCase) ? data.OrderByDescending(p => p.PunchinTime).ToList()
                                                                                                 : data.OrderBy(p => p.PunchinTime).ToList();
                        break;
                    case "1":
                        lst = orderDir.Equals("DESC", StringComparison.CurrentCultureIgnoreCase) ? data.OrderByDescending(p => p.PunchinTime).ToList()
                                                                                                 : data.OrderBy(p => p.PunchinTime).ToList();
                        break;
                    case "2":
                        lst = orderDir.Equals("DESC", StringComparison.CurrentCultureIgnoreCase) ? data.OrderByDescending(p => p.PunchoutTime).ToList()
                                                                                                 : data.OrderBy(p => p.PunchoutTime).ToList();
                        break;
                    default:
                        lst = orderDir.Equals("DESC", StringComparison.CurrentCultureIgnoreCase) ? data.OrderByDescending(p => p.PunchinTime).ToList()
                                                                                                 : data.OrderBy(p => p.PunchinTime).ToList();
                        break;
                }
            }
            catch (Exception ex)
            {
                Console.Write(ex);
            }
            return lst;
        }
    }
}