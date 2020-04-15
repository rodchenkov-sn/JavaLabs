package ru.spbstu.gidraque;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class StudentPool {

    private final int capacity;

    private AtomicBoolean done;
    private ReentrantLock lock;
    private Condition     condition;
    Queue<Student>        students;

    public StudentPool(int capacity) {
        this.capacity = capacity;
        this.done = new AtomicBoolean(false);
        this.lock = new ReentrantLock();
        this.condition = this.lock.newCondition();
        this.students = new LinkedList<>();
    }

    public void put(Student student) {
        this.lock.lock();
        try {
            while (!this.done.get() && this.students.size() >= capacity) {
                this.condition.await();
            }
            this.students.add(student);
            if (students.size() == 1) {
                condition.signalAll();
            }
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        } finally {
            this.lock.unlock();
        }
    }

    public Student get(Subject subject) {
        Student student = null;
        this.lock.lock();
        try {
            while (!this.done.get() &&
                    (this.students.isEmpty() || this.students.peek().subject != subject)) {
                this.condition.await();
            }
            student = this.students.poll();
            condition.signalAll();
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        } finally {
            this.lock.unlock();
        }
        return student;
    }

    public void done() {
        this.done.set(true);
        lock.lock();
        this.condition.signal();
        lock.unlock();
    }

}
