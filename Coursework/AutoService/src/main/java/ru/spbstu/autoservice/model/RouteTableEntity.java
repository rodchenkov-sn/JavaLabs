package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ru.spbstu.autoservice.deserialization.RouteTableEntityDeserializer;
import ru.spbstu.autoservice.serialization.RouteTableEntitySerializer;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "route_table", schema = "auto_service_db")
@JsonSerialize(using = RouteTableEntitySerializer.class)
@JsonDeserialize(using = RouteTableEntityDeserializer.class)
public class RouteTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name", nullable = false, length = 50)
    private String name;

    @OneToMany(mappedBy = "route", cascade = CascadeType.PERSIST, fetch = FetchType.LAZY)
    private Set<JournalTableEntity> journalTableEntities = new HashSet<>();

    public void bindJournal(JournalTableEntity journalTableEntity) {
        this.journalTableEntities.add(journalTableEntity);
        journalTableEntity.setRoute(this);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<JournalTableEntity> getJournalTableEntities() {
        return journalTableEntities;
    }

    public void setJournalTableEntities(Set<JournalTableEntity> journalTableEntities) {
        this.journalTableEntities = journalTableEntities;
    }

}
