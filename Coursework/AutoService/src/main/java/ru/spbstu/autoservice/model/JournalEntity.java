package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ru.spbstu.autoservice.model.deserialization.JournalEntityDeserializer;

import java.sql.Timestamp;

@JsonDeserialize(using = JournalEntityDeserializer.class)
public class JournalEntity {

    private final Timestamp timeIn;
    private final Timestamp timeOut;
    private final int automobileId;
    private final int routeId;

    public JournalEntity(Timestamp timeIn, Timestamp timeOut, int automobileId, int routeId) {
        this.timeIn = timeIn;
        this.timeOut = timeOut;
        this.automobileId = automobileId;
        this.routeId = routeId;
    }

    public Timestamp getTimeIn() {
        return timeIn;
    }

    public Timestamp getTimeOut() {
        return timeOut;
    }

    public int getAutomobileId() {
        return automobileId;
    }

    public int getRouteId() {
        return routeId;
    }
}
