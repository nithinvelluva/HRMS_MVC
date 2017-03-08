using System.Web.Mvc;
using System.Web.Routing;

namespace HrmsMvc
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "AdminPanel",
               "AdminPanel",
                new { controller = "Admin", action = "AdminPage", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                "UserProfile",
                 "UserProfile",
                new { controller = "User", action = "UserProfile", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                "Login",
                 "Login",
                new { controller = "Login", action = "Login", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Login", action = "Login", id = UrlParameter.Optional }
            );
        }
    }
}
