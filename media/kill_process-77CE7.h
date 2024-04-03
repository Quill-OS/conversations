#include <stdbool.h>
int get_pid_by_name(const char * name);
void kill_process(const char * name, int signal);
char * read_file(const char * file_path, bool strip_newline);
bool is_number(const char * str);
