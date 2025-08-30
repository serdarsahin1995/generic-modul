package com.bacooo.generic_modul.service;

import com.bacooo.generic_modul.model.MessageDto;

import java.util.List;

public interface MessageService {
    List<MessageDto> getAllMessages();
    MessageDto getMessageById(Long id);
}