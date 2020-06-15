typedef enum bit [1:0] {IDLE,BUSY,NONSEQ,SEQ} htransfer_t;
typedef enum bit [2:0] {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16} hburst_t;
typedef enum bit [2:0] {BYTE,HALFWORD,WORD,DOUBLEWORD,FOURWORD, EIGHTWORD, SIXTEENWORD, THIRTYTWOWORD} hsize_t;
typedef enum bit 	   {READ,WRITE} rw_t;
