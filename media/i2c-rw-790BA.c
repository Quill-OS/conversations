#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
  int i2cfd = open(argv[1], O_RDWR);
  struct i2c_rdwr_ioctl_data iod;
  struct i2c_msg msg[2];
  uint8_t buf[256];
  uint8_t rbuf[256];
  int wlen,i;
  iod.nmsgs=1;
  //iod.nmsgs=2;
  iod.msgs=msg;
  int ret;
  if (i2cfd < 0) {
    fprintf(stderr, "cannot open %s\n",argv[1]);
    return 1;
  } 
  wlen = strlen(argv[3])/2;
  for(i=0;i<wlen;i++) {
    char b[5];
    b[0]='0';
    b[1]='x';
    b[2]=(argv[3])[i*2];
    b[3]=(argv[3])[i*2+1];
    b[4]=0;
    buf[i] = strtoul(b,NULL,16);
  } 
  msg[0].flags = 0;
  msg[0].addr = strtoul(argv[2], NULL, 0);
  msg[0].len = wlen;
  msg[0].buf = buf;
  msg[1].flags = I2C_M_RD;
  msg[1].addr = strtoul(argv[2], NULL, 0);
  msg[1].len = atoi(argv[4]);
  if (msg[1].len > sizeof(rbuf))
    msg[1].len = sizeof(rbuf);
  msg[1].buf = rbuf;
  ret = ioctl(i2cfd,I2C_RDWR,&iod);
  iod.nmsgs=1;
  iod.msgs=msg+1;
  if (msg[1].len > 0) {
   usleep(70000);
  ret += ioctl(i2cfd,I2C_RDWR,&iod);
  }
  printf("i2c rdwr: %d\n",ret);
  if (ret >= 0) {
    for(i = 0; i < msg[1].len; i++) {
      printf("%02x", rbuf[i]);
    }
    printf("\n");
  }
  return 0;
}
