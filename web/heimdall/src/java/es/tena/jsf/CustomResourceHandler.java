/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es.tena.jsf;

import javax.faces.application.Resource;
import javax.faces.application.ResourceHandler;

/**
 *
 * @author Ftena
 */
public class CustomResourceHandler extends javax.faces.application.ResourceHandlerWrapper {

    private ResourceHandler wrapped;

    public CustomResourceHandler(ResourceHandler wrapped) {
        this.wrapped = wrapped;
    }
    @Override
    public ResourceHandler getWrapped() {
        return this.wrapped;
    }

    @Override
    public Resource createResource(String resourceName, String libraryName) {
        Resource resource = super.createResource(resourceName, libraryName);
    // here a check of library name could be necessary, etc.
        return new CustomResource(resource);
    }
}
