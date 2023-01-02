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

        // Iniciar el bucle de dibuix
        animationTimer = new AnimationTimer() {
            private long previousFrame = 0;

            @Override public void handle(long now) {

                // Ingorar el primer frame, però apuntar-se el temps
                if (previousFrame == 0) {
                    previousFrame = now;
                    frameTimes[0] = now;
                    frameCount++;
                    return;
                }
                
                // Si hem fet 2 frames en un cicle de pantalla, ignorar el segon
                if (now <= previousFrame) {
                    return;
                }

                // Mesurar els FPS
                int frameIndex = (int) (frameCount % frameTimes.length);
                frameTimes[frameIndex] = now;
                if (frameCount > frameTimes.length) {
                    // Quan ja tenim 120 frames, calcular els FPS
                    int prev = (int) ((frameCount + 1) % frameTimes.length);
                    long delta = now - frameTimes[prev];
                    fps = (1e9 * frameTimes.length) / delta;
                } else {
                    // Si encara no tenim 120 frames, no podem calcular els FPS
                    fps =60.0;
                }
                frameCount++;
                
                // Calcular el temps fins al pròxim dibuix de pantalla
                long rest = now % frameNs;
                long nextFrame = now;
                if (rest != 0) {
                    nextFrame += frameNs - rest;
                }
                
                // Animar i dibuixar
                run(fps);
                previousFrame = nextFrame;
                draw();
            }
        };

        // Iniciar el bucle de dibuix
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
