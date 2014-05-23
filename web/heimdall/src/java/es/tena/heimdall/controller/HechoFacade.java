/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package es.tena.heimdall.controller;

import es.tena.heimdall.Hecho;
import es.tena.heimdall.bean.UserDayTime;
import java.util.Date;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

/**
 *
 * @author Ftena
 */
@Stateless
public class HechoFacade extends AbstractFacade<Hecho> {
    @PersistenceContext(unitName = "heimdall2PU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public HechoFacade() {
        super(Hecho.class);
    }

    @Override
    public void create(Hecho entity) {
        entity.setFechaCambio(new Date());
        entity.setFechaFin(null);
        entity.setTiempo(0);
        if (entity.getEstado().equalsIgnoreCase("Pendiente")){
            entity.setFechaPendiente(new Date());
        }else{
            if (entity.getEstado().equalsIgnoreCase("Trabajando")){
                entity.setFechaIni(new Date());
            }
            entity.setFechaPendiente(null);
        }
        getEntityManager().persist(entity);
    }
    
    @Override
    public void edit(Hecho entity) {        
        Hecho entity_old = entity.getId() != null ? find(entity.getId()): null;
        System.out.println("-- Modificando: "+ entity.getId() +"-"+ entity.getNombre() +"-"+ entity.getEstado() +" de ("+ (entity_old != null?entity_old.getEstado():"") +")");
        Integer tiempo = entity.getTiempo() == null?0:entity.getTiempo();
            
        if (entity_old != null){
            // si pasamos a un estado nuevo 
            if (!entity_old.getEstado().equalsIgnoreCase(entity.getEstado()) && entity_old.getEstado().equalsIgnoreCase("Trabajando")){
                tiempo = tiempo + safeLongToInt((new Date().getTime() - entity.getFechaCambio().getTime())/1000);
            }
        }
        
        if (entity_old == null || !entity.getEstado().equalsIgnoreCase(entity_old.getEstado())){
            if (entity.getEstado().equalsIgnoreCase("Terminado")){
                entity.setFechaFin(new Date());
            }else {
                if (entity.getEstado().equalsIgnoreCase("Pendiente")){
                    entity.setFechaPendiente(new Date());
                }else{
                    if (entity.getEstado().equalsIgnoreCase("Trabajando")){
                        if (entity.getFechaIni() == null){
                            entity.setFechaIni(new Date());
                        }
                    }
                }
            }

            entity.setFechaCambio(new Date());
        }

        entity.setTiempo(tiempo);        
        getEntityManager().merge(entity);
    }
    
    public List<Hecho> findByUser(Integer idUser) {
        TypedQuery<Hecho> queryByUser = getEntityManager().createNamedQuery("Hecho.findByUser", Hecho.class);
        queryByUser.setParameter ("idUser", idUser);
        List<Hecho> hechos = queryByUser.getResultList();
        return hechos;
    }
    
    public List<Hecho> findByState() {
        TypedQuery<Hecho> query = getEntityManager().createNamedQuery("Hecho.findByState", Hecho.class);
        List<Hecho> hechos = query.getResultList();
        return hechos;
    }
    
    public List<Hecho> findByOrder() {
        TypedQuery<Hecho> query = getEntityManager().createNamedQuery("Hecho.findAll", Hecho.class);
        List<Hecho> hechos = query.getResultList();
        return hechos;
    }
    
    public List<UserDayTime> findByTaskAndUser() {
            
        String q = "SELECT new es.tena.heimdall.bean.UserDayTime(h.idUser, h.idTarea, SUM(h.tiempo)) from Hecho h group by h.idUser, h.idTarea order by h.idUser.id, h.idTarea.id";
        TypedQuery<UserDayTime> query = em.createQuery(q, UserDayTime.class);
        List<UserDayTime> list = query.getResultList();
        return list;
    }

    public List<UserDayTime> findByDayAndUser() {
            
        String q = "SELECT new es.tena.heimdall.bean.UserDayTime(h.idUser, h.idTarea, SUM(h.tiempo), CAST(h.fechaIni as date)) from Hecho h group by h.idUser, h.idTarea, CAST(h.fechaIni as date) order by CAST(h.fechaIni as date), h.idUser.id, h.idtarea";
        TypedQuery<UserDayTime> query = em.createQuery(q, UserDayTime.class);
        List<UserDayTime> list = query.getResultList();
        return list;
    }
        
    public static int safeLongToInt(long l) {
        if (l < Integer.MIN_VALUE || l > Integer.MAX_VALUE) {
            throw new IllegalArgumentException
                (l + " cannot be cast to int without changing its value.");
        }
        return (int) l;
    }
}
