package ru.spbstu.gidraque;

import java.util.concurrent.atomic.AtomicBoolean;

public class Robot implements Runnable {

    public Robot(Subject subject, StudentPool studentPool) {
        this.subject = subject;
        this.studentPool = studentPool;
        this.exit = new AtomicBoolean(false);
    }

    @Override
    public void run() {
        try {
            while (!exit.get()) {
                var s = studentPool.get(subject);
                if (s != null) {
                    System.out.println("Checking " + s.labCount + " " + s.subject + " labs.");
                    Thread.sleep(s.labCount * 100);
                }
            }
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }
    }

    public void done() {
        this.exit.set(true);
    }

    AtomicBoolean       exit;
    private Subject     subject;
    private StudentPool studentPool;

}
