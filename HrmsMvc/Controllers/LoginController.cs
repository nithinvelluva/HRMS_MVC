using HrmsMvc.Models;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using System.Web.Security;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class LoginController : Controller
    {
        // GET: Login
        [OutputCache(NoStore = true, Duration = 0)]
        [RequireHttps]
        public ActionResult Login()
        {
            int EmpID = (Session["UserId"] != null) ? Convert.ToInt32(Session["UserId"]) : 0;
            int UserType = (Session["Usertype"] != null) ? Convert.ToInt32(Session["Usertype"]) : 0;

            if (EmpID > 0 && UserType > 0)
            {
                if (UserType == 1)
                {
                    return RedirectToAction("AdminDashboard", "Admin");
                }
                else
                {
                    return RedirectToAction("UserDetails", "User");
                }
            }
            else
            {
                HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
                cookie1.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(cookie1);

                //clearing session cookies
                HttpCookie cookie2 = new HttpCookie("ASP.NET_SessionId", "");
                cookie2.Expires = DateTime.Now.AddYears(-1);
                Response.Cookies.Add(cookie2);

                return View();
            }
        }

        // POST: Login
        [AcceptVerbs(HttpVerbs.Post)]
        [RequireHttps]        
        public ActionResult Login(LoginModel lobj)
        {
            ViewBag.ErrorMsg = "";
            string userName = lobj.UserName;
            string password = lobj.Password;
            bool status = true;
            string errStr = "";

            if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
            {
                status = false;
                errStr = "Enter credentials";
            }

            if (status)
            {
                LoginModel lm = new LoginModel();
                DataTable dt = Db.Validateuser(userName, password);
                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        lm.UserName = row["UserName"].ToString();
                        lm.Id = Convert.ToInt32(row["ID"].ToString().TrimEnd());
                        lm.UserType = Convert.ToInt32(row["UserType"].ToString().TrimEnd());
                    }

                    TempData["UserId"] = lm.Id;
                    TempData["Usertype"] = lm.UserType;

                    Session["UserId"] = lm.Id;
                    Session["Usertype"] = lm.UserType;

                    if (lm.UserType == 1)
                    {
                        return RedirectToAction("AdminDashboard", "Admin");
                    }
                    else
                    {
                        return RedirectToAction("UserDetails", "User");
                    }
                }

                status = false;
                errStr = "Invalid credentials";
            }
            ViewBag.ErrorMsg = errStr;
            return View(lobj);
        }

        // GET: Logout
        [RequireHttps]
        public void Logout()
        {
            Session.RemoveAll();
        }

        // GET: ForgotPassword
        [OutputCache(NoStore = true, Duration = 0)]
        [RequireHttps]
        public ActionResult ForgotPassword()
        {
            int EmpID = (Session["UserId"] != null) ? Convert.ToInt32(Session["UserId"]) : 0;
            int UserType = (Session["Usertype"] != null) ? Convert.ToInt32(Session["Usertype"]) : 0;

            if (EmpID > 0 && UserType > 0)
            {
                if (UserType == 1)
                {
                    return RedirectToAction("AdminDashboard", "Admin");
                }
                else
                {
                    return RedirectToAction("UserDetails", "User");
                }
            }
            else
            {
                return View();
            }
        }

        // POST: ForgotPassword
        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ForgotPassword(LoginModel lobj)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string errStr = "";
            bool status = false;
            if (!string.IsNullOrEmpty(lobj.UserEmail))
            {
                if (!Helpers.Helper.RegexEmail.IsMatch(lobj.UserEmail))
                {
                    errStr = errStr + "INV";
                }
                else
                {
                    DataTable dt = Db.GetEmployeeInfo(0, lobj.UserEmail);
                    string EmpID = "";
                    string empName = "";
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            EmpID = row["EmpId"].ToString();
                            empName = row["EmpName"].ToString();
                        }

                        // generate password token
                        var token = Guid.NewGuid().ToString() + "_" + lobj.UserEmail + "_" + EmpID;
                        Db.createResetPasswordToken(EmpID, token);

                        //create url with above token
                        var link = Url.Action("ResetPassword", "Login", new { un = lobj.UserEmail, rt = token, empId = EmpID }, "https");
                        lobj.UserToken = link;                     

                        //var resetLink = "To change your password, click <a class='hrefLink' href='" + Url.Action("ResetPassword", "Login", new { un = lobj.UserEmail, rt = token, empId = EmpID }, "https") + "'>here</a>";
                        var rendView = RenderRazorViewToString("ResetPwdEmailTemplate", lobj);
                        Helpers.Helper.sentEmail("Hrms - Reset password link", rendView, lobj.UserEmail);
                        errStr = "";
                        status = true;
                    }
                    else
                    {
                        errStr = errStr + "RNE";
                    }
                }
            }
            else
            {
                errStr = "EMPTY";
            }

            return Json(new { status = status, rtrnMsg = errStr }, JsonRequestBehavior.AllowGet);
        }

        public string RenderRazorViewToString(string viewName, object model)
        {
            try
            {
                ViewData.Model = model;
                using (var sw = new StringWriter())
                {
                    var viewResult = ViewEngines.Engines.FindPartialView(ControllerContext,
                                                                             viewName);
                    var viewContext = new ViewContext(ControllerContext, viewResult.View,
                                                 ViewData, TempData, sw);
                    viewResult.View.Render(viewContext, sw);
                    viewResult.ViewEngine.ReleaseView(ControllerContext, viewResult.View);
                    return sw.GetStringBuilder().ToString();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        // GET: ResetPassword
        [RequireHttps]
        public ActionResult ResetPassword(string un, string rt, string empId)
        {
            Session["ResetEmpId"] = empId;
            Session["ResetToken"] = rt;

            if (!string.IsNullOrEmpty(empId) && !string.IsNullOrEmpty(rt))
            {
                if (Db.validateResetPasswordToken(empId, rt))
                {
                    return View();
                }
            }

            return RedirectToAction("ErrorPage", "Login");
        }

        // POST: ResetPassword
        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ResetPassword(LoginModel lobj)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string errStr = "";
            bool status = false;
            int EmpID = (Session["ResetEmpId"] != null) ? Convert.ToInt32(Session["ResetEmpId"]) : 0;
            string token = (Session["ResetToken"] != null) ? Session["ResetToken"].ToString() : "";

            if (EmpID > 0 && !string.IsNullOrEmpty(token))
            {
                if (string.IsNullOrEmpty(lobj.Password))
                {
                    errStr = errStr + "NP:";
                }
                if (string.IsNullOrEmpty(lobj.CnfrmPassword))
                {
                    errStr = errStr + "NPC:";
                }
                if (!string.IsNullOrEmpty(lobj.Password) && !string.IsNullOrEmpty(lobj.CnfrmPassword) && lobj.Password != lobj.CnfrmPassword)
                {
                    errStr = errStr + "PM:";
                }

                if (string.IsNullOrEmpty(errStr))
                {
                    string rtrnStr = Db.UpdateUserPassword(EmpID, null, lobj.Password);
                    if (rtrnStr.Equals("OK:"))
                    {
                        Db.updateResetPasswordToken(EmpID.ToString(), token);
                        Session.RemoveAll();
                        status = true;
                    }

                    errStr = rtrnStr;
                }
            }

            return Json(new { status = status, rtrnMsg = errStr }, JsonRequestBehavior.AllowGet);
        }

        // GET: ErrorPage
        [OutputCache(NoStore = true, Duration = 0)]
        [RequireHttps]
        public ActionResult ErrorPage()
        {
            return View();
        }
    }
}