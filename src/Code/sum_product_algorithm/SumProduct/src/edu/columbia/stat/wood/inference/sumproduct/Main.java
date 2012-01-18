/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.columbia.stat.wood.inference.sumproduct;

import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.util.Iterator;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

/**
 *
 * @author fwood
 */
public class Main {

    public static void loopyBPImageDenoisingExample() {

        double h = .2;
        double beta = .5;
        double eta = .75;

        //Iterator readers = ImageIO.getImageReadersByFormatName("bmp");
        //ImageReader reader = (ImageReader) readers.next();

        try {


            int[][] noisy_image = {{1, 1, 1, 1}, {1, 1, 1, 1}, {1, 0, 0, 0}, {1, 0, 0, 0}};
            int num_rows = noisy_image.length;
            int num_cols = noisy_image[0].length; //obviously not safe

            /*BufferedInputStream bis = new BufferedInputStream(new FileInputStream("/Users/fwood/Projects/columbia/web/w4240/src/Code/image_denoising/professor_wood.bmp"));

            ImageInputStream iis = ImageIO.createImageInputStream(bis);
            reader.setInput(iis, true);
            BufferedImage buffered_image = reader.read(0);

            int[][] image = new int[buffered_image.getWidth()][buffered_image.getHeight()];
            Raster raster = buffered_image.getRaster();

            int num_rows = buffered_image.getHeight();
            int num_cols = buffered_image.getWidth();
            for (int r = 0; r < num_rows; r++) {
            for (int c = 0; c < num_cols; c++) {
            int[] pixel = new int[3];
            raster.getPixel(r, c, pixel);
            if (pixel[0] > 128 || pixel[1] > 128 || pixel[2] > 128) {
            image[r][c] = 1;
            }
            }
            }*/




            VariableNode[][] observedVariables = new VariableNode[num_rows][num_cols];
            VariableNode[][] hiddenVariables = new VariableNode[num_rows][num_cols];

            //FactorNode[][] observedToHiddenFactors = new FactorNode[num_rows][num_cols];
            //FactorNode[][] verticalHiddenToHiddenFactors = new FactorNode[num_rows][num_cols];
            //FactorNode[][] horizontalHiddenToHiddenFactors = new FactorNode[num_rows][num_cols];


            for (int r = 0; r < num_rows; r++) {
                for (int c = 0; c < num_cols; c++) {
                    VariableNode observation = new VariableNode(2);
                    observation.setValue(noisy_image[r][c]);

                    if (r == 0 || r == (num_rows - 1) || c == 0 || c == (num_cols - 1)) {
                        // on border
                        hiddenVariables[r][c] = observation;
                    } else { // interior
                        observedVariables[r][c] = observation;
                        hiddenVariables[r][c] = new VariableNode(2);
                    }
                    //System.out.print(image[i][j]);
                }
                //System.out.println();
            }

            for (int r = 0; r < num_rows; r++) {
                for (int c = 0; c < num_cols; c++) {
                    if (!(r == 0 || r == (num_rows - 1) || c == 0 || c == (num_cols - 1))) {    // interior
                        FactorNode fn = new FactorNode(hiddenVariables[r][c], observedVariables[r][c]);
                        fn.setValue(Math.exp(eta - h), 0, 0);
                        fn.setValue(Math.exp(-eta - h), 0, 1);
                        fn.setValue(Math.exp(-eta + h), 1, 0);
                        fn.setValue(Math.exp(eta + h), 1, 1);
                    }
                }
            }

            for (int r = 1; r < (num_rows - 1); r++) {
                for (int c = 1; c < (num_cols - 1); c++) {
                    FactorNode fnv = new FactorNode(hiddenVariables[r][c], hiddenVariables[r - 1][c]);
                    FactorNode fnh = new FactorNode(hiddenVariables[r][c], hiddenVariables[r][c - 1]);
                    fnv.setValue(Math.exp(beta), 0, 0);
                    fnv.setValue(Math.exp(-beta), 0, 1);
                    fnv.setValue(Math.exp(-beta), 1, 0);
                    fnv.setValue(Math.exp(beta), 1, 1);
                    fnh.setValue(Math.exp(beta), 0, 0);
                    fnh.setValue(Math.exp(-beta), 0, 1);
                    fnh.setValue(Math.exp(-beta), 1, 0);
                    fnh.setValue(Math.exp(beta), 1, 1);

                    if (r == (num_rows - 2)) {
                        fnv = new FactorNode(hiddenVariables[r][c], hiddenVariables[r + 1][c]);
                        fnv.setValue(Math.exp(beta), 0, 0);
                        fnv.setValue(Math.exp(-beta), 0, 1);
                        fnv.setValue(Math.exp(-beta), 1, 0);
                        fnv.setValue(Math.exp(beta), 1, 1);
                    }
                    if (c == (num_cols - 2)) {
                        fnh = new FactorNode(hiddenVariables[r][c], hiddenVariables[r][c + 1]);
                        fnh.setValue(Math.exp(beta), 0, 0);
                        fnh.setValue(Math.exp(-beta), 0, 1);
                        fnh.setValue(Math.exp(-beta), 1, 0);
                        fnh.setValue(Math.exp(beta), 1, 1);
                    }
                }
            }

            FactorGraph model = new FactorGraph();
            model.addVariableNodes(observedVariables);
            model.addVariableNodes(hiddenVariables);

            model.initLoopyBPMessages();
            
            imageDenoisingResults(noisy_image, model, hiddenVariables);

            for (int l = 0; l < 10; l++) {

                model.passLoopyBPMessages();
                imageDenoisingResults(noisy_image, model, hiddenVariables);
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void imageDenoisingResults(int[][] noisy_image, FactorGraph model, VariableNode[][] hiddenVariables) {
        int num_rows = noisy_image.length;
        int num_cols = noisy_image[0].length;
        double[][][] marginals = new double[num_rows][num_cols][2];

        int[][] map_image = new int[num_rows][num_cols];

        for (int r = 0; r < num_rows; r++) {
            for (int c = 0; c < num_cols; c++) {
                double[] pixel_marginal = model.marginal(hiddenVariables[r][c]);
                marginals[r][c][0] = pixel_marginal[0];
                marginals[r][c][1] = pixel_marginal[1];

                if (pixel_marginal[0] > pixel_marginal[1]) {
                    map_image[r][c] = 0;
                }
                System.out.print(marginals[r][c][0] + "-" + marginals[r][c][1] + ", ");

            }
            System.out.println();
        }
    }

    public static void gaugeExplainingAwayExample() {
        VariableNode electricFuelGauge = new VariableNode(2);
        VariableNode battery = new VariableNode(2);
        VariableNode fuelTank = new VariableNode(2);

        FactorNode batteryFactor = new FactorNode(battery);
        FactorNode fuelTankFactor = new FactorNode(fuelTank);
        FactorNode electricFuelGaugeFactor = new FactorNode(electricFuelGauge, battery, fuelTank);

        batteryFactor.setValue(.1, 0);
        batteryFactor.setValue(.9, 1); // prior 90% chance charged
        fuelTankFactor.setValue(.1, 0);
        fuelTankFactor.setValue(.9, 1); // prior 90% chance full of fuel
        electricFuelGaugeFactor.setValue(.8, 1, 1, 1); // 80% chance gauge reads full if battery is charged and fuel tank is full
        electricFuelGaugeFactor.setValue(.2, 1, 1, 0);
        electricFuelGaugeFactor.setValue(.2, 1, 0, 1);
        electricFuelGaugeFactor.setValue(.1, 1, 0, 0);
        electricFuelGaugeFactor.setValue(.2, 0, 1, 1);
        electricFuelGaugeFactor.setValue(.8, 0, 1, 0);
        electricFuelGaugeFactor.setValue(.8, 0, 0, 1);
        electricFuelGaugeFactor.setValue(.9, 0, 0, 0);

        FactorGraph model = new FactorGraph();
        model.addVariableNodes(electricFuelGauge, battery, fuelTank);
        model.addFactorNodes(batteryFactor, fuelTankFactor, electricFuelGaugeFactor);

        model.passMessages();

        double[] marginal = model.marginal(electricFuelGauge);

        System.out.println("No Observations : prior dist of fuel gauge status (" + marginal[0] + ", " + marginal[1] + ")");

        fuelTank.setValue(0);
        model.passMessages();

        marginal = model.marginal(electricFuelGauge);

        System.out.println("Fuel tank  empty : conditional dist of fuel gauge status (" + marginal[0] + ", " + marginal[1] + ")");

        marginal = model.marginal(fuelTank);

        System.out.println("Check : Fuel tank  empty : conditional dist of fuel tank (" + marginal[0] + ", " + marginal[1] + ")");


        model.clearValues();
        electricFuelGauge.setValue(0);
        model.passMessages();

        marginal = model.marginal(fuelTank);

        System.out.println("Conditional probability that tank  empty :  given gauge reads empty (" + marginal[0] + ", " + marginal[1] + ")");

        battery.setValue(0);
        model.passMessages();

        marginal = model.marginal(fuelTank);

        System.out.println("Conditional probability that tank  empty :  given gauge reads empty and battery is dead (" + marginal[0] + ", " + marginal[1] + ")");

        model.clear();
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        gaugeExplainingAwayExample();

        System.out.println("Loopy BP broken");
        loopyBPImageDenoisingExample();
    }
}
