package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ru.spbstu.autoservice.deserialization.AutomobileEntityDeserializer;

@JsonDeserialize(using = AutomobileEntityDeserializer.class)
public class AutomobileEntity {

    private final String num;
    private final String color;
    private final String mark;
    private final int driverId;

    public AutomobileEntity(String num, String color, String mark, int driverId) {
        this.num = num;
        this.color = color;
        this.mark = mark;
        this.driverId = driverId;
    }

    public String getNum() {
        return num;
    }

    public String getColor() {
        return color;
    }

    public String getMark() {
        return mark;
    }

    public int getDriverId() {
        return driverId;
    }
}
