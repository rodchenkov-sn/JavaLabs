package ru.spbstu;

import java.util.Scanner;

public class Main {

    private static boolean isPrime(int x) {
        if (x == 2 || x == 3) {
            return true;
        }
        if (x <= 4 || x % 2 == 0) {
            return false;
        }
        for (int i = 3; i <= Math.sqrt(x); i+= 2) {
            if (x % i == 0) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        try {
            final var scanner = new Scanner(System.in);
            final int low = scanner.nextInt();
            final int high = scanner.nextInt();
            if (low >= high) {
                System.out.println("Expected correct int range");
                return;
            }
            for (int i = low; i < high; i++) {
                if (isPrime(i)) {
                    System.out.println(i);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
