package com.TaskMaster.service;

import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Value;

@Service
public class FeedbackAnalysisService {
    @Value("${python.interpreter.path:python}")
    private String pythonInterpreter;

    @Value("${feedback.analyzer.script.path}")
    private String scriptPath;

    public String analyzeFeedback(String challengeText, int difficulty, int feedbackID) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder (
                pythonInterpreter,
                scriptPath,
                "--challenge", challengeText,
                "--difficulty", String.valueOf(difficulty),
                "--feedback-id", String.valueOf(feedbackID)
            );

            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            boolean completed = process.waitFor(120, TimeUnit.SECONDS);
            if (!completed) {
                process.destroyForcibly();
                throw new RuntimeException("Python script execution timed out");
            }

            return output.toString().trim();

        } catch(Exception e) {
            throw new RuntimeException("Failed to execute Python feedback analyzer", e);
        }
    }
    
}
