package com.bacooo.generic_modul.repository;

import com.bacooo.generic_modul.model.MessageDto;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Repository
public class InMemoryMessageRepository implements MessageRepository {
    
    private final List<MessageDto> messages = Arrays.asList(
            new MessageDto(1L, "Merhaba"),
            new MessageDto(2L, "Dünya"),
            new MessageDto(3L, "REST")
    );

    @Override
    public List<MessageDto> findAll() {
        return messages;
    }

    @Override
    public Optional<MessageDto> findById(Long id) {
        return messages.stream()
                .filter(message -> message.getId().equals(id))
                .findFirst();
    }
}