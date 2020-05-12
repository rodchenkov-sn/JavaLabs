package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ru.spbstu.autoservice.model.serialization.AutomobileTableEntitySerializer;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "automobile_table", schema = "auto_service_db")
@JsonSerialize(using = AutomobileTableEntitySerializer.class)
public class AutomobileTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "num", nullable = false, length = 20)
    private String num;

    @Column(name = "color", nullable = false, length = 20)
    private String color;

    @Column(name = "mark", nullable = false, length = 20)
    private String mark;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "personnel_id", referencedColumnName = "id")
    private PersonnelTableEntity driver;

    @OneToMany(mappedBy = "automobile", cascade = CascadeType.PERSIST, fetch = FetchType.LAZY)
    private Set<JournalTableEntity> journalTableEntities = new HashSet<>();

    public void setProperties(AutomobileEntity automobileEntity) {
        this.color = automobileEntity.getColor();
        this.mark = automobileEntity.getMark();
        this.num = automobileEntity.getNum();
    }

    public void bindJournal(JournalTableEntity journalTableEntity) {
        this.journalTableEntities.add(journalTableEntity);
        journalTableEntity.setAutomobile(this);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNum() {
        return num;
    }

    public void setNum(String num) {
        this.num = num;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

    public PersonnelTableEntity getDriver() {
        return driver;
    }

    public void setDriver(PersonnelTableEntity driver) {
        this.driver = driver;
    }

    public Set<JournalTableEntity> getJournalTableEntities() {
        return journalTableEntities;
    }

    public void setJournalTableEntities(Set<JournalTableEntity> journalTableEntities) {
        this.journalTableEntities = journalTableEntities;
    }
}
