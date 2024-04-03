#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include <stdbool.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include "kill_process.h"

void kill_process(const char * name, int signal) {
	int pid = get_pid_by_name(name);
	printf("%d\n", pid);
	if(pid != -1) {
		kill(pid, signal);
	}
}

int is_regular_file(const char *path)
{
    struct stat path_stat;
    stat(path, &path_stat);
    return S_ISREG(path_stat.st_mode);
}

int get_pid_by_name(const char * name) {
	struct dirent * entry = NULL;
	DIR * dp = NULL;

	const char proc[] = "/proc/";
	dp = opendir(proc);
	while((entry = readdir(dp))) {
		// cmdline is more accurate, sometimes status may be buggy
		char cmdline_file[1024] = { 0 };
		sprintf(cmdline_file, "%s%s/cmdline", proc, entry->d_name);
		printf("%s\n", cmdline_file);

		if(strcmp(cmdline_file, "/proc/./cmdline") == 0 || strcmp(cmdline_file, "/proc/self/cmdline") == 0 || strcmp(cmdline_file, "/proc/thread-self/cmdline") == 0) {
			continue;
		}
		if(access(cmdline_file, F_OK) != 0) {
			continue;
		}
		printf("got there\n");

		// https://www.geeksforgeeks.org/how-to-append-a-character-to-a-string-in-c/
		FILE* ptr;
		char ch;
		char cmdline[4096] = { 0 };

		// Opening file in reading mode
		ptr = fopen(cmdline_file, "r");
		printf("opened file\n");
		// Printing what is written in file
		// character by character using loop.
		do {
			ch = fgetc(ptr);
			strncat(cmdline, &ch, 1);

			// Checking if character is not EOF.
			// If it is EOF stop reading.
		} while (ch != EOF);

		// Closing the file
		fclose(ptr);
		printf("closed file\n");

		// https://stackoverflow.com/questions/2340281/check-if-a-string-contains-a-string-in-c
		if(strstr(cmdline, name)) {
			// After closing directory, it's impossible to call entry->d_name
			int return_pid = atoi(entry->d_name);
			closedir(dp);
			return return_pid;
		}
	}
	// If we get here, we haven't found any PID
	closedir(dp);
	return -1;
}

char * read_file(const char * file_path, bool strip_newline) {
	// Ensure that specified file exists, then try to read it
	if(access(file_path, F_OK) != 0) {
		return NULL;
	}

	FILE * fp = fopen(file_path , "rb");
	if(!fp) {
		return NULL;
	}

	fseek(fp, 0L, SEEK_END);
	long bytes = ftell(fp);
	rewind(fp);

	// Allocate memory for entire content
	char * buffer = NULL;
	buffer = calloc(sizeof(*buffer), (size_t) bytes + 1U);
	if(!buffer) {
		goto cleanup;
	}

	// Copy the file into the buffer
	if(fread(buffer, sizeof(*buffer), (size_t) bytes, fp) < (size_t) bytes || ferror(fp) != 0) {
		// Short read or error, meep!
		free(buffer);
		buffer = NULL;
		goto cleanup;
	}

	// If requested, remove trailing newline
	if(strip_newline && bytes > 0 && buffer[bytes - 1] == '\n') {
		buffer[bytes - 1] = '\0';
	}

cleanup:
	fclose(fp);
	return buffer; // May be NULL (indicates failure)
}

int main() {
	kill_process("busybox", SIGKILL);
}
