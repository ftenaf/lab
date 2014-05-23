package es.tena.heimdall.bean;

import es.tena.heimdall.Actividad;
import es.tena.heimdall.controller.ActividadFacade;
import java.io.Serializable;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;

@Named(value = "actividadController")
@ViewScoped
public class ActividadController extends AbstractController<Actividad> implements Serializable {

    @Inject
    private ActividadFacade ejbFacade;

    public ActividadController() {
        super(Actividad.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
    }

}
