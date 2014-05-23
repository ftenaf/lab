package es.tena.heimdall.bean;

import es.tena.heimdall.Actividad;
import es.tena.heimdall.Hecho;
import es.tena.heimdall.Rangobarcode;
import es.tena.heimdall.Tarea;
import es.tena.heimdall.controller.HechoFacade;
import es.tena.heimdall.controller.RangobarcodeFacade;
import es.tena.heimdall.controller.TareaFacade;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Named;
import javax.inject.Inject;
import javax.faces.view.ViewScoped;
import org.primefaces.model.chart.CartesianChartModel;
import org.primefaces.model.chart.ChartSeries;
import org.primefaces.model.chart.DonutChartModel;

@Named(value = "hechoController")
@ViewScoped
public class HechoController extends AbstractController<Hecho> implements Serializable {

    private CartesianChartModel categoryModel;
    private DonutChartModel donutModel;
    private long maxBarValue = 300;
    private long slideValue = 0;

    private List<Actividad> actividades = new ArrayList<>();
    private List<Tarea> tareas = new ArrayList<>();
    private List<Rangobarcode> rangos = new ArrayList<>();

    @Inject
    private HechoFacade ejbFacade;

    @Inject
    private TareaFacade tareaFacade;

    @Inject
    private RangobarcodeFacade rangoFacade;

    public HechoController() {
        super(Hecho.class);
    }

    @PostConstruct
    public void init() {
        super.setFacade(ejbFacade);
        createCategoryModel();
    }
//    
//    @Override
//    public List<Hecho> getItems() {
//        setItems(ejbFacade.findByOrder());   
//        return super.getItems();
//    }

    public void updateItems() {
        getItems();
    }

    @Override
    public Hecho prepareCreate(ActionEvent event) {
        System.out.println("-- preparando para crear: ");
        tareas = new ArrayList<>();
        return super.prepareCreate(event);
    }

    public void handleActividadChange() {

        if (getSelected().getIdActividad() != null) {
            tareas = tareaFacade.findByActividad(getSelected().getIdActividad().getId());
        } else {
            tareas = new ArrayList<>();
        }
    }

    public void handleTareaChange() {

        if (getSelected().getIdTarea().getNombre().toLowerCase().contains("etiqueta manual")) {
            rangos = rangoFacade.findBy4Date();
        } else {
            rangos = new ArrayList<>();
        }
    }

    public void working() {
        if (getSelected() != null) {
            ResourceBundle bundle = ResourceBundle.getBundle("/Bundle");
            getSelected().setEstado(bundle.getString("enproceso"));
            save();
        } else {
            FacesMessage msg = new FacesMessage("No Seleccionado", "Seleccione una tarea primero");
            FacesContext.getCurrentInstance().addMessage(null, msg);
        }
    }

    public void pause() {
        if (getSelected() != null) {
            ResourceBundle bundle = ResourceBundle.getBundle("/Bundle");
            getSelected().setEstado(bundle.getString("pendiente"));
            save();
        } else {
            FacesMessage msg = new FacesMessage("No Seleccionado", "Seleccione una tarea primero");
            FacesContext.getCurrentInstance().addMessage(null, msg);
        }
    }

    public void finish() {
        if (getSelected() != null) {
            ResourceBundle bundle = ResourceBundle.getBundle("/Bundle");
            getSelected().setEstado(bundle.getString("terminado"));
            save();
        } else {
            FacesMessage msg = new FacesMessage("No Seleccionado", "Seleccione una tarea primero");
            FacesContext.getCurrentInstance().addMessage(null, msg);
        }
    }

    public CartesianChartModel getCategoryModel() {
        return categoryModel;
    }

    public void createCategoryModel() {
        if (categoryModel == null) {
            List<UserDayTime> list = ejbFacade.findByTaskAndUser();
            UserDayTime old = null;
            categoryModel = new CartesianChartModel();
            ChartSeries chart = null;
            for (Iterator<UserDayTime> it = list.iterator(); it.hasNext();) {
                UserDayTime userDayTime = it.next();
                // cambio de usuario
                if (old == null || !old.getIdUser().getId().equals(userDayTime.getIdUser().getId())) {
                    if (chart != null) {
                        categoryModel.addSeries(chart);
                    }
                    chart = new ChartSeries();
                    chart.setLabel(userDayTime.getIdUser().getLogin());
                }
                Long tiempo = userDayTime.getTiempo();
                if (tiempo > getMaxBarValue()) {
                    setMaxBarValue(tiempo);
                }
                chart.set(userDayTime.getIdTarea().getNombreActividad(), tiempo);
                old = userDayTime;
            }
            if (chart != null) categoryModel.addSeries(chart);
        }
    }

    private void createDonutModel() {
        donutModel = new DonutChartModel();

        Map<String, Number> circle1 = new LinkedHashMap<>();
        List<UserDayTime> list = ejbFacade.findByDayAndUser();
        for (UserDayTime userDayTime : list) {
            circle1.put(userDayTime.getIdTarea().getNombre(), userDayTime.getTiempo());
        }
        donutModel.addCircle(circle1);
    }

    public void loadCurrentRequest(ActionEvent event) {
        setSelected((Hecho) event.getComponent().getAttributes().get("node"));
        if (getSelected() != null) {
            try {
                System.out.println("-- Seleccionado: " + getSelected().getId());
                FacesMessage msg = new FacesMessage("Seleccionado", "" + getSelected().getId());
                FacesContext.getCurrentInstance().addMessage(null, msg);
            } catch (Exception e) {
                FacesMessage msg = new FacesMessage("Error", "Imposible leer el contexto actual");
                FacesContext.getCurrentInstance().addMessage(null, msg);
            }
        }
    }
    
    public String getDatatipFormat(){
//        JsfUtil.getDurationString(getTiempo());
        return "<span style=\"display:none;\">%s</span>";
    }

    public List<Hecho> getWorkItems() {
        return ejbFacade.findByState();
    }

    public void getStyle() {

    }

    public List<Actividad> getActividades() {
        return actividades;
    }

    public void setActividades(List<Actividad> actividades) {
        this.actividades = actividades;
    }

    public List<Tarea> getTareas() {
        return tareas;
    }

    public void setTareas(List<Tarea> tareas) {
        this.tareas = tareas;
    }

    public List<Rangobarcode> getRangos() {
        return rangos;
    }

    public void setRangos(List<Rangobarcode> rangos) {
        this.rangos = rangos;
    }

    public long getMaxBarValue() {
        return maxBarValue;
    }

    public void setMaxBarValue(long maxBarValue) {
        this.maxBarValue = maxBarValue;
    }

    public long getSlideValue() {
        return slideValue;
    }

    public void setSlideValue(long slideValue) {
        this.slideValue = slideValue;
    }
    
    

//   private SelectItem[] createFilterOptions(String[] data)  {  
//        SelectItem[] options = new SelectItem[data.length + 1];  
//  
//        options[0] = new SelectItem("", "Select");  
//        for(int i = 0; i < data.length; i++) {  
//            options[i + 1] = new SelectItem(data[i], data[i]);  
//        }  
//  
//        return options;  
//    }  
//  
//    public SelectItem[] getManufacturerOptions() {  
//        return manufacturerOptions;  
//    }  
    public void display() {
//        FacesMessage msg = new FacesMessage("Selected", "Actividad:" + idActividad + ", Tarea: " + idTarea);    
//        FacesContext.getCurrentInstance().addMessage(null, msg);  38, Elaboracion de Etiqueta Manual, , 9

    }

}
