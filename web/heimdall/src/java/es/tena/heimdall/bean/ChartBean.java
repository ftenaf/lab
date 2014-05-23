package es.tena.heimdall.bean;
import java.io.Serializable;  
import javax.faces.view.ViewScoped;
import javax.inject.Named;
  
import org.primefaces.model.chart.CartesianChartModel;  
import org.primefaces.model.chart.ChartSeries;  
  
@Named(value = "chartBean")
@ViewScoped
public class ChartBean implements Serializable {  
  
    HechoController hecho = new HechoController();
    
    private CartesianChartModel categoryModel;  
  
    public ChartBean() {  
        createCategoryModel();  
    }  
  
    public CartesianChartModel getCategoryModel() {  
        return categoryModel;  
    }  
    
    
    private void createCategoryModel() {  
//        categoryModel = new CartesianChartModel();  
        hecho.createCategoryModel();
        categoryModel = hecho.getCategoryModel();
 
    }  
  
    private void createCategoryModel_() {  
        categoryModel = new CartesianChartModel();  
  
        ChartSeries boys = new ChartSeries();  
        boys.setLabel("Boys");  
  
        boys.set("2004", 120);  
        boys.set("2005", 100);  
        boys.set("2006", 44);  
        boys.set("2007", 150);  
        boys.set("2008", 25);  
  
        ChartSeries girls = new ChartSeries();  
        girls.setLabel("Girls");  
  
        girls.set("2004", 52);  
        girls.set("2005", 60);  
        girls.set("2006", 110);  
        girls.set("2007", 135);  
        girls.set("2008", 120);  
  
        categoryModel.addSeries(boys);  
        categoryModel.addSeries(girls);  
    }  
}  