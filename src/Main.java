import java.util.ArrayList;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.stage.Stage;
 
public class Main extends Application {

    public static Drawing drawing = new Drawing();
    public static ArrayList<DrawingObj> drawingList = new ArrayList<>();

    public static ObjNumeros numeros = new ObjNumeros();
    public static ObjAgulles agulles = new ObjAgulles();

    public static void main(String[] args) {
 
        // Crear objectes
        drawingList.add(numeros);
        drawingList.add(agulles);

        // Iniciar app JavaFX   
        launch(args);
    }
    
    @Override
    public void start(Stage stage) throws Exception {

        final int windowWidth = 500;
        final int windowHeight = 500;

        UtilsViews.stage = stage;
        UtilsViews.parentContainer.setStyle("-fx-font: 14 arial;");
        UtilsViews.addView(getClass(), "View0", "./assets/view0.fxml");

        Scene scene = new Scene(UtilsViews.parentContainer);
        scene.addEventFilter(KeyEvent.ANY, keyEvent -> { keyEvent(keyEvent); });

        stage.setScene(scene);
        stage.onCloseRequestProperty(); // Call close method when closing window
        stage.setTitle("Rellotge");
        stage.setMinWidth(windowWidth);
        stage.setMinHeight(windowHeight);
        stage.show();

        // Image icon = new Image("file:./assets/icon.png");
        // stage.getIcons().add(icon);
    }

    @Override
    public void stop() {
        // Aturar el bucle de dibuix
        drawing.stop(); 

        // Acabar l'aplicació
        System.out.println("Acabar");
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