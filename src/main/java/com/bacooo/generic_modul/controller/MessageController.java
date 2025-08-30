package com.bacooo.generic_modul.controller;

import com.bacooo.generic_modul.model.MessageDto;
import com.bacooo.generic_modul.service.MessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@Slf4j
public class MessageController {

    private final MessageService messageService;

    @GetMapping("/messages")
    public ResponseEntity<List<MessageDto>> getAllMessages() {
        log.info("GET /api/v1/messages - Retrieving all messages");
        List<MessageDto> messages = messageService.getAllMessages();
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/messages/{id}")
    public ResponseEntity<MessageDto> getMessageById(@PathVariable Long id) {
        log.info("GET /api/v1/messages/{} - Retrieving message by id", id);
        MessageDto message = messageService.getMessageById(id);
        return ResponseEntity.ok(message);
    }
}