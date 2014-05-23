package es.tena.vodafone.facturas;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 * Main class to generate the database tables and insert an xml instance
 * @author Francisco Tena <francisco.tena@gmail.com>
 */
public class Main {

    private static EntityManagerFactory entityManagerFactory;

    public static void setUp() throws Exception {
        entityManagerFactory = Persistence.createEntityManagerFactory("es.tena.vodafone.factura");
    }

    public static void main(String[] args) throws Exception {
        Helper h = new Helper();
        h.start(null);

    }
}
