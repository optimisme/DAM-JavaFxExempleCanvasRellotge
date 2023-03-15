import java.util.function.Consumer;

import javafx.animation.AnimationTimer;

public class UtilsFps extends AnimationTimer {
    private long lastNanoTime;
    private int frameCount;
    private double fps;
    private double elapsedTime;
    private double updateInterval = 0.25; // Interval d'actualizació en segons
    private Consumer<Double> runFunction;
    private Runnable drawFunction;

    public UtilsFps(Consumer<Double> runFunction, Runnable drawFunction) {
        this.runFunction = runFunction;
        this.drawFunction = drawFunction;
        lastNanoTime = System.nanoTime();
    }

    @Override
    public void handle(long now) {
        long nanoDelta = now - lastNanoTime;
        double delta = nanoDelta / 1_000_000_000.0;
        elapsedTime += delta;
        frameCount++;

        if (elapsedTime >= updateInterval) {
            fps = frameCount / elapsedTime;
            elapsedTime = 0;
            frameCount = 0;
        }

        // Animar y dibuixar
        runFunction.accept(fps);
        drawFunction.run();

        lastNanoTime = now;
    }
}
