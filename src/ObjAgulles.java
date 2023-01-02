import java.util.Calendar;

import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.paint.Color;
import javafx.scene.shape.StrokeLineCap;

public class ObjAgulles implements DrawingObj {

    // Definir atributs
    private double hores = 0;
    private double minuts = 0;
    private double segons = 0;
    private double millis = 0;

    // Getters i setters
    public void     setHores(double hores)         { this.hores = hores; }
    public void     setMinuts(double minuts)       { this.minuts = minuts; }
    public void     setSegons(double segons)       { this.segons = segons; }

    // Animar
    public void run(Canvas cnv, double fps) { 
        // Posar hores, minuts i segons a l'hora actual
        Calendar cal = Calendar.getInstance();
        hores = cal.get(Calendar.HOUR_OF_DAY);
        minuts = cal.get(Calendar.MINUTE);
        segons = cal.get(Calendar.SECOND);
        millis = cal.get(Calendar.MILLISECOND);
    }

    // Dibuixar el rellotge circular
    public void draw(GraphicsContext gc) {

        int canvasHeight = (int) gc.getCanvas().getHeight();
        int canvasWidth = (int) gc.getCanvas().getWidth();

        int diameter = canvasWidth - 25;
        if (canvasWidth > canvasHeight) diameter = canvasHeight - 25;

        int x = canvasWidth / 2;
        int y = canvasHeight / 2;
        
        int radius = diameter / 2;
        int radiusHalf = radius / 2;
        double sub = Math.PI / 2;
        double radians = 0;

        // Dibuixar les hores
        radians = Math.toRadians((hores + minuts / 60) * 30) - sub;
        drawCircleLine(gc, Color.WHITE, 3, x, y,  0, 25, radians);
        drawCircleLine(gc, Color.WHITE, 8, x, y, 20, radiusHalf, radians);

        // Dibuixar els minuts
        radians = Math.toRadians((minuts + segons / 60) * 6) - sub;
        drawCircleLine(gc, Color.WHITE,  3, x, y,  0, 25, radians);
        drawCircleLine(gc, Color.WHITE, 8,  x, y, 20, radius - 25, radians);

        // Dibuixar els segons
        radians = Math.toRadians(segons * 6) + Math.toRadians(millis * 0.006) - sub;
        drawCircleLine(gc, Color.RED, 2, x, y, -20, radius, radians);
        
        // Dibuixar el cercle dels segons
        int radiusCS = 6;
        int diameterCS = radiusCS * 2;
        gc.setFill(Color.RED);
        gc.fillOval(x - radiusCS, y - radiusCS, diameterCS, diameterCS);

        // Dibuixar el centre
        int radiusCT = 3;
        int diameterCT = radiusCT * 2;
        gc.setFill(Color.BLACK);
        gc.fillOval(x - radiusCT, y - radiusCT, diameterCT, diameterCT);
    }

    private void drawCircleLine (GraphicsContext gc, Color color, double size, int x, int y, int radiusMin, int radiusMax, double radians) {
        gc.setStroke(color);
        gc.setLineWidth(size);
        gc.setLineCap(StrokeLineCap.ROUND);
        gc.beginPath();
        gc.moveTo(x + radiusMin * Math.cos(radians), y + radiusMin * Math.sin(radians));
        gc.lineTo(x + radiusMax * Math.cos(radians), y + radiusMax * Math.sin(radians));
        gc.stroke();
        gc.setLineCap(StrokeLineCap.SQUARE);
    }
}
