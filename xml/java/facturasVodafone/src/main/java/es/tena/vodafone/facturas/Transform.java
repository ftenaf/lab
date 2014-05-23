package es.tena.vodafone.facturas;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * Generates an HTML from the XML applying XSLT
 * @author Francisco Tena <francisco.tena@gmail.com>
 */
public class Transform {
    public static void main(String[] args) throws IOException, URISyntaxException, TransformerException {
        TransformerFactory factory = TransformerFactory.newInstance();
        Source xslt = new StreamSource(new File("src/test/samples/vf_generar_factura_html.xslt"));

        Transformer transformer = factory.newTransformer(xslt);
        Source text = new StreamSource(new File("src/test/samples/FAC0_.....xml"));
        transformer.transform(text, new StreamResult(new File("src/test/samples/output.xml")));
    }
}