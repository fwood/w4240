/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.columbia.stat.wood.inference.sumproduct;

import java.util.HashMap;
import java.util.HashSet;

/**
 *
 * @author fwood
 */
public class VariableNode {

     public void passUnitFunctionMessageToNeighbors() {
         if(value<0) {
        for(FactorNode n : factors) {
            double[] message = Util.ones(dimension);
            messagesToFactorNodes.put(n, message);
        } } else {
            for(FactorNode n : factors) {
            double[] message = new double[dimension];
            message[value] = 1;
            messagesToFactorNodes.put(n, message);
        }
        }
    }

    public void computeAllMessages() {
        for(FactorNode n : factors) {
            computeMessageTo(n);
        }
    }

    protected boolean visited = false;

    public static void clearVisited() {
        for(VariableNode n : instances ) {
            n.visited = false;
        }
    }

    public void descendAndPassMessagesUp(FactorNode parent) {
        visited = true;

        for(FactorNode n : factors) {
            if(n.visited == false)
                n.descendAndPassMessagesUp(this);
        }
        if(parent == null) { // root node of traversal
            return;
        } else {
            computeMessageTo(parent);
        }
    }

    public void passMessagesDown() {
        visited = true;
        for(FactorNode n : factors) {
            computeMessageTo(n);
            if(!n.visited)
                n.passMessagesDown();
        }
    }

    public int dimension;
    public int value;
    public static HashSet<VariableNode> instances = new HashSet<VariableNode>();

    public static void clearMessages() {
        for (VariableNode n : instances) {
            n.messagesToFactorNodes = new HashMap<FactorNode, double[]>();
        }
    }

    public VariableNode(int dimension) {
        this.dimension = dimension;
        instances.add(this);
        value = -1;
    }
    public HashSet<FactorNode> factors = new HashSet<FactorNode>();

    public void clearValue() {
        value = -1;
    }

    public void setValue(int k) {
        value = k;
    }
    HashMap<FactorNode, double[]> messagesToFactorNodes = new HashMap<FactorNode, double[]>();

    public double[] getMessageTo(FactorNode n) {
        double[] message = messagesToFactorNodes.get(n);
        assert message != null : "message to factor node from variable node requested but not yet computed, problem in graph traversal";
        return message;
    }

    public double[] computeMessageTo(FactorNode n) {
        if (value < 0) {
            double[] message = Util.ones(dimension);

            for (FactorNode f : factors) {
                if (f != n) {
                    Util.prodIntoFirst(message, f.getMessageTo(this));
                }
            }

            messagesToFactorNodes.put(n, message);
            return message;
        } else {
            double[] message = new double[dimension];
            message[value] = 1;
            messagesToFactorNodes.put(n, message);
            return message;
        }
    }

    public void addFactor(FactorNode n) {
        factors.add(n);
    }
}
