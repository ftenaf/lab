/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package es.tena.heimdall;

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
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Ftena
 */
@Entity
@Table(name = "rangobarcode")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Rangobarcode.findAll", query = "SELECT r FROM Rangobarcode r"),
    @NamedQuery(name = "Rangobarcode.findById", query = "SELECT r FROM Rangobarcode r WHERE r.id = :id"),
    @NamedQuery(name = "Rangobarcode.findByFecha", query = "SELECT r FROM Rangobarcode r WHERE r.fecha = :fecha"),
    //@NamedQuery(name = "Rangobarcode.findBy4Dias", query = "SELECT r FROM Rangobarcode r WHERE r.fecha > DATE_SUB(NOW(), INTERVAL 4 DAY)"),
    @NamedQuery(name = "Rangobarcode.findByDesde", query = "SELECT r FROM Rangobarcode r WHERE r.desde = :desde"),
    @NamedQuery(name = "Rangobarcode.findByHasta", query = "SELECT r FROM Rangobarcode r WHERE r.hasta = :hasta")})
public class Rangobarcode implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Column(name = "fecha")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fecha;
    @Size(max = 128)
    @Column(name = "desde")
    private String desde;
    @Size(max = 128)
    @Column(name = "hasta")
    private String hasta;
    @JoinColumn(name = "idUser", referencedColumnName = "id")
    @ManyToOne
    private User idUser;

    public Rangobarcode() {
    }

    public Rangobarcode(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getDesde() {
        return desde;
    }

    public void setDesde(String desde) {
        this.desde = desde;
    }

    public String getHasta() {
        return hasta;
    }

    public void setHasta(String hasta) {
        this.hasta = hasta;
    }

    public User getIdUser() {
        return idUser;
    }

    public void setIdUser(User idUser) {
        this.idUser = idUser;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Rangobarcode)) {
            return false;
        }
        Rangobarcode other = (Rangobarcode) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "es.tena.heimdall.Rangobarcode[ id=" + id + " ]";
    }
    
}
