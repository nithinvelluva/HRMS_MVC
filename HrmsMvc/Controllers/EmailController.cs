using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class EmailController : Controller
    {      
        public ActionResult SentQuery()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]        
        public string SentQuery(FormCollection fm)
        {
            return null;
        }
    }
}