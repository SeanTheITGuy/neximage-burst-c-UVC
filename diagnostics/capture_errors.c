/* Capture every dequeued buffer, including V4L2_BUF_FLAG_ERROR. No device writes
 * beyond volatile UVC streaming negotiation. Usage: capture_errors [device] */
#include <linux/videodev2.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <poll.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
static void check(int r,const char *s){if(r<0){perror(s);exit(1);}}
int main(int argc,char **argv){
 setvbuf(stdout,NULL,_IOLBF,0);
 int fd=open(argc>1?argv[1]:"/dev/video0",O_RDWR|O_NONBLOCK);check(fd,"open");
 struct v4l2_format f={.type=V4L2_BUF_TYPE_VIDEO_CAPTURE};check(ioctl(fd,VIDIOC_G_FMT,&f),"G_FMT");
 printf("format %ux%u %.4s stride=%u size=%u\n",f.fmt.pix.width,f.fmt.pix.height,(char*)&f.fmt.pix.pixelformat,f.fmt.pix.bytesperline,f.fmt.pix.sizeimage);
 struct v4l2_requestbuffers req={.count=4,.type=V4L2_BUF_TYPE_VIDEO_CAPTURE,.memory=V4L2_MEMORY_MMAP};check(ioctl(fd,VIDIOC_REQBUFS,&req),"REQBUFS");
 void *ptr[4];size_t lengths[4];
 for(unsigned i=0;i<req.count;i++){
 struct v4l2_buffer b={.type=req.type,.memory=req.memory,.index=i};check(ioctl(fd,VIDIOC_QUERYBUF,&b),"QUERYBUF");lengths[i]=b.length;ptr[i]=mmap(NULL,b.length,PROT_READ|PROT_WRITE,MAP_SHARED,fd,b.m.offset);if(ptr[i]==MAP_FAILED){perror("mmap");return 1;}check(ioctl(fd,VIDIOC_QBUF,&b),"QBUF");}
 int type=req.type;check(ioctl(fd,VIDIOC_STREAMON,&type),"STREAMON");puts("STREAMON success");
 const char *count_env=getenv("NEXIMAGE_CAPTURE_COUNT");int count=count_env?atoi(count_env):8;
 if(count<1 || count>1000){fprintf(stderr,"Invalid capture count\n");return 1;}
 for(int i=0;i<count;i++){
 struct pollfd p={.fd=fd,.events=POLLIN};int r=poll(&p,1,2500);check(r,"poll");if(!r){puts("No buffer in 2500 ms");break;}
 struct v4l2_buffer b={.type=req.type,.memory=req.memory};check(ioctl(fd,VIDIOC_DQBUF,&b),"DQBUF");
 printf("seq=%u bytes=%u flags=0x%x error=%d time=%ld.%06ld\n",b.sequence,b.bytesused,b.flags,!!(b.flags&V4L2_BUF_FLAG_ERROR),(long)b.timestamp.tv_sec,(long)b.timestamp.tv_usec);
 const char *prefix=getenv("NEXIMAGE_CAPTURE_PREFIX");if(!prefix)prefix="diagnostics/frame";
 char name[256];snprintf(name,sizeof(name),"%s-%u.raw",prefix,b.sequence);FILE *out=fopen(name,"wb");if(!out){perror("fopen");break;}fwrite(ptr[b.index],1,b.bytesused,out);fclose(out);check(ioctl(fd,VIDIOC_QBUF,&b),"QBUF");}
 check(ioctl(fd,VIDIOC_STREAMOFF,&type),"STREAMOFF");for(unsigned i=0;i<req.count;i++)munmap(ptr[i],lengths[i]);close(fd);return 0;
}
