package com.bacooo.generic_modul.controller;

import com.bacooo.generic_modul.model.MessageDto;
import com.bacooo.generic_modul.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(MessageController.class)
class MessageControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private MessageService messageService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldReturnAllMessages() throws Exception {
        List<MessageDto> messages = Arrays.asList(
                new MessageDto(1L, "Merhaba"),
                new MessageDto(2L, "Dünya"),
                new MessageDto(3L, "REST")
        );
        when(messageService.getAllMessages()).thenReturn(messages);

        mockMvc.perform(get("/api/v1/messages"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(3))
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].text").value("Merhaba"));
    }

    @Test
    void shouldReturnMessageById() throws Exception {
        MessageDto message = new MessageDto(1L, "Merhaba");
        when(messageService.getMessageById(1L)).thenReturn(message);

        mockMvc.perform(get("/api/v1/messages/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.text").value("Merhaba"));
    }
}