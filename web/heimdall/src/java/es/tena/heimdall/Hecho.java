/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es.tena.heimdall;

import es.tena.heimdall.bean.util.JsfUtil;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Ftena
 */
@Entity
@Table(name = "hecho")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Hecho.findAll", query = "SELECT h FROM Hecho h order by h.id desc, h.estado asc"),
    @NamedQuery(name = "Hecho.findById", query = "SELECT h FROM Hecho h WHERE h.id = :id"),
    @NamedQuery(name = "Hecho.findByNombre", query = "SELECT h FROM Hecho h WHERE h.nombre = :nombre"),
    @NamedQuery(name = "Hecho.findByState", query = "SELECT h FROM Hecho h WHERE h.estado <> 'Terminado'"),
    @NamedQuery(name = "Hecho.findByUser", query = "SELECT h FROM Hecho h WHERE h.idUser = :idUser"),
    @NamedQuery(name = "Hecho.findByFechaIni", query = "SELECT h FROM Hecho h WHERE h.fechaIni = :fechaIni"),
    @NamedQuery(name = "Hecho.findByFechaFin", query = "SELECT h FROM Hecho h WHERE h.fechaFin = :fechaFin"),
    @NamedQuery(name = "Hecho.findByCantidad", query = "SELECT h FROM Hecho h WHERE h.cantidad = :cantidad"),
    @NamedQuery(name = "Hecho.findByDetalle", query = "SELECT h FROM Hecho h WHERE h.detalle = :detalle")})

public class Hecho implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Size(max = 45)
    @Column(name = "nombre")
    private String nombre;
    @Column(name = "fechaIni")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaIni;
    @Column(name = "fechaFin")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaFin;
    @Column(name = "fechaPendiente")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaPendiente;
    @Column(name = "fechaCambio")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaCambio;
    @Column(name = "cantidad")
    private Integer cantidad;
    @Size(max = 500)
    @Column(name = "detalle")
    private String detalle;
    @JoinColumn(name = "idTarea", referencedColumnName = "id")
    @ManyToOne
    private Tarea idTarea;
    @JoinColumn(name = "idUser", referencedColumnName = "id")
    @ManyToOne
    private User idUser;
    @Transient
    private Actividad idActividad;
    @Column(name = "tiempo")
    private Integer tiempo;

    @Size(max = 45)
    @Column(name = "estado")
    private String estado;

    public Hecho() {
    }

    public Hecho(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFechaIni() {
        return fechaIni;
    }

    public void setFechaIni(Date fechaIni) {
        this.fechaIni = fechaIni;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
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

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Integer getTiempo() {
        return tiempo;
    }

    public void setTiempo(Integer tiempo) {
        this.tiempo = tiempo;
    }

    public Date getFechaPendiente() {
        return fechaPendiente;
    }

    public void setFechaPendiente(Date fechaPendiente) {
        this.fechaPendiente = fechaPendiente;
    }

    public Date getFechaCambio() {
        return fechaCambio;
    }

    public void setFechaCambio(Date fechaCambio) {
        this.fechaCambio = fechaCambio;
    }

    public String getTiempoHoras() {
        return JsfUtil.getDurationString(getTiempo());
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Hecho)) {
            return false;
        }
        Hecho other = (Hecho) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "es.tena.heimdall.Hecho[ id=" + id + " ]";
    }

}
