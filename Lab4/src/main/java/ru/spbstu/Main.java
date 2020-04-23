package ru.spbstu;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;

import org.ini4j.Wini;

import ru.spbstu.database.DataBase;

public class Main extends Application {

    public static DataBase dataBase;

    public static void main(String[] args) {
        launch();
    }

    @Override
    public void start(Stage primaryStage) throws IOException {
        try {
            var settings = new Wini();
            settings.load(new File("settings.ini"));
            var url = settings.get("database", "url");
            var user = settings.get("database", "user");
            var password = settings.get("database", "password");
            var minWidth = settings.get("window", "min-width", int.class);
            var minHeight = settings.get("window", "min-height", int.class);
            dataBase = new DataBase(url, user, password);

            primaryStage.setTitle("Items");
            Pane root = FXMLLoader.load(getClass().getResource("/main.fxml"));
            Scene myScene = new Scene(root);
            primaryStage.setScene(myScene);
            primaryStage.show();
            primaryStage.setMinWidth(minWidth);
            primaryStage.setMinHeight(minHeight);
        } catch (SQLException e) {
            showError("An SQL error occurred.", e.getMessage());
        } catch (Exception e) {
            showError("An error occurred.", e.getMessage());
        }
    }

    public static void showError(String title, String content) {
        try {
            var alert = new Alert(AlertType.ERROR);
            alert.setHeaderText(title);
            alert.setContentText(content);
            alert.showAndWait();
        } catch (Exception e) {
            System.err.println("Could not show an error window");
        }
    }

}
