package es.tena.vodafone.facturas;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.SourceLocator;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Generic class to use XSL on a XML
 * @author Francisco Tena <francisco.tena@gmail.com>
 */
public class XSL {
    
    public static void xsl(String inFilename, String outFilename, String xslFilename) {
        try {
            TransformerFactory factory = TransformerFactory.newInstance();

            Templates template = factory.newTemplates(new StreamSource(new FileInputStream(xslFilename)));

            Transformer xformer = template.newTransformer();

            Source source = new StreamSource(new FileInputStream(inFilename));
            Result result = new StreamResult(new FileOutputStream(outFilename));

            xformer.transform(source, result);
        } catch (FileNotFoundException e) {
        } catch (TransformerConfigurationException e) {
        } catch (TransformerException e) {
            SourceLocator locator = e.getLocator();
            int col = locator.getColumnNumber();
            int line = locator.getLineNumber();
            String publicId = locator.getPublicId();
            String systemId = locator.getSystemId();
        }
    }
}