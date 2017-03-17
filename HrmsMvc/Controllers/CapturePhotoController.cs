using System;
using System.IO;
using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class CapturePhotoController : Controller
    {
        // GET: CapturePhoto
        
        public ActionResult Index()
        {
            Session["val"] = "";
            return View();
        }

        [HttpPost]
        
        public ActionResult Index(string Imagename)
        {
            string sss = Session["val"].ToString();

            ViewBag.pic = "http://localhost:55694/Content/UserIcons/" + Session["val"].ToString();

            return View();
        }

        [HttpGet]
        
        public ActionResult Changephoto()
        {
            if (Convert.ToString(Session["val"]) != string.Empty)
            {
                ViewBag.pic = "http://localhost:55694/Content/UserIcons/" + Session["val"].ToString();
            }
            else
            {
                ViewBag.pic = "../../WebImages/person.jpg";
            }
            return View();
        }

        public JsonResult Rebind()
        {
            //string path = "http://localhost:55694/Content/UserIcons/" + Session["val"].ToString();
            string imgName = Session["val"].ToString();
            return Json(imgName, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        
        public void Capture()
        {
            var stream = Request.InputStream;
            string dump;
            string _imgname = string.Empty;

            using (var reader = new StreamReader(stream))
            {
                dump = reader.ReadToEnd();
                var _ext = ".jpg";
                _imgname = Guid.NewGuid().ToString();
                _imgname = "HRMS_" + _imgname + _ext;

                var path = Server.MapPath("~/Content/UserIcons/") + _imgname;

                var storagePath = Server.MapPath("~/Content/UserIcons/");
                if (!Directory.Exists(storagePath))
                {
                    Directory.CreateDirectory(storagePath);
                }

                System.IO.File.WriteAllBytes(path, String_To_Bytes2(dump));

                ViewBag.ImgPath = path;
                ViewBag.ImgName = _imgname;

                //// resizing image
                //MemoryStream ms = new MemoryStream();
                //WebImage img = new WebImage(_comPath);

                //if (img.Width > 200)
                //    img.Resize(200, 200);
               // img.Save(_comPath);
                // end resize               
            }

            Session["val"] = _imgname;
        }

        private byte[] String_To_Bytes2(string strInput)
        {
            int numBytes = (strInput.Length) / 2;

            byte[] bytes = new byte[numBytes];

            for (int x = 0; x < numBytes; ++x)
            {
                bytes[x] = Convert.ToByte(strInput.Substring(x * 2, 2), 16);
            }

            return bytes;
        }
    }
}