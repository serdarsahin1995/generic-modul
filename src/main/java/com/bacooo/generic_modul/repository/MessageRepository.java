package com.bacooo.generic_modul.repository;

import com.bacooo.generic_modul.model.MessageDto;

import java.util.List;
import java.util.Optional;

public interface MessageRepository {
    List<MessageDto> findAll();
    Optional<MessageDto> findById(Long id);
}