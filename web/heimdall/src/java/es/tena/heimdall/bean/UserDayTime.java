/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package es.tena.heimdall.bean;

import es.tena.heimdall.Actividad;
import es.tena.heimdall.Tarea;
import es.tena.heimdall.User;
import java.util.Date;

/**
 *
 * @author Ftena
 */
public class UserDayTime  {
   
    private Tarea idTarea;
    
    private User idUser;
    
    private Actividad idActividad;

    private Long tiempo;
    
    private Date fechaIni;

    public UserDayTime(User idUser, Tarea idTarea, Long tiempo) {
        this.idTarea = idTarea;
        this.idUser = idUser;
        this.tiempo = tiempo;
    }
    
    public UserDayTime(User idUser, Tarea idTarea, Long tiempo, Date fecha) {
        this.idTarea = idTarea;
        this.idUser = idUser;
        this.tiempo = tiempo;
        this.fechaIni = fecha;
    }

    public Tarea getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(Tarea idTarea) {
        this.idTarea = idTarea;
    }

    public User getIdUser() {
        return idUser;
    }

    public void setIdUser(User idUser) {
        this.idUser = idUser;
    }

    public Actividad getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(Actividad idActividad) {
        this.idActividad = idActividad;
    }

    public Long getTiempo() {
        return tiempo;
    }

    public void setTiempo(Long tiempo) {
        this.tiempo = tiempo;
    }

    public Date getFechaIni() {
        return fechaIni;
    }

    public void setFechaIni(Date fechaIni) {
        this.fechaIni = fechaIni;
    }


    @Override
    public boolean equals(Object object) {
        if (!(object instanceof UserDayTime)) {
            return false;
        }
        UserDayTime other = (UserDayTime) object;
        if (!this.fechaIni.equals(other.fechaIni) || !this.idActividad.equals(other.idActividad) || !this.idTarea.equals(other.idTarea) || !this.idUser.equals(other.idUser) || !this.tiempo.equals(other.tiempo)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "UserTaskTime[ idTarea=" + idTarea.getNombre() + " ][ idUser=" + idUser.getLogin() + " ][ tiempo=" + tiempo + " ][fecha="+ fechaIni +"]";

    }
    
}
