using Altova.AltovaXML;
using System;

namespace XsltTransformer.AltovaXsltTransformer
{
    public class AltovaTransformer
    {
        private readonly string _outputFile;
        private readonly string _xmlData = Data.Xml;
        private readonly string _stylesheet = "RawData";
        private readonly string _stylesheetParameter = "Value";
        private readonly string _stylesheetParameterValue = "\"\"";

        public string OutputString { get; private set; }

        public AltovaTransformer(string outputFile)
        {
            _outputFile = outputFile;
        }

        public bool Transform(bool generateFile)
        {
            bool transformed = true;
            string xsltDoc = string.Empty;

            var altovaXML = new Application();
            var xslt2 = altovaXML.XSLT2;

            try
            {
                xsltDoc = GetTransformXsltText(_stylesheet);
                if (_xmlData.Length > 0 && xsltDoc.Length > 0)
                {
                    xslt2.InputXMLFromText = _xmlData;
                    xslt2.XSLFromText = xsltDoc;
                    if (_stylesheetParameter.Length > 0)
                        xslt2.AddExternalParameter(_stylesheetParameter, _stylesheetParameterValue);

                    OutputString = xslt2.ExecuteAndGetResultAsString();
                    if (generateFile)
                        xslt2.Execute(_outputFile);
                }
                else
                {
                    transformed = false;
                    throw new Exception("XSLT conversion failed. XSLT stream or XML stream is empty.");
                }
            }
            catch (Exception ex)
            {
                transformed = false;
                throw new Exception(string.Format("XSLT conversion failed. Error: {0}", ex.Message), ex);
            }
            finally
            {
                System.Runtime.InteropServices.Marshal.ReleaseComObject(xslt2);
                System.Runtime.InteropServices.Marshal.ReleaseComObject(altovaXML);
            }

            return transformed;
        }

        private string GetTransformXsltText(string fileName) => XSLT.RawData;
    }
}
