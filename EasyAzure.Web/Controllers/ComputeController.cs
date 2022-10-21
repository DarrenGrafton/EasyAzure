using Microsoft.AspNetCore.Mvc;

namespace EasyAzure.Controllers
{
    public class ComputeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public ComputeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> IaaS()
        {
            return View();
        }

        public async Task<IActionResult> AppService()
        {
            return View();
        }

        public async Task<IActionResult> Functions()
        {
            return View();
        }


    }
}