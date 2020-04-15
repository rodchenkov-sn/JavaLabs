package ru.spbstu;

import java.io.File;
import java.io.IOException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

import org.ini4j.Wini;

import ru.spbstu.database.DataBase;

public class Main extends Application {

    public static DataBase dataBase;

    public static void main(String[] args) {
        try {
            var settings = new Wini(new File("settings.ini"));
            var url = settings.get("database", "url");
            var user = settings.get("database", "user");
            var password = settings.get("database", "password");
            dataBase = new DataBase(url, user, password);
            launch();
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    @Override
    public void start(Stage primaryStage) throws IOException {
        primaryStage.setTitle("Items");
        Pane root = FXMLLoader.load(getClass().getResource("/main.fxml"));
        Scene myScene = new Scene(root);
        primaryStage.setScene(myScene);
        primaryStage.show();
    }

}
