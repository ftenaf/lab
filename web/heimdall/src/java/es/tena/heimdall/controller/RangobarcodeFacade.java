/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es.tena.heimdall.controller;

import es.tena.heimdall.Rangobarcode;
import java.util.Date;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TemporalType;
import org.joda.time.DateTime;

/**
 *
 * @author Ftena
 */
@Stateless
public class RangobarcodeFacade extends AbstractFacade<Rangobarcode> {

    @PersistenceContext(unitName = "heimdall2PU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public RangobarcodeFacade() {
        super(Rangobarcode.class);
    }

    public List<Rangobarcode> findBy4Date() {
//
//        TypedQuery<Rangobarcode> query = getEntityManager().createNamedQuery("Rangobarcode.findBy4Dias", Rangobarcode.class);
//        List<Rangobarcode> rangos = query.getResultList();
//        return rangos;
        DateTime dt = new DateTime();
        
        return em.createQuery("SELECT e from Rangobarcode e WHERE e.fecha BETWEEN ?1 AND ?2")
            .setParameter(1, new Date(), TemporalType.DATE)
            .setParameter(2, dt.minusDays(4).toDate(), TemporalType.DATE).getResultList();
        
    }

}
