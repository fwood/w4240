/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.columbia.stat.wood.inference.sumproduct;

/**
 *
 * @author fwood
 */
public class Factor {

    private double[] table;
    public int[] dimensions;
    private int[] linearIndexOffetMultiples;

    public Factor(int[] dims) {
        dimensions = dims;
        linearIndexOffetMultiples = new int[dims.length];
        linearIndexOffetMultiples[linearIndexOffetMultiples.length-1]=1;

        // 50 x 3 x 10
        //   ... [50 2 1:10] [50 3 1:10]
        for(int i=dims.length-2;i>=0;i--) {
            linearIndexOffetMultiples[i] = linearIndexOffetMultiples[i+1]*dims[i+1];
        }

        int numel = Util.prod(dims);

        table = new double[numel];
    }

    public double value(int... ind) {

        return table[getLinearIndex(ind)];
    }

    public void set(double v, int... ind) {
        table[getLinearIndex(ind)] = v;
    }

    private int getLinearIndex(int... ind) {
        int linear_index = 0;

        assert ind.length == linearIndexOffetMultiples.length : "wrong number of indices into factor";
        linear_index = 0;
        for(int d=0;d<ind.length;d++)
            linear_index += linearIndexOffetMultiples[d]*ind[d];


        assert linear_index>=0 && linear_index<table.length : "index computed is out of legal array boundary";

        return linear_index;
    }
}
