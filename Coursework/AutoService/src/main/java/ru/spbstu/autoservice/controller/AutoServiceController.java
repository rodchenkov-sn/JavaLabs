package ru.spbstu.autoservice.controller;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import ru.spbstu.autoservice.model.*;
import ru.spbstu.autoservice.service.AutomobileDataBaseService;

import java.util.List;
import java.util.Optional;

@RequestMapping("/autoservice")
@RestController
public class AutoServiceController {

    private final AutomobileDataBaseService automobileDataBaseService;

    public AutoServiceController(AutomobileDataBaseService automobileDataBaseService) {
        this.automobileDataBaseService = automobileDataBaseService;
    }

    //
    //  get all
    //

    @GetMapping("/automobiles/all")
    public List<AutomobileTableEntity> automobilesAll() {
        return automobileDataBaseService.getAllAutomobiles();
    }

    @GetMapping("/personnel/all")
    public List<PersonnelTableEntity> personnelAll() {
        return automobileDataBaseService.getAllPersonnel();
    }

    @GetMapping("/routes/all")
    public List<RouteTableEntity> routesAll() {
        return automobileDataBaseService.getAllRoutes();
    }

    @GetMapping("/journal/all")
    public List<JournalTableEntity> journalAll() {
        return automobileDataBaseService.getAllJournal();
    }

    //
    //  get by id
    //

    @GetMapping("/automobiles/{id}")
    public Optional<AutomobileTableEntity> automobilesById(@PathVariable int id) {
        return automobileDataBaseService.getAutomobileById(id);
    }

    @GetMapping("/personnel/{id}}")
    public Optional<PersonnelTableEntity> personnelById(@PathVariable int id) {
        return automobileDataBaseService.getPersonnelById(id);
    }

    @GetMapping("/routes/{id}")
    public Optional<RouteTableEntity> routesById(@PathVariable int id) {
        return automobileDataBaseService.getRouteById(id);
    }

    @GetMapping("/journal/{id}")
    public Optional<JournalTableEntity> journalById(@PathVariable int id) {
        return automobileDataBaseService.getJournalById(id);
    }

    //
    //  add
    //

    @PostMapping("/automobiles")
    public String automobilesAdd(@RequestBody AutomobileEntity automobileEntity) {
        return automobileDataBaseService.addAutomobile(automobileEntity) ? "ok" : "error";
    }

    @PostMapping("/personnel")
    public String personnelAdd(@RequestBody PersonnelTableEntity personnelTableEntity) {
        automobileDataBaseService.addPersonnel(personnelTableEntity);
        return "ok";
    }

    @PostMapping("/routes")
    public String routesAdd(@RequestBody RouteTableEntity routeTableEntity) {
        automobileDataBaseService.addRoute(routeTableEntity);
        return "ok";
    }

    @PostMapping("/journal")
    public String journalAdd(@RequestBody JournalEntity journalEntity) {
        return automobileDataBaseService.addJournal(journalEntity) ? "ok" : "error";
    }

    //
    //  delete by id
    //

    @DeleteMapping("/automobiles/{id}")
    public String automobilesDelete(@PathVariable int id) {
        return automobileDataBaseService.deleteAutomobileById(id) ? "ok" : "error";
    }

    @DeleteMapping("/personnel/{id}")
    public String personnelDelete(@PathVariable int id) {
        return automobileDataBaseService.deletePersonnelById(id) ? "ok" : "error";
    }

    @DeleteMapping("/routes/{id}")
    public String routesDelete(@PathVariable int id) {
        return automobileDataBaseService.deleteRouteById(id) ? "ok" : "error";
    }

    @DeleteMapping("/journal/{id}")
    public String journalDelete(@PathVariable int id) {
        automobileDataBaseService.deleteJournalById(id);
        return "ok";
    }

}
