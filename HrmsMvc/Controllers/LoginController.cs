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
        public ActionResult Login()
        {
            if (Session["USER"] != null)
            {
                int UserType = (Session["USER"] as LoginModel).UserType;

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

        // POST: Login
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Login(LoginModel lobj)
        {
            string userName = lobj.UserName;
            string password = lobj.Password;

            if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
            {
                ModelState.AddModelError("UserName", "Enter credentials");
            }
            if (ModelState.IsValid)
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

                    //Session["UserId"] = lm.Id;
                    //Session["Usertype"] = lm.UserType;
                    Session["USER"] = new LoginModel() { Id = lm.Id, UserType = lm.UserType };

                    if (lm.UserType == 1)
                    {
                        return RedirectToAction("AdminDashboard", "Admin");
                    }
                    else
                    {
                        return RedirectToAction("UserDetails", "User");
                    }
                }

                ModelState.AddModelError("UserName", "Invalid credentials");
            }
            return View(lobj);
        }

        // GET: Logout
        public ActionResult Logout()
        {
            Session.RemoveAll();
            return RedirectToAction("Login");
        }

        // GET: ForgotPassword
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult ForgotPassword()
        {
            if (Session["USER"] != null)
            {
                int UserType = (Session["USER"] as LoginModel).UserType;

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
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ForgotPassword(LoginModel lobj)
        {
            if (string.IsNullOrEmpty(lobj.UserEmail))
            {
                ModelState.AddModelError("UserEmail", "Please enter your email to receive password reset link");
            }
            else if (!Helpers.Helper.RegexEmail.IsMatch(lobj.UserEmail))
            {
                ModelState.AddModelError("UserEmail", "Enter a valid email id");
            }

            if (ModelState.IsValid)
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
                    var rendView = RenderRazorViewToString("ResetPwdEmailTemplate", lobj);
                    Helpers.Helper.sentEmail("Hrms - Reset password link", rendView, lobj.UserEmail);
                 
                    return RedirectToAction("SuccessViewPartial", "Login", new LoginModel() { returnString = "Please check your email for a link to reset your password" });
                }
                else
                {
                    ModelState.AddModelError("UserEmail", "Entered email id is not registered with us");
                }
            }

            return View(lobj);
            //return Json(new { status = status}, JsonRequestBehavior.AllowGet);
        }

        // GET: ResetPassword
        public ActionResult ResetPassword(string un, string rt, string empId)
        {
            if (!string.IsNullOrEmpty(un) && !string.IsNullOrEmpty(rt) && !string.IsNullOrEmpty(empId))
            {
                Session["RESETLINKPARAM"] = new LoginModel() { Id = Convert.ToInt32(empId), UserToken = rt };

                if (!string.IsNullOrEmpty(empId) && !string.IsNullOrEmpty(rt))
                {
                    if (Db.validateResetPasswordToken(empId, rt))
                    {
                        return View();
                    }
                }
            }

            return RedirectToAction("ErrorPage", "Login");
        }

        // POST: ResetPassword
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ResetPassword(LoginModel lobj)
        {
            if (Session["RESETLINKPARAM"] != null)
            {
                int EmpID = (Session["RESETLINKPARAM"] as LoginModel).Id;
                string token = (Session["RESETLINKPARAM"] as LoginModel).UserToken;

                if (string.IsNullOrEmpty(lobj.Password))
                {
                    ModelState.AddModelError("Password", "Please enter password");
                }
                if (string.IsNullOrEmpty(lobj.CnfrmPassword))
                {
                    ModelState.AddModelError("CnfrmPassword", "Please enter password again to confirm");
                }
                if (!string.IsNullOrEmpty(lobj.Password) && !string.IsNullOrEmpty(lobj.CnfrmPassword) && lobj.Password != lobj.CnfrmPassword)
                {
                    ModelState.AddModelError("CnfrmPassword", "Confirm password doesn't match");
                }

                if (ModelState.IsValid)
                {
                    string rtrnStr = Db.UpdateUserPassword(EmpID, null, lobj.Password);
                    if (rtrnStr.Equals("OK:"))
                    {
                        Db.updateResetPasswordToken(EmpID.ToString(), token);
                        Session.RemoveAll();
                        
                        return RedirectToAction("SuccessViewPartial", "Login", new LoginModel() { returnString = "Your password has been changed successfully" });
                    }
                }
            }

            return View(lobj);
        }

        // GET: ErrorPage
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult ErrorPage()
        {
            return View();
        }

        // GET: SuccessViewPartial
        [OutputCache(NoStore = true, Duration = 0)]
        public ActionResult SuccessViewPartial(LoginModel lobj)
        {
            return View(lobj);
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
    }
}