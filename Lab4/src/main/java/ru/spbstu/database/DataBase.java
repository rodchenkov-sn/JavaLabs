package ru.spbstu.database;

import org.jetbrains.annotations.NotNull;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;
import java.util.ArrayList;

public class DataBase {

    private static final String driver = "com.mysql.cj.jdbc.Driver";

    private Connection connection;
    private Statement statement;

    private CallableStatement addItemStmt;
    private CallableStatement deleteItemStmt;
    private CallableStatement changePriceStmt;
    private CallableStatement getItemsByPriceStmt;
    private CallableStatement getPriceStmt;
    private CallableStatement findItemsStmt;

    public DataBase(String url, String user, String password) throws SQLException, ClassNotFoundException {
        Class.forName(driver);
        this.connection = DriverManager.getConnection(url, user, password);
        this.statement = connection.createStatement();
        this.addItemStmt = connection.prepareCall("call add_item(?, ?, ?)");
        this.deleteItemStmt = connection.prepareCall("call delete_item(?)");
        this.changePriceStmt = connection.prepareCall("call change_price(?, ?)");
        this.getItemsByPriceStmt = connection.prepareCall("call get_by_price(?, ?)");
        this.getPriceStmt = connection.prepareCall("select get_price(?)");
        this.findItemsStmt = connection.prepareCall("call find_items(?, ?, ?)");
    }

    public void addItem(@NotNull Item item) throws SQLException {
        addItemStmt.setInt(1, item.getProdId());
        addItemStmt.setString(2, item.getTitle());
        addItemStmt.setInt(3, item.getPrice());
        addItemStmt.execute();
    }

    public void deleteItem(String title) throws SQLException {
        deleteItemStmt.setString(1, title);
        deleteItemStmt.execute();
    }

    public void changePrice(String title, int newPrice) throws SQLException {
        if (newPrice <= 0) {
            throw new IllegalArgumentException("new price must be a positive integer.");
        }
        changePriceStmt.setString(1, title);
        changePriceStmt.setInt(2, newPrice);
        changePriceStmt.execute();
    }

    public ArrayList<Item> getAllItems() throws SQLException {
        var items = new ArrayList<Item>();
        if (statement.execute("call get_all()")) {
            var result = statement.getResultSet();
            while (result.next()) {
                items.add(new Item(
                   result.getInt("prod_id"),
                   result.getString("title"),
                   result.getInt("price")
                ));
            }
        }
        return items;
    }

    public ArrayList<Item> findItems(String query, int min, int max) throws SQLException {
        var items = new ArrayList<Item>();
        findItemsStmt.setString(1, query);
        findItemsStmt.setInt(2, min);
        findItemsStmt.setInt(3, max);
        if (findItemsStmt.execute()) {
            var result = findItemsStmt.getResultSet();
            while (result.next()) {
                items.add(new Item(
                        result.getInt("prod_id"),
                        result.getString("title"),
                        result.getInt("price")
                ));
            }
        }
        return items;
    }

    public ArrayList<Item> getItemsByPrice(int low, int high) throws SQLException {
        var items = new ArrayList<Item>();
        getItemsByPriceStmt.setInt(1, low);
        getItemsByPriceStmt.setInt(2, high);
        if (getItemsByPriceStmt.execute()) {
            var result = getItemsByPriceStmt.getResultSet();
            while (result.next()) {
                items.add(new Item(
                        result.getInt("prod_id"),
                        result.getString("title"),
                        result.getInt("price")
                ));
            }
        }
        return items;
    }

    public int getPrice(String title) throws SQLException {
        getPriceStmt.setString(1, title);
        if (getPriceStmt.execute()) {
            var result = getPriceStmt.getResultSet();
            result.next();
            return result.getInt(1);
        } else {
            return -1;
        }
    }

    public void close() throws SQLException {
        connection.close();
        statement.close();
    }

}
