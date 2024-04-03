int get_pid_by_name(const char * name);
int is_regular_file(const char * path);
void kill_process(const char * name, int signal);
char * read_file(const char * file_path, bool strip_newline);
