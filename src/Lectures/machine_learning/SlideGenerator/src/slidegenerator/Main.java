/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package slidegenerator;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.TreeSet;

/**
 *
 * @author fwood
 */
public class Main {

    static String preamble = "\\documentclass{beamer}\n\n"+
"% \\usepackage{beamerthemesplit} // Activate for custom appearance\n\n"+
"\\title{Lecture}\n"+
"\\author{Frank Wood}\n"+
"\\date{\\today}\n\n"+
"\\input{../definitions/definitions.tex}\n\n"+
"\\begin{document}\n\n"+
"\\frame{\\titlepage}\n\n"+
"\\section[Outline]{}\n"+
"\\frame[t]{\\tableofcontents}\n\n"+
"\\section{Introduction}\n"+
"\\subsection{Overview of Topics}\n\n"+
"\\section{}\n"+
"\\subsection{}\n\n";

    static String theend = "\\end{document}";

    static String framestart = "\\frame[t] { \n"+
 "\\frametitle{}\n"+
 "\\begin{figure}[htbp]\n"+
"\\begin{center}\n"+
"\\includegraphics{\"../prmlfigs-pdf-recolored/";

    static String frameend = 
"\\end{center}\n"+
"\\end{figure}\n"+
"}\n\n\n";


    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here

        if(args.length!=3) {
            System.err.println("Usage : fig_num_start fig_num_end filename");
            System.exit(-1);
        }

        File dir = new File("./prmlfigs-pdf-recolored");

        String[] files = dir.list();

        //for(int i = 0; i<files.length; i++) {
        //    System.out.println(files[i]);
        //}

        List<String> files_al = Arrays.asList(files);
        FileNameComparator fnc = new FileNameComparator();
        TreeSet<String> ts = new TreeSet<String>(fnc);
        ts.addAll(files_al);

        try {
        FileOutputStream fos = new FileOutputStream(new File(args[2]));
        PrintStream ps = new PrintStream(fos);
        ps.print(preamble);
        for(String s : ts.descendingSet()) {
           if(fnc.compare(s, args[0]) <0 && fnc.compare(s, args[1])>0) {
               ps.print(framestart);
               String[] s_parts = s.split("\\.");
               String basename = s_parts[0];

               ps.print(basename);
               String figname = basename.substring(6);

               String[] chapt_fig = figname.split("_");

               String chapter = chapt_fig[0];
               String fig = chapt_fig[1];

               String caption = "Chapter "+chapter+", Figure "+fig;

               String label = "fig:"+chapter+"_"+fig;
               ps.print("\"}"+
"\\caption{"+ caption +"}\n"+
"\\label{" + label +"}\n");
               ps.print(frameend);
           }
        }
        ps.print(theend);
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    private static class FileNameComparator implements Comparator {

        public int compare(Object o1, Object o2) {
            String fn1 = (String)o1;
            String fn2 = (String)o2;

            String[] fn1_parts = fn1.split("_");
            String[] fn1_rparts = fn1_parts[1].split("\\.");

            String fn1_num = fn1_rparts[0];
            String[] fn1_num_sub = fn1_num.split("\\d");
            String fn1_sub = "";
            if(fn1_num_sub.length!=0) {
              fn1_sub = fn1_num_sub[fn1_num_sub.length-1];
              fn1_num_sub = fn1_num.split("\\D");
              fn1_num = fn1_num_sub[0];
            }
            //


            String fn1_chapt = fn1_parts[0].substring(6);

            String[] fn2_parts = fn2.split("_");
            String[] fn2_rparts = fn2_parts[1].split("\\.");

            String fn2_num = fn2_rparts[0];
            String[] fn2_num_sub = fn2_num.split("\\d");
            String fn2_sub = "";
            if(fn2_num_sub.length!=0) {
              fn2_sub = fn2_num_sub[fn2_num_sub.length-1];
              fn2_num_sub = fn2_num.split("\\D");
              fn2_num = fn2_num_sub[0];
            }
            //
            
            String fn2_chapt = fn2_parts[0].substring(6);

            int j=0;

            if(fn1_chapt.matches("\\D*") && !fn2_chapt.matches("\\D*"))
                return -2;
            else if (!fn1_chapt.matches("\\D*") && fn2_chapt.matches("\\D*"))
                return 2;

            if(fn1_chapt.length() < fn2_chapt.length())
                return 2;
            else if (fn1_chapt.length() > fn2_chapt.length())
                return -2;
            

            while(j<fn1_chapt.length() && j < fn2_chapt.length()) {
                if(fn1_chapt.charAt(j)<fn2_chapt.charAt(j)) {
                    return 2;
                } else if (fn1_chapt.charAt(j)>fn2_chapt.charAt(j)) {
                    return -2;
                }
                j++;
            }

            //if(fn1_num.length() < fn2_num.length())
            //    return 2;
            //else if (fn1_num.length() > fn2_num.length())
            //    return -2;

            // same chapter

            if(Integer.parseInt(fn1_num) < Integer.parseInt(fn2_num))
                return 2;
            else if (Integer.parseInt(fn1_num) > Integer.parseInt(fn2_num))
                return -2;

            /*int k=0;
            while(k<fn1_num.length() && k < fn2_num.length()) {
                if(fn1_num.charAt(k)<fn2_num.charAt(k)) {
                    return 2;
                } else if (fn1_num.charAt(k)>fn2_num.charAt(k)) {
                    return -2;
                }
                k++;
            }*/

            // same figure
            int l=0;
            while(l<fn1_sub.length() && l < fn2_sub.length()) {
                if(fn1_sub.charAt(l)<fn2_sub.charAt(l)) {
                    return 2;
                } else if (fn1_sub.charAt(l)>fn2_sub.charAt(l)) {
                    return -2;
                }
                l++;
            }
            
            return 0;

            //throw new UnsupportedOperationException("Not supported yet.");
        }

    }

}
