package es.tena.jsf;

import javax.faces.application.Resource;

/**
 *
 * @author Ftena
 */
public class CustomResource extends javax.faces.application.ResourceWrapper {

    private javax.faces.application.Resource resource;

    public CustomResource(Resource resource) {
        this.resource = resource;
    }

    @Override
    public Resource getWrapped() {
        return this.resource;
    }

    @Override
    public String getRequestPath() {
        String requestPath = resource.getRequestPath();

        // get current revision
        double revision = Math.random()*10000;

        if (requestPath.contains("?")) {
            requestPath = requestPath + "&rv=" + revision;
        } else {
            requestPath = requestPath + "?rv=" + revision;
        }

        return requestPath;
    }

    @Override
    public String getContentType() {
        return getWrapped().getContentType();
    }

}
