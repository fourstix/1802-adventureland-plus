/* ADVLAND.H */

/* This file is a port of ADVEN1.BAS found on PC-SIG disk #203 */
/* This was originally written for DOS by Morten Lohre in 1993 */
/* It was further modified by Richard Goedeken in 2019.        */
/*                                                             */
/* Please see the NOTES.TXT and LICENSE.TXT files for more     */
/* information.                                                */
/*                                                             */
/* Copyright (C) 1993 by Morten Løhre, All Rights Reserved.    */
/* Copyright (C) 2019 by Richard Goedeken, All Rights Reselved.*/

#define CL      147+1
#define NL      59+1
#define RL      33+1
#define ML      78+1
#define IL      60+1
#define MX      5       /* max number of items allowed to carry */
#define AR      11      /* start location */
#define TT      13      /* number of treasures */
#define LN      3       /* number of characters in commands in item strings */
#define LT      125     /* number of steps before light goes out */
#define TR      3       /* treasure depository location */
#define MAXLINE 79      /* max number of characters on one line */

/* NOTE: This file is out of date for the 1802 Adventureland project and is for reference only.
 *       The game data in the "adventureland_data.asm" file has been updated and is newer than
 *       the data found here.
 */

/* C0%(151), C1%(151), C2%(151), C3%(151),
   C4%(151), C5%(151), C6%(151), C7%(151) action */
const unsigned char C[CL][16] = {
      0, 75,  8,  1, 19,  6,  8,  0, 10,  0,  0,  0,117, 62,  0,  0,
      0, 10, 20,  1, 21,  0, 20,  0,  7,  6,  0,  0, 12, 52, 59,  0,
      0,  8, 21,  1,  0,  0,  0,  0,  0,  0,  0,  0, 13, 61,  0,  0,
      0,  8, 26,  1, 26,  0, 13,  0,  0,  0,  0,  0, 17, 59, 52,  0,
      0,100,  5,  8, 38,  0, 41,  0, 21,  0,  5,  0, 55, 62, 60, 64,
      0,100, 24,  4,  0,  0,  0,  0,  0,  0,  0,  0, 37, 63,  0,  0,
      0,  5,  7,  1,  7,  0,  1,  0, 12,  6,  0,  0, 40, 62,  0,  0,
      0,  5, 20,  6, 21,  6, 20,  0, 22,  2,  7,  6, 52, 45,  0,  0,
      0,  8, 24,  2,  7, 12,  0,  0,  0,  0,  0,  0, 15, 61,  0,  0,
      0,100,  5,  4,  0,  0,  0,  0,  0,  0,  0,  0, 57,  0,  0,  0,
      0, 50,  8,  1, 12,  6,  8,  0, 55,  0,  0,  0, 48, 59, 52,  0,
      0,100,  7,  8,  7,  0, 47,  0, 25,  0,  0,  0, 60, 62, 66,  0,
      0, 30, 42,  1, 21,  6, 20,  6, 20,  0,  0,  0, 52, 45,  0,  0,
      0, 50, 27,  2,  7,  1,  0,  0,  0,  0,  0,  0, 70,  4, 61,  0,
      0,100, 12,  8, 32,  2, 36,  0, 32,  0, 35,  0, 53, 55, 53,  0,
      0,100, 12,  8, 27,  2, 52,  0, 27,  0,  0,  0, 53, 55,  0,  0,
      0,100,  1,  8,  2,  9,  1,  0,  2,  0,  0,  0, 42, 60, 58,  0,
      0,100, 14,  8, 13,  0, 14,  0,  0,  0,  0,  0, 52, 60, 61,  0,
      0,100, 12,  8, 12,  0,  0,  0,  0,  0,  0,  0, 64, 60,  0,  0,
      0,100, 13,  9, 13,  0,  0,  0,  0,  0,  0,  0,110, 58,115,107,
      0,100,  1,  8,  2,  8,  1,  0,  2,  0,  0,  0, 27, 60, 60,  0,
     29, 16,  1,  2,  0,  0,  0,  0,  0,  0,  0,  0, 46,  0,  0,  0,
     29, 24,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 65,  0,  0,  0,
     29, 54, 34,  2,  0,  0,  0,  0,  0,  0,  0,  0, 46,  0,  0,  0,
     29, 57,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0, 46,  0,  0,  0,
     10, 21,  7,  2, 21,  1, 21,  0,  7,  0,  0,  0, 59, 52,118,  0,
     10, 42, 23,  2,  7,  6, 24,  2,  0,  0,  0,  0, 15, 61,  0,  0,
     10, 21,  7,  2, 20,  1, 20,  0,  7,  0,  0,  0, 59, 52,118,  0,
     18, 42, 23,  1, 23,  0, 25,  2, 39,  0, 25,  0, 59, 14, 53, 55,
     10, 23, 24,  2,  7,  6,  0,  0,  0,  0,  0,  0, 15, 61,  0,  0,
     10, 23, 24,  2,  7,  1, 13,  6,  0,  0,  0,  0, 16,  0,  0,  0,
     10, 23, 24,  2,  7,  1, 13,  1, 13,  0, 26,  0, 59, 52,128,  0,
     10, 33,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 66,  0,  0,  0,
     29,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 70, 64,  0,  0,
     34,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 66,  0,  0,  0,
     23,  0, 29,  1, 17,  4, 23,  0,  0,  0,  0,  0, 54,122, 57, 64,
     14, 25, 31,  3, 28,  6,  0,  0,  0,  0,  0,  0, 19,  0,  0,  0,
     14, 25, 31,  1, 28,  1, 31,  0,  0,  0,  0,  0, 21, 61, 59,  0,
     45, 44,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,114,  0,  0,  0,
     14, 25, 31,  2, 28,  1, 31,  0, 12,  0,  0,  0, 70, 55, 58, 20,
      1, 34, 20,  4, 35,  2, 19,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     10, 25,  1,  4, 40,  6,  0,  0,  0,  0,  0,  0, 16,  0,  0,  0,
     10, 25,  1,  4, 40,  1, 40,  0, 31,  0,  0,  0, 59, 52,127,  0,
     18, 25, 31,  1, 31,  0, 40,  0,  0,  0,  0,  0, 59, 52, 23,  0,
     14, 25, 18,  2, 28,  1,  0,  0,  0,  0,  0,  0, 22,  0,  0,  0,
     45, 53,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,114,  0,  0,  0,
      1, 35, 19,  4,  0,  0,  0,  0,  0,  0,  0,  0, 25,  0,  0,  0,
     18, 10, 38,  1, 38,  0, 29,  2,  1,  0,  0,  0, 53, 36, 58,  0,
     42, 43, 46,  1, 46,  0,  0,  0,  0,  0,  0,  0,119, 59,  0,  0,
     10, 13,  6,  2, 13,  1, 13,  0, 12,  0,  0,  0, 59, 52,  0,  0,
      6,  0, 19,  4, 21,  0, 36,  6,  0,  0,  0,  0, 54, 64,  0,  0,
      6,  0, 21,  4, 19,  0,  0,  0,  0,  0,  0,  0, 54, 64,  0,  0,
      1, 35, 21,  4, 25,  2,  0,  0,  0,  0,  0,  0, 26,  0,  0,  0,
      1, 35, 21,  4, 25,  5, 22,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     35, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 71,  0,  0,  0,
      1, 54, 34,  2,  0,  0,  0,  0,  0,  0,  0,  0,125,  0,  0,  0,
     18, 23, 26,  1, 25,  2, 26,  0, 24,  0, 14,  0, 28, 59, 53, 58,
     10, 13,  6,  2, 13,  6,  0,  0,  0,  0,  0,  0, 16,  0,  0,  0,
     38, 51,  3,  2,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0,  0,  0,
      1, 57,  2,  0,  5,  2,  0,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     18, 13, 12,  1, 12,  0, 13,  0,  0,  0,  0,  0, 59, 52, 29,  0,
     10, 28, 22,  2, 22,  0, 10,  0,  0,  0,  0,  0, 55, 69, 55, 44,
      8, 57,  5,  0,  5,  2, 14, 12,  4,  0, 11,  1, 55, 53,  8,  7,
     39, 20,  5,  4, 16,  2, 14,  6,  0,  0,  0,  0,  6,  0,  0,  0,
     37, 20,  5,  4, 16,  2, 14,  6,  0,  0,  0,  0,  6,  0,  0,  0,
     24, 11, 11,  1,  3,  0, 11,  0,  0,  0,  0,  0, 30, 58, 53,  0,
     39, 20, 16,  2, 14,  1, 16,  0, 17,  0,  0,  0, 55, 53, 64,  0,
     18, 37, 36,  1, 34,  5, 36,  0,  0,  0,  0,  0, 53,  0,  0,  0,
      6,  0, 19,  4, 36,  1,  0,  0,  0,  0,  0,  0, 33, 61,  0,  0,
     18, 37, 36,  1, 56,  0, 45,  0, 34,  0, 36,  0, 53, 53, 55, 59,
     10, 37, 36,  2, 36,  0,  0,  0,  0,  0,  0,  0, 32, 52,  0,  0,
     22,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 34,  0,  0,  0,
     26,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 65, 63,  0,  0,
     10, 10, 38,  2, 25,  2,  0,  0,  0,  0,  0,  0, 26,  0,  0,  0,
     18, 10, 38,  1, 29,  5, 41,  0, 38,  0,  0,  0, 35, 53, 59,  0,
      7,  0,  3,  8, 38,  5,  3,  0,  0,  0,  0,  0,111, 60,  0,  0,
     32,  0,  3,  8,  3,  0, 27,  2,  0,  0,  0,  0, 39, 60,  0,  0,
     33,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 65,  0,  0,  0,
     47,  0, 20,  1,  0,  0,  0,  0,  0,  0,  0,  0,110,113,105,  0,
     47,  0, 21,  1,  0,  0,  0,  0,  0,  0,  0,  0,110,113,105,  0,
      1, 34, 18,  4,  0,  0,  0,  0,  0,  0,  0,  0,102,  0,  0,  0,
     10, 54, 34,  2,  0,  0,  0,  0,  0,  0,  0,  0, 51,  0,  0,  0,
     51,  0, 25,  2, 43,  0, 18,  0, 25,  0,  0,  0, 41, 62, 55,  0,
     18, 23, 26,  1, 27,  2, 24,  0, 44,  0, 27,  0, 53, 53, 55, 43,
     49,  0,  3,  8,  3,  0,  0,  0,  0,  0,  0,  0, 60,  1,110,107,
     39, 20, 17,  2,  0,  0,  0,  0,  0,  0,  0,  0, 64,  0,  0,  0,
      1, 16, 35,  2, 19,  0,  0,  0,  0,  0,  0,  0, 70, 54, 64,  0,
      7,  0,  3,  8, 38,  0,  5,  0,  3,  0, 25,  2, 55, 58, 31, 60,
     45, 11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,110,114,  0,  0,
     36,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 47,  0,  0,
      1, 57,  4,  2,  3,  0,  0,  0,  0,  0,  0,  0, 54, 70, 64,  0,
      8, 57,  5,  2, 11,  1,  5,  0,  4,  0, 14,  1, 55, 53,  8,  0,
     40, 38, 25,  2,  0,  0,  0,  0,  0,  0,  0,  0, 26, 47,  0,  0,
     40, 39, 27,  2,  0,  0,  0,  0,  0,  0,  0,  0,124, 47,  0,  0,
     42, 13, 12,  1, 12,  0, 13,  0,  0,  0,  0,  0,  3, 59, 52,  0,
     42, 13,  6,  2,  0,  0,  0,  0,  0,  0,  0,  0,  3,  0,  0,  0,
     42, 42, 23,  1, 23,  0,  0,  0,  0,  0,  0,  0,119, 59,  0,  0,
     50,  0, 16,  2,  3,  8, 16,  0, 17,  0,  3,  0, 55, 53,  5, 60,
     27,  0, 26,  4,  0, 10,  0,  0,  0,  0,  0,  0,123,  0,  0,  0,
     27,  0, 26,  4,  0, 11, 10,  0,  0,  0,  0,  0, 54, 70, 64,  0,
      8,  0, 11,  6,  0,  0,  0,  0,  0,  0,  0,  0, 38,  0,  0,  0,
     44,  0, 47,  3, 11,  1, 11,  0, 25,  0,  7,  0, 18, 62, 58,  0,
     44,  0, 11,  1, 26,  7, 11,  0, 25,  0,  0,  0, 18, 62, 66,  0,
     28, 17,  9,  3,  0,  0,  0,  0,  0,  0,  0,  0, 51,  0,  0,  0,
     28, 17, 10,  3,  8,  9, 48,  0,  8,  0,  0,  0, 49, 53, 58,  0,
     28, 17, 10,  3, 11,  8,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
     28, 17, 10,  3, 10,  8, 11,  0, 33,  0, 48,  0, 50, 58, 54, 59,
     28, 17, 10,  3,  9,  8, 10,  0, 33,  0, 49,  0, 50, 58, 54, 59,
     28, 17, 10,  3,  8,  8, 49,  0,  9,  0,  0,  0, 49, 53, 58,  0,
     51,  0, 20,  1, 20,  0, 21,  0,  0,  0,  0,  0,120, 12, 59, 52,
     51,  0, 21,  1,  0,  0,  0,  0,  0,  0,  0,  0,120, 13, 61,  0,
     27,  0, 26,  7,  0,  0,  0,  0,  0,  0,  0,  0,126,  0,  0,  0,
     23,  0, 29,  6,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
     44,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
     14, 17,  9,  3,  0,  0,  0,  0,  0,  0,  0,  0,121,  0,  0,  0,
     45, 57,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,103,  0,  0,  0,
     18, 23, 26,  1, 24,  0, 26,  0, 13,  0,  0,  0, 53, 59, 52,  0,
     45, 30,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,103,  0,  0,  0,
     45, 21,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,103,  0,  0,  0,
     48,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,104,  0,  0,  0,
      1, 57, 11,  4, 28,  0,  0,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     47,  0, 26,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,105,109,  0,
     47,  0, 11,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,105,  0,  0,
     47,  0, 19,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,105,  0,  0,
     47,  0, 23,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,106,  0,  0,
     47,  0, 13,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,109,  0,  0,
     47,  0, 17,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,109,  0,  0,
     47,  0, 15,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,109,  0,  0,
     47,  0, 21,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,105,  0,  0,
     47,  0,  8,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,108,  0,  0,
     37, 20, 14,  1, 16,  2, 17,  0, 16,  0,  0,  0, 53, 55, 64,  0,
      1, 56, 17,  2,  6,  0,  0,  0,  0,  0,  0,  0, 54, 56, 70, 64,
     14, 17, 10,  1, 10,  0,  9,  0,  0,  0,  0,  0, 59, 52, 10,  0,
     14, 19,  9,  1,  9,  0, 10,  0,  0,  0,  0,  0, 59, 52,  9,  0,
     10, 51,  3,  2,  0,  0,  0,  0,  0,  0,  0,  0, 11, 61,  0,  0,
      1, 16, 52,  2, 24,  0,  0,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     10, 49,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,110,111,  0,  0,
     14,  0, 28,  1, 18,  5,  0,  0,  0,  0,  0,  0, 24,  0,  0,  0,
     51,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
     23,  0, 29,  1, 17,  7, 17,  0,  0,  0,  0,  0, 54,122, 56, 64,
     47,  0,  1,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,105,  0,  0,
     24, 11, 11,  6,  0,  0,  0,  0,  0,  0,  0,  0, 38,  0,  0,  0,
     47,  0, 20,  4,  0,  0,  0,  0,  0,  0,  0,  0,110,116,103,  0,
     45, 24,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 65,  0,  0,  0,
      1, 16,  4,  4,  5,  0,  0,  0,  0,  0,  0,  0, 54, 70, 64,  0,
     47,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
      8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1, 47,  0,  0,
     24,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,112,  0,  0,  0
};

/* NV$(59,1) commands */
const char *NVS[2][NL] =
{
  "AUT","GO","*ENT","*RUN","*WAL","*CLI","JUM","BEA","CHO","*CUT",
  "TAK","*GET","*PIC","*CAT","LIG","*TUR","*LAM","*BUR","DRO","*REL",
  "*SPI","*LEA","STO","AWA","THR","TOS","QUI","SWI","RUB","LOO",
  "*SHO","*SEE","DRA","SCO","INV","SAV","WAK","UNL","REA","OPE",
  "ATT","*KIL","DRI","*EAT","BUN","FIN","*LOC","HEL","SAY","WIN",
  "DOO","SCR","*YEL","*HOL","NORTH","SOUTH","EAST","WEST","UP","DOWN",
  "ANY","NORTH","SOUTH","EAST","WEST","UP","DOWN","NET","FIS","AWA",
  "MIR","AXE","AXE","WAT","BOT","GAM","HOL","LAM","*ON","OFF",
  "DOO","MUD","*MED","BEE","SCO","GAS","FLI","EGG","OIL","*SLI",
  "KEY","HEL","BUN","INV","LED","THR","CRO","BRI","BEA","DRA",
  "RUG","RUB","HON","FRU","OX","RIN","CHI","*BIT","BRA","SIG",
  "BLA","WEB","*WRI","SWA","LAV","ARO","HAL","TRE","*STU","FIR"
};

/* RM(33,5) room travel */
const unsigned char RM[RL][6] =
{
  0,7,10,1,0,24,
  23,1,1,25,0,0,
  0,0,0,0,0,1,
  1,1,1,1,1,4,
  0,0,0,0,3,5,
  0,0,0,0,4,0,
  0,0,0,0,5,7,
  8,9,0,27,6,12,
  0,7,0,0,0,0,
  7,0,0,0,20,0,
  11,10,0,1,0,26,
  11,11,23,11,0,0,
  13,15,15,0,0,13,
  0,0,0,14,12,0,
  17,12,13,16,16,17,
  12,0,13,12,13,0,
  0,17,0,0,14,17,
  17,12,12,15,14,18,
  0,0,0,0,17,0,
  0,0,0,20,0,0,
  0,0,0,0,0,9,
  0,0,0,0,0,0,
  0,0,0,21,0,0,
  10,1,10,11,0,0,
  0,0,0,0,0,0,
  11,0,1,11,0,0,
  0,0,0,0,0,0,
  0,0,7,0,0,0,
  0,0,0,0,0,11,
  0,0,0,0,0,0,
  0,0,0,0,0,0,
  0,0,0,0,0,0,
  0,0,0,0,0,0,
  0,24,11,24,28,24
};

/* RS$(33) room description */
const char *RSS[RL] = {
  " ",
  "dismal swamp.",
  "*I'm in the top of a tall cypress tree.",
  "large hollow damp stump in the swamp.",
  "root chamber under the stump.",
  "semi-dark hole by the root chamber.",
  "long down-sloping hall.",
  "large cavern.",
  "large 8-sided room.",
  "royal anteroom.",
  "*I'm on the shore of a lake.",
  "forest.",
  "maze of pits.",
  "maze of pits.",
  "maze of pits.",
  "maze of pits.",
  "maze of pits.",
  "maze of pits.",
  "bottom of a chasm.  Above me there are 2 ledges. One has a bricked up\nwindow.",
  "*I'm on a narrow ledge over a chasm. Across the chasm is a throne room.",
  "royal chamber.",
  "*I'm on a narrow ledge by the throne room.\nAcross the chasm is another ledge.",
  "throne room.",
  "sunny meadow.",
  "*I think I'm in real trouble.  Here's a guy with a pitchfork!",
  "hidden grove.",
  "quick-sand bog.",
  "memory RAM of an IBM-PC.  I took a wrong turn!",
  "branch on the top of an old oak tree.\nTo the east I see a meadow beyond a lake.",
  " ",
  " ",
  " ",
  " ",
  "large misty room with strange letters over the exits."
};

/* MS$(77) messages */
const char *MSS[ML] =
{
  " ",
  "Nothing happens...",
  "Focusing intently on the intricate patterns of the web, I am surprised to\nsee the words: CHOP IT DOWN!",
  "Gulp gulp gulp. I didn't realize how thirsty I was!",
  "The dragon snorts and rumbles, smelling something offensive. It grimaces and\nopens its eyes, looking straight at me, then charges!",
  "I hurl the axe at the door and the spinning blade crashes into the lock,\nshattering it. The door swings open.",
  "I pull on the handle but it's no use; the door is secured with a padlock.",
  "I saw a flash of light as the treetop crashed to the ground. Something was\nlost in the branches.",
  "I swing the axe over and over. Chop! Chop! Chop! After a few minutes the giant\ntree heaves over. TIMBER...",
  "One quick puff extinguishes the lamp.",
  "The lamp pops on and bathes the room in a soft warm glow.",
  "As I'm gathering up the web, the spider darts over and bites my hand!",
  "My chigger bites are now infected.",
  "The chigger bites have rotted my whole body.",
  "The bear lumbers over to the honey, voraciously slurps it all up,\nthen falls asleep.",
  "The bees buzz loudly and swarm angrily around me, then begin to sting me\nall over...",
  "I don't have any container to put it in!",
  "I just noticed that the buzzing has stopped. The bees have all suffocated\nin the bottle.",
  "I speak the magic word and begin to feel dizzy. The world spins around me\nand I close my eyes. After breathing slowly for a few seconds, I open\nmy eyes to find that I have been transported.",
  "I don't have anything that I can use to light the gas!",
  "The gas bladder explodes with a loud BANG! A cloud of dust slowly settles.",
  "The gas bladder explodes violently in my hands and knocks me backwards. I hit\nmy head on something.",
  "An eerie blue flame glows for a few seconds then goes out. That was neat\nbut didn't help you much.",
  "Fffffffff. The swamp gas all rushes out of the wine bladder.",
  "I don't think that's flammable.",
  "How do you want me to get across the chasm? Jump?!",
  "To be honest, I'm too scared of the bear to do that. I need to get him out of\nhere first.",
  "Don't waste *HONEY*.  Get mad instead.  Dam lava!",
  "The bees escape from the bottle, buzzing loudly. The bear hears them, looks\nangrily at me, and then charges to attack me!",
  "I pour out the bottle, its former contents soaking into the ground.",
  "Using only one word, tell me at what object you would like me to throw the axe.",
  "I send the axe spinning towards the bear, but he dodges to the side, and then\nI hear a CRASH! Oh no, something broke.",
  "I gather up an armload of bricks, straining under the load. They are heavy!",
  "With all my strength, I jump heroically off the ledge, but I'm carrying too\nmuch weight and don't make it across, falling into the chasm.",
  "To exit the game, say -QUIT-",
  "The mirror slips out of my hands, hits the floor, and shatters into a million\npieces.",
  "The mirror slips out of my hands but miraculously lands softly on the rug.\nIt then begins to glow, and a message appears:",
  "You lost *ALL* treasures.",
  "I'm not carrying the axe. Try 'TAKE INVENTORY'!",
  "The axe ricochets wildly off of the dragon's thick hide.\nThe dragon does not even wake up.",
  "The caked-on mud has become dry and fallen off of my arm.",
  "As I scream, the bear turns to look at me with a started expression on its\nface. As the bear twists, it loses its balance and falls off the ledge!",
  "*DRAGON STINGS* The message fades after a few seconds. I don't understand what\nthis means, but I hope you do!",
  "The bees swarm around the dragon, which wakes up to their incessant buzzing,\nand flies away...",
  "The magical oil has attracted a magical lamp, which appears in your hands. The\nlamp is now full of oil and burning with a blue flame.",
  "Argh! I've been bitten by chiggers! I hate these things. This cannot be good.",
  "It looks exactly like I'd expect it to look. Maybe I should go there?",
  "Maybe if I threw something?...",
  "This poor fish is dry with no water around, and has now died. That's a bummer.",
  "A glowing genie appears, drops something shiny, and then vanishes.",
  "A genie appears and says, \"boy, you're selfish!\" He takes something and then\nvanishes!",
  "NO!  It's too hot.",
  "There's no way for me to climb up to the ledges from down here.",
  "Try the swamp.",
  "Don't use the verb 'say'. Just give me one word.",
  "Try:  LOOK,JUMP,SWIM,CLIMB,THROW,FIND,GO,TAKE,INVENTORY,SCORE,HELP.",
  "Only 3 things will wake the dragon. One of them is dangerous!",
  "If you need a hint on something, try 'HELP'.",
  "Read the sign in the meadow!",
  "You may need magic words here.",
  "A loud, low voice rumbles from all around me, saying:",
  "PLEASE LEAVE IT ALONE!",
  "I don't think it's a good idea to throw that.",
  "Medicine is good for bites.",
  "Sorry, but I can't find it anywhere around here.",
  "Treasures have a * in their name.  Say 'SCORE'",
  "BLOW IT UP",
  "The golden fish wriggles out of your hands and slips back into the lake.",
  "Ewww. The smooth goo stinks to high heaven. But rubbing it into the chigger\nbites feels good.",
  "It tastes delicious! Yet I miss it now that it's gone. Maybe that wasn't such\na good idea.",
  "Argh! These chigger bites itch like mad! Scratching them feels good for a few\nseconds, but then they get even worse.",
  "The lamp is already lit.",
  "The thick persian rug unfurls itself and I hop on. Just by thinking the\nmagic word, it lifts me up and flies away...",
  "I swim out into the lake, but I'm carrying too much and begin sinking, so I\nswim back to shore.",
  "I'm not so sure that it's a good idea to attack the dragon.",
  "I'm not going in the lava! You go in the lava! That's way too hot.",
  "I don't see any place to go swimming around here.",
  "I hold the empty bladder near the bubbling swamp and pull it open, sucking\nthe gas into the bladder.",
  "I manage to coax a few of the bees into the empty bottle without getting stung!"
};

/* IA$(60) item descriptions */
const char *IAS[IL] =
{
  " ",
  "Dark hole",
  "*POT OF RUBIES*/RUB/",
  "Spider web with writing on it.",
  "Hollow stump and remains of a felled tree.",
  "Cypress tree",
  "Water",
  "Evil smelling mud/MUD/",
  "*GOLDEN FISH*/FIS/",
  "Brass lamp (lit)/LAM/",
  "Old fashoned brass lamp/LAM/",
  "Axe (rusty, with a magic word: BUNYON on it)/AXE/",
  "Bottle (filled with water)/BOT/",
  "Empty bottle/BOT/",
  "Ring of skeleton keys/KEY/",
  "Sign: LEAVE TREASURE HERE (say 'SCORE')",
  "Door (locked)",
  "Door (open, with a hallway beyond)",
  "Swamp gas",
  "*GOLDEN NET*/NET/",
  "Chigger bites",
  "Infected chigger bites",
  "Floating patch of oily slime",
  "*ROYAL HONEY*/HON/",
  "Large african bees",
  "Thin black bear",
  "Bottle (with bees buzzing inside)/BOT/",
  "Large sleeping dragon",
  "Flint and steel/FLI/",
  "*THICK PERSIAN RUG*/RUG/",
  "Sign: MAGIC WORD IS AWAY. LOOK LA -(rest of sign is missing)",
  "Bladder (swollen with swamp gas)/BLA/",
  "Bricked up window",
  "Sign: IN SOME CASES MUD IS GOOD, IN OTHERS...",
  "Stream of lava",
  "Bricked up window with a hole blown out of the center, leading to a narrow\nledge",
  "Loose fire bricks",
  "*GOLD CROWN*/CRO/",
  "*MAGIC MIRROR*/MIR/",
  "Thin black bear (asleep)",
  "Empty wine bladder/BLA/",
  "Shards of broken glass",
  "Chiggers/CHI/",
  "Thin black bear (dead)",
  "*DRAGON EGGS* (very rare)/EGG/",
  "Lava stream stopped up with bricks",
  "*JEWELED FRUIT*/FRU/",
  "*SMALL STATUE OF A BLUE OX*/OX/",
  "*DIAMOND RING*/RIN/",
  "*DIAMOND BRACELET*/BRA/",
  "Elaborate carvings on rock which form the message: ALADDIN WAS HERE",
  "Sign: LIMBO.  FIND RIGHT EXIT AND LIVE AGAIN!",
  "Smoking hole.  Pieces of dragon and gore.",
  "Sign: NO SWIMMING ALLOWED",
  "Arrow (pointing down)",
  "Dead golden fish/FIS/",
  "*FIRESTONE* (cold now)/FIR/",
  "Sign: PAUL'S PLACE",
  "Trees",
  " ",
  " "
};

/* I2(60) item locations */
const char I2[IL] =
{
  0,4,4,2,0,1,10,1,10,0,
  3,10,3,0,2,3,5,0,1,18,
  0,0,1,8,8,21,0,23,13,17,
  18,0,20,23,18,0,0,22,21,0,
  9,0,1,0,0,0,25,26,0,0,
  14,33,0,10,17,0,0,25,11,0,
  0
};
