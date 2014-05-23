package es.tena.vodafone.facturas;

import es.tena.vodafone.factura.INVOICEType;
import es.tena.vodafone.factura.ObjectFactory;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

/**
 * Helper to create database
 * @author Francisco Tena <francisco.tena@gmail.com>
 */
public class Helper {

    private JAXBContext context;

    private ObjectFactory objectFactory;

    private EntityManagerFactory entityManagerFactory;

    public long start(Object o) throws Exception {
       
        setUp();

        final Object object;
        final Unmarshaller unmarshaller = context.createUnmarshaller();
        final INVOICEType invoice;

        if (o != null) {
            String purchaseOrderString = (String) o;
            InputStream stream = new ByteArrayInputStream(purchaseOrderString.getBytes("UTF-8"));
            object = unmarshaller.unmarshal(stream);
            invoice = ((JAXBElement<INVOICEType>) object).getValue();
        } else {

            object = unmarshaller.unmarshal(new File("src/test/samples/FAC0_....xml"));
            invoice = ((JAXBElement<INVOICEType>) object).getValue();

        }

        long id = persist(invoice);

        return id;
    }

    public long persist(INVOICEType invoice) {
        try {
            setPersistenceProperties();
        } catch (IOException ex) {
            Logger.getLogger(Helper.class.getName()).log(Level.SEVERE, null, ex);
        }

        final EntityManager saveManager = entityManagerFactory
                .createEntityManager();
        saveManager.getTransaction().begin();
        saveManager.persist(invoice);
        saveManager.getTransaction().commit();
        saveManager.close();

        return invoice.getHjid();
    }

    public String loadAsString(long id) {
        final EntityManager loadManager = entityManagerFactory.createEntityManager();
        final INVOICEType beta = loadManager.find(INVOICEType.class, id);

        final Marshaller marshaller;
        OutputStream os = new ByteArrayOutputStream();

        try {
            marshaller = context.createMarshaller();
            marshaller.marshal(objectFactory.createINVOICE(beta), os);
        } catch (JAXBException ex) {
            Logger.getLogger(Helper.class.getName()).log(Level.SEVERE, null, ex);
        }

        loadManager.close();

        return os.toString();
    }

    public void setPersistenceProperties() throws IOException {

        final Properties persistenceProperties = new Properties();
        InputStream is = null;
        try {
            is = getClass().getClassLoader().getResourceAsStream("persistence.properties");
            persistenceProperties.load(is);
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException ignored) {
                }
            }
        }

        entityManagerFactory = new Persistence().createEntityManagerFactory("es.tena.vodafone.factura", persistenceProperties);
    }

    protected void setUp() throws Exception {
        context = JAXBContext.newInstance("es.tena.vodafone.factura");
        objectFactory = new ObjectFactory();
    }

    public void setUpPersistence() throws Exception {
        entityManagerFactory = Persistence.createEntityManagerFactory("es.tena.vodafone.factura");
    }

}
