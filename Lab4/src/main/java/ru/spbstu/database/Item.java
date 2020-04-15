package ru.spbstu.database;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;

public class Item {

    public static final int maxTitleLength = 200;

    private final SimpleIntegerProperty prodId = new SimpleIntegerProperty();
    private final SimpleStringProperty title = new SimpleStringProperty();
    private final SimpleIntegerProperty price = new SimpleIntegerProperty();

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
        this.prodId.set(prodId);
        this.title.set(title);
        this.price.set(price);
    }

    public int getProdId() {
        return prodId.get();
    }
    public String getTitle() {
        return title.get();
    }
    public int getPrice() {
        return price.get();
    }

    public void setProdId(int prodId) {
        this.prodId.set(prodId);
    }
    public void setTitle(String title) {
        this.title.set(title);
    }
    public void setPrice(int price) {
        this.price.set(price);
    }

}
