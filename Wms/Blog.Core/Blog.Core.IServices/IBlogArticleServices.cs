using Blog.Core.IServices.BASE;
using Blog.Core.Model.Models;
using Blog.Core.Model.ViewModels;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Blog.Core.IServices
{
    public interface IBlogArticleServices :IBaseServices<BlogArticle>
    {
        Task<List<BlogArticle>> GetBlogs();
        Task<BlogViewModels> GetBlogDetails(int id);
        public static string ToCamel(string className)
        {
            StringBuilder tableName = new StringBuilder();
            for (int i = 0; i < className.Length; i++)
            {
                if (className[i].ToString() == "_")
                {
                    i++;
                    tableName.Append(className[i].ToString().ToUpper());
                }
                else
                {
                    if (i == 0)
                    {
                        tableName.Append(className[i].ToString().ToLower());
                    }
                    else
                    {
                        tableName.Append(className[i].ToString());
                    }
                }
            }
            return tableName.ToString();
        }

    }

}
