using System.Web.Mvc;
using System.Web.Routing;

namespace HrmsMvc
{
    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //routes.MapRoute(
            //    "Default",                                              // Route name
            //    "{controller}/{action}/{id}",                           // URL with parameters
            //    new { controller = "Scheduler", action = "ScaleMonths", id = "" }  // Parameter defaults
            //);

            // routes.MapRoute(
            //    "Default",                                              // Route name
            //    "{controller}/{action}/{id}",                           // URL with parameters
            //    new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
            //);
            routes.MapRoute(
            "Default",                                              // Route name
            "{controller}/{action}/{id}",                           // URL with parameters
            new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
        );
        }



        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}
