using System.Web;
using System.Web.Mvc;
using HrmsMvc.Helpers;

public partial class _Default : System.Web.UI.Page
{
    public void Page_Load(object sender, System.EventArgs e)
    {
        Helper.MaintainLeaveTask();

        // Change the current path so that the Routing handler can correctly interpret
        // the request, then restore the original path so that the OutputCache module
        // can correctly process the response (if caching is enabled).

        string originalPath = Request.Path;
        //HttpContext.Current.RewritePath(Request.ApplicationPath, false);
        var httpContext = HttpContext.Current;
        httpContext.Server.TransferRequest(Request.ApplicationPath, false);
        IHttpHandler httpHandler = new MvcHttpHandler();
        httpHandler.ProcessRequest(HttpContext.Current);
        // HttpContext.Current.RewritePath(originalPath, false);
        var httpContext1 = HttpContext.Current;
        httpContext1.Server.TransferRequest(originalPath, false);

       
    }
}
