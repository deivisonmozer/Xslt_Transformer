using com.saxonica.config;
using Saxon.Api;
using System;
using System.IO;
using System.Xml;

namespace XsltTransformer.SaxonXsltTransformer
{
    public class SaxonTransformer
    {
        private readonly string _rootPath;
        private readonly XmlDocument _xmlDocument;

        public XdmNode ResultDocument { get; private set; }

        public SaxonTransformer(string rootPath, XmlDocument xmlDocument)
        {
            _rootPath = rootPath;
            _xmlDocument = xmlDocument;
        }

        public bool Transform()
        {

            var configuration = new EnterpriseConfiguration();
            string licensePath = "C:/Program Files/Saxonica/SaxonEE10.3N/bin/saxon-license.lic";
            var licenseFile = new FileStream (licensePath, FileMode.Open);
            configuration.setConfigurationProperty(FeatureKeys.LICENSE_FILE_LOCATION, licensePath);
            var features = configuration.getLicenseFeature(FeatureKeys.OPTIMIZATION_LEVEL); ;
            var teste1 = configuration.isLicenseFound();
            //var teste42 = configuration.isLicensedFeature(FeatureKeys.OPTIMIZATION_LEVEL.);
            
            

            //var configUri = new Uri($@"{_rootPath}\SaxonXsltTransformer\config.xsd");
            //var stream = new FileStream(configUri.OriginalString, FileMode.Open);
            //var processor = new Processor(stream, configUri);
            var processor = new Processor(true);
                        
            var xsltCompiler = processor.NewXsltCompiler();
            var xslUri = new Uri($@"{_rootPath}\BuiltInXsltTransformer\RawData.xsl");
            var xsltExecutable = xsltCompiler.Compile(xslUri);

            var sourceDocument = processor.NewDocumentBuilder().Build(_xmlDocument);

            var xsltTransformer = xsltExecutable.Load();
            xsltTransformer.InitialContextNode = sourceDocument;

            var destination = new XdmDestination();
            xsltTransformer.Run(destination);
            ResultDocument = destination.XdmNode;

            return true;
        }
    }
}
