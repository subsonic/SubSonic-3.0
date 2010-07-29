using SubSonic.DataProviders;
using System.Linq.Expressions;
using System;
namespace SubSonic.Linq.Structure
{
    /// <summary>
    /// Defines the language rules for the query provider
    /// </summary>
    public interface IQueryLanguage
    {
        string ClientName { get; set; }
        IDataProvider DataProvider { get;set;}
        string Quote(string name);
        bool IsScalar(Type type);
        bool CanBeColumn(Expression expression);
        Expression Translate(Expression expression);
        string Format(Expression expression);
        Expression Parameterize(Expression expression);
    }
}

