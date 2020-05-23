package ru.spbstu.autoservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<List<UserTableEntity>> usersAll() {
        return ResponseEntity.ok(userTableService.getAll());
    }

    @GetMapping("/users/{id}")
    public ResponseEntity<UserTableEntity> userGetById(@PathVariable int id) {
        var user = userTableService.findById(id);
        return user == null ? new ResponseEntity<>(HttpStatus.NOT_FOUND) : ResponseEntity.ok(user);
    }

    @PostMapping("/users")
    public ResponseEntity<Void> userPost(@RequestBody UserEntity userEntity) {
        if (userTableService.findByUsername(userEntity.getUsername()) != null) {
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        }
        var userTableEntity = new UserTableEntity();
        userTableEntity.setUsername(userEntity.getUsername());
        userTableEntity.setPassword(userEntity.getPassword());
        userTableService.register(userTableEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<Void> userDelete(@PathVariable int id) {
        userTableService.deleteById(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
