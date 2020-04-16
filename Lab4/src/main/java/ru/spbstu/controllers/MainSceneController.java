package ru.spbstu.controllers;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Group;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.HBox;
import javafx.util.StringConverter;
import javafx.util.converter.IntegerStringConverter;
import ru.spbstu.Main;
import ru.spbstu.database.Item;

import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class MainSceneController implements Initializable {

    @FXML private TableColumn<Item, Integer> prodIdCol;
    @FXML private TableColumn<Item, String> titleCol;
    @FXML private TableColumn<Item, Integer> priceCol;

    @FXML private TableView<Item> itemTable;

    @FXML private Group findGroup;
    @FXML private Group addGroup;

    @FXML private HBox findBox;
    @FXML private HBox addBox;

    @FXML private TextField findField;
    @FXML private TextField minPriceField;
    @FXML private TextField maxPriceField;
    @FXML private TextField prodIdAddField;
    @FXML private TextField titleAddField;
    @FXML private TextField priceAddField;

    private ObservableList<Item> dataList = FXCollections.observableArrayList();

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try {
            dataList.addAll(Main.dataBase.getAllItems());
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        prodIdCol.setCellValueFactory(new PropertyValueFactory<>("prodId"));
        titleCol.setCellValueFactory(new PropertyValueFactory<>("title"));
        priceCol.setCellValueFactory(new PropertyValueFactory<>("price"));
        priceCol.setCellFactory(TextFieldTableCell.forTableColumn(new StringConverter<Integer>() {
            @Override
            public String toString(Integer integer) {
                return integer.toString();
            }

            @Override
            public Integer fromString(String s) {
                try {
                    return Integer.parseInt(s);
                } catch (NumberFormatException e) {
                    return -1;
                }
            }
        }));
        itemTable.setItems(dataList);
        makeNumberOnly(minPriceField);
        makeNumberOnly(maxPriceField);
        makeNumberOnly(prodIdAddField);
        makeNumberOnly(priceAddField);
    }

    private void makeNumberOnly(TextField textField) {
        textField.textProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue.equals("0") && oldValue.isEmpty()) {
                textField.clear();
            }
            if (!newValue.matches("\\d*")) {
                textField.setText(newValue.replaceAll("[^\\d]", ""));
            }
            if (newValue.length() > 6) {
                textField.setText(oldValue);
            }
        });
    }

    public void onPriceEdit(TableColumn.CellEditEvent<Item, Integer> itemIntegerCellEditEvent) {
        try {
            var editedTitle = itemIntegerCellEditEvent.getRowValue().getTitle();
            var newPrice = itemIntegerCellEditEvent.getNewValue();
            if (newPrice > 0) {
                Main.dataBase.changePrice(editedTitle, newPrice);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        } finally {
            reloadData();
        }
    }

    public void onKeyPressedTable(KeyEvent keyEvent) {
        try {
            var selected = itemTable.getSelectionModel().getSelectedItem();
            if (selected != null && keyEvent.getCode() == KeyCode.DELETE) {
                Main.dataBase.deleteItem(selected.getTitle());
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        } finally {
            reloadData();
        }
    }

    public void findButtonClicked(ActionEvent actionEvent) {
        findGroup.setVisible(true);
        findBox.setVisible(true);
        addBox.setVisible(false);
    }

    public void addButtonClicked(ActionEvent actionEvent) {
        addGroup.setVisible(true);
        addBox.setVisible(true);
        findBox.setVisible(false);
    }

    public void onCancel(ActionEvent actionEvent) {
        findGroup.setVisible(false);
        addGroup.setVisible(false);
        clearFields();
        clearFieldsStyle();
        reloadData();
    }

    public void onFind(ActionEvent actionEvent) {
        var title = findField.getText();
        var min = minPriceField.getText().isEmpty() ? 0 : Integer.parseInt(minPriceField.getText());
        var max = maxPriceField.getText().isEmpty() ? 0 : Integer.parseInt(maxPriceField.getText());
        try {
            var items = Main.dataBase.findItems(title, min, max);
            dataList.clear();
            dataList.addAll(items);
            clearFields();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
    }

    public void onAdd(ActionEvent actionEvent) {
        clearFieldsStyle();
        var correct = true;
        var prodIdStr = prodIdAddField.getText();
        if (prodIdStr.isEmpty()) {
            prodIdAddField.setStyle("-fx-border-color: #cc0000");
            correct = false;
        }
        var title = titleAddField.getText();
        if (title.isEmpty() || title.length() >= Item.maxTitleLength) {
            titleAddField.setStyle("-fx-border-color: #cc0000");
            correct = false;
        }
        var priceStr = priceAddField.getText();
        if (priceStr.isEmpty()) {
            priceAddField.setStyle("-fx-border-color: #cc0000");
            correct = false;
        }
        if (correct) {
            try {
                var newItem = new Item(Integer.parseInt(prodIdStr), title, Integer.parseInt(priceStr));
                Main.dataBase.addItem(newItem);
                clearFields();
                reloadData();
            } catch (SQLException e) {
                System.err.println(e.getMessage());
            }
        }
    }

    private void reloadData() {
        try {
            var freshData = Main.dataBase.getAllItems();
            dataList.clear();
            dataList.addAll(freshData);
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
    }

    private void clearFields() {
        findField.clear();
        minPriceField.clear();
        maxPriceField.clear();
        prodIdAddField.clear();
        titleAddField.clear();
        priceAddField.clear();
    }

    private void clearFieldsStyle() {
        prodIdAddField.setStyle(null);
        titleAddField.setStyle(null);
        priceAddField.setStyle(null);
    }

}
