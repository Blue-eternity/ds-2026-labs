using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using StackExchange.Redis;
using System.Security.Cryptography;
using System.Text;

namespace Valuator.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly IConnectionMultiplexer _redis;

    public IndexModel(ILogger<IndexModel> logger, IConnectionMultiplexer redis)
    {
        _logger = logger;
        _redis = redis;
    }

    public IActionResult OnPost(string text)
    {
        _logger.LogDebug(text);

        if (string.IsNullOrEmpty(text))
        {
            return RedirectToPage("Index");
        }

        var db = _redis.GetDatabase();

        string id = Guid.NewGuid().ToString();
        string textKey = "TEXT-" + id;
        db.StringSet(textKey, text);

        int alphabeticCount = text.Count(c => char.IsLetter(c));
        double rank = 1.0 - (double)alphabeticCount / text.Length;

        string rankKey = "RANK-" + id;
        db.StringSet(rankKey, rank.ToString());

        string textHash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text))).ToLowerInvariant();
        string duplicateKey = "DUPLICATE-" + textHash;

        int similarity = db.KeyExists(duplicateKey) ? 1 : 0;
        string similarityKey = "SIMILARITY-" + id;
        db.StringSet(similarityKey, similarity.ToString());

        if (similarity == 0)
        {
            db.StringSet(duplicateKey, "1");
        }

        return Redirect($"summary?id={id}");
    }
}