import org.junit.Test;
import static org.junit.Assert.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

/*sample tests for homework. you will need to add to these */

public class PrimeNumberFinderTest {

    // Instantiate class - this will cover the constructor of the class
    @Test
    public void instantiateClass() {
        PrimeNumberFinder myPrime = new PrimeNumberFinder();
    }

    // Tests for the findPrimes method (you can add to these)
    @Test
    public void testFindPrimes1() {
        List<Integer> primes = PrimeNumberFinder.findPrimes(2, 8);
        List<Integer> expected = Arrays.asList(2, 3, 5, 7);
        assertArrayEquals(expected.toArray(), primes.toArray());
    }

    @Test
    public void testFindPrimes2() {
        List<Integer> primes = PrimeNumberFinder.findPrimes(10, 21);
        List<Integer> expected = Arrays.asList(11, 13, 17, 19);
        assertArrayEquals(expected.toArray(), primes.toArray());
    }

    // tests for the isPrime method

    // test for a prime number
    @Test
    public void testIsPrime1() {
        assertTrue(PrimeNumberFinder.isPrime(23));
    }

    // test for a non-prime number
    @Test
    public void testIsPrime2() {
        assertFalse(PrimeNumberFinder.isPrime(10));
    }

    // test for a prime number
    @Test
    public void testIsPrime3() {
        assertTrue(PrimeNumberFinder.isPrime(13));
        assertTrue(PrimeNumberFinder.isPrime(17));
    }

    // test for a non-prime number
    @Test
    public void testIsPrime4() {
        assertFalse(PrimeNumberFinder.isPrime(0));
        assertFalse(PrimeNumberFinder.isPrime(1));
        assertFalse(PrimeNumberFinder.isPrime(6));
        assertFalse(PrimeNumberFinder.isPrime(9));
        assertFalse(PrimeNumberFinder.isPrime(20));
        assertFalse(PrimeNumberFinder.isPrime(25));
        assertFalse(PrimeNumberFinder.isPrime(44));
        assertFalse(PrimeNumberFinder.isPrime(49));
        assertFalse(PrimeNumberFinder.isPrime(143));
    }

    // tests for the sumofP method - note the list provided is the list of primes
    // to be summed - not the lower and upper bound

    @Test
    public void sumofP1() {
        List<Integer> input = Arrays.asList(5, 7);
        assertEquals(12, PrimeNumberFinder.computeSumOfPrimes(input));
    }

    @Test
    public void sumofP2() {
        List<Integer> input = Arrays.asList(5);
        assertEquals(5, PrimeNumberFinder.computeSumOfPrimes(input));
    }

    @Test
    public void testComputeSumOfPrimesWithEmptyList() {
        List<Integer> input = Arrays.asList();
        int result = PrimeNumberFinder.computeSumOfPrimes(input);
        assertEquals(0, result);
    }

    /*
    @Test
    public void test() {
        List<Integer> input = Arrays.asList();
        assertThrows(ArrayIndexOutOfBoundsException.class, () -> PrimeNumberFinder.computeSumOfPrimes(input));
    }
     */
}
