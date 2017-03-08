using HrmsMvc.Models;
using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class UploadPhotoController : Controller
    {
        // GET: UploadPhoto
        [RequireHttps]
        public ActionResult Index()
        {
            return View();
        }

        [RequireHttps]
        [HttpPost]
        public string Upload(HttpPostedFileBase myFile)
        {
            try
            {
                if (myFile != null && myFile.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(myFile.FileName);
                    var path = Path.Combine(Server.MapPath("~/Content/UserIcons/"), fileName);
                    myFile.SaveAs(path);
                }
                return "OK";
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        [RequireHttps]
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult UploadFile()
        {
            string _imgname = string.Empty;

            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var pic = System.Web.HttpContext.Current.Request.Files["MyImages"];
                if (pic.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(pic.FileName);
                    var _ext = Path.GetExtension(pic.FileName);
                    _imgname = Guid.NewGuid().ToString();
                    _imgname = "HRMS_" + _imgname + _ext;

                    try
                    {
                        var _comPath = Server.MapPath("~/Content/UserIcons/") + _imgname;// +_ext;

                        ViewBag.Msg = _comPath;
                        var path = _comPath;

                        var storagePath = Server.MapPath("~/Content/UserIcons/");                  

                        if (!Directory.Exists(storagePath))
                        {
                            Directory.CreateDirectory(storagePath);
                        }

                        // Saving Image in Original Mode
                        pic.SaveAs(path);

                        // resizing image
                        //MemoryStream ms = new MemoryStream();
                        WebImage img = new WebImage(_comPath);

                        if (img.Width > 200)
                            img.Resize(200, 200);
                        img.Save(_comPath);
                        // end resize                        
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
            }
            return Json(Convert.ToString(_imgname), JsonRequestBehavior.AllowGet);
        }

        [RequireHttps]
        public string UpdateUserPhoto(string empid, string userphotopath, string prvUserPhotoPath, bool CancelFlag)
        {
            try
            {
                string rtrnStr = "";
                int EmpId = (!string.IsNullOrEmpty(empid)) ? Convert.ToInt32(empid) : 0;

                if (EmpId > 0 && !string.IsNullOrEmpty(userphotopath))
                {
                    if (!CancelFlag)
                    {
                        if (!string.IsNullOrEmpty(prvUserPhotoPath))
                        {
                            var _comPath = Server.MapPath("~/Content/UserIcons/") + prvUserPhotoPath.Replace("../Content/UserIcons/", "");
                            if (System.IO.File.Exists(_comPath.ToString()))
                            {
                                System.IO.File.Delete(_comPath);
                            }
                        }
                        EmployeeModel em = new EmployeeModel();
                        em.EmpID = EmpId;
                        em.UserPhotoPath = userphotopath;

                        rtrnStr = Db.UpdateProfile(em, true);                               
                    }
                    else
                    {
                        var _comPath = Server.MapPath("~/Content/UserIcons/") + userphotopath.Replace("../Content/UserIcons/", "");
                        System.IO.File.Delete(_comPath);
                        rtrnStr = "CANCEL";
                    }
                }

                return rtrnStr;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}