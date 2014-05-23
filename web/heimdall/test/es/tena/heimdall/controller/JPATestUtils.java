
package es.tena.heimdall.controller;

import java.util.Properties;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 *
 * @author Ftena
 */
public class JPATestUtils {

    public static EntityManagerFactory getEntityManagerFactory(){
        return Persistence.createEntityManagerFactory("heimdall2PU");
    }
    
    public static EntityManager createEntityManager() {
        Properties emfProps = new Properties();
        String driver, url;
        // Here, connecting to Derby in-memory DB created by Maven inmemdb plugin (see pom.xml)
        // in-memory DB info: http://db.apache.org/derby/docs/10.7/devguide/cdevdvlpinmemdb.html
        driver = "com.mysql.jdbc.jdbc2.optional.MysqlDataSource";
        url = "jdbc:mysql://localhost:3306/heimdall?zeroDateTimeBehavior=convertToNull";

        emfProps.setProperty("javax.persistence.jdbc.driver", driver);
        emfProps.setProperty("javax.persistence.jdbc.url", url);
        emfProps.setProperty("javax.persistence.jdbc.user", "heimdall");
        emfProps.setProperty("javax.persistence.jdbc.password", "asgard");

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("heimdall2PU", emfProps);
        EntityManager em = emf.createEntityManager();
        return em;
    }
    
    public static String getDurationString(int seconds) {

        int days = seconds / 86400;    
        int hours = (seconds % 86400) / 3600;
        int minutes = (seconds % 3600) / 60;
        seconds = seconds % 60;

        return (days >0?twoDigitString(days)+"d":"") + twoDigitString(hours) + ":" + twoDigitString(minutes) + ":" + twoDigitString(seconds);
    }

    
    private static String twoDigitString(int number) {
        if (number == 0) {
            return "00";
        }
        if (number / 10 == 0) {
            return "0" + number;
        }
        return String.valueOf(number);
    }

}
