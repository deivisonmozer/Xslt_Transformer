using Saxon.Api;
using System;
using System.IO;
using System.Xml;
using XmlPrime;

namespace XsltTransformer.XmlPrimeXsltTransformer
{
	public class XmlPrimeTransformer
	{

		private readonly string _rootPath;

		//public string outputPath = "C:/test/test.csv";
		public string outputPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "\\test.csv";
		public XdmNode ResultDocument { get; private set; }

		public XmlPrimeTransformer(string rootPath)
		{
			_rootPath = rootPath;
		}

		public void Transform()
		{
			var nameTable = new NameTable();

			var xmlReaderSettings = new XmlReaderSettings { NameTable = nameTable };

			XdmDocument document;
			using (var reader = XmlReader.Create(_rootPath + "\\XmlPrimeXsltTransformer\\data.xml", xmlReaderSettings))
			{
				document = new XdmDocument(reader);
			}

			var xsltSettings = new XsltSettings(nameTable) { ContextItemType = XdmType.Node };

			var xslt = Xslt.Compile(_rootPath + "\\XmlPrimeXsltTransformer\\template.xsl", xsltSettings);

			var contextItem = document.CreateNavigator();
			var settings = new DynamicContextSettings { ContextItem = contextItem };

			using (var outputStream = File.Create(outputPath))

				xslt.ApplyTemplates(settings, outputStream);
		}

	}
}

