package ru.spbstu.autoservice.controller;

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

    @GetMapping("/automobiles/by_id")
    public Optional<AutomobileTableEntity> automobilesById(@RequestParam(value = "id") int id) {
        return automobileDataBaseService.getAutomobileById(id);
    }

    @GetMapping("/personnel/by_id")
    public Optional<PersonnelTableEntity> personnelById(@RequestParam(value = "id") int id) {
        return automobileDataBaseService.getPersonnelById(id);
    }

    @GetMapping("/routes/by_id")
    public Optional<RouteTableEntity> routesById(@RequestParam(value = "id") int id) {
        return automobileDataBaseService.getRouteById(id);
    }

    @GetMapping("/journal/by_id")
    public Optional<JournalTableEntity> journalById(@RequestParam(value = "id") int id) {
        return automobileDataBaseService.getJournalById(id);
    }

    //
    //  add
    //

    @PostMapping("/automobiles/add")
    public String automobilesAdd(@RequestBody AutomobileEntity automobileEntity) {
        return automobileDataBaseService.addAutomobile(automobileEntity) ? "ok" : "error";
    }

    @PostMapping("/personnel/add")
    public String personnelAdd(@RequestBody PersonnelTableEntity personnelTableEntity) {
        automobileDataBaseService.addPersonnel(personnelTableEntity);
        return "ok";
    }

    @PostMapping("/routes/add")
    public String routesAdd(@RequestBody RouteTableEntity routeTableEntity) {
        automobileDataBaseService.addRoute(routeTableEntity);
        return "ok";
    }

    @PostMapping("/journal/add")
    public String journalAdd(@RequestBody JournalEntity journalEntity) {
        return automobileDataBaseService.addJournal(journalEntity) ? "ok" : "error";
    }

}
