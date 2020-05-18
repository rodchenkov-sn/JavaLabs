package ru.spbstu.autoservice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.spbstu.autoservice.model.*;
import ru.spbstu.autoservice.service.AutomobileDataBaseService;

import java.util.List;

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
    public ResponseEntity<List<AutomobileTableEntity>> automobilesAll() {
        return ResponseEntity.ok(automobileDataBaseService.getAllAutomobiles());
    }

    @GetMapping("/personnel/all")
    public ResponseEntity<List<PersonnelTableEntity>> personnelAll() {
        return ResponseEntity.ok(automobileDataBaseService.getAllPersonnel());
    }

    @GetMapping("/routes/all")
    public ResponseEntity<List<RouteTableEntity>> routesAll() {
        return ResponseEntity.ok(automobileDataBaseService.getAllRoutes());
    }

    @GetMapping("/journal/all")
    public ResponseEntity<List<JournalTableEntity>> journalAll() {
        return ResponseEntity.ok(automobileDataBaseService.getAllJournal());
    }

    //
    //  get by id
    //

    @GetMapping("/automobiles/{id}")
    public ResponseEntity<AutomobileTableEntity> automobilesById(@PathVariable int id) {
        return automobileDataBaseService
                .getAutomobileById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/personnel/{id}")
    public ResponseEntity<PersonnelTableEntity> personnelById(@PathVariable int id) {
        return automobileDataBaseService
                .getPersonnelById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/routes/{id}")
    public ResponseEntity<RouteTableEntity> routesById(@PathVariable int id) {
        return automobileDataBaseService
                .getRouteById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/journal/{id}")
    public ResponseEntity<JournalTableEntity> journalById(@PathVariable int id) {
        return automobileDataBaseService
                .getJournalById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    //
    //  add
    //

    @PostMapping("/automobiles")
    public ResponseEntity<Void> automobilesAdd(@RequestBody AutomobileEntity automobileEntity) {
        return automobileDataBaseService.addAutomobile(automobileEntity)
                ? new ResponseEntity<>(HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    @PostMapping("/personnel")
    public ResponseEntity<Void> personnelAdd(@RequestBody PersonnelTableEntity personnelTableEntity) {
        automobileDataBaseService.addPersonnel(personnelTableEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/routes")
    public ResponseEntity<Void> routesAdd(@RequestBody RouteTableEntity routeTableEntity) {
        automobileDataBaseService.addRoute(routeTableEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/journal")
    public ResponseEntity<Void> journalAdd(@RequestBody JournalEntity journalEntity) {
        return automobileDataBaseService.addJournal(journalEntity)
                ? new ResponseEntity<>(HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    //
    //  delete by id
    //

    @DeleteMapping("/automobiles/{id}")
    public ResponseEntity<Void> automobilesDelete(@PathVariable int id) {
        return automobileDataBaseService.deleteAutomobileById(id)
                ? new ResponseEntity<>(HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    @DeleteMapping("/personnel/{id}")
    public ResponseEntity<Void> personnelDelete(@PathVariable int id) {
        return automobileDataBaseService.deletePersonnelById(id)
                ? new ResponseEntity<>(HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    @DeleteMapping("/routes/{id}")
    public ResponseEntity<Void> routesDelete(@PathVariable int id) {
        return automobileDataBaseService.deleteRouteById(id)
                ? new ResponseEntity<>(HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }

    @DeleteMapping("/journal/{id}")
    public ResponseEntity<Void> journalDelete(@PathVariable int id) {
        automobileDataBaseService.deleteJournalById(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //
    //  get page
    //

    @GetMapping("/automobiles/page/{page}")
    public ResponseEntity<List<AutomobileTableEntity>> automobilePage(@PathVariable int page) {
        return ResponseEntity.ok(automobileDataBaseService.getAutomobilePage(page));
    }

    @GetMapping("/personnel/page/{page}")
    public ResponseEntity<List<PersonnelTableEntity>> personnelPage(@PathVariable int page) {
        return ResponseEntity.ok(automobileDataBaseService.getPersonnelPage(page));
    }

    @GetMapping("/routes/page/{page}")
    public ResponseEntity<List<RouteTableEntity>> routesPage(@PathVariable int page) {
        return ResponseEntity.ok(automobileDataBaseService.getRoutesPage(page));
    }

    @GetMapping("/journal/page/{page}")
    public ResponseEntity<List<JournalTableEntity>> journalPage(@PathVariable int page) {
        return ResponseEntity.ok(automobileDataBaseService.getJournalPage(page));
    }

}
