package ru.spbstu.main.shapes;

public class Circle implements Shape, Ellipse, Point {

    public Circle(float radius, float x, float y) {
        this.radius = radius;
        this.x = x;
        this.y = y;
    }

    @Override
    public float getArea() {
        return (float) (Math.pow(this.radius, 2) * Math.PI);
    }

    @Override
    public float getLength() {
        return (float) (2 * this.radius * Math.PI);
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

    private float radius;
    private float x;
    private float y;

}
