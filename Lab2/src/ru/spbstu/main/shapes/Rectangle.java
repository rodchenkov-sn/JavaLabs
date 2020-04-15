package ru.spbstu.main.shapes;

public class Rectangle implements Shape, Polygon, Point {

    public Rectangle(float width, float height, int rotation, float x, float y) {
        this.width = width;
        this.height = height;
        this.rotation = rotation;
        this.x = x;
        this.y = y;
    }

    @Override
    public float getPerimeter() {
        return (this.width + this.height) * 2;
    }

    @Override
    public float getArea() {
        return this.width * this.height;
    }

    @Override
    public int getRotation() {
        return this.rotation;
    }

    @Override
    public void setRotation(int rotation) {
        this.rotation = rotation;
    }

    @Override
    public float getX() {
        return this.x;
    }

    @Override
    public void setX(float x) {
        this.x = x;
    }

    @Override
    public float getY() {
        return this.y;
    }

    @Override
    public void setY(float y) {
        this.y = y;
    }

    private float width;
    private float height;
    private float x;
    private float y;
    private int rotation;

}
