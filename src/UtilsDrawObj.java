import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;

interface UtilsDrawObj {
    public void run(Canvas cnv, double fps);
    public void draw(GraphicsContext gc);
}
