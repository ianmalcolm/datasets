/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hbgen;

import java.util.Random;

/**
 *
 * @author ian
 */
public class HBGen {

    private static int simlen = 3600 * 24 * 7;
    private static int accurq = 0;
    private static int accurp = 0;
    private static int period = 600;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        Session[] s = new Session[10];
//        s[0] = new Session(66, 66, 10);
//        s[1] = new Session(66, 66, 12);
//        s[2] = new Session(66, 66, 14);
//        s[3] = new Session(66, 66, 16);
//        s[4] = new Session(66, 66, 18);
//        s[5] = new Session(66, 66, 20);
//        s[6] = new Session(66, 66, 22);
//        s[7] = new Session(66, 66, 24);
//        s[8] = new Session(66, 66, 26);
//        s[9] = new Session(66, 66, 28);
//        s[10] = new Session(36, 0, 11);
//        s[11] = new Session(36, 0, 13);
//        s[12] = new Session(36, 0, 15);
//        s[13] = new Session(36, 0, 17);
//        s[14] = new Session(36, 0, 19);
//        s[15] = new Session(36, 0, 21);
//        s[16] = new Session(36, 0, 23);
//        s[17] = new Session(36, 0, 25);
//        s[18] = new Session(36, 0, 27);
//        s[19] = new Session(36, 0, 29);
        Random r = new Random();
        for (int i = 0; i < s.length; i++) {
            int len = (int) (50 + r.nextGaussian() * 15);
            boolean ssh = r.nextBoolean();
            int p = (int) (100 + r.nextGaussian() * 10);
//            s[i] = new Session(len, ssh ? 0 : len, p);
            s[i] = new Session(ssh ? 36 : 66, ssh ? 0 : 66, p);
        }

        for (int t = 0; t < simlen; t++) {

            for (int i = 0; i < s.length; i++) {
                accurq += s[i].tic();
            }
            for (int i = 0; i < s.length; i++) {
                accurp += s[i].toc();
            }

            if (t % period == 0) {
                if (t > 600) {
//                    System.out.printf("%d\t%d\t%d\n", accurq, accurp, accurq - accurp);
                    System.out.printf("%d\t%d\n", accurq, accurp);
                }
                accurq = 0;
                accurp = 0;
            }
        }

    }

}

class Session {

    private int hbrqlen;
    private int hbrplen;
    private int period;
    private int delay = 1;
    private int cnt;

    Session(int rq, int rp, int p) {
        hbrqlen = rq;
        hbrplen = rp;
        period = p;
        cnt = 1;
    }

    public int tic() {
        cnt++;
        if (cnt == period - 1) {
            return hbrqlen;
        }
        return 0;

    }

    public int toc() {
        if (cnt == period) {
            Random r = new Random();
            delay = r.nextInt(3) == 2 ? 2 : 1;
            cnt = 0;
            return hbrplen;
        }
        return 0;
    }

}
