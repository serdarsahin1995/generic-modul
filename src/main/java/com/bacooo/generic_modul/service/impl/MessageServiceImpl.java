package com.bacooo.generic_modul.service.impl;

import com.bacooo.generic_modul.exception.MessageNotFoundException;
import com.bacooo.generic_modul.model.MessageDto;
import com.bacooo.generic_modul.repository.MessageRepository;
import com.bacooo.generic_modul.service.MessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MessageServiceImpl implements MessageService {

    private final MessageRepository messageRepository;

    @Override
    public List<MessageDto> getAllMessages() {
        log.info("Retrieving all messages");
        List<MessageDto> messages = messageRepository.findAll();
        log.info("Found {} messages", messages.size());
        return messages;
    }

    @Override
    public MessageDto getMessageById(Long id) {
        log.info("Retrieving message with id: {}", id);
        return messageRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Message with id {} not found", id);
                    return new MessageNotFoundException("Message not found with id: " + id);
                });
    }
}