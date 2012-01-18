/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.columbia.stat.wood.inference.sumproduct;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author fwood
 */
public class FactorGraphTest {

    public FactorGraphTest() {
    }

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @Before
    public void setUp() {
    }

    @After
    public void tearDown() {
    }

    /**
     * Test of addVariableNodes method, of class FactorGraph.
     */
    @Test
    public void testAddVariableNodes() {
        System.out.println("addVariableNodes");
        VariableNode[] nodes = null;
        FactorGraph instance = new FactorGraph();
        instance.addVariableNodes(nodes);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of addFactorNodes method, of class FactorGraph.
     */
    @Test
    public void testAddFactorNodes() {
        System.out.println("addFactorNodes");
        FactorNode[] nodes = null;
        FactorGraph instance = new FactorGraph();
        instance.addFactorNodes(nodes);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of marginal method, of class FactorGraph.
     */
    @Test
    public void testMarginal() {
        System.out.println("marginal");
        VariableNode v = null;
        FactorGraph instance = new FactorGraph();
        double[] expResult = null;
        double[] result = instance.marginal(v);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of clearValues method, of class FactorGraph.
     */
    @Test
    public void testClearValues() {
        System.out.println("clearValues");
        FactorGraph instance = new FactorGraph();
        instance.clearValues();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of passMessages method, of class FactorGraph.
     */
    @Test
    public void testPassMessages() {
        System.out.println("passMessages");
        FactorGraph instance = new FactorGraph();
        instance.passMessages();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

}