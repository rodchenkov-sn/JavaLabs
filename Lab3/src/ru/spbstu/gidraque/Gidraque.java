package ru.spbstu.gidraque;

import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Gidraque {

    public Gidraque(int simTime, int poolSize) {
        this.simTime = simTime;
        this.poolSize = poolSize;
    }

    public void simulate() {
        var pool           = Executors.newFixedThreadPool(poolSize);
        var studentPool    = new StudentPool(10);
        var oopRobot       = new Robot(Subject.OOP, studentPool);
        var mathRobot      = new Robot(Subject.MATH, studentPool);
        var physicsRobot   = new Robot(Subject.PHYSICS, studentPool);
        var studentFactory = new StudentFactory(studentPool);
        try {
            pool.execute(oopRobot);
            pool.execute(mathRobot);
            pool.execute(physicsRobot);
            pool.execute(studentFactory);
            Thread.sleep(simTime * 1000);
            oopRobot.done();
            mathRobot.done();
            physicsRobot.done();
            studentFactory.done();
            studentPool.done();
            pool.shutdown();
            pool.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }
    }

    private int simTime;
    private int poolSize;

}
