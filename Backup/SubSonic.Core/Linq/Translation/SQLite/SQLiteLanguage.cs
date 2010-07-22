using System.Linq.Expressions;
using SubSonic.DataProviders;
using SubSonic.Linq.Structure;

namespace SubSonic.Linq.Translation.SQLite
{
    /// <summary>
    /// TSQL specific QueryLanguage
    /// </summary>
    public class SqliteLanguage : QueryLanguage
    {
        public SqliteLanguage(IDataProvider provider)
            : base(provider)
        {
        }


        public override string Quote(string name)
        {
            return string.Format("'{0}'", name);
            //return cb.QuoteIdentifier(name);
        }

        public override Expression Translate(Expression expression)
        {
            // fix up any order-by's
            expression = OrderByRewriter.Rewrite(expression);

            expression = base.Translate(expression);

            // convert skip/take info into RowNumber pattern
            if (isPaged(expression))
            {
                //we have some clean up here
                //paging embeds a SELECT in the FROM expression
                //this needs to be reset to the table name
                //and Skip/Take need to be reset
                var projection = expression as ProjectionExpression;

                //pull the select
                SelectExpression outer = projection.Source;

                //take out the nested FROM
                var inner = outer.From as SelectExpression;

                //and stick it on the outer
                outer.From = inner.From;

                //the outer Skip is in place
                //reset the Take since we need both on the Select
                //for the formatter to work
                outer.Take = inner.Take;


                expression = new ProjectionExpression(outer, projection.Projector);
            }

            // fix up any order-by's we may have changed
            expression = OrderByRewriter.Rewrite(expression);

            return expression;
        }

        public override string Format(Expression expression)
        {
            return SqliteFormatter.FormatExpression(expression);
        }

        private bool isPaged(Expression exp)
        {
            bool result = false;
            var projection = exp as ProjectionExpression;
            SelectExpression outer = projection.Source;

            //see if there is a nested select in the from
            if (outer.From is SelectExpression && outer.Skip != null)
            {
                var inner = outer.From as SelectExpression;
                result = inner.Take != null;
            }
            return result;
        }
    }
}