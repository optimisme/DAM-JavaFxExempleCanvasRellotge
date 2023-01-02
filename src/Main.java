import java.util.ArrayList;

import javafx.application.Application;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundFill;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
 
public class Main extends Application {

    private Drawing drawing = new Drawing();
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
    public void start(Stage primaryStage) {

        int windowHeight = 350;
        int windowWidth = 300;

        // Construir interficie
        VBox root = buildInterface(primaryStage);

        // Definir escena
        Scene  scene = new Scene(root);
        scene.addEventFilter(KeyEvent.ANY, keyEvent -> { keyEvent(keyEvent); });

        // Iniciar finestra d'app
        primaryStage.setTitle("Rellotge");
        primaryStage.onCloseRequestProperty();
        primaryStage.setScene(scene);
        primaryStage.show();
        primaryStage.setResizable(true);
        primaryStage.setHeight(windowHeight);
        primaryStage.setWidth(windowWidth);
        primaryStage.setMinHeight(windowHeight);
        primaryStage.setMinWidth(windowWidth);
        primaryStage.heightProperty().addListener((observable, oldValue, newvalue) -> {
            double titleHeight = primaryStage.getHeight() - scene.getHeight();
            double rootHeight = primaryStage.getHeight() - titleHeight;
            root.setPrefHeight(rootHeight);
        });

        // Definir icona d'app
        Image icon = new Image("file:./assets/icon.png");
        primaryStage.getIcons().add(icon);
    }

    @Override
    public void stop() {
        // Aturar el bucle de dibuix
        drawing.stop(); 

        // Acabar l'aplicació
        System.out.println("Acabar");
    }

    public VBox buildInterface(Stage primaryStage) {

        // Definir la divisió vertical
        VBox vbox = new VBox(0);
        vbox.setAlignment(Pos.TOP_CENTER);

            // Definir l'area de dibuix
            Canvas canvas = new Canvas(100, 100);
            drawing.start(canvas);
            canvas.heightProperty().bind(vbox.heightProperty());
            canvas.widthProperty().bind(vbox.widthProperty());
            
        vbox.getChildren().addAll(canvas);
        VBox.setVgrow(canvas, Priority.ALWAYS);

        vbox.setBackground(new Background(new BackgroundFill(Color.BLACK,null,null)));

        return vbox;
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