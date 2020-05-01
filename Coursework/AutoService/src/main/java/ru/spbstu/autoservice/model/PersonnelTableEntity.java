//package ru.spbstu.autoservice.model;
//
//import javax.persistence.*;
//
//@Entity
//@Table(name = "personnel_table", schema = "auto_service_db")
//public class PersonnelTableEntity {
//    private int id;
//    private String firstName;
//    private String lastName;
//    private String fatherName;
//
//    @Id
//    @Column(name = "id", nullable = false)
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    @Basic
//    @Column(name = "first_name", nullable = false, length = 20)
//    public String getFirstName() {
//        return firstName;
//    }
//
//    public void setFirstName(String firstName) {
//        this.firstName = firstName;
//    }
//
//    @Basic
//    @Column(name = "last_name", nullable = false, length = 20)
//    public String getLastName() {
//        return lastName;
//    }
//
//    public void setLastName(String lastName) {
//        this.lastName = lastName;
//    }
//
//    @Basic
//    @Column(name = "father_name", nullable = true, length = 20)
//    public String getFatherName() {
//        return fatherName;
//    }
//
//    public void setFatherName(String fatherName) {
//        this.fatherName = fatherName;
//    }
//
//    @Override
//    public boolean equals(Object o) {
//        if (this == o) return true;
//        if (o == null || getClass() != o.getClass()) return false;
//
//        PersonnelTableEntity that = (PersonnelTableEntity) o;
//
//        if (id != that.id) return false;
//        if (firstName != null ? !firstName.equals(that.firstName) : that.firstName != null) return false;
//        if (lastName != null ? !lastName.equals(that.lastName) : that.lastName != null) return false;
//        if (fatherName != null ? !fatherName.equals(that.fatherName) : that.fatherName != null) return false;
//
//        return true;
//    }
//
//    @Override
//    public int hashCode() {
//        int result = id;
//        result = 31 * result + (firstName != null ? firstName.hashCode() : 0);
//        result = 31 * result + (lastName != null ? lastName.hashCode() : 0);
//        result = 31 * result + (fatherName != null ? fatherName.hashCode() : 0);
//        return result;
//    }
//}

package ru.spbstu.autoservice.model;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ru.spbstu.autoservice.model.deserialization.PersonnelTableEntityDeserializer;
import ru.spbstu.autoservice.model.serialization.PersonnelTableEntitySerializer;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "personnel_table", schema = "auto_service_db")
@JsonSerialize(using = PersonnelTableEntitySerializer.class)
@JsonDeserialize(using = PersonnelTableEntityDeserializer.class)
public class PersonnelTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "first_name", nullable = false, length = 20)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 20)
    private String lastName;

    @Column(name = "father_name", length = 20)
    private String fatherName;

    @OneToMany(mappedBy = "driver", cascade = CascadeType.PERSIST, fetch = FetchType.LAZY)
    private Set<AutomobileTableEntity> automobileTableEntities = new HashSet<>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    public Set<AutomobileTableEntity> getAutomobileTableEntities() {
        return automobileTableEntities;
    }

    public void setAutomobileTableEntities(Set<AutomobileTableEntity> automobileTableEntities) {
        this.automobileTableEntities = automobileTableEntities;
    }

    public void bindCar(AutomobileTableEntity automobileTableEntity) {
        this.automobileTableEntities.add(automobileTableEntity);
        automobileTableEntity.setDriver(this);
    }

}
