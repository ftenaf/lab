package es.tena.heimdall.controller;

import es.tena.heimdall.bean.UserDayTime;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

/**
 *
 * @author Ftena
 */
public class HechoFacadeTest {
    

    static EntityManager em;
    
    public HechoFacadeTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
        em = JPATestUtils.createEntityManager();     
    }
    
    @AfterClass
    public static void tearDownClass() {
        em.close();
    }
    
    @Before
    public void setUp() {
        
    }
    
    @After
    public void tearDown() {
    }


    @Test
    @Ignore
    public void findByUserTest() {
    }

    @Test
    @Ignore
    public void findByState() {
    }

    @Test
    @Ignore
    public void findByOrder() {
    }

    @Test
    @Ignore
    public void findByTaskAndUser() {
           
        String q = "SELECT new es.tena.heimdall.bean.UserDayTime(h.idUser, h.idTarea, SUM(h.tiempo)) from Hecho h group by h.idUser, h.idTarea";
        TypedQuery<UserDayTime> query = em.createQuery(q, UserDayTime.class);
        List<UserDayTime> list = query.getResultList();
        for (UserDayTime userTaskTime : list) {
            System.out.println("---"+ userTaskTime.toString());
        }        
    }

    @Test
//    @Ignore
    public void findByDayAndUser() {
        String q = "SELECT new es.tena.heimdall.bean.UserDayTime(h.idUser, h.idTarea, SUM(h.tiempo), CAST(h.fechaIni as date)) from Hecho h group by h.idUser, h.idTarea, CAST(h.fechaIni as date)";
        TypedQuery<UserDayTime> query = em.createQuery(q, UserDayTime.class);
        List<UserDayTime> list = query.getResultList();
        for (UserDayTime userTaskTime : list) {
            System.out.println("---"+ userTaskTime);
        }     
    }

    @Test
    @Ignore
    public void safeLongToInt() {
        Date fecha1 = new Date(2013, 11, 11, 9, 54, 52);
        Date fecha2 = new Date(2013, 11, 11, 17, 50, 26);
        long l = (fecha2.getTime() - fecha1.getTime())/1000;
        if (l < Integer.MIN_VALUE || l > Integer.MAX_VALUE) {
            throw new IllegalArgumentException(l + " cannot be cast to int without changing its value.");
        }
//        assert.equals((int)l == l);
        System.out.println(l);
        System.out.println(JPATestUtils.getDurationString((int)l));
        System.out.println((int)l);

    }
}