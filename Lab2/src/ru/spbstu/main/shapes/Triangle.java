package ru.spbstu.main.shapes;

public class Triangle implements Shape, Polygon, Point {

    public Triangle(float a, float b, float c, float x, float y, int rotation) {
        if (a + b <= c || a + c <= b || b + c <= a) {
            throw new IllegalArgumentException("invalid triangle sides");
        }
        this.a = a;
        this.b = b;
        this.c = c;
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }


    @Override
    public float getArea() {
        float hP = (float) (getPerimeter() / 2.0);
        return (float) Math.sqrt(hP * (hP - a) * (hP - b) * (hP - c));
    }

    @Override
    public int getRotation() {
        return rotation;
    }

    @Override
    public void setRotation(int rotation) {
        this.rotation = rotation;
    }

    @Override
    public float getX() {
        return x;
    }

    @Override
    public void setX(float x) {
        this.x = x;
    }

    @Override
    public float getY() {
        return y;
    }

    @Override
    public void setY(float y) {
        this.y = y;
    }

    @Override
    public float getPerimeter() {
        return a + b + c;
    }

    private float a, b, c;
    private float x;
    private float y;
    private int rotation;

}
