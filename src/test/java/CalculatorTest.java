import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;
import CalculatorProject.Calculator;

public class CalculatorTest {

    private Calculator calc;

    @Before
    public void setUp() {
        calc = new Calculator();
    }

    @Test
    public void testAddTwoNumbers() {
        assertEquals(20, calc.add(10, 10));
    }

    @Test
    public void testAddThreeNumbers() {
        assertEquals(20, calc.add(5, 5, 10));
    }

    @Test
    public void testSubtractTwoNumbers() {
        assertEquals(0, calc.subtract(10, 10));
    }

    @Test
    public void testSubtractThreeNumbers() {
        assertEquals(0, calc.subtract(20, 10, 10));
    }
}
