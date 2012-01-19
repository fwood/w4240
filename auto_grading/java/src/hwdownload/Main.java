/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package hwdownload;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author nicholasbartlett
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException, ParseException {
        Properties props = System.getProperties();
        props.setProperty("mail.store.protocol", "imaps");
        try {
            Session session = Session.getDefaultInstance(props, null);
            Store store = session.getStore("imaps");
            store.connect("imap.gmail.com", "w4240.spring2011.stat.columbia.edu", "2010sasmbmbbwcnhm");

            Folder inbox = store.getFolder("Inbox");
            inbox.open(Folder.READ_ONLY);
            Message messages[] = inbox.getMessages();

            Arrays.sort(messages,new MessageComparator());

            String path = "/Users/nicholasbartlett/Documents/ta/w4240/hw/" + args[0] + "/";

            HashMap<String,String> h = new HashMap<String,String>();

            for (Message m : messages) {

                String[] parsedSubject = m.getSubject().split(":");

                if(parsedSubject.length == 2){

                    String uni = parsedSubject[0].trim().toLowerCase();
                    String hwNumber = parsedSubject[1].trim().toLowerCase();

                    if(hwNumber.equals(args[0])){
                        MimeMessage message = (MimeMessage) m;
                        MimeMultipart mp = (MimeMultipart) m.getContent();

                        for(int i = 0; i < mp.getCount(); i++){
                            MimeBodyPart bp = (MimeBodyPart) mp.getBodyPart(i);
                            
                            if(bp.getFileName() != null && (bp.getFileName().trim().indexOf(".m") == bp.getFileName().trim().length()-2 ||
                                                            bp.getFileName().trim().indexOf(".rar") == bp.getFileName().trim().length()-4 ||
                                                            bp.getFileName().trim().indexOf(".gz") == bp.getFileName().trim().length()-3 ||
                                                            bp.getFileName().trim().indexOf(".doc") == bp.getFileName().trim().length()-4 ||
                                                            bp.getFileName().trim().indexOf(".docx") == bp.getFileName().trim().length()-5 ||
                                                            bp.getFileName().trim().indexOf(".pdf") == bp.getFileName().trim().length()-4 ||
                                                            bp.getFileName().trim().indexOf(".zip") == bp.getFileName().trim().length()-4 )){

                                BufferedInputStream bis = null;
                                BufferedOutputStream bos = null;
                                try{
                                    File f_path = new File(path + uni + "/");
                                    f_path.mkdirs();
                                    File f = new File(path + uni + "/" + bp.getFileName());

                                    bos = new BufferedOutputStream(new FileOutputStream(f));
                                    bis = new BufferedInputStream(bp.getInputStream());
                                    byte[] mfile = new byte[bp.getSize()];
                                    
                                    int b;
                                    int ind = 0;
                                    while((b = bis.read()) > -1){
                                        mfile[ind++] = (byte) b;
                                        bos.write(b);
                                    }

                                    byte[] mfile2 = new byte[ind];
                                    System.arraycopy(mfile,0,mfile2,0,ind);

                                    String md5 = MD5.getMD5(mfile2);
                                    String otherUNI = h.put(md5,uni);

                                    if(otherUNI != null){
                                        System.out.println(mfile2.length);
                                        System.out.println("The UNI's " + uni + " and " + otherUNI + " have the same file"
                                                + " for file " + bp.getFileName());
                                    }

                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                                finally {
                                    bis.close();
                                    bos.close();
                                }
                            }
                        }
                    }
                }
            }
            inbox.close(false);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.exit(2);
        }
    }

    public static class MessageComparator implements Comparator{

        public int compare(Object message1, Object message2) {
            MimeMessage m1 = (MimeMessage) message1;
            MimeMessage m2 = (MimeMessage) message2;
            
            try {
                Date m1Sent = m1.getSentDate();
                Date m2Sent = m2.getSentDate();

                return m1Sent.compareTo(m2Sent);
            } catch (MessagingException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }

            throw new RuntimeException();
        }

    }

    public static class MD5 {
        public static String getMD5(byte[] input) {
            try {
                MessageDigest md = MessageDigest.getInstance("MD5");
                byte[] messageDigest = md.digest(input);
                BigInteger number = new BigInteger(1, messageDigest);
                String hashtext = number.toString(16);

                // Now we need to zero pad it if you actually want the full 32 chars.
                while (hashtext.length() < 32) {
                    hashtext = "0" + hashtext;
                }
                return hashtext;
            }
            catch (NoSuchAlgorithmException e) {
                throw new RuntimeException(e);
            }
        }
    }


}
