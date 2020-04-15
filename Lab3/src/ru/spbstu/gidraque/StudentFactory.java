package ru.spbstu.gidraque;

import java.util.Random;
import java.util.concurrent.atomic.AtomicBoolean;

public class StudentFactory implements Runnable {

    public StudentFactory(StudentPool studentPool) {
        this.studentPool = studentPool;
        this.done = new AtomicBoolean(false);
    }

    public static Student getRandomStudent() {
        return new Student(
                possibleCounts[new Random().nextInt(possibleCounts.length)],
                possibleSubjects[new Random().nextInt(possibleSubjects.length)]
        );
    }

    @Override
    public void run() {
        try {
            while (!done.get()) {
                studentPool.put(getRandomStudent());
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }
    }

    public void done() {
        this.done.set(true);
    }

    private static final int[]     possibleCounts = { 10, 20, 100 };
    private static final Subject[] possibleSubjects = { Subject.MATH, Subject.OOP, Subject.PHYSICS };

    private StudentPool   studentPool;
    private AtomicBoolean done;
}
