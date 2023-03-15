import javafx.animation.AnimationTimer;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.paint.Color;

public class Drawing {

    private long frameCount = 0;
    private double fps = 60.0;
    long[] frameTimes = new long[120];
    private long frameNs = 1_000_000_000L / 60; //Default a 60Hz
  
    private Canvas cnv;
    private GraphicsContext gc;
    private AnimationTimer animationTimer;

    public Drawing () { }

    // Iniciar el context i bucle de dibuix
    public void start (Canvas canvas) {

        cnv = canvas;

        // Definir contexte de dibuix
        gc = canvas.getGraphicsContext2D();

        // Init drawing bucle
        animationTimer = new DrawingFps(this::run, this::draw);
        animationTimer.start();
    }

    // Aturar el bucle de dibuix
    public void stop () {
        animationTimer.stop();
    }

    // Animar
    private void run(double fps) {

        // Animar elements
        for (DrawingObj obj : Main.drawingList) {
            obj.run(cnv, fps);
        }
    }

    // Dibuixar
    private void draw() {
        // Netejar l'area de dibuix
        gc.clearRect(0, 0, cnv.getWidth(), cnv.getHeight());

        // Dibuixar elements
        for (DrawingObj obj : Main.drawingList) {
            obj.draw(gc);
        }

        // Dibuixar un marc a l'area de dibuix
        gc.setStroke(Color.BLACK);
        gc.setLineWidth(1);
        gc.strokeRect(0, 0, cnv.getWidth(), cnv.getHeight());
    }
}
