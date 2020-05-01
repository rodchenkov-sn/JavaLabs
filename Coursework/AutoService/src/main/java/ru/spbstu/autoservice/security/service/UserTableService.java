package ru.spbstu.autoservice.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import ru.spbstu.autoservice.security.model.RoleTableEntity;
import ru.spbstu.autoservice.security.model.UserTableEntity;
import ru.spbstu.autoservice.security.repository.RoleTableRepository;
import ru.spbstu.autoservice.security.repository.UserTableRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserTableService {

    private final UserTableRepository userTableRepository;
    private final RoleTableRepository roleTableRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    public UserTableService(UserTableRepository userTableRepository, RoleTableRepository roleTableRepository) {
        this.userTableRepository = userTableRepository;
        this.roleTableRepository = roleTableRepository;
    }

    public UserTableEntity register(UserTableEntity user) {
        var role = roleTableRepository.findByName("ROLE_USER");
        var roles = new ArrayList<RoleTableEntity>();
        roles.add(role);

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRoles(roles);

        return userTableRepository.save(user);
    }

    public List<UserTableEntity> getAll() {
        return userTableRepository.findAll();
    }

    public UserTableEntity findByUsername(String username) {
        return userTableRepository.findByUsername(username);
    }

    public UserTableEntity findById(int id) {
        return userTableRepository.findById(id).orElse(null);
    }

    public void deleteById(int id) {
        userTableRepository.deleteById(id);
    }

}
