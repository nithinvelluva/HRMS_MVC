using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class EmailController : Controller
    {
        [RequireHttps]
        public ActionResult SentQuery()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [RequireHttps]
        public string SentQuery(FormCollection fm)
        {
            return null;
        }
    }
}