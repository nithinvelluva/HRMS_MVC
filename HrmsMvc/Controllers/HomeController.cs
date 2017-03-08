using System.Web.Mvc;

namespace HrmsMvc.Controllers
{
    [RequireHttps]
    public class HomeController : Controller
    {
        // GET: Home
        [RequireHttps]
        public ActionResult Index()
        {
            return View();
        }
    }
}