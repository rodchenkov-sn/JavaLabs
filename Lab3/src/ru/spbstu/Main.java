package ru.spbstu;

import ru.spbstu.gidraque.Gidraque;

public class Main {

    public static void main(String[] args) {
        try {
            var gidraque = new Gidraque(30, 4);
            gidraque.simulate();
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

}
