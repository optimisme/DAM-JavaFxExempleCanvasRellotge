import java.net.URL;
import java.util.ResourceBundle;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.canvas.Canvas;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.AnchorPane;

public class Crtl0 implements Initializable {

    @FXML
    private AnchorPane anchor;

    @FXML
    public Canvas canvas;

    public static Crtl0Canvas drawing = new Crtl0Canvas();

    @Override
    public void initialize(URL url, ResourceBundle rb) {

        // Initialize canvas responsive size
        UtilsViews.stage.heightProperty().addListener((observable, oldValue, newvalue) -> {
            updateCanvasSize();
        });
        UtilsViews.stage.widthProperty().addListener((observable, oldValue, newvalue) -> {
            updateCanvasSize();
        });
    }

    public void startDrawing () {
        drawing.start(canvas);
    }

    public void stopDrawing () {
        drawing.start(canvas);
    }

    public void updateCanvasSize () {
        // Start Canvas size
        canvas.setWidth(UtilsViews.parentContainer.getWidth());
        canvas.setHeight(UtilsViews.parentContainer.getHeight());
    }

    public void keyEvent (KeyEvent evt) {

        // Quan apretem una tecla
        if (evt.getEventType() == KeyEvent.KEY_PRESSED) {
            if (evt.getCode() == KeyCode.UP) {
            }
        }

        // Quan deixem anar la tecla
        if (evt.getEventType() == KeyEvent.KEY_RELEASED) {

        }
    }
}