#include "util.h"

#define SYS_WRITE 4
#define STDOUT 1
#define SYS_OPEN 5
#define O_RDWR 2
#define SYS_SEEK 19
#define SEEK_SET 0
#define SHIRA_OFFSET 0x291

extern int system_call();

int main (int argc , char* argv[], char* envp[])
{
  int i;
  for (i = 0; i < argc; i++) {
    system_call(SYS_WRITE,STDOUT,argv[i],strlen(argv[i]));
    system_call(4, 1, "\n", 1);
  }  
  return 0;
}
