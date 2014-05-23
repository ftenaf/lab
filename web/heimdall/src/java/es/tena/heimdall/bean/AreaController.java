package es.tena.heimdall.bean;

import es.tena.heimdall.Area;
import es.tena.heimdall.controller.AreaFacade;
import java.io.Serializable;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;

@Named(value = "areaController")
@ViewScoped
public class AreaController extends AbstractController<Area> implements Serializable {

    @Inject
    private AreaFacade ejbFacade;

    public AreaController() {
        super(Area.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
    }

}
