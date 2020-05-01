package ru.spbstu.autoservice.security.model;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ru.spbstu.autoservice.security.model.serialization.UserTableEntitySerializer;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "user_table", schema = "auto_service_db")
@JsonSerialize(using = UserTableEntitySerializer.class)
public class UserTableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "username", length = 20, nullable = false)
    private String username;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "user_role_table",
        joinColumns = {@JoinColumn(name = "user_id", referencedColumnName = "id")},
        inverseJoinColumns = {@JoinColumn(name = "role_id", referencedColumnName = "id")}
    )
    private List<RoleTableEntity> roles;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<RoleTableEntity> getRoles() {
        return roles;
    }

    public void setRoles(List<RoleTableEntity> roles) {
        this.roles = roles;
    }

}
