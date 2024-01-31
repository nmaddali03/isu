// 3.3 Project Task
// Neha Maddali

/** Modifications to the code:
 *  added an integer variable v to count the number of vowels.
 *  inside wc function, in the loop that iterates through the
 *  characters in the input file, for each character, it checks
 *  if it is a vowel (lowercase and uppercase) using strchr.
 *  if it is a vowel, it increments the v counter.
 *  updated the printf statement to include the v variable for 
 *  number of vowels.
**/
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char buf[512];

void
wc(int fd, char *name)
{
  int i, n;
  //added variable v for the vowels
  int l, w, c, v, inword;

  //initialized variable v for the vowels
  l = w = c = v = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
        inword = 1;
      }
      //check for the vowels
      if(strchr("aeiouAEIOU", buf[i]))
        v++;
    }
  }
  if(n < 0){
    printf("wc: read error\n");
    exit(1);
  }
  //edit print statement to fit vowels
  printf("%d %d %d %d %s\n", l, w, c, v, name);
}

int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit(0);
}
