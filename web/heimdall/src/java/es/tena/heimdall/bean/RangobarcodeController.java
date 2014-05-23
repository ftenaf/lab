package es.tena.heimdall.bean;

import es.tena.heimdall.Rangobarcode;
import es.tena.heimdall.controller.RangobarcodeFacade;
import java.io.Serializable;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;

@Named(value = "rangobarcodeController")
@ViewScoped
public class RangobarcodeController extends AbstractController<Rangobarcode> implements Serializable {

    @Inject
    private RangobarcodeFacade ejbFacade;

    public RangobarcodeController() {
        super(Rangobarcode.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
    }

}
