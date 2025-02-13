package com.TaskMaster.controller;

import com.theokanning.openai.service.OpenAiService;
import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatMessage;
import com.theokanning.openai.completion.chat.ChatCompletionResult;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/taskBreakdown")
public class TaskBreakdownController {


    @Value("${openai.api.key}")
    private String OPENAI_API_KEY;

    @PostMapping("/generate")
    public ResponseEntity<List<String>> breakdownTask(@RequestBody TaskBreakdownRequest request) {
        try {
            OpenAiService openAiService = new OpenAiService(OPENAI_API_KEY);
            
            ChatCompletionRequest chatCompletionRequest = ChatCompletionRequest.builder()
                .model("gpt-3.5-turbo")  // You can also use "gpt-4"
                .messages(Arrays.asList(
                    new ChatMessage("system", "You are a helpful assistant."),
                    new ChatMessage("user", "Break down this task into 3-4 specific, actionable subtasks: " + request.getTaskDescription())
                ))
                .maxTokens(150)
                .build();

            // Call OpenAI API
            ChatCompletionResult result = openAiService.createChatCompletion(chatCompletionRequest);

            // Log the raw OpenAI response for debugging
            System.out.println("OpenAI API Response: " + result);

            // Process and return the subtasks
            List<String> subtasks = Arrays.stream(
                result.getChoices().get(0).getMessage().getContent().split("\n")
            )
            .filter(subtask -> !subtask.trim().isEmpty())
            .collect(Collectors.toList());

            return ResponseEntity.ok(subtasks);
        } catch (Exception e) {
            e.printStackTrace();  // Log the exception
            return ResponseEntity.status(500).body(List.of("An error occurred: " + e.getMessage()));
        }
    }
}

class TaskBreakdownRequest {
    private String taskDescription;

    // Getter
    public String getTaskDescription() {
        return taskDescription;
    }

    // Setter
    public void setTaskDescription(String taskDescription) {
        this.taskDescription = taskDescription;
    }
}