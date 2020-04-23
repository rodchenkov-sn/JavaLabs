package ru.spbstu.database;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;

public class Item {

    public static final int maxTitleLength = 200;

    private int prodId;
    private String title;
    private int price;

    public Item() {
        this(1, "", 1);
    }

    public Item(int prodId, String title, int price) {
        if (prodId <= 0) {
            throw new IllegalArgumentException("prodId must be a positive integer.");
        }
        if (title.length() > maxTitleLength) {
            throw new IllegalArgumentException("title length must be less then or equal to " + maxTitleLength + ".");
        }
        if (price <= 0) {
            throw new IllegalArgumentException("price must be a positive integer.");
        }
        this.prodId = prodId;
        this.title = title;
        this.price = price;
    }

    public int getProdId() {
        return prodId;
    }
    public String getTitle() {
        return title;
    }
    public int getPrice() {
        return price;
    }

    public void setProdId(int prodId) {
        this.prodId = prodId;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public void setPrice(int price) {
        this.price = price;
    }

}
