package CalculatorProject;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class Calculator {

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello, calculator app is working!";
    }

    public int add(int num1, int num2) {
        return num1 + num2;
    }

    public int add(int num1, int num2, int num3) {
        return num1 + num2 + num3;
    }

    public int subtract(int num1, int num2, int num3) {
        return num1 - num2 - num3;
    }

    public int subtract(int num1, int num2) {
        return num1 - num2;
    }
}
