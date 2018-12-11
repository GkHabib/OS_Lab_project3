
_sort:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return str; 
} 

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp

  // sort_syscalls(2);
  // invoked_syscalls(2);
  // get_count(2, 16);
  // log_syscalls();
  ticketlockinit();
  11:	e8 2c 04 00 00       	call   442 <ticketlockinit>
  ticketlocktest();
  16:	e8 2f 04 00 00       	call   44a <ticketlocktest>
  ticketlocktest();
  1b:	e8 2a 04 00 00       	call   44a <ticketlocktest>
  ticketlocktest();
  20:	e8 25 04 00 00       	call   44a <ticketlocktest>
  ticketlocktest();
  25:	e8 20 04 00 00       	call   44a <ticketlocktest>
  exit();
  2a:	e8 53 03 00 00       	call   382 <exit>
  2f:	90                   	nop

00000030 <reverse>:
{ 
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	56                   	push   %esi
  34:	53                   	push   %ebx
    int end = length -1; 
  35:	8b 45 0c             	mov    0xc(%ebp),%eax
{ 
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int end = length -1; 
  3b:	83 e8 01             	sub    $0x1,%eax
    while (start < end) 
  3e:	85 c0                	test   %eax,%eax
  40:	7e 20                	jle    62 <reverse+0x32>
    int start = 0; 
  42:	31 d2                	xor    %edx,%edx
  44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        char a = *(str+start);
  48:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        *(str+start) = *(str+end);
  4c:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
  50:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        *(str+end) = a;
  53:	89 f3                	mov    %esi,%ebx
        start++; 
  55:	83 c2 01             	add    $0x1,%edx
        *(str+end) = a;
  58:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
        end--; 
  5b:	83 e8 01             	sub    $0x1,%eax
    while (start < end) 
  5e:	39 c2                	cmp    %eax,%edx
  60:	7c e6                	jl     48 <reverse+0x18>
} 
  62:	5b                   	pop    %ebx
  63:	5e                   	pop    %esi
  64:	5d                   	pop    %ebp
  65:	c3                   	ret    
  66:	8d 76 00             	lea    0x0(%esi),%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000070 <itoa>:
{ 
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	57                   	push   %edi
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
  76:	83 ec 04             	sub    $0x4,%esp
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if (num == 0) 
  7f:	85 c0                	test   %eax,%eax
  81:	0f 84 91 00 00 00    	je     118 <itoa+0xa8>
    if (num < 0 && base == 10) 
  87:	85 c0                	test   %eax,%eax
  89:	79 7d                	jns    108 <itoa+0x98>
  8b:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
  8f:	75 77                	jne    108 <itoa+0x98>
        num = -num; 
  91:	f7 d8                	neg    %eax
        isNegative = 1; 
  93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
  9a:	31 db                	xor    %ebx,%ebx
  9c:	eb 04                	jmp    a2 <itoa+0x32>
  9e:	66 90                	xchg   %ax,%ax
  a0:	89 fb                	mov    %edi,%ebx
  a2:	99                   	cltd   
  a3:	f7 7d 10             	idivl  0x10(%ebp)
  a6:	8d 7a 57             	lea    0x57(%edx),%edi
  a9:	8d 72 30             	lea    0x30(%edx),%esi
  ac:	83 fa 0a             	cmp    $0xa,%edx
  af:	89 fa                	mov    %edi,%edx
  b1:	8d 7b 01             	lea    0x1(%ebx),%edi
  b4:	0f 4c d6             	cmovl  %esi,%edx
    while (num != 0) 
  b7:	85 c0                	test   %eax,%eax
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
  b9:	88 54 39 ff          	mov    %dl,-0x1(%ecx,%edi,1)
    while (num != 0) 
  bd:	75 e1                	jne    a0 <itoa+0x30>
    if (isNegative) 
  bf:	8b 75 f0             	mov    -0x10(%ebp),%esi
  c2:	8d 14 39             	lea    (%ecx,%edi,1),%edx
  c5:	85 f6                	test   %esi,%esi
  c7:	74 09                	je     d2 <itoa+0x62>
        str[i++] = '-'; 
  c9:	8d 7b 02             	lea    0x2(%ebx),%edi
  cc:	c6 02 2d             	movb   $0x2d,(%edx)
  cf:	8d 14 39             	lea    (%ecx,%edi,1),%edx
    while (start < end) 
  d2:	83 ef 01             	sub    $0x1,%edi
    str[i] = '\0';
  d5:	c6 02 00             	movb   $0x0,(%edx)
    while (start < end) 
  d8:	74 1e                	je     f8 <itoa+0x88>
  da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        char a = *(str+start);
  e0:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
        *(str+start) = *(str+end);
  e4:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  e8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
        *(str+end) = a;
  eb:	88 1c 39             	mov    %bl,(%ecx,%edi,1)
        start++; 
  ee:	83 c0 01             	add    $0x1,%eax
        end--; 
  f1:	83 ef 01             	sub    $0x1,%edi
    while (start < end) 
  f4:	39 f8                	cmp    %edi,%eax
  f6:	7c e8                	jl     e0 <itoa+0x70>
} 
  f8:	83 c4 04             	add    $0x4,%esp
  fb:	89 c8                	mov    %ecx,%eax
  fd:	5b                   	pop    %ebx
  fe:	5e                   	pop    %esi
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    
 102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int isNegative = 0; 
 108:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 10f:	eb 89                	jmp    9a <itoa+0x2a>
 111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[i++] = '0'; 
 118:	bf 30 00 00 00       	mov    $0x30,%edi
} 
 11d:	89 c8                	mov    %ecx,%eax
        str[i++] = '0'; 
 11f:	66 89 39             	mov    %di,(%ecx)
} 
 122:	83 c4 04             	add    $0x4,%esp
 125:	5b                   	pop    %ebx
 126:	5e                   	pop    %esi
 127:	5f                   	pop    %edi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    
 12a:	66 90                	xchg   %ax,%ax
 12c:	66 90                	xchg   %ax,%ax
 12e:	66 90                	xchg   %ax,%ax

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	89 c2                	mov    %eax,%edx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 140:	83 c1 01             	add    $0x1,%ecx
 143:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 147:	83 c2 01             	add    $0x1,%edx
 14a:	84 db                	test   %bl,%bl
 14c:	88 5a ff             	mov    %bl,-0x1(%edx)
 14f:	75 ef                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 151:	5b                   	pop    %ebx
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    
 154:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 15a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 55 08             	mov    0x8(%ebp),%edx
 167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 16a:	0f b6 02             	movzbl (%edx),%eax
 16d:	0f b6 19             	movzbl (%ecx),%ebx
 170:	84 c0                	test   %al,%al
 172:	75 1c                	jne    190 <strcmp+0x30>
 174:	eb 2a                	jmp    1a0 <strcmp+0x40>
 176:	8d 76 00             	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 180:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 183:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 186:	83 c1 01             	add    $0x1,%ecx
 189:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 18c:	84 c0                	test   %al,%al
 18e:	74 10                	je     1a0 <strcmp+0x40>
 190:	38 d8                	cmp    %bl,%al
 192:	74 ec                	je     180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 194:	29 d8                	sub    %ebx,%eax
}
 196:	5b                   	pop    %ebx
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1a2:	29 d8                	sub    %ebx,%eax
}
 1a4:	5b                   	pop    %ebx
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	89 f6                	mov    %esi,%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1b6:	80 39 00             	cmpb   $0x0,(%ecx)
 1b9:	74 15                	je     1d0 <strlen+0x20>
 1bb:	31 d2                	xor    %edx,%edx
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
 1c0:	83 c2 01             	add    $0x1,%edx
 1c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1c7:	89 d0                	mov    %edx,%eax
 1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1d0:	31 c0                	xor    %eax,%eax
}
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	89 d7                	mov    %edx,%edi
 1ef:	fc                   	cld    
 1f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f2:	89 d0                	mov    %edx,%eax
 1f4:	5f                   	pop    %edi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    
 1f7:	89 f6                	mov    %esi,%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 20a:	0f b6 10             	movzbl (%eax),%edx
 20d:	84 d2                	test   %dl,%dl
 20f:	74 1d                	je     22e <strchr+0x2e>
    if(*s == c)
 211:	38 d3                	cmp    %dl,%bl
 213:	89 d9                	mov    %ebx,%ecx
 215:	75 0d                	jne    224 <strchr+0x24>
 217:	eb 17                	jmp    230 <strchr+0x30>
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 220:	38 ca                	cmp    %cl,%dl
 222:	74 0c                	je     230 <strchr+0x30>
  for(; *s; s++)
 224:	83 c0 01             	add    $0x1,%eax
 227:	0f b6 10             	movzbl (%eax),%edx
 22a:	84 d2                	test   %dl,%dl
 22c:	75 f2                	jne    220 <strchr+0x20>
      return (char*)s;
  return 0;
 22e:	31 c0                	xor    %eax,%eax
}
 230:	5b                   	pop    %ebx
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    
 233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	31 f6                	xor    %esi,%esi
 248:	89 f3                	mov    %esi,%ebx
{
 24a:	83 ec 1c             	sub    $0x1c,%esp
 24d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 250:	eb 2f                	jmp    281 <gets+0x41>
 252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 258:	8d 45 e7             	lea    -0x19(%ebp),%eax
 25b:	83 ec 04             	sub    $0x4,%esp
 25e:	6a 01                	push   $0x1
 260:	50                   	push   %eax
 261:	6a 00                	push   $0x0
 263:	e8 32 01 00 00       	call   39a <read>
    if(cc < 1)
 268:	83 c4 10             	add    $0x10,%esp
 26b:	85 c0                	test   %eax,%eax
 26d:	7e 1c                	jle    28b <gets+0x4b>
      break;
    buf[i++] = c;
 26f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 273:	83 c7 01             	add    $0x1,%edi
 276:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 23                	je     2a0 <gets+0x60>
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 1f                	je     2a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 281:	83 c3 01             	add    $0x1,%ebx
 284:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 287:	89 fe                	mov    %edi,%esi
 289:	7c cd                	jl     258 <gets+0x18>
 28b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 290:	c6 03 00             	movb   $0x0,(%ebx)
}
 293:	8d 65 f4             	lea    -0xc(%ebp),%esp
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
 29b:	90                   	nop
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a0:	8b 75 08             	mov    0x8(%ebp),%esi
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	01 de                	add    %ebx,%esi
 2a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 2ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    
 2b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	6a 00                	push   $0x0
 2ca:	ff 75 08             	pushl  0x8(%ebp)
 2cd:	e8 f0 00 00 00       	call   3c2 <open>
  if(fd < 0)
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	78 27                	js     300 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	ff 75 0c             	pushl  0xc(%ebp)
 2df:	89 c3                	mov    %eax,%ebx
 2e1:	50                   	push   %eax
 2e2:	e8 f3 00 00 00       	call   3da <fstat>
  close(fd);
 2e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ea:	89 c6                	mov    %eax,%esi
  close(fd);
 2ec:	e8 b9 00 00 00       	call   3aa <close>
  return r;
 2f1:	83 c4 10             	add    $0x10,%esp
}
 2f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2f7:	89 f0                	mov    %esi,%eax
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 300:	be ff ff ff ff       	mov    $0xffffffff,%esi
 305:	eb ed                	jmp    2f4 <stat+0x34>
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 11             	movsbl (%ecx),%edx
 31a:	8d 42 d0             	lea    -0x30(%edx),%eax
 31d:	3c 09                	cmp    $0x9,%al
  n = 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 324:	77 1f                	ja     345 <atoi+0x35>
 326:	8d 76 00             	lea    0x0(%esi),%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 330:	8d 04 80             	lea    (%eax,%eax,4),%eax
 333:	83 c1 01             	add    $0x1,%ecx
 336:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 33a:	0f be 11             	movsbl (%ecx),%edx
 33d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	5b                   	pop    %ebx
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    
 348:	90                   	nop
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
 355:	8b 5d 10             	mov    0x10(%ebp),%ebx
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	85 db                	test   %ebx,%ebx
 360:	7e 14                	jle    376 <memmove+0x26>
 362:	31 d2                	xor    %edx,%edx
 364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 368:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 36c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 36f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 372:	39 d3                	cmp    %edx,%ebx
 374:	75 f2                	jne    368 <memmove+0x18>
  return vdst;
}
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <exit>:
SYSCALL(exit)
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <wait>:
SYSCALL(wait)
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <pipe>:
SYSCALL(pipe)
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <read>:
SYSCALL(read)
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <write>:
SYSCALL(write)
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <close>:
SYSCALL(close)
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <kill>:
SYSCALL(kill)
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exec>:
SYSCALL(exec)
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <open>:
SYSCALL(open)
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mknod>:
SYSCALL(mknod)
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <unlink>:
SYSCALL(unlink)
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <fstat>:
SYSCALL(fstat)
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <link>:
SYSCALL(link)
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mkdir>:
SYSCALL(mkdir)
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <chdir>:
SYSCALL(chdir)
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <dup>:
SYSCALL(dup)
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getpid>:
SYSCALL(getpid)
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sbrk>:
SYSCALL(sbrk)
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sleep>:
SYSCALL(sleep)
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <uptime>:
SYSCALL(uptime)
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <invoked_syscalls>:
SYSCALL(invoked_syscalls)
 422:	b8 16 00 00 00       	mov    $0x16,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <sort_syscalls>:
SYSCALL(sort_syscalls)
 42a:	b8 17 00 00 00       	mov    $0x17,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <get_count>:
SYSCALL(get_count)
 432:	b8 18 00 00 00       	mov    $0x18,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <log_syscalls>:
SYSCALL(log_syscalls)
 43a:	b8 19 00 00 00       	mov    $0x19,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <ticketlockinit>:
SYSCALL(ticketlockinit)
 442:	b8 1a 00 00 00       	mov    $0x1a,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <ticketlocktest>:
SYSCALL(ticketlocktest)
 44a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    
