package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ru.spbstu.autoservice.model.serialization.JournalTableEntitySerializer;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "journal_table", schema = "auto_service_db")
@JsonSerialize(using = JournalTableEntitySerializer.class)
public class JournalTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "time_out", nullable = false)
    private Timestamp timeOut;

    @Column(name = "time_in", nullable = false)
    private Timestamp timeIn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "auto_id", referencedColumnName = "id")
    private AutomobileTableEntity automobile;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", referencedColumnName = "id")
    private RouteTableEntity route;

    public void setProperties(JournalEntity journalEntity) {
        this.timeIn = journalEntity.getTimeIn();
        this.timeOut = journalEntity.getTimeOut();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Timestamp getTimeOut() {
        return timeOut;
    }

    public void setTimeOut(Timestamp timeOut) {
        this.timeOut = timeOut;
    }

    public Timestamp getTimeIn() {
        return timeIn;
    }

    public void setTimeIn(Timestamp timeIn) {
        this.timeIn = timeIn;
    }

    public AutomobileTableEntity getAutomobile() {
        return automobile;
    }

    public void setAutomobile(AutomobileTableEntity automobile) {
        this.automobile = automobile;
    }

    public RouteTableEntity getRoute() {
        return route;
    }

    public void setRoute(RouteTableEntity route) {
        this.route = route;
    }

}
