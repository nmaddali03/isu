package edu.iastate.cs311.hw3;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
public class AlignmentTest {
	SubstitutionGap param;
	Sequence seqone;
	Sequence seqtwo;
	Alignment align;
	
	@Before
	public void create() {
		param = new SubstitutionGap();
	}
	
	@Test
	public void runtimeErrorTest() {
        seqtwo = new Sequence("B", "ACCTCGACTA");
        String expectedError = "Sequence object one is null.";
        String thrownError = null;
        
        try{
        	align = new Alignment(null, seqtwo, param);
        }catch(RuntimeException e){
        	thrownError = e.getMessage();
        }

        assertTrue("seqone null, expected: \"Sequence object one is null.\"", expectedError.equals(thrownError));
        
        seqone = new Sequence("B", "ACCTCGACTA");
        expectedError = "Sequence object two is null.";
        thrownError = null;
        
        try{
        	align = new Alignment(seqone, null, param);
        }catch(RuntimeException e){
        	thrownError = e.getMessage();
        }

        assertTrue("seqtwo null, expected: \"Sequence object two is null.\"", expectedError.equals(thrownError));
        
        expectedError = "SubstitutionGap object is null.";
        thrownError = null;
        
        try{
        	align = new Alignment(seqone, seqtwo, null);
        }catch(RuntimeException e){
        	thrownError = e.getMessage();
        }

        assertTrue("SubstitutionGap is null expected: \"SubstitutionGap object is null.\"", expectedError.equals(thrownError));
        
        seqone = new Sequence("A", "");
        seqtwo = new Sequence("B", "");
        expectedError = "Both sequences are empty.";
        thrownError = null;
        
        try{
        	align = new Alignment(seqone, seqtwo, param);
        }catch(RuntimeException e){
        	thrownError = e.getMessage();
        }

        assertTrue("seqone and seqtwo are empty, expected: \"Both sequences are empty.\"", expectedError.equals(thrownError));
	}
	
	@Test
	public void editDistanceTest() {
		Sequence seqone = new Sequence("A", "ACGTCGAGCTA");
		Sequence seqtwo = new Sequence("B", "ACCTCGACTA");
		Alignment align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 1: Test from skeleton code not working, align value = " + align.getEditdistance() + " not 35", align.getEditdistance() == 35);
		
		seqone = new Sequence("A", "CTAGCAGGTGA");
		seqtwo = new Sequence("B", "ACGCATGCACG");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 2: Alignment value is " + align.getEditdistance() + " not 120", align.getEditdistance() == 120);
		
		
		seqone = new Sequence("A", "ACAGGTGTGGTAAACACAGCCCCAC");
		seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 3: Alignment value is " + align.getEditdistance() + " not 290", align.getEditdistance() == 290);
		
		seqone = new Sequence("A", "");
        seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 4: Alignment value is " + align.getEditdistance() + " not 105", align.getEditdistance() == 105);
        
        seqone = new Sequence("A", "TTAGAGA");
        seqtwo = new Sequence("B", "");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 5: Alignment value is " + align.getEditdistance() + " not 105", align.getEditdistance() == 105);
		
		seqone = new Sequence("A", "CGGTTATACTGTTGTACGATCCAATCCGAGCATGTGGAGACCTTCTATCGCTGGCCCGTTCAGTATTGTTTTGGG");
		seqtwo = new Sequence("B", "AAAGAGCGACTAGGTACGCGGTGTCGCCCTTTGAAACAGAACTGGTAGGGCGGCTCTACCCGTATCTCTTCATCCACGATCG");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 6: Alignment value is " + align.getEditdistance() + " not 795", align.getEditdistance() == 795);

		//give match bonus of -5
		param.match = -5;
		//re-caluclate last score
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 7: When match bonus is set to -5, edit distance does not decrease to 560", align.getEditdistance() == 560);
	}
	
	@Test
	public void numDifferencesTest() {
		seqone = new Sequence("A", "ACGTCGAGCTA");
		seqtwo = new Sequence("B", "ACCTCGACTA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 1: Test from skeleton code not working, difference value = " + align.getNumberOfDifference() + " not 2", align.getNumberOfDifference() == 2);
		seqone = new Sequence("A", "CTAGCAGGTGA");
		seqtwo = new Sequence("B", "ACGCATGCACG");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 2: Difference value is " + align.getNumberOfDifference() + " not 8", align.getNumberOfDifference() == 8);
		
		seqone = new Sequence("A", "ACAGGTGTGGTAAACACAGCCCCAC");
		seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 3: Difference value is " + align.getNumberOfDifference() + " not 19", align.getNumberOfDifference() == 19);
		
		seqone = new Sequence("A", "");
        seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 4: Difference value is " + align.getNumberOfDifference() + " not 7", align.getNumberOfDifference() == 7);
        
        seqone = new Sequence("A", "TTAGAGA");
        seqtwo = new Sequence("B", "");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 5: Difference value is " + align.getNumberOfDifference() + " not 7", align.getNumberOfDifference() == 7);
		
		seqone = new Sequence("A", "CGGTTATACTGTTGTACGATCCAATCCGAGCATGTGGAGACCTTCTATCGCTGGCCCGTTCAGTATTGTTTTGGG");
		seqtwo = new Sequence("B", "AAAGAGCGACTAGGTACGCGGTGTCGCCCTTTGAAACAGAACTGGTAGGGCGGCTCTACCCGTATCTCTTCATCCACGATCG");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 6: Difference value is " + align.getNumberOfDifference() + " not 48", align.getNumberOfDifference() == 48);
	}
	
	@Test
	public void getAlignmentLengthTest() {
		seqone = new Sequence("A", "ACGTCGAGCTA");
		seqtwo = new Sequence("B", "ACCTCGACTA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 1: Test from skeleton code not working, alignment length = " + align.getAlignmentLength() + " not 11", align.getAlignmentLength() == 11);
		seqone = new Sequence("A", "CTAGCAGGTGA");
		seqtwo = new Sequence("B", "ACGCATGCACG");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 2: Alignment length is " + align.getAlignmentLength() + " not 15", align.getAlignmentLength() == 15);
		
		seqone = new Sequence("A", "ACAGGTGTGGTAAACACAGCCCCAC");
		seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 3: Alignment length is " + align.getAlignmentLength() + " not 25", align.getAlignmentLength() == 25);
		
		seqone = new Sequence("A", "");
        seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 4: Alignment length is " + align.getAlignmentLength() + " not 7", align.getAlignmentLength() == 7);
        
        seqone = new Sequence("A", "TTAGAGA");
        seqtwo = new Sequence("B", "");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 5: Alignment length is " + align.getAlignmentLength() + " not 7", align.getAlignmentLength() == 7);
		
		seqone = new Sequence("A", "CGGTTATACTGTTGTACGATCCAATCCGAGCATGTGGAGACCTTCTATCGCTGGCCCGTTCAGTATTGTTTTGGG");
		seqtwo = new Sequence("B", "AAAGAGCGACTAGGTACGCGGTGTCGCCCTTTGAAACAGAACTGGTAGGGCGGCTCTACCCGTATCTCTTCATCCACGATCG");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 6: Alignment length is " + align.getAlignmentLength() + " not 95", align.getAlignmentLength() == 95);
	}
	
	@Test
	public void midRowTest() {
		seqone = new Sequence("A", "ACGTCGAGCTA");
		seqtwo = new Sequence("B", "ACCTCGACTA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 1: Test from skeleton code not working, Mid Row Expected = \"|| ||||-|||\"", align.getAlignment('M').equals("|| ||||-|||"));
		
		seqone = new Sequence("A", "CTAGCAGGTGA");
		seqtwo = new Sequence("B", "ACGCATGCACG");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 2: Expected Mid Row is \"--|-|||--||-|--\"", align.getAlignment('M').equals("--|-|||--||-|--"));
		
		seqone = new Sequence("A", "ACAGGTGTGGTAAACACAGCCCCAC");
		seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 3: Expected Mid Row is \"-------|--|----| ||----|-\"", align.getAlignment('M').equals("-------|--|----| ||----|-"));
		
		seqone = new Sequence("A", "");
        seqtwo = new Sequence("B", "TTAGAGA");
		align = new Alignment(seqone, seqtwo, param);
		
		assertTrue("Test 4: Expected Mid Row is \"-------\"", align.getAlignment('M').equals("-------"));
        
        seqone = new Sequence("A", "TTAGAGA");
        seqtwo = new Sequence("B", "");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 5: Expected Mid Row is \"-------\"", align.getAlignment('M').equals("-------"));
		
		seqone = new Sequence("A", "CGGTTATACTGTTGTACGATCCAATCCGAGCATGTGGAGACCTTCTATCGCTGGCCCGTTCAGTATTGTTTTGGG");
		seqtwo = new Sequence("B", "AAAGAGCGACTAGGTACGCGGTGTCGCCCTTTGAAACAGAACTGGTAGGGCGGCTCTACCCGTATCTCTTCATCCACGATCG");
		align = new Alignment(seqone, seqtwo, param);

		assertTrue("Test 6: Expected Mid Row is \"------||  ||--|||- | |||-||- ||----|| | || |-|-||-||-|-|--|-||||-| |-|  | |-||||-|--|- |-- |- |\"",
				align.getAlignment('M').equals("------||  ||--|||- | |||-||- ||----|| | || |-|-||-||-|-|--|-||||-| |-|  | |-||||-|--|- |-- |- |"));
	}
}
