using System;

namespace SubSonic.DataProviders.Log
{
    public interface ILogAdapter
    {
        void Log(String message);
    }
}