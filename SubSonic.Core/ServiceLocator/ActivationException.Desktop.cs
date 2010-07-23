using System;
using System.Runtime.Serialization;

namespace Microsoft.Practices.ServiceLocation
{
    [Serializable]
    public partial class ActivationException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="T:System.Exception" /> class with serialized data.
        /// </summary>
        /// <param name="info">
        /// The <see cref="T:System.Runtime.Serialization.SerializationInfo" /> that holds the serialized object data about the exception being thrown. 
        /// </param>
        /// <param name="context">
        /// The <see cref="T:System.Runtime.Serialization.StreamingContext" /> that contains contextual information about the source or destination. 
        /// </param>
        /// <exception cref="T:System.ArgumentNullException">
        /// The <paramref name="info" /> parameter is null. 
        /// </exception>
        /// <exception cref="T:System.Runtime.Serialization.SerializationException">
        /// The class name is null or <see cref="P:System.Exception.HResult" /> is zero (0). 
        /// </exception>
        protected ActivationException(SerializationInfo info, StreamingContext context) : base(info, context) {}
    }
}
