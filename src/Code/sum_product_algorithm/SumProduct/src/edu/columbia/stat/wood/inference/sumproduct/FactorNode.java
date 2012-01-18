/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.columbia.stat.wood.inference.sumproduct;

import com.sun.org.apache.xpath.internal.operations.Variable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Stack;

/**
 *
 * @author fwood
 */
public class FactorNode {

    public void descendAndPassMessagesUp(VariableNode parent) {
        visited = true;

        for(VariableNode n : variables) {
            if(n.visited == false)
                n.descendAndPassMessagesUp(this);
        }
        if(parent == null) { // root node of traversal
            return;
        } else {
            //for(VariableNode neighbor : variables) {
            //    if(neighbor.visited)
            //        computeMessageTo(neighbor);
            //}
            computeMessageTo(parent);
        }
    }

    public void passMessagesDown() {
        visited = true;
        for(VariableNode n : variables) {
            computeMessageTo(n);
            if(!n.visited)
                n.passMessagesDown();
        }
    }

    public static HashSet<FactorNode> instances = new HashSet<FactorNode>();

    protected boolean visited = false;

    public static void clearVisited() {
        for(FactorNode fn : instances ) {
            fn.visited = false;
        }
    }

    public static void clearMessages() {
        for(FactorNode fn : instances ) {
            fn.messagesToVariableNodes = new HashMap<VariableNode,double[]>();
        }
    }


    ArrayList<VariableNode> variables = new ArrayList<VariableNode>();

    Factor factor;

    public void setValue(double val, int... index) {
        factor.set(val, index);
    }

    public FactorNode(VariableNode... a) {
        int[] dims = new int[a.length];
        
        int c = 0;
        for (VariableNode v : a) {
            variables.add(v);
            dims[c++] = v.dimension;
            v.addFactor(this);
        }
        factor = new Factor(dims);
        instances.add(this);
    }

    public void passUnitFunctionMessageToNeighbors() {
        for(VariableNode n : variables) {
            double[] message = Util.ones(n.dimension);
            messagesToVariableNodes.put(n, message);
        }
    }

    public void computeAllMessages() {
        for(VariableNode n : variables) {
            computeMessageTo(n);
        }
    }

    HashMap<VariableNode, double[]> messagesToVariableNodes = new HashMap<VariableNode,double[]>();


    private double recursiveSumProduct(
            int indexOfToNode, int indexOfVarToSumOut,
            double cumProd, int[] configuration) {

        if(indexOfVarToSumOut == variables.size()) {
            return factor.value(configuration) *cumProd;
        } else {
            if(indexOfVarToSumOut != indexOfToNode) {
                double sum = 0.0;
                VariableNode variableToSumOut = variables.get(indexOfVarToSumOut);
                double[] messageToThisNode = variableToSumOut.getMessageTo(this);
                assert messageToThisNode != null : "message from variable to factor node not ready, messages processed out of order";

                for(int k = 0;k<variableToSumOut.dimension;k++) {
                     configuration[indexOfVarToSumOut] = k;
                     sum += recursiveSumProduct( 
                            indexOfToNode,  indexOfVarToSumOut+1,
                             cumProd* messageToThisNode[k],
                             configuration);

                }
                return sum;
            } else {
                return recursiveSumProduct(
                            indexOfToNode,  indexOfVarToSumOut+1,
                             cumProd,
                             configuration);
            }
        }
    }

    public double[] computeMessageTo(VariableNode v) {
       double[] message = new double[v.dimension];
       int[] configuration = new int[variables.size()];

       int indexOfToNode = variables.indexOf(v);

       for(int d=0;d<v.dimension;d++) {
           configuration[indexOfToNode] = d;
           message[d] = recursiveSumProduct(indexOfToNode, 1, 1.0, configuration);
       }
       messagesToVariableNodes.put(v, message);

       return message;
        
    }

    public double[] getMessageTo(VariableNode v) {
        double[] ret = messagesToVariableNodes.get(v);
        assert ret != null : "Message to variable node requested before it has been computed";
        return ret;
    }
}
