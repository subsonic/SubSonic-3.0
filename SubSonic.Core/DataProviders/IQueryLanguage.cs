using System;using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.Composition;
using System.Linq.Expressions;

namespace SubSonic.DataProviders
{
    [InheritedExport]
    public interface IQueryLanguage
    {
        string ClientName { get; set; }
        IDataProvider DataProvider { get; set; }
        string Quote(string name);
        
        bool IsScalar(Type type);
       

        
        bool CanBeColumn(Expression expression);
       

        
        Expression Translate(Expression expression);
        
        string Format(Expression expression);

        Expression Parameterize(Expression expression);
        
 
    }
}
