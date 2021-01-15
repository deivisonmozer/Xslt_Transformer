using System;
using System.Diagnostics;
using System.IO;
using XsltTransformer.AltovaXsltTransformer;
using XsltTransformer.BuiltInXsltTransformer;
using XsltTransformer.SaxonXsltTransformer;

namespace XsltTransformer
{
    static class Program
    {   
        static readonly string _rootPath = Directory.GetParent(Environment.CurrentDirectory).Parent.FullName;

        static void Main(string[] args)
        {
            var sw = new Stopwatch();

            sw.Start();
            UseAltovaTransformer();
            sw.Stop();
            Console.WriteLine($"Altova elapsed time in seconds: {sw.ElapsedMilliseconds / 1000.0}s");
            sw.Reset();

            sw.Start();
            UseSaxonTransformer();
            sw.Stop();
            Console.WriteLine($"Saxon elapsed time in seconds: {sw.ElapsedMilliseconds / 1000.0}s");
            sw.Reset();

            Console.ReadKey();
        }

        private static void UseAltovaTransformer()
        {
            var altovaTransformer = new AltovaTransformer(_rootPath);
            var result = altovaTransformer.Transform(generateFile: false);
            //Console.WriteLine($"Altova transform result: {result} / Output: {altovaTransformer.OutputString}");
        }

        private static void UseMicrosoftTransformer()
        {
            var msTransformer = new MicrosoftBuiltInTransformer(_rootPath);
            msTransformer.Transform();
        }

        private static void UseSaxonTransformer()
        {
            var xmlDocument = Data.BuildXmlDocument();
            var saxonTransformer = new SaxonTransformer(_rootPath, xmlDocument);
            var result = saxonTransformer.Transform();
            //Console.WriteLine($"Saxon transform result: {result} / Output: {saxonTransformer.ResultDocument}");
        }
    }
}
    