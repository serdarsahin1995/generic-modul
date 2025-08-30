package com.bacooo.generic_modul.service.impl;

import com.bacooo.generic_modul.exception.MessageNotFoundException;
import com.bacooo.generic_modul.model.MessageDto;
import com.bacooo.generic_modul.repository.MessageRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MessageServiceImplTest {

    @Mock
    private MessageRepository messageRepository;

    @InjectMocks
    private MessageServiceImpl messageService;

    @Test
    void shouldReturnAllMessages() {
        List<MessageDto> expectedMessages = Arrays.asList(
                new MessageDto(1L, "Test Message 1"),
                new MessageDto(2L, "Test Message 2")
        );
        when(messageRepository.findAll()).thenReturn(expectedMessages);

        List<MessageDto> actualMessages = messageService.getAllMessages();

        assertEquals(expectedMessages, actualMessages);
        verify(messageRepository).findAll();
    }

    @Test
    void shouldReturnMessageById() {
        Long messageId = 1L;
        MessageDto expectedMessage = new MessageDto(messageId, "Test Message");
        when(messageRepository.findById(messageId)).thenReturn(Optional.of(expectedMessage));

        MessageDto actualMessage = messageService.getMessageById(messageId);

        assertEquals(expectedMessage, actualMessage);
        verify(messageRepository).findById(messageId);
    }

    @Test
    void shouldThrowExceptionWhenMessageNotFound() {
        Long messageId = 999L;
        when(messageRepository.findById(messageId)).thenReturn(Optional.empty());

        MessageNotFoundException exception = assertThrows(MessageNotFoundException.class, 
                () -> messageService.getMessageById(messageId));

        assertEquals("Message not found with id: " + messageId, exception.getMessage());
        verify(messageRepository).findById(messageId);
    }
}