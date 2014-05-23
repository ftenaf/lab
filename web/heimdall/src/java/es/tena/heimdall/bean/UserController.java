package es.tena.heimdall.bean;

import es.tena.heimdall.User;
import es.tena.heimdall.controller.UserFacade;
import java.io.Serializable;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;

@Named(value = "userController")
@ViewScoped
public class UserController extends AbstractController<User> implements Serializable {

    @Inject
    private UserFacade ejbFacade;

    public UserController() {
        super(User.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
    }

}
