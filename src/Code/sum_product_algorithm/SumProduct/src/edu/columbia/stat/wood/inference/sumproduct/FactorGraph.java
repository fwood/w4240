/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.columbia.stat.wood.inference.sumproduct;

import java.util.Arrays;
import java.util.HashSet;

/**
 *
 * @author fwood
 */
public class FactorGraph {

    public HashSet<FactorNode> factorNodes = new HashSet<FactorNode>();
    public HashSet<VariableNode> variableNodes = new HashSet<VariableNode>();

    public void clear() {
        VariableNode.instances.clear();
        FactorNode.instances.clear();
    }

    public void addVariableNodes(VariableNode[][] nodes) {
        for (VariableNode[] n : nodes) {
            if(n!=null && !(n.length==0))
            variableNodes.addAll(Arrays.asList(n));
            for(VariableNode vn : n) {
                if(vn!=null && vn.factors != null) {
                for(FactorNode fn : vn.factors)
                    factorNodes.add(fn);}
            }
        }
        variableNodes.remove(null);
    }

    public void addFactorNodes(FactorNode[][] nodes) {
        for (FactorNode[] n : nodes) {
            if(n!=null && !(n.length==0))
            factorNodes.addAll(Arrays.asList(n));
            
        }
        factorNodes.remove(null);

    }

    public void addVariableNodes(VariableNode... nodes) {
        variableNodes.addAll(Arrays.asList(nodes));
    }

    public void addFactorNodes(FactorNode... nodes) {
        factorNodes.addAll(Arrays.asList(nodes));
    }

    public double[] marginal(VariableNode v) {
        double[] marginal = null;

        if(v.value<0) {
             marginal = Util.ones(v.dimension);
        for (FactorNode n : v.factors) {
            Util.prodIntoFirst(marginal, n.getMessageTo(v));
        }
        double sum = 0.0;

        for (int i = 0; i < marginal.length; i++) {
            sum += marginal[i];
        }
        for (int i = 0; i < marginal.length; i++) {
            marginal[i] = marginal[i] / sum;
        }
        } else {
            marginal = new double[v.dimension];
            marginal[v.value] = 1;
        }
        return marginal;
    }

    public void clearValues() {
        for (VariableNode v : variableNodes) {
            v.clearValue();
        }
    }

    public void initLoopyBPMessages() {
        for(VariableNode n : variableNodes) {
            n.passUnitFunctionMessageToNeighbors();
        }
        for(FactorNode n : factorNodes) {
            n.passUnitFunctionMessageToNeighbors();
        }
    }

    public void passLoopyBPMessages() {
        for(VariableNode n : variableNodes) {
            n.computeAllMessages();
        }
        for(FactorNode n : factorNodes) {
            n.computeAllMessages();
        }
    }

    public void passMessages() {
        VariableNode root = variableNodes.iterator().next();
        VariableNode.clearVisited();
        FactorNode.clearVisited();
        root.descendAndPassMessagesUp(null);
        VariableNode.clearVisited();
        FactorNode.clearVisited();
        root.passMessagesDown();
    }
}
