/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es.tena.heimdall.controller;

import es.tena.heimdall.Tarea;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

/**
 *
 * @author Ftena
 */
@Stateless
public class TareaFacade extends AbstractFacade<Tarea> {

    @PersistenceContext(unitName = "heimdall2PU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public TareaFacade() {
        super(Tarea.class);
    }

    public List<Tarea> findByActividad(Integer idActividad) {
                
        TypedQuery<Tarea> queryTareasByActividad = getEntityManager().createNamedQuery("Tarea.findByActividad", Tarea.class);
        queryTareasByActividad.setParameter ("idActividad", idActividad);
        List<Tarea> tareas = queryTareasByActividad.getResultList();
        return tareas;
        
//        CriteriaBuilder cb = getEntityManager().getCriteriaBuilder();
//        CriteriaQuery cq = cb.createQuery();
//        Root<Tarea> root = cq.from(Tarea.class);
//        cq.select(root);
//        Predicate p = cb.equal(root.get("idActividad"), idActividad);
//        cq.where(p);
//        Query q = getEntityManager().createQuery(cq);
//        return q.getResultList();
        
    }
}
