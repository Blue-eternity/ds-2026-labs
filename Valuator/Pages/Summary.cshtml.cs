using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;

namespace Valuator.Pages;

public class SummaryModel : PageModel
{
    private readonly ILogger<SummaryModel> _logger;
    private readonly IConnectionMultiplexer _redis;

    public SummaryModel(ILogger<SummaryModel> logger, IConnectionMultiplexer redis)
    {
        _logger = logger;
        _redis = redis;
    }

    public double Rank { get; set; }
    public double Similarity { get; set; }

    public void OnGet(string id)
    {
        _logger.LogDebug(id);

        if (string.IsNullOrEmpty(id))
        {
            RedirectToPage("Index");
            return;
        }

        var db = _redis.GetDatabase();

        string? rankStr = db.StringGet("RANK-" + id);
        string? similarityStr = db.StringGet("SIMILARITY-" + id);

        Rank = double.TryParse(rankStr, out double r) ? r : 0.0;
        Similarity = double.TryParse(similarityStr, out double s) ? s : 0.0;
    }
}

