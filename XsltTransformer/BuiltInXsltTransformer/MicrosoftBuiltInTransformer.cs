using System.Xml.Xsl;

namespace XsltTransformer.BuiltInXsltTransformer
{
    public class MicrosoftBuiltInTransformer
    {
        private readonly XslCompiledTransform _xslTransform = new XslCompiledTransform();
        private readonly string _rootPath;

        public MicrosoftBuiltInTransformer(string rootPath)
        {
            _rootPath = $@"{rootPath}\BuiltInXsltTransformer";
        }

        public void Transform()
        {
            var stylesheetUri = $@"{_rootPath}\RawData.xsl";
            _xslTransform.Load(stylesheetUri);

            var inputUri = $@"{_rootPath}\Data.xml";
            var outputUri = $@"{_rootPath}\Output.txt";
            _xslTransform.Transform(inputUri, outputUri);
        }
    }
}
