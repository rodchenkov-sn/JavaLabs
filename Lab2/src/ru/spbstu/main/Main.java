package ru.spbstu.main;

import ru.spbstu.main.shapes.*;

public class Main {

    private static Shape getShapeWithMaxArea(Shape[] shapes) {
        Shape maxShape = null;
        float maxArea = 0;
        for (Shape shape: shapes) {
            if (shape.getArea() > maxArea) {
                maxArea = shape.getArea();
                maxShape = shape;
            }
        }
        return maxShape;
    }

    public static void main(String[] args) {
        try {
            Shape[] shapes = {
                    new Rectangle(100, 100, 0, 0, 0),
                    new Rectangle(10, 10, 0, 0, 0),
                    new Circle(5, 0, 0),
                    new Triangle(5, 4, 3, 0, 0, 0)
            };
            Shape maxShape = getShapeWithMaxArea(shapes);
            System.out.println(maxShape.getArea());
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
