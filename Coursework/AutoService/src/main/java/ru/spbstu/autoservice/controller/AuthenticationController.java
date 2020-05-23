package ru.spbstu.autoservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.spbstu.autoservice.security.jwt.JwtTokenProvider;
import ru.spbstu.autoservice.security.model.UserEntity;
import ru.spbstu.autoservice.security.service.UserTableService;

import java.util.HashMap;

@RestController
@RequestMapping("/autoservice/auth")
public class AuthenticationController {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserTableService userTableService;

    @Autowired
    public AuthenticationController(
            AuthenticationManager authenticationManager,
            JwtTokenProvider jwtTokenProvider,
            UserTableService userTableService
    ) {
        this.authenticationManager = authenticationManager;
        this.jwtTokenProvider = jwtTokenProvider;
        this.userTableService = userTableService;
    }

    @PostMapping("/login")
    public ResponseEntity<HashMap<String, String>> login(@RequestBody UserEntity userEntity) {
        try {
            var username = userEntity.getUsername();
            var password = userEntity.getPassword();
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
            var user = userTableService.findByUsername(username);

            if (user == null) {
                throw new UsernameNotFoundException(String.format("User \"%s\" was not found.", username));
            }

            var token = jwtTokenProvider.createToken(username, user.getRoles());

            var response = new HashMap<String, String>();
            response.put("username", username);
            response.put("token", token);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        }
    }

}
