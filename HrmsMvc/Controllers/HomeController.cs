using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class HomeController : Controller
    {
        // GET: Home     
        public ActionResult Index()
        {
            return View();
        }
    }
}