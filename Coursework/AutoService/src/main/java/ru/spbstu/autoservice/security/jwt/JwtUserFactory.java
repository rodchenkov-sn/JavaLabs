package ru.spbstu.autoservice.security.jwt;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import ru.spbstu.autoservice.security.model.RoleTableEntity;
import ru.spbstu.autoservice.security.model.UserTableEntity;

import java.util.List;
import java.util.stream.Collectors;

public class JwtUserFactory {

    public static JwtUser produce(UserTableEntity user) {
        return new JwtUser(
                user.getId(),
                user.getUsername(),
                user.getPassword(),
                getAuthorities(user.getRoles())
        );
    }

    private static List<GrantedAuthority> getAuthorities(List<RoleTableEntity> roles) {
        return roles.stream()
                .map(role -> new SimpleGrantedAuthority(role.getName()))
                .collect(Collectors.toList());
    }

}
