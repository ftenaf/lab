package es.tena.heimdall.bean;

import es.tena.heimdall.Tarea;
import es.tena.heimdall.controller.TareaFacade;
import java.io.Serializable;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;

@Named(value = "tareaController")
@ViewScoped
public class TareaController extends AbstractController<Tarea> implements Serializable {

    @Inject
    private TareaFacade ejbFacade;

    public TareaController() {
        super(Tarea.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
    }

}
