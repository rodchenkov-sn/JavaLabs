package ru.spbstu.autoservice.security.model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "role_table", schema = "auto_service_db")
public class RoleTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "name", length = 20, nullable = false)
    private String name;

    @ManyToMany(mappedBy = "roles", fetch = FetchType.LAZY)
    private List<UserTableEntity> users;

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

    public List<UserTableEntity> getUsers() {
        return users;
    }

    public void setUsers(List<UserTableEntity> users) {
        this.users = users;
    }
    
}
