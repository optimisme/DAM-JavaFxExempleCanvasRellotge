import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.input.KeyEvent;
import javafx.stage.Stage;
 
public class Main extends Application {

    public static Crtl0 crtl0;

    public static void main(String[] args) {

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
        crtl0 = (Crtl0) UtilsViews.getController("View0");

        Scene scene = new Scene(UtilsViews.parentContainer);
        scene.addEventFilter(KeyEvent.ANY, keyEvent -> { crtl0.keyEvent(keyEvent); });

        stage.setScene(scene);
        stage.onCloseRequestProperty(); // Call close method when closing window
        stage.setTitle("Rellotge");
        stage.setMinWidth(windowWidth);
        stage.setMinHeight(windowHeight);
        stage.show();

        // Start drawing loop
        crtl0.startDrawing();

        // Add icon only if not Mac
        if (!System.getProperty("os.name").contains("Mac")) {
            Image icon = new Image("file:./assets/icon.png");
            stage.getIcons().add(icon);
        }
    }

    @Override
    public void stop() {
        // Aturar el bucle de dibuix
        crtl0.stopDrawing();

        // Acabar l'aplicació
        System.out.println("Acabar");
    }
}