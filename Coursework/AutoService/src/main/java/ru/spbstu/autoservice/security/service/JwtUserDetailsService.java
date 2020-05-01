package ru.spbstu.autoservice.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import ru.spbstu.autoservice.security.jwt.JwtUserFactory;

@Service
public class JwtUserDetailsService implements UserDetailsService {

    private final UserTableService userTableService;

    @Autowired
    public JwtUserDetailsService(UserTableService userTableService) {
        this.userTableService = userTableService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        var user = userTableService.findByUsername(username);

        if (user == null) {
            throw new UsernameNotFoundException(String.format("username \"%s\" was not found", username));
        }

        return JwtUserFactory.produce(user);
    }

}
