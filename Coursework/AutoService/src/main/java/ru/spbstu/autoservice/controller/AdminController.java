package ru.spbstu.autoservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ru.spbstu.autoservice.security.model.UserEntity;
import ru.spbstu.autoservice.security.model.UserTableEntity;
import ru.spbstu.autoservice.security.service.UserTableService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/autoservice/admin")
public class AdminController {

    private final UserTableService userTableService;

    @Autowired
    public AdminController(UserTableService userTableService) {
        this.userTableService = userTableService;
    }

    @GetMapping("/users/all")
    public List<UserTableEntity> usersAll() {
        return userTableService.getAll();
    }

    @GetMapping("/users/{id}")
    public Optional<UserTableEntity> userGetById(@PathVariable int id) {
        return Optional.ofNullable(userTableService.findById(id));
    }

    @PostMapping("/users")
    public String userPost(@RequestBody UserEntity userEntity) {
        if (userTableService.findByUsername(userEntity.getUsername()) != null) {
            return "error";
        }
        var userTableEntity = new UserTableEntity();
        userTableEntity.setUsername(userEntity.getUsername());
        userTableEntity.setPassword(userEntity.getPassword());
        userTableService.register(userTableEntity);
        return "ok";
    }

    @DeleteMapping("/users/{id}")
    public void userDelete(@PathVariable int id) {
        userTableService.deleteById(id);
    }

}
