
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2f 10 80       	mov    $0x80102fe0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 77 10 80       	push   $0x80107700
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 95 43 00 00       	call   801043f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 03 42 00 00       	call   801042a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 47 44 00 00       	call   80104530 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 89 44 00 00       	call   801045f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 41 00 00       	call   801042e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 20 00 00       	call   80102260 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 77 10 80       	push   $0x8010770e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 41 00 00       	call   801043a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 97 20 00 00       	jmp    80102260 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 77 10 80       	push   $0x8010771f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 41 00 00       	call   801043a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 41 00 00       	call   80104340 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 20 43 00 00       	call   80104530 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 43 00 00       	jmp    801045f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 77 10 80       	push   $0x80107726
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 16 00 00       	call   801018a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 42 00 00       	call   80104530 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 f6 3b 00 00       	call   80103ec0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 36 00 00       	call   80103920 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 fc 42 00 00       	call   801045f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 14 00 00       	call   801017c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 9e 42 00 00       	call   801045f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 14 00 00       	call   801017c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 24 00 00       	call   80102870 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 77 10 80       	push   $0x8010772d
801003b7:	e8 54 03 00 00       	call   80100710 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 4b 03 00 00       	call   80100710 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 6f 82 10 80 	movl   $0x8010826f,(%esp)
801003cc:	e8 3f 03 00 00       	call   80100710 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 40 00 00       	call   80104410 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 77 10 80       	push   $0x80107741
801003ed:	e8 1e 03 00 00       	call   80100710 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100416:	85 d2                	test   %edx,%edx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 bd 00 00 00    	je     801004f3 <consputc+0xe3>
  } else if(c == LEFT_ARROW){
80100436:	3d 00 02 00 00       	cmp    $0x200,%eax
8010043b:	0f 84 d9 01 00 00    	je     8010061a <consputc+0x20a>
  } else if(c == RIGHT_ARROW){
80100441:	3d 01 02 00 00       	cmp    $0x201,%eax
80100446:	74 0c                	je     80100454 <consputc+0x44>
    uartputc(c);
80100448:	83 ec 0c             	sub    $0xc,%esp
8010044b:	50                   	push   %eax
8010044c:	e8 af 5e 00 00       	call   80106300 <uartputc>
80100451:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100454:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100459:	b8 0e 00 00 00       	mov    $0xe,%eax
8010045e:	89 da                	mov    %ebx,%edx
80100460:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100461:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100466:	89 ca                	mov    %ecx,%edx
80100468:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100469:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046c:	89 da                	mov    %ebx,%edx
8010046e:	c1 e0 08             	shl    $0x8,%eax
80100471:	89 c7                	mov    %eax,%edi
80100473:	b8 0f 00 00 00       	mov    $0xf,%eax
80100478:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100479:	89 ca                	mov    %ecx,%edx
8010047b:	ec                   	in     (%dx),%al
8010047c:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010047f:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100481:	83 fe 0a             	cmp    $0xa,%esi
80100484:	0f 84 7d 01 00 00    	je     80100607 <consputc+0x1f7>
  else if(c == BACKSPACE){
8010048a:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100490:	0f 84 87 00 00 00    	je     8010051d <consputc+0x10d>
  else if(c == LEFT_ARROW){
80100496:	81 fe 00 02 00 00    	cmp    $0x200,%esi
8010049c:	74 7f                	je     8010051d <consputc+0x10d>
  else if(c == RIGHT_ARROW){
8010049e:	81 fe 01 02 00 00    	cmp    $0x201,%esi
801004a4:	0f 84 49 01 00 00    	je     801005f3 <consputc+0x1e3>
    for (int i = pos + (80 - pos%80) - 1; i >= pos ; --i)
801004aa:	89 d8                	mov    %ebx,%eax
801004ac:	b9 50 00 00 00       	mov    $0x50,%ecx
801004b1:	99                   	cltd   
801004b2:	f7 f9                	idiv   %ecx
801004b4:	29 d1                	sub    %edx,%ecx
801004b6:	8d 44 0b ff          	lea    -0x1(%ebx,%ecx,1),%eax
801004ba:	39 c3                	cmp    %eax,%ebx
801004bc:	7f 20                	jg     801004de <consputc+0xce>
801004be:	8d 93 ff bf 05 40    	lea    0x4005bfff(%ebx),%edx
801004c4:	01 c0                	add    %eax,%eax
801004c6:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801004cb:	01 d2                	add    %edx,%edx
801004cd:	8d 76 00             	lea    0x0(%esi),%esi
      crt[i+1] = crt[i];
801004d0:	0f b7 08             	movzwl (%eax),%ecx
801004d3:	83 e8 02             	sub    $0x2,%eax
801004d6:	66 89 48 04          	mov    %cx,0x4(%eax)
    for (int i = pos + (80 - pos%80) - 1; i >= pos ; --i)
801004da:	39 c2                	cmp    %eax,%edx
801004dc:	75 f2                	jne    801004d0 <consputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004de:	89 f0                	mov    %esi,%eax
801004e0:	0f b6 c0             	movzbl %al,%eax
801004e3:	80 cc 07             	or     $0x7,%ah
801004e6:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004ed:	80 
801004ee:	83 c3 01             	add    $0x1,%ebx
801004f1:	eb 31                	jmp    80100524 <consputc+0x114>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004f3:	83 ec 0c             	sub    $0xc,%esp
801004f6:	6a 08                	push   $0x8
801004f8:	e8 03 5e 00 00       	call   80106300 <uartputc>
801004fd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100504:	e8 f7 5d 00 00       	call   80106300 <uartputc>
80100509:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100510:	e8 eb 5d 00 00       	call   80106300 <uartputc>
80100515:	83 c4 10             	add    $0x10,%esp
80100518:	e9 37 ff ff ff       	jmp    80100454 <consputc+0x44>
    if(pos > 0) --pos;
8010051d:	85 db                	test   %ebx,%ebx
8010051f:	74 13                	je     80100534 <consputc+0x124>
80100521:	83 eb 01             	sub    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100524:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010052a:	7f 79                	jg     801005a5 <consputc+0x195>
  if((pos/80) >= 24){  // Scroll up.
8010052c:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100532:	7f 37                	jg     8010056b <consputc+0x15b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100534:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100539:	b8 0e 00 00 00       	mov    $0xe,%eax
8010053e:	89 fa                	mov    %edi,%edx
80100540:	ee                   	out    %al,(%dx)
80100541:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
80100546:	89 d8                	mov    %ebx,%eax
80100548:	c1 f8 08             	sar    $0x8,%eax
8010054b:	89 ca                	mov    %ecx,%edx
8010054d:	ee                   	out    %al,(%dx)
8010054e:	b8 0f 00 00 00       	mov    $0xf,%eax
80100553:	89 fa                	mov    %edi,%edx
80100555:	ee                   	out    %al,(%dx)
80100556:	89 d8                	mov    %ebx,%eax
80100558:	89 ca                	mov    %ecx,%edx
8010055a:	ee                   	out    %al,(%dx)
  if(c == BACKSPACE) {
8010055b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100561:	74 4f                	je     801005b2 <consputc+0x1a2>
}
80100563:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100566:	5b                   	pop    %ebx
80100567:	5e                   	pop    %esi
80100568:	5f                   	pop    %edi
80100569:	5d                   	pop    %ebp
8010056a:	c3                   	ret    
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010056b:	50                   	push   %eax
8010056c:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100571:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100574:	68 a0 80 0b 80       	push   $0x800b80a0
80100579:	68 00 80 0b 80       	push   $0x800b8000
8010057e:	e8 1d 42 00 00       	call   801047a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100583:	b8 80 07 00 00       	mov    $0x780,%eax
80100588:	83 c4 0c             	add    $0xc,%esp
8010058b:	29 d8                	sub    %ebx,%eax
8010058d:	01 c0                	add    %eax,%eax
8010058f:	50                   	push   %eax
80100590:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100593:	6a 00                	push   $0x0
80100595:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
8010059a:	50                   	push   %eax
8010059b:	e8 50 41 00 00       	call   801046f0 <memset>
801005a0:	83 c4 10             	add    $0x10,%esp
801005a3:	eb 8f                	jmp    80100534 <consputc+0x124>
    panic("pos under/overflow");
801005a5:	83 ec 0c             	sub    $0xc,%esp
801005a8:	68 45 77 10 80       	push   $0x80107745
801005ad:	e8 de fd ff ff       	call   80100390 <panic>
    for (int i =  pos; i < pos + (80 - pos%80) ; ++i)
801005b2:	89 d8                	mov    %ebx,%eax
801005b4:	b9 50 00 00 00       	mov    $0x50,%ecx
    crt[pos] = ' ' | 0x0700;
801005b9:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
    for (int i =  pos; i < pos + (80 - pos%80) ; ++i)
801005bc:	99                   	cltd   
801005bd:	f7 f9                	idiv   %ecx
801005bf:	89 c8                	mov    %ecx,%eax
    crt[pos] = ' ' | 0x0700;
801005c1:	66 c7 86 00 80 0b 80 	movw   $0x720,-0x7ff48000(%esi)
801005c8:	20 07 
    for (int i =  pos; i < pos + (80 - pos%80) ; ++i)
801005ca:	29 d0                	sub    %edx,%eax
801005cc:	01 d8                	add    %ebx,%eax
801005ce:	39 c3                	cmp    %eax,%ebx
801005d0:	7d 91                	jge    80100563 <consputc+0x153>
801005d2:	05 01 c0 05 40       	add    $0x4005c001,%eax
801005d7:	81 ee fe 7f f4 7f    	sub    $0x7ff47ffe,%esi
801005dd:	01 c0                	add    %eax,%eax
801005df:	90                   	nop
      crt[i] = crt[i+1];
801005e0:	0f b7 16             	movzwl (%esi),%edx
801005e3:	83 c6 02             	add    $0x2,%esi
801005e6:	66 89 56 fc          	mov    %dx,-0x4(%esi)
    for (int i =  pos; i < pos + (80 - pos%80) ; ++i)
801005ea:	39 f0                	cmp    %esi,%eax
801005ec:	75 f2                	jne    801005e0 <consputc+0x1d0>
801005ee:	e9 70 ff ff ff       	jmp    80100563 <consputc+0x153>
    if(pos < 25*80) ++pos;
801005f3:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
801005f9:	0f 8f 25 ff ff ff    	jg     80100524 <consputc+0x114>
801005ff:	83 c3 01             	add    $0x1,%ebx
80100602:	e9 25 ff ff ff       	jmp    8010052c <consputc+0x11c>
    pos += 80 - pos%80;
80100607:	89 d8                	mov    %ebx,%eax
80100609:	b9 50 00 00 00       	mov    $0x50,%ecx
8010060e:	99                   	cltd   
8010060f:	f7 f9                	idiv   %ecx
80100611:	29 d1                	sub    %edx,%ecx
80100613:	01 cb                	add    %ecx,%ebx
80100615:	e9 0a ff ff ff       	jmp    80100524 <consputc+0x114>
    uartputc('\b');
8010061a:	83 ec 0c             	sub    $0xc,%esp
8010061d:	6a 08                	push   $0x8
8010061f:	e8 dc 5c 00 00       	call   80106300 <uartputc>
80100624:	83 c4 10             	add    $0x10,%esp
80100627:	e9 28 fe ff ff       	jmp    80100454 <consputc+0x44>
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <printint>:
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	89 d3                	mov    %edx,%ebx
80100638:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010063b:	85 c9                	test   %ecx,%ecx
{
8010063d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100640:	74 04                	je     80100646 <printint+0x16>
80100642:	85 c0                	test   %eax,%eax
80100644:	78 5a                	js     801006a0 <printint+0x70>
    x = xx;
80100646:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010064d:	31 c9                	xor    %ecx,%ecx
8010064f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100652:	eb 06                	jmp    8010065a <printint+0x2a>
80100654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100658:	89 f9                	mov    %edi,%ecx
8010065a:	31 d2                	xor    %edx,%edx
8010065c:	8d 79 01             	lea    0x1(%ecx),%edi
8010065f:	f7 f3                	div    %ebx
80100661:	0f b6 92 70 77 10 80 	movzbl -0x7fef8890(%edx),%edx
  }while((x /= base) != 0);
80100668:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010066a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010066d:	75 e9                	jne    80100658 <printint+0x28>
  if(sign)
8010066f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100672:	85 c0                	test   %eax,%eax
80100674:	74 08                	je     8010067e <printint+0x4e>
    buf[i++] = '-';
80100676:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
8010067b:	8d 79 02             	lea    0x2(%ecx),%edi
8010067e:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
80100688:	0f be 03             	movsbl (%ebx),%eax
8010068b:	83 eb 01             	sub    $0x1,%ebx
8010068e:	e8 7d fd ff ff       	call   80100410 <consputc>
  while(--i >= 0)
80100693:	39 f3                	cmp    %esi,%ebx
80100695:	75 f1                	jne    80100688 <printint+0x58>
}
80100697:	83 c4 2c             	add    $0x2c,%esp
8010069a:	5b                   	pop    %ebx
8010069b:	5e                   	pop    %esi
8010069c:	5f                   	pop    %edi
8010069d:	5d                   	pop    %ebp
8010069e:	c3                   	ret    
8010069f:	90                   	nop
    x = -xx;
801006a0:	f7 d8                	neg    %eax
801006a2:	eb a9                	jmp    8010064d <printint+0x1d>
801006a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801006b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 18             	sub    $0x18,%esp
801006b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801006bc:	ff 75 08             	pushl  0x8(%ebp)
801006bf:	e8 dc 11 00 00       	call   801018a0 <iunlock>
  acquire(&cons.lock);
801006c4:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801006cb:	e8 60 3e 00 00       	call   80104530 <acquire>
  for(i = 0; i < n; i++)
801006d0:	83 c4 10             	add    $0x10,%esp
801006d3:	85 f6                	test   %esi,%esi
801006d5:	7e 18                	jle    801006ef <consolewrite+0x3f>
801006d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006da:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006dd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801006e0:	0f b6 07             	movzbl (%edi),%eax
801006e3:	83 c7 01             	add    $0x1,%edi
801006e6:	e8 25 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
801006eb:	39 fb                	cmp    %edi,%ebx
801006ed:	75 f1                	jne    801006e0 <consolewrite+0x30>
  release(&cons.lock);
801006ef:	83 ec 0c             	sub    $0xc,%esp
801006f2:	68 20 b5 10 80       	push   $0x8010b520
801006f7:	e8 f4 3e 00 00       	call   801045f0 <release>
  ilock(ip);
801006fc:	58                   	pop    %eax
801006fd:	ff 75 08             	pushl  0x8(%ebp)
80100700:	e8 bb 10 00 00       	call   801017c0 <ilock>

  return n;
}
80100705:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100708:	89 f0                	mov    %esi,%eax
8010070a:	5b                   	pop    %ebx
8010070b:	5e                   	pop    %esi
8010070c:	5f                   	pop    %edi
8010070d:	5d                   	pop    %ebp
8010070e:	c3                   	ret    
8010070f:	90                   	nop

80100710 <cprintf>:
{
80100710:	55                   	push   %ebp
80100711:	89 e5                	mov    %esp,%ebp
80100713:	57                   	push   %edi
80100714:	56                   	push   %esi
80100715:	53                   	push   %ebx
80100716:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100719:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010071e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100720:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100723:	0f 85 6f 01 00 00    	jne    80100898 <cprintf+0x188>
  if (fmt == 0)
80100729:	8b 45 08             	mov    0x8(%ebp),%eax
8010072c:	85 c0                	test   %eax,%eax
8010072e:	89 c7                	mov    %eax,%edi
80100730:	0f 84 77 01 00 00    	je     801008ad <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100736:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100739:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010073c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010073e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100741:	85 c0                	test   %eax,%eax
80100743:	75 56                	jne    8010079b <cprintf+0x8b>
80100745:	eb 79                	jmp    801007c0 <cprintf+0xb0>
80100747:	89 f6                	mov    %esi,%esi
80100749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100750:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100753:	85 d2                	test   %edx,%edx
80100755:	74 69                	je     801007c0 <cprintf+0xb0>
80100757:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010075a:	83 fa 70             	cmp    $0x70,%edx
8010075d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100760:	0f 84 84 00 00 00    	je     801007ea <cprintf+0xda>
80100766:	7f 78                	jg     801007e0 <cprintf+0xd0>
80100768:	83 fa 25             	cmp    $0x25,%edx
8010076b:	0f 84 ff 00 00 00    	je     80100870 <cprintf+0x160>
80100771:	83 fa 64             	cmp    $0x64,%edx
80100774:	0f 85 8e 00 00 00    	jne    80100808 <cprintf+0xf8>
      printint(*argp++, 10, 1);
8010077a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100782:	8d 48 04             	lea    0x4(%eax),%ecx
80100785:	8b 00                	mov    (%eax),%eax
80100787:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010078a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010078f:	e8 9c fe ff ff       	call   80100630 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 06             	movzbl (%esi),%eax
80100797:	85 c0                	test   %eax,%eax
80100799:	74 25                	je     801007c0 <cprintf+0xb0>
8010079b:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
8010079e:	83 f8 25             	cmp    $0x25,%eax
801007a1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801007a4:	74 aa                	je     80100750 <cprintf+0x40>
801007a6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801007a9:	e8 62 fc ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ae:	0f b6 06             	movzbl (%esi),%eax
      continue;
801007b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801007b4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b6:	85 c0                	test   %eax,%eax
801007b8:	75 e1                	jne    8010079b <cprintf+0x8b>
801007ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801007c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801007c3:	85 c0                	test   %eax,%eax
801007c5:	74 10                	je     801007d7 <cprintf+0xc7>
    release(&cons.lock);
801007c7:	83 ec 0c             	sub    $0xc,%esp
801007ca:	68 20 b5 10 80       	push   $0x8010b520
801007cf:	e8 1c 3e 00 00       	call   801045f0 <release>
801007d4:	83 c4 10             	add    $0x10,%esp
}
801007d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007da:	5b                   	pop    %ebx
801007db:	5e                   	pop    %esi
801007dc:	5f                   	pop    %edi
801007dd:	5d                   	pop    %ebp
801007de:	c3                   	ret    
801007df:	90                   	nop
    switch(c){
801007e0:	83 fa 73             	cmp    $0x73,%edx
801007e3:	74 43                	je     80100828 <cprintf+0x118>
801007e5:	83 fa 78             	cmp    $0x78,%edx
801007e8:	75 1e                	jne    80100808 <cprintf+0xf8>
      printint(*argp++, 16, 0);
801007ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007ed:	ba 10 00 00 00       	mov    $0x10,%edx
801007f2:	8d 48 04             	lea    0x4(%eax),%ecx
801007f5:	8b 00                	mov    (%eax),%eax
801007f7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007fa:	31 c9                	xor    %ecx,%ecx
801007fc:	e8 2f fe ff ff       	call   80100630 <printint>
      break;
80100801:	eb 91                	jmp    80100794 <cprintf+0x84>
80100803:	90                   	nop
80100804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100810:	e8 fb fb ff ff       	call   80100410 <consputc>
      consputc(c);
80100815:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100818:	89 d0                	mov    %edx,%eax
8010081a:	e8 f1 fb ff ff       	call   80100410 <consputc>
      break;
8010081f:	e9 70 ff ff ff       	jmp    80100794 <cprintf+0x84>
80100824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010082b:	8b 10                	mov    (%eax),%edx
8010082d:	8d 48 04             	lea    0x4(%eax),%ecx
80100830:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100833:	85 d2                	test   %edx,%edx
80100835:	74 49                	je     80100880 <cprintf+0x170>
      for(; *s; s++)
80100837:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010083a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010083d:	84 c0                	test   %al,%al
8010083f:	0f 84 4f ff ff ff    	je     80100794 <cprintf+0x84>
80100845:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100848:	89 d3                	mov    %edx,%ebx
8010084a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100850:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100853:	e8 b8 fb ff ff       	call   80100410 <consputc>
      for(; *s; s++)
80100858:	0f be 03             	movsbl (%ebx),%eax
8010085b:	84 c0                	test   %al,%al
8010085d:	75 f1                	jne    80100850 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010085f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100862:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100865:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100868:	e9 27 ff ff ff       	jmp    80100794 <cprintf+0x84>
8010086d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100870:	b8 25 00 00 00       	mov    $0x25,%eax
80100875:	e8 96 fb ff ff       	call   80100410 <consputc>
      break;
8010087a:	e9 15 ff ff ff       	jmp    80100794 <cprintf+0x84>
8010087f:	90                   	nop
        s = "(null)";
80100880:	ba 58 77 10 80       	mov    $0x80107758,%edx
      for(; *s; s++)
80100885:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100888:	b8 28 00 00 00       	mov    $0x28,%eax
8010088d:	89 d3                	mov    %edx,%ebx
8010088f:	eb bf                	jmp    80100850 <cprintf+0x140>
80100891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100898:	83 ec 0c             	sub    $0xc,%esp
8010089b:	68 20 b5 10 80       	push   $0x8010b520
801008a0:	e8 8b 3c 00 00       	call   80104530 <acquire>
801008a5:	83 c4 10             	add    $0x10,%esp
801008a8:	e9 7c fe ff ff       	jmp    80100729 <cprintf+0x19>
    panic("null fmt");
801008ad:	83 ec 0c             	sub    $0xc,%esp
801008b0:	68 5f 77 10 80       	push   $0x8010775f
801008b5:	e8 d6 fa ff ff       	call   80100390 <panic>
801008ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
801008c5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008c6:	31 f6                	xor    %esi,%esi
{
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801008ce:	68 20 b5 10 80       	push   $0x8010b520
801008d3:	e8 58 3c 00 00       	call   80104530 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	90                   	nop
801008dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008e0:	ff d3                	call   *%ebx
801008e2:	85 c0                	test   %eax,%eax
801008e4:	89 c7                	mov    %eax,%edi
801008e6:	0f 88 b4 00 00 00    	js     801009a0 <consoleintr+0xe0>
    switch(c){
801008ec:	83 ff 15             	cmp    $0x15,%edi
801008ef:	0f 84 6b 01 00 00    	je     80100a60 <consoleintr+0x1a0>
801008f5:	0f 8e c5 00 00 00    	jle    801009c0 <consoleintr+0x100>
801008fb:	81 ff e4 00 00 00    	cmp    $0xe4,%edi
80100901:	0f 84 39 01 00 00    	je     80100a40 <consoleintr+0x180>
80100907:	81 ff e5 00 00 00    	cmp    $0xe5,%edi
8010090d:	0f 84 fd 00 00 00    	je     80100a10 <consoleintr+0x150>
80100913:	83 ff 7f             	cmp    $0x7f,%edi
80100916:	0f 84 c4 00 00 00    	je     801009e0 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010091c:	85 ff                	test   %edi,%edi
8010091e:	74 c0                	je     801008e0 <consoleintr+0x20>
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	89 c2                	mov    %eax,%edx
80100927:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
8010092d:	83 fa 7f             	cmp    $0x7f,%edx
80100930:	77 ae                	ja     801008e0 <consoleintr+0x20>
80100932:	8d 50 01             	lea    0x1(%eax),%edx
80100935:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100938:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
8010093b:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
80100941:	0f 84 81 01 00 00    	je     80100ac8 <consoleintr+0x208>
        input.buf[input.e++ % INPUT_BUF] = c;
80100947:	89 f9                	mov    %edi,%ecx
80100949:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
8010094f:	89 f8                	mov    %edi,%eax
80100951:	e8 ba fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100956:	83 ff 0a             	cmp    $0xa,%edi
80100959:	0f 84 7a 01 00 00    	je     80100ad9 <consoleintr+0x219>
8010095f:	83 ff 04             	cmp    $0x4,%edi
80100962:	0f 84 71 01 00 00    	je     80100ad9 <consoleintr+0x219>
80100968:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010096d:	83 e8 80             	sub    $0xffffff80,%eax
80100970:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100976:	0f 85 64 ff ff ff    	jne    801008e0 <consoleintr+0x20>
          wakeup(&input.r);
8010097c:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010097f:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100984:	68 c0 0f 11 80       	push   $0x80110fc0
80100989:	e8 72 37 00 00       	call   80104100 <wakeup>
8010098e:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100991:	ff d3                	call   *%ebx
80100993:	85 c0                	test   %eax,%eax
80100995:	89 c7                	mov    %eax,%edi
80100997:	0f 89 4f ff ff ff    	jns    801008ec <consoleintr+0x2c>
8010099d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009a0:	83 ec 0c             	sub    $0xc,%esp
801009a3:	68 20 b5 10 80       	push   $0x8010b520
801009a8:	e8 43 3c 00 00       	call   801045f0 <release>
  if(doprocdump) {
801009ad:	83 c4 10             	add    $0x10,%esp
801009b0:	85 f6                	test   %esi,%esi
801009b2:	0f 85 00 01 00 00    	jne    80100ab8 <consoleintr+0x1f8>
}
801009b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009bb:	5b                   	pop    %ebx
801009bc:	5e                   	pop    %esi
801009bd:	5f                   	pop    %edi
801009be:	5d                   	pop    %ebp
801009bf:	c3                   	ret    
    switch(c){
801009c0:	83 ff 08             	cmp    $0x8,%edi
801009c3:	74 1b                	je     801009e0 <consoleintr+0x120>
801009c5:	83 ff 10             	cmp    $0x10,%edi
801009c8:	0f 85 4e ff ff ff    	jne    8010091c <consoleintr+0x5c>
      doprocdump = 1;
801009ce:	be 01 00 00 00       	mov    $0x1,%esi
801009d3:	e9 08 ff ff ff       	jmp    801008e0 <consoleintr+0x20>
801009d8:	90                   	nop
801009d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
801009e0:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009e5:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801009eb:	0f 84 ef fe ff ff    	je     801008e0 <consoleintr+0x20>
        input.e--;
801009f1:	83 e8 01             	sub    $0x1,%eax
801009f4:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
801009f9:	b8 00 01 00 00       	mov    $0x100,%eax
801009fe:	e8 0d fa ff ff       	call   80100410 <consputc>
80100a03:	e9 d8 fe ff ff       	jmp    801008e0 <consoleintr+0x20>
80100a08:	90                   	nop
80100a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100a10:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100a15:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100a1b:	0f 84 bf fe ff ff    	je     801008e0 <consoleintr+0x20>
        input.e++;
80100a21:	83 c0 01             	add    $0x1,%eax
80100a24:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(RIGHT_ARROW);
80100a29:	b8 01 02 00 00       	mov    $0x201,%eax
80100a2e:	e8 dd f9 ff ff       	call   80100410 <consputc>
80100a33:	e9 a8 fe ff ff       	jmp    801008e0 <consoleintr+0x20>
80100a38:	90                   	nop
80100a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        consputc(LEFT_ARROW);
80100a40:	b8 00 02 00 00       	mov    $0x200,%eax
        input.e--;
80100a45:	83 2d c8 0f 11 80 01 	subl   $0x1,0x80110fc8
        consputc(LEFT_ARROW);
80100a4c:	e8 bf f9 ff ff       	call   80100410 <consputc>
    break;
80100a51:	e9 8a fe ff ff       	jmp    801008e0 <consoleintr+0x20>
80100a56:	8d 76 00             	lea    0x0(%esi),%esi
80100a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      while(input.e != input.w &&
80100a60:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100a65:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100a6b:	75 32                	jne    80100a9f <consoleintr+0x1df>
80100a6d:	e9 6e fe ff ff       	jmp    801008e0 <consoleintr+0x20>
80100a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100a78:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100a7d:	b8 00 01 00 00       	mov    $0x100,%eax
        input.m--;
80100a82:	83 2d cc 0f 11 80 01 	subl   $0x1,0x80110fcc
        consputc(BACKSPACE);
80100a89:	e8 82 f9 ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
80100a8e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100a93:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100a99:	0f 84 41 fe ff ff    	je     801008e0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a9f:	83 e8 01             	sub    $0x1,%eax
80100aa2:	89 c2                	mov    %eax,%edx
80100aa4:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100aa7:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100aae:	75 c8                	jne    80100a78 <consoleintr+0x1b8>
80100ab0:	e9 2b fe ff ff       	jmp    801008e0 <consoleintr+0x20>
80100ab5:	8d 76 00             	lea    0x0(%esi),%esi
}
80100ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100abb:	5b                   	pop    %ebx
80100abc:	5e                   	pop    %esi
80100abd:	5f                   	pop    %edi
80100abe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100abf:	e9 1c 37 00 00       	jmp    801041e0 <procdump>
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ac8:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
80100acf:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ad4:	e8 37 f9 ff ff       	call   80100410 <consputc>
80100ad9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100ade:	e9 99 fe ff ff       	jmp    8010097c <consoleintr+0xbc>
80100ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100af0 <consoleinit>:

void
consoleinit(void)
{
80100af0:	55                   	push   %ebp
80100af1:	89 e5                	mov    %esp,%ebp
80100af3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100af6:	68 68 77 10 80       	push   $0x80107768
80100afb:	68 20 b5 10 80       	push   $0x8010b520
80100b00:	e8 eb 38 00 00       	call   801043f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b05:	58                   	pop    %eax
80100b06:	5a                   	pop    %edx
80100b07:	6a 00                	push   $0x0
80100b09:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b0b:	c7 05 8c 19 11 80 b0 	movl   $0x801006b0,0x8011198c
80100b12:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b15:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
80100b1c:	02 10 80 
  cons.locking = 1;
80100b1f:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100b26:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b29:	e8 e2 18 00 00       	call   80102410 <ioapicenable>
}
80100b2e:	83 c4 10             	add    $0x10,%esp
80100b31:	c9                   	leave  
80100b32:	c3                   	ret    
80100b33:	66 90                	xchg   %ax,%ax
80100b35:	66 90                	xchg   %ax,%ax
80100b37:	66 90                	xchg   %ax,%ax
80100b39:	66 90                	xchg   %ax,%ax
80100b3b:	66 90                	xchg   %ax,%ax
80100b3d:	66 90                	xchg   %ax,%ax
80100b3f:	90                   	nop

80100b40 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b40:	55                   	push   %ebp
80100b41:	89 e5                	mov    %esp,%ebp
80100b43:	57                   	push   %edi
80100b44:	56                   	push   %esi
80100b45:	53                   	push   %ebx
80100b46:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b4c:	e8 cf 2d 00 00       	call   80103920 <myproc>
80100b51:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100b57:	e8 84 21 00 00       	call   80102ce0 <begin_op>

  if((ip = namei(path)) == 0){
80100b5c:	83 ec 0c             	sub    $0xc,%esp
80100b5f:	ff 75 08             	pushl  0x8(%ebp)
80100b62:	e8 b9 14 00 00       	call   80102020 <namei>
80100b67:	83 c4 10             	add    $0x10,%esp
80100b6a:	85 c0                	test   %eax,%eax
80100b6c:	0f 84 91 01 00 00    	je     80100d03 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b72:	83 ec 0c             	sub    $0xc,%esp
80100b75:	89 c3                	mov    %eax,%ebx
80100b77:	50                   	push   %eax
80100b78:	e8 43 0c 00 00       	call   801017c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b7d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b83:	6a 34                	push   $0x34
80100b85:	6a 00                	push   $0x0
80100b87:	50                   	push   %eax
80100b88:	53                   	push   %ebx
80100b89:	e8 12 0f 00 00       	call   80101aa0 <readi>
80100b8e:	83 c4 20             	add    $0x20,%esp
80100b91:	83 f8 34             	cmp    $0x34,%eax
80100b94:	74 22                	je     80100bb8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	53                   	push   %ebx
80100b9a:	e8 b1 0e 00 00       	call   80101a50 <iunlockput>
    end_op();
80100b9f:	e8 ac 21 00 00       	call   80102d50 <end_op>
80100ba4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100baf:	5b                   	pop    %ebx
80100bb0:	5e                   	pop    %esi
80100bb1:	5f                   	pop    %edi
80100bb2:	5d                   	pop    %ebp
80100bb3:	c3                   	ret    
80100bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100bb8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100bbf:	45 4c 46 
80100bc2:	75 d2                	jne    80100b96 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100bc4:	e8 87 68 00 00       	call   80107450 <setupkvm>
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bd1:	74 c3                	je     80100b96 <exec+0x56>
  sz = 0;
80100bd3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bdc:	00 
80100bdd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100be3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100be9:	0f 84 8c 02 00 00    	je     80100e7b <exec+0x33b>
80100bef:	31 f6                	xor    %esi,%esi
80100bf1:	eb 7f                	jmp    80100c72 <exec+0x132>
80100bf3:	90                   	nop
80100bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bf8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bff:	75 63                	jne    80100c64 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100c01:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c07:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c0d:	0f 82 86 00 00 00    	jb     80100c99 <exec+0x159>
80100c13:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c19:	72 7e                	jb     80100c99 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c1b:	83 ec 04             	sub    $0x4,%esp
80100c1e:	50                   	push   %eax
80100c1f:	57                   	push   %edi
80100c20:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c26:	e8 45 66 00 00       	call   80107270 <allocuvm>
80100c2b:	83 c4 10             	add    $0x10,%esp
80100c2e:	85 c0                	test   %eax,%eax
80100c30:	89 c7                	mov    %eax,%edi
80100c32:	74 65                	je     80100c99 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100c34:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c3a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c3f:	75 58                	jne    80100c99 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c41:	83 ec 0c             	sub    $0xc,%esp
80100c44:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c4a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c50:	53                   	push   %ebx
80100c51:	50                   	push   %eax
80100c52:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c58:	e8 53 65 00 00       	call   801071b0 <loaduvm>
80100c5d:	83 c4 20             	add    $0x20,%esp
80100c60:	85 c0                	test   %eax,%eax
80100c62:	78 35                	js     80100c99 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c64:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c6b:	83 c6 01             	add    $0x1,%esi
80100c6e:	39 f0                	cmp    %esi,%eax
80100c70:	7e 3d                	jle    80100caf <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c72:	89 f0                	mov    %esi,%eax
80100c74:	6a 20                	push   $0x20
80100c76:	c1 e0 05             	shl    $0x5,%eax
80100c79:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100c7f:	50                   	push   %eax
80100c80:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c86:	50                   	push   %eax
80100c87:	53                   	push   %ebx
80100c88:	e8 13 0e 00 00       	call   80101aa0 <readi>
80100c8d:	83 c4 10             	add    $0x10,%esp
80100c90:	83 f8 20             	cmp    $0x20,%eax
80100c93:	0f 84 5f ff ff ff    	je     80100bf8 <exec+0xb8>
    freevm(pgdir);
80100c99:	83 ec 0c             	sub    $0xc,%esp
80100c9c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ca2:	e8 29 67 00 00       	call   801073d0 <freevm>
80100ca7:	83 c4 10             	add    $0x10,%esp
80100caa:	e9 e7 fe ff ff       	jmp    80100b96 <exec+0x56>
80100caf:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100cb5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100cbb:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100cc1:	83 ec 0c             	sub    $0xc,%esp
80100cc4:	53                   	push   %ebx
80100cc5:	e8 86 0d 00 00       	call   80101a50 <iunlockput>
  end_op();
80100cca:	e8 81 20 00 00       	call   80102d50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ccf:	83 c4 0c             	add    $0xc,%esp
80100cd2:	56                   	push   %esi
80100cd3:	57                   	push   %edi
80100cd4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cda:	e8 91 65 00 00       	call   80107270 <allocuvm>
80100cdf:	83 c4 10             	add    $0x10,%esp
80100ce2:	85 c0                	test   %eax,%eax
80100ce4:	89 c6                	mov    %eax,%esi
80100ce6:	75 3a                	jne    80100d22 <exec+0x1e2>
    freevm(pgdir);
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cf1:	e8 da 66 00 00       	call   801073d0 <freevm>
80100cf6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfe:	e9 a9 fe ff ff       	jmp    80100bac <exec+0x6c>
    end_op();
80100d03:	e8 48 20 00 00       	call   80102d50 <end_op>
    cprintf("exec: fail\n");
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	68 81 77 10 80       	push   $0x80107781
80100d10:	e8 fb f9 ff ff       	call   80100710 <cprintf>
    return -1;
80100d15:	83 c4 10             	add    $0x10,%esp
80100d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1d:	e9 8a fe ff ff       	jmp    80100bac <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d22:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d28:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100d2b:	31 ff                	xor    %edi,%edi
80100d2d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d2f:	50                   	push   %eax
80100d30:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d36:	e8 b5 67 00 00       	call   801074f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3e:	83 c4 10             	add    $0x10,%esp
80100d41:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d47:	8b 00                	mov    (%eax),%eax
80100d49:	85 c0                	test   %eax,%eax
80100d4b:	74 70                	je     80100dbd <exec+0x27d>
80100d4d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100d53:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d59:	eb 0a                	jmp    80100d65 <exec+0x225>
80100d5b:	90                   	nop
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100d60:	83 ff 20             	cmp    $0x20,%edi
80100d63:	74 83                	je     80100ce8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d65:	83 ec 0c             	sub    $0xc,%esp
80100d68:	50                   	push   %eax
80100d69:	e8 a2 3b 00 00       	call   80104910 <strlen>
80100d6e:	f7 d0                	not    %eax
80100d70:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d75:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d76:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d79:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d7c:	e8 8f 3b 00 00       	call   80104910 <strlen>
80100d81:	83 c0 01             	add    $0x1,%eax
80100d84:	50                   	push   %eax
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d8b:	53                   	push   %ebx
80100d8c:	56                   	push   %esi
80100d8d:	e8 be 68 00 00       	call   80107650 <copyout>
80100d92:	83 c4 20             	add    $0x20,%esp
80100d95:	85 c0                	test   %eax,%eax
80100d97:	0f 88 4b ff ff ff    	js     80100ce8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100da0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100da7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100daa:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100db0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100db3:	85 c0                	test   %eax,%eax
80100db5:	75 a9                	jne    80100d60 <exec+0x220>
80100db7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbd:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100dc4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100dc6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100dcd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100dd1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dd8:	ff ff ff 
  ustack[1] = argc;
80100ddb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100de1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100de3:	83 c0 0c             	add    $0xc,%eax
80100de6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100de8:	50                   	push   %eax
80100de9:	52                   	push   %edx
80100dea:	53                   	push   %ebx
80100deb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100df1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df7:	e8 54 68 00 00       	call   80107650 <copyout>
80100dfc:	83 c4 10             	add    $0x10,%esp
80100dff:	85 c0                	test   %eax,%eax
80100e01:	0f 88 e1 fe ff ff    	js     80100ce8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100e07:	8b 45 08             	mov    0x8(%ebp),%eax
80100e0a:	0f b6 00             	movzbl (%eax),%eax
80100e0d:	84 c0                	test   %al,%al
80100e0f:	74 17                	je     80100e28 <exec+0x2e8>
80100e11:	8b 55 08             	mov    0x8(%ebp),%edx
80100e14:	89 d1                	mov    %edx,%ecx
80100e16:	83 c1 01             	add    $0x1,%ecx
80100e19:	3c 2f                	cmp    $0x2f,%al
80100e1b:	0f b6 01             	movzbl (%ecx),%eax
80100e1e:	0f 44 d1             	cmove  %ecx,%edx
80100e21:	84 c0                	test   %al,%al
80100e23:	75 f1                	jne    80100e16 <exec+0x2d6>
80100e25:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e28:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e2e:	50                   	push   %eax
80100e2f:	6a 10                	push   $0x10
80100e31:	ff 75 08             	pushl  0x8(%ebp)
80100e34:	89 f8                	mov    %edi,%eax
80100e36:	83 c0 6c             	add    $0x6c,%eax
80100e39:	50                   	push   %eax
80100e3a:	e8 91 3a 00 00       	call   801048d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100e3f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100e45:	89 f9                	mov    %edi,%ecx
80100e47:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100e4a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100e4d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100e4f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100e52:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e58:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e5b:	8b 41 18             	mov    0x18(%ecx),%eax
80100e5e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e61:	89 0c 24             	mov    %ecx,(%esp)
80100e64:	e8 b7 61 00 00       	call   80107020 <switchuvm>
  freevm(oldpgdir);
80100e69:	89 3c 24             	mov    %edi,(%esp)
80100e6c:	e8 5f 65 00 00       	call   801073d0 <freevm>
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
80100e74:	31 c0                	xor    %eax,%eax
80100e76:	e9 31 fd ff ff       	jmp    80100bac <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e7b:	be 00 20 00 00       	mov    $0x2000,%esi
80100e80:	e9 3c fe ff ff       	jmp    80100cc1 <exec+0x181>
80100e85:	66 90                	xchg   %ax,%ax
80100e87:	66 90                	xchg   %ax,%ax
80100e89:	66 90                	xchg   %ax,%ax
80100e8b:	66 90                	xchg   %ax,%ax
80100e8d:	66 90                	xchg   %ax,%ax
80100e8f:	90                   	nop

80100e90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e96:	68 8d 77 10 80       	push   $0x8010778d
80100e9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea0:	e8 4b 35 00 00       	call   801043f0 <initlock>
}
80100ea5:	83 c4 10             	add    $0x10,%esp
80100ea8:	c9                   	leave  
80100ea9:	c3                   	ret    
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100eb0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100eb9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ebc:	68 e0 0f 11 80       	push   $0x80110fe0
80100ec1:	e8 6a 36 00 00       	call   80104530 <acquire>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb 10                	jmp    80100edb <filealloc+0x2b>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ed0:	83 c3 18             	add    $0x18,%ebx
80100ed3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100ed9:	73 25                	jae    80100f00 <filealloc+0x50>
    if(f->ref == 0){
80100edb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ede:	85 c0                	test   %eax,%eax
80100ee0:	75 ee                	jne    80100ed0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ee2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ee5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100eec:	68 e0 0f 11 80       	push   $0x80110fe0
80100ef1:	e8 fa 36 00 00       	call   801045f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ef6:	89 d8                	mov    %ebx,%eax
      return f;
80100ef8:	83 c4 10             	add    $0x10,%esp
}
80100efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100efe:	c9                   	leave  
80100eff:	c3                   	ret    
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f05:	68 e0 0f 11 80       	push   $0x80110fe0
80100f0a:	e8 e1 36 00 00       	call   801045f0 <release>
}
80100f0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f11:	83 c4 10             	add    $0x10,%esp
}
80100f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 10             	sub    $0x10,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f2a:	68 e0 0f 11 80       	push   $0x80110fe0
80100f2f:	e8 fc 35 00 00       	call   80104530 <acquire>
  if(f->ref < 1)
80100f34:	8b 43 04             	mov    0x4(%ebx),%eax
80100f37:	83 c4 10             	add    $0x10,%esp
80100f3a:	85 c0                	test   %eax,%eax
80100f3c:	7e 1a                	jle    80100f58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f47:	68 e0 0f 11 80       	push   $0x80110fe0
80100f4c:	e8 9f 36 00 00       	call   801045f0 <release>
  return f;
}
80100f51:	89 d8                	mov    %ebx,%eax
80100f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f56:	c9                   	leave  
80100f57:	c3                   	ret    
    panic("filedup");
80100f58:	83 ec 0c             	sub    $0xc,%esp
80100f5b:	68 94 77 10 80       	push   $0x80107794
80100f60:	e8 2b f4 ff ff       	call   80100390 <panic>
80100f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 28             	sub    $0x28,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f7c:	68 e0 0f 11 80       	push   $0x80110fe0
80100f81:	e8 aa 35 00 00       	call   80104530 <acquire>
  if(f->ref < 1)
80100f86:	8b 43 04             	mov    0x4(%ebx),%eax
80100f89:	83 c4 10             	add    $0x10,%esp
80100f8c:	85 c0                	test   %eax,%eax
80100f8e:	0f 8e 9b 00 00 00    	jle    8010102f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f94:	83 e8 01             	sub    $0x1,%eax
80100f97:	85 c0                	test   %eax,%eax
80100f99:	89 43 04             	mov    %eax,0x4(%ebx)
80100f9c:	74 1a                	je     80100fb8 <fileclose+0x48>
    release(&ftable.lock);
80100f9e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa8:	5b                   	pop    %ebx
80100fa9:	5e                   	pop    %esi
80100faa:	5f                   	pop    %edi
80100fab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fac:	e9 3f 36 00 00       	jmp    801045f0 <release>
80100fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100fb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100fbc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fc1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100fc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fcd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fd0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100fd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fd8:	e8 13 36 00 00       	call   801045f0 <release>
  if(ff.type == FD_PIPE)
80100fdd:	83 c4 10             	add    $0x10,%esp
80100fe0:	83 ff 01             	cmp    $0x1,%edi
80100fe3:	74 13                	je     80100ff8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100fe5:	83 ff 02             	cmp    $0x2,%edi
80100fe8:	74 26                	je     80101010 <fileclose+0xa0>
}
80100fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fed:	5b                   	pop    %ebx
80100fee:	5e                   	pop    %esi
80100fef:	5f                   	pop    %edi
80100ff0:	5d                   	pop    %ebp
80100ff1:	c3                   	ret    
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ff8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ffc:	83 ec 08             	sub    $0x8,%esp
80100fff:	53                   	push   %ebx
80101000:	56                   	push   %esi
80101001:	e8 8a 24 00 00       	call   80103490 <pipeclose>
80101006:	83 c4 10             	add    $0x10,%esp
80101009:	eb df                	jmp    80100fea <fileclose+0x7a>
8010100b:	90                   	nop
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101010:	e8 cb 1c 00 00       	call   80102ce0 <begin_op>
    iput(ff.ip);
80101015:	83 ec 0c             	sub    $0xc,%esp
80101018:	ff 75 e0             	pushl  -0x20(%ebp)
8010101b:	e8 d0 08 00 00       	call   801018f0 <iput>
    end_op();
80101020:	83 c4 10             	add    $0x10,%esp
}
80101023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101026:	5b                   	pop    %ebx
80101027:	5e                   	pop    %esi
80101028:	5f                   	pop    %edi
80101029:	5d                   	pop    %ebp
    end_op();
8010102a:	e9 21 1d 00 00       	jmp    80102d50 <end_op>
    panic("fileclose");
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	68 9c 77 10 80       	push   $0x8010779c
80101037:	e8 54 f3 ff ff       	call   80100390 <panic>
8010103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	pushl  0x10(%ebx)
80101055:	e8 66 07 00 00       	call   801017c0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	pushl  0xc(%ebp)
8010105f:	ff 73 10             	pushl  0x10(%ebx)
80101062:	e8 09 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	pushl  0x10(%ebx)
8010106b:	e8 30 08 00 00       	call   801018a0 <iunlock>
    return 0;
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101085:	eb ee                	jmp    80101075 <filestat+0x35>
80101087:	89 f6                	mov    %esi,%esi
80101089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	pushl  0x10(%ebx)
801010ba:	e8 01 07 00 00       	call   801017c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	pushl  0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	pushl  0x10(%ebx)
801010c7:	e8 d4 09 00 00       	call   80101aa0 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	85 c0                	test   %eax,%eax
801010d1:	89 c6                	mov    %eax,%esi
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	pushl  0x10(%ebx)
801010de:	e8 bd 07 00 00       	call   801018a0 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 3e 25 00 00       	jmp    80103640 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 a6 77 10 80       	push   $0x801077a6
80101117:	e8 74 f2 ff ff       	call   80100390 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 75 08             	mov    0x8(%ebp),%esi
8010112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010112f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101133:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101136:	8b 45 10             	mov    0x10(%ebp),%eax
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 aa 00 00 00    	je     801011ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 06                	mov    (%esi),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 c3 00 00 00    	je     80101210 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 d9 00 00 00    	jne    8010122f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 ff                	xor    %edi,%edi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 34                	jg     80101193 <filewrite+0x73>
8010115f:	e9 9c 00 00 00       	jmp    80101200 <filewrite+0xe0>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
8010116e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101171:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101174:	e8 27 07 00 00       	call   801018a0 <iunlock>
      end_op();
80101179:	e8 d2 1b 00 00       	call   80102d50 <end_op>
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101184:	39 c3                	cmp    %eax,%ebx
80101186:	0f 85 96 00 00 00    	jne    80101222 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010118c:	01 df                	add    %ebx,%edi
    while(i < n){
8010118e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101191:	7e 6d                	jle    80101200 <filewrite+0xe0>
      int n1 = n - i;
80101193:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101196:	b8 00 06 00 00       	mov    $0x600,%eax
8010119b:	29 fb                	sub    %edi,%ebx
8010119d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011a6:	e8 35 1b 00 00       	call   80102ce0 <begin_op>
      ilock(f->ip);
801011ab:	83 ec 0c             	sub    $0xc,%esp
801011ae:	ff 76 10             	pushl  0x10(%esi)
801011b1:	e8 0a 06 00 00       	call   801017c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	53                   	push   %ebx
801011ba:	ff 76 14             	pushl  0x14(%esi)
801011bd:	01 f8                	add    %edi,%eax
801011bf:	50                   	push   %eax
801011c0:	ff 76 10             	pushl  0x10(%esi)
801011c3:	e8 d8 09 00 00       	call   80101ba0 <writei>
801011c8:	83 c4 20             	add    $0x20,%esp
801011cb:	85 c0                	test   %eax,%eax
801011cd:	7f 99                	jg     80101168 <filewrite+0x48>
      iunlock(f->ip);
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	ff 76 10             	pushl  0x10(%esi)
801011d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d8:	e8 c3 06 00 00       	call   801018a0 <iunlock>
      end_op();
801011dd:	e8 6e 1b 00 00       	call   80102d50 <end_op>
      if(r < 0)
801011e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	85 c0                	test   %eax,%eax
801011ea:	74 98                	je     80101184 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801011ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801011f4:	89 f8                	mov    %edi,%eax
801011f6:	5b                   	pop    %ebx
801011f7:	5e                   	pop    %esi
801011f8:	5f                   	pop    %edi
801011f9:	5d                   	pop    %ebp
801011fa:	c3                   	ret    
801011fb:	90                   	nop
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101200:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101203:	75 e7                	jne    801011ec <filewrite+0xcc>
}
80101205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101208:	89 f8                	mov    %edi,%eax
8010120a:	5b                   	pop    %ebx
8010120b:	5e                   	pop    %esi
8010120c:	5f                   	pop    %edi
8010120d:	5d                   	pop    %ebp
8010120e:	c3                   	ret    
8010120f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101210:	8b 46 0c             	mov    0xc(%esi),%eax
80101213:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101219:	5b                   	pop    %ebx
8010121a:	5e                   	pop    %esi
8010121b:	5f                   	pop    %edi
8010121c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010121d:	e9 0e 23 00 00       	jmp    80103530 <pipewrite>
        panic("short filewrite");
80101222:	83 ec 0c             	sub    $0xc,%esp
80101225:	68 af 77 10 80       	push   $0x801077af
8010122a:	e8 61 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	68 b5 77 10 80       	push   $0x801077b5
80101237:	e8 54 f1 ff ff       	call   80100390 <panic>
8010123c:	66 90                	xchg   %ax,%ax
8010123e:	66 90                	xchg   %ax,%ax

80101240 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101292:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101295:	bb 01 00 00 00       	mov    $0x1,%ebx
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	85 df                	test   %ebx,%edi
801012ab:	89 fa                	mov    %edi,%edx
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 14 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 bf 77 10 80       	push   $0x801077bf
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 ae 1b 00 00       	call   80102eb0 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 d6 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
80101315:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101317:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131a:	83 c4 0c             	add    $0xc,%esp
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 c6 33 00 00       	call   801046f0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 7e 1b 00 00       	call   80102eb0 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 a6 ee ff ff       	call   801001e0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010134a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101358:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 00 1a 11 80       	push   $0x80111a00
8010136a:	e8 c1 31 00 00       	call   80104530 <acquire>
8010136f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101375:	eb 17                	jmp    8010138e <iget+0x3e>
80101377:	89 f6                	mov    %esi,%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101380:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101386:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010138c:	73 22                	jae    801013b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010138e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101391:	85 c9                	test   %ecx,%ecx
80101393:	7e 04                	jle    80101399 <iget+0x49>
80101395:	39 3b                	cmp    %edi,(%ebx)
80101397:	74 4f                	je     801013e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e3                	jne    80101380 <iget+0x30>
8010139d:	85 c9                	test   %ecx,%ecx
8010139f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013ae:	72 de                	jb     8010138e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b0:	85 f6                	test   %esi,%esi
801013b2:	74 5b                	je     8010140f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013ca:	68 00 1a 11 80       	push   $0x80111a00
801013cf:	e8 1c 32 00 00       	call   801045f0 <release>

  return ip;
801013d4:	83 c4 10             	add    $0x10,%esp
}
801013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013da:	89 f0                	mov    %esi,%eax
801013dc:	5b                   	pop    %ebx
801013dd:	5e                   	pop    %esi
801013de:	5f                   	pop    %edi
801013df:	5d                   	pop    %ebp
801013e0:	c3                   	ret    
801013e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013eb:	75 ac                	jne    80101399 <iget+0x49>
      release(&icache.lock);
801013ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013f5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801013fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013fd:	e8 ee 31 00 00       	call   801045f0 <release>
      return ip;
80101402:	83 c4 10             	add    $0x10,%esp
}
80101405:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101408:	89 f0                	mov    %esi,%eax
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
8010140e:	c3                   	ret    
    panic("iget: no inodes");
8010140f:	83 ec 0c             	sub    $0xc,%esp
80101412:	68 d5 77 10 80       	push   $0x801077d5
80101417:	e8 74 ef ff ff       	call   80100390 <panic>
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	53                   	push   %ebx
80101426:	89 c6                	mov    %eax,%esi
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	77 18                	ja     80101448 <bmap+0x28>
80101430:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101433:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101436:	85 db                	test   %ebx,%ebx
80101438:	74 76                	je     801014b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143d:	89 d8                	mov    %ebx,%eax
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5f                   	pop    %edi
80101442:	5d                   	pop    %ebp
80101443:	c3                   	ret    
80101444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101448:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010144b:	83 fb 7f             	cmp    $0x7f,%ebx
8010144e:	0f 87 90 00 00 00    	ja     801014e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101454:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010145a:	8b 00                	mov    (%eax),%eax
8010145c:	85 d2                	test   %edx,%edx
8010145e:	74 70                	je     801014d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101460:	83 ec 08             	sub    $0x8,%esp
80101463:	52                   	push   %edx
80101464:	50                   	push   %eax
80101465:	e8 66 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010146a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010146e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101471:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101473:	8b 1a                	mov    (%edx),%ebx
80101475:	85 db                	test   %ebx,%ebx
80101477:	75 1d                	jne    80101496 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101479:	8b 06                	mov    (%esi),%eax
8010147b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010147e:	e8 bd fd ff ff       	call   80101240 <balloc>
80101483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101486:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101489:	89 c3                	mov    %eax,%ebx
8010148b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010148d:	57                   	push   %edi
8010148e:	e8 1d 1a 00 00       	call   80102eb0 <log_write>
80101493:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101496:	83 ec 0c             	sub    $0xc,%esp
80101499:	57                   	push   %edi
8010149a:	e8 41 ed ff ff       	call   801001e0 <brelse>
8010149f:	83 c4 10             	add    $0x10,%esp
}
801014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a5:	89 d8                	mov    %ebx,%eax
801014a7:	5b                   	pop    %ebx
801014a8:	5e                   	pop    %esi
801014a9:	5f                   	pop    %edi
801014aa:	5d                   	pop    %ebp
801014ab:	c3                   	ret    
801014ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014b0:	8b 00                	mov    (%eax),%eax
801014b2:	e8 89 fd ff ff       	call   80101240 <balloc>
801014b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014bd:	89 c3                	mov    %eax,%ebx
}
801014bf:	89 d8                	mov    %ebx,%eax
801014c1:	5b                   	pop    %ebx
801014c2:	5e                   	pop    %esi
801014c3:	5f                   	pop    %edi
801014c4:	5d                   	pop    %ebp
801014c5:	c3                   	ret    
801014c6:	8d 76 00             	lea    0x0(%esi),%esi
801014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d0:	e8 6b fd ff ff       	call   80101240 <balloc>
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014dd:	8b 06                	mov    (%esi),%eax
801014df:	e9 7c ff ff ff       	jmp    80101460 <bmap+0x40>
  panic("bmap: out of range");
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	68 e5 77 10 80       	push   $0x801077e5
801014ec:	e8 9f ee ff ff       	call   80100390 <panic>
801014f1:	eb 0d                	jmp    80101500 <readsb>
801014f3:	90                   	nop
801014f4:	90                   	nop
801014f5:	90                   	nop
801014f6:	90                   	nop
801014f7:	90                   	nop
801014f8:	90                   	nop
801014f9:	90                   	nop
801014fa:	90                   	nop
801014fb:	90                   	nop
801014fc:	90                   	nop
801014fd:	90                   	nop
801014fe:	90                   	nop
801014ff:	90                   	nop

80101500 <readsb>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	56                   	push   %esi
80101504:	53                   	push   %ebx
80101505:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101508:	83 ec 08             	sub    $0x8,%esp
8010150b:	6a 01                	push   $0x1
8010150d:	ff 75 08             	pushl  0x8(%ebp)
80101510:	e8 bb eb ff ff       	call   801000d0 <bread>
80101515:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101517:	8d 40 5c             	lea    0x5c(%eax),%eax
8010151a:	83 c4 0c             	add    $0xc,%esp
8010151d:	6a 1c                	push   $0x1c
8010151f:	50                   	push   %eax
80101520:	56                   	push   %esi
80101521:	e8 7a 32 00 00       	call   801047a0 <memmove>
  brelse(bp);
80101526:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101529:	83 c4 10             	add    $0x10,%esp
}
8010152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5d                   	pop    %ebp
  brelse(bp);
80101532:	e9 a9 ec ff ff       	jmp    801001e0 <brelse>
80101537:	89 f6                	mov    %esi,%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <bfree>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	89 d3                	mov    %edx,%ebx
80101547:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	68 e0 19 11 80       	push   $0x801119e0
80101551:	50                   	push   %eax
80101552:	e8 a9 ff ff ff       	call   80101500 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101557:	58                   	pop    %eax
80101558:	5a                   	pop    %edx
80101559:	89 da                	mov    %ebx,%edx
8010155b:	c1 ea 0c             	shr    $0xc,%edx
8010155e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101564:	52                   	push   %edx
80101565:	56                   	push   %esi
80101566:	e8 65 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010156b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010156d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101570:	ba 01 00 00 00       	mov    $0x1,%edx
80101575:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101578:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010157e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101581:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101583:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101588:	85 d1                	test   %edx,%ecx
8010158a:	74 25                	je     801015b1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010158c:	f7 d2                	not    %edx
8010158e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101590:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101593:	21 ca                	and    %ecx,%edx
80101595:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101599:	56                   	push   %esi
8010159a:	e8 11 19 00 00       	call   80102eb0 <log_write>
  brelse(bp);
8010159f:	89 34 24             	mov    %esi,(%esp)
801015a2:	e8 39 ec ff ff       	call   801001e0 <brelse>
}
801015a7:	83 c4 10             	add    $0x10,%esp
801015aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ad:	5b                   	pop    %ebx
801015ae:	5e                   	pop    %esi
801015af:	5d                   	pop    %ebp
801015b0:	c3                   	ret    
    panic("freeing free block");
801015b1:	83 ec 0c             	sub    $0xc,%esp
801015b4:	68 f8 77 10 80       	push   $0x801077f8
801015b9:	e8 d2 ed ff ff       	call   80100390 <panic>
801015be:	66 90                	xchg   %ax,%ax

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	53                   	push   %ebx
801015c4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801015c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015cc:	68 0b 78 10 80       	push   $0x8010780b
801015d1:	68 00 1a 11 80       	push   $0x80111a00
801015d6:	e8 15 2e 00 00       	call   801043f0 <initlock>
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	68 12 78 10 80       	push   $0x80107812
801015e8:	53                   	push   %ebx
801015e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015ef:	e8 ac 2c 00 00       	call   801042a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801015fd:	75 e1                	jne    801015e0 <iinit+0x20>
  readsb(dev, &sb);
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	68 e0 19 11 80       	push   $0x801119e0
80101607:	ff 75 08             	pushl  0x8(%ebp)
8010160a:	e8 f1 fe ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010160f:	ff 35 f8 19 11 80    	pushl  0x801119f8
80101615:	ff 35 f4 19 11 80    	pushl  0x801119f4
8010161b:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101621:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101627:	ff 35 e8 19 11 80    	pushl  0x801119e8
8010162d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101633:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101639:	68 78 78 10 80       	push   $0x80107878
8010163e:	e8 cd f0 ff ff       	call   80100710 <cprintf>
}
80101643:	83 c4 30             	add    $0x30,%esp
80101646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101649:	c9                   	leave  
8010164a:	c3                   	ret    
8010164b:	90                   	nop
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <ialloc>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	53                   	push   %ebx
80101656:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101659:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101660:	8b 45 0c             	mov    0xc(%ebp),%eax
80101663:	8b 75 08             	mov    0x8(%ebp),%esi
80101666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101669:	0f 86 91 00 00 00    	jbe    80101700 <ialloc+0xb0>
8010166f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101674:	eb 21                	jmp    80101697 <ialloc+0x47>
80101676:	8d 76 00             	lea    0x0(%esi),%esi
80101679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101680:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101683:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101686:	57                   	push   %edi
80101687:	e8 54 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 c4 10             	add    $0x10,%esp
8010168f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101695:	76 69                	jbe    80101700 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101697:	89 d8                	mov    %ebx,%eax
80101699:	83 ec 08             	sub    $0x8,%esp
8010169c:	c1 e8 03             	shr    $0x3,%eax
8010169f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016a5:	50                   	push   %eax
801016a6:	56                   	push   %esi
801016a7:	e8 24 ea ff ff       	call   801000d0 <bread>
801016ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801016ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801016b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801016b3:	83 e0 07             	and    $0x7,%eax
801016b6:	c1 e0 06             	shl    $0x6,%eax
801016b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016c1:	75 bd                	jne    80101680 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016c3:	83 ec 04             	sub    $0x4,%esp
801016c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016c9:	6a 40                	push   $0x40
801016cb:	6a 00                	push   $0x0
801016cd:	51                   	push   %ecx
801016ce:	e8 1d 30 00 00       	call   801046f0 <memset>
      dip->type = type;
801016d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016dd:	89 3c 24             	mov    %edi,(%esp)
801016e0:	e8 cb 17 00 00       	call   80102eb0 <log_write>
      brelse(bp);
801016e5:	89 3c 24             	mov    %edi,(%esp)
801016e8:	e8 f3 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801016ed:	83 c4 10             	add    $0x10,%esp
}
801016f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016f3:	89 da                	mov    %ebx,%edx
801016f5:	89 f0                	mov    %esi,%eax
}
801016f7:	5b                   	pop    %ebx
801016f8:	5e                   	pop    %esi
801016f9:	5f                   	pop    %edi
801016fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801016fb:	e9 50 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
80101700:	83 ec 0c             	sub    $0xc,%esp
80101703:	68 18 78 10 80       	push   $0x80107818
80101708:	e8 83 ec ff ff       	call   80100390 <panic>
8010170d:	8d 76 00             	lea    0x0(%esi),%esi

80101710 <iupdate>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	83 ec 08             	sub    $0x8,%esp
8010171b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101721:	c1 e8 03             	shr    $0x3,%eax
80101724:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010172a:	50                   	push   %eax
8010172b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010172e:	e8 9d e9 ff ff       	call   801000d0 <bread>
80101733:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101735:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101738:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010173f:	83 e0 07             	and    $0x7,%eax
80101742:	c1 e0 06             	shl    $0x6,%eax
80101745:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101749:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010174c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101750:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101753:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101757:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010175b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010175f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101763:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101767:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010176a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176d:	6a 34                	push   $0x34
8010176f:	53                   	push   %ebx
80101770:	50                   	push   %eax
80101771:	e8 2a 30 00 00       	call   801047a0 <memmove>
  log_write(bp);
80101776:	89 34 24             	mov    %esi,(%esp)
80101779:	e8 32 17 00 00       	call   80102eb0 <log_write>
  brelse(bp);
8010177e:	89 75 08             	mov    %esi,0x8(%ebp)
80101781:	83 c4 10             	add    $0x10,%esp
}
80101784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101787:	5b                   	pop    %ebx
80101788:	5e                   	pop    %esi
80101789:	5d                   	pop    %ebp
  brelse(bp);
8010178a:	e9 51 ea ff ff       	jmp    801001e0 <brelse>
8010178f:	90                   	nop

80101790 <idup>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	53                   	push   %ebx
80101794:	83 ec 10             	sub    $0x10,%esp
80101797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010179a:	68 00 1a 11 80       	push   $0x80111a00
8010179f:	e8 8c 2d 00 00       	call   80104530 <acquire>
  ip->ref++;
801017a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017a8:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017af:	e8 3c 2e 00 00       	call   801045f0 <release>
}
801017b4:	89 d8                	mov    %ebx,%eax
801017b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017b9:	c9                   	leave  
801017ba:	c3                   	ret    
801017bb:	90                   	nop
801017bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017c0 <ilock>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017c8:	85 db                	test   %ebx,%ebx
801017ca:	0f 84 b7 00 00 00    	je     80101887 <ilock+0xc7>
801017d0:	8b 53 08             	mov    0x8(%ebx),%edx
801017d3:	85 d2                	test   %edx,%edx
801017d5:	0f 8e ac 00 00 00    	jle    80101887 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017db:	8d 43 0c             	lea    0xc(%ebx),%eax
801017de:	83 ec 0c             	sub    $0xc,%esp
801017e1:	50                   	push   %eax
801017e2:	e8 f9 2a 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid == 0){
801017e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ea:	83 c4 10             	add    $0x10,%esp
801017ed:	85 c0                	test   %eax,%eax
801017ef:	74 0f                	je     80101800 <ilock+0x40>
}
801017f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f4:	5b                   	pop    %ebx
801017f5:	5e                   	pop    %esi
801017f6:	5d                   	pop    %ebp
801017f7:	c3                   	ret    
801017f8:	90                   	nop
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101800:	8b 43 04             	mov    0x4(%ebx),%eax
80101803:	83 ec 08             	sub    $0x8,%esp
80101806:	c1 e8 03             	shr    $0x3,%eax
80101809:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010180f:	50                   	push   %eax
80101810:	ff 33                	pushl  (%ebx)
80101812:	e8 b9 e8 ff ff       	call   801000d0 <bread>
80101817:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101819:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010181c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010181f:	83 e0 07             	and    $0x7,%eax
80101822:	c1 e0 06             	shl    $0x6,%eax
80101825:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101829:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010182c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010182f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101833:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101837:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010183b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010183f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101843:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101847:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010184b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010184e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101851:	6a 34                	push   $0x34
80101853:	50                   	push   %eax
80101854:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101857:	50                   	push   %eax
80101858:	e8 43 2f 00 00       	call   801047a0 <memmove>
    brelse(bp);
8010185d:	89 34 24             	mov    %esi,(%esp)
80101860:	e8 7b e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101865:	83 c4 10             	add    $0x10,%esp
80101868:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010186d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101874:	0f 85 77 ff ff ff    	jne    801017f1 <ilock+0x31>
      panic("ilock: no type");
8010187a:	83 ec 0c             	sub    $0xc,%esp
8010187d:	68 30 78 10 80       	push   $0x80107830
80101882:	e8 09 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101887:	83 ec 0c             	sub    $0xc,%esp
8010188a:	68 2a 78 10 80       	push   $0x8010782a
8010188f:	e8 fc ea ff ff       	call   80100390 <panic>
80101894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010189a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801018a0 <iunlock>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	74 28                	je     801018d4 <iunlock+0x34>
801018ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801018af:	83 ec 0c             	sub    $0xc,%esp
801018b2:	56                   	push   %esi
801018b3:	e8 e8 2a 00 00       	call   801043a0 <holdingsleep>
801018b8:	83 c4 10             	add    $0x10,%esp
801018bb:	85 c0                	test   %eax,%eax
801018bd:	74 15                	je     801018d4 <iunlock+0x34>
801018bf:	8b 43 08             	mov    0x8(%ebx),%eax
801018c2:	85 c0                	test   %eax,%eax
801018c4:	7e 0e                	jle    801018d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018cc:	5b                   	pop    %ebx
801018cd:	5e                   	pop    %esi
801018ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018cf:	e9 6c 2a 00 00       	jmp    80104340 <releasesleep>
    panic("iunlock");
801018d4:	83 ec 0c             	sub    $0xc,%esp
801018d7:	68 3f 78 10 80       	push   $0x8010783f
801018dc:	e8 af ea ff ff       	call   80100390 <panic>
801018e1:	eb 0d                	jmp    801018f0 <iput>
801018e3:	90                   	nop
801018e4:	90                   	nop
801018e5:	90                   	nop
801018e6:	90                   	nop
801018e7:	90                   	nop
801018e8:	90                   	nop
801018e9:	90                   	nop
801018ea:	90                   	nop
801018eb:	90                   	nop
801018ec:	90                   	nop
801018ed:	90                   	nop
801018ee:	90                   	nop
801018ef:	90                   	nop

801018f0 <iput>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 28             	sub    $0x28,%esp
801018f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018ff:	57                   	push   %edi
80101900:	e8 db 29 00 00       	call   801042e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101905:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101908:	83 c4 10             	add    $0x10,%esp
8010190b:	85 d2                	test   %edx,%edx
8010190d:	74 07                	je     80101916 <iput+0x26>
8010190f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101914:	74 32                	je     80101948 <iput+0x58>
  releasesleep(&ip->lock);
80101916:	83 ec 0c             	sub    $0xc,%esp
80101919:	57                   	push   %edi
8010191a:	e8 21 2a 00 00       	call   80104340 <releasesleep>
  acquire(&icache.lock);
8010191f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101926:	e8 05 2c 00 00       	call   80104530 <acquire>
  ip->ref--;
8010192b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010192f:	83 c4 10             	add    $0x10,%esp
80101932:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101939:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010193c:	5b                   	pop    %ebx
8010193d:	5e                   	pop    %esi
8010193e:	5f                   	pop    %edi
8010193f:	5d                   	pop    %ebp
  release(&icache.lock);
80101940:	e9 ab 2c 00 00       	jmp    801045f0 <release>
80101945:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101948:	83 ec 0c             	sub    $0xc,%esp
8010194b:	68 00 1a 11 80       	push   $0x80111a00
80101950:	e8 db 2b 00 00       	call   80104530 <acquire>
    int r = ip->ref;
80101955:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101958:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010195f:	e8 8c 2c 00 00       	call   801045f0 <release>
    if(r == 1){
80101964:	83 c4 10             	add    $0x10,%esp
80101967:	83 fe 01             	cmp    $0x1,%esi
8010196a:	75 aa                	jne    80101916 <iput+0x26>
8010196c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101972:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101975:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101978:	89 cf                	mov    %ecx,%edi
8010197a:	eb 0b                	jmp    80101987 <iput+0x97>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101980:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101983:	39 fe                	cmp    %edi,%esi
80101985:	74 19                	je     801019a0 <iput+0xb0>
    if(ip->addrs[i]){
80101987:	8b 16                	mov    (%esi),%edx
80101989:	85 d2                	test   %edx,%edx
8010198b:	74 f3                	je     80101980 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010198d:	8b 03                	mov    (%ebx),%eax
8010198f:	e8 ac fb ff ff       	call   80101540 <bfree>
      ip->addrs[i] = 0;
80101994:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010199a:	eb e4                	jmp    80101980 <iput+0x90>
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019a9:	85 c0                	test   %eax,%eax
801019ab:	75 33                	jne    801019e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019b7:	53                   	push   %ebx
801019b8:	e8 53 fd ff ff       	call   80101710 <iupdate>
      ip->type = 0;
801019bd:	31 c0                	xor    %eax,%eax
801019bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019c3:	89 1c 24             	mov    %ebx,(%esp)
801019c6:	e8 45 fd ff ff       	call   80101710 <iupdate>
      ip->valid = 0;
801019cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019d2:	83 c4 10             	add    $0x10,%esp
801019d5:	e9 3c ff ff ff       	jmp    80101916 <iput+0x26>
801019da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019e0:	83 ec 08             	sub    $0x8,%esp
801019e3:	50                   	push   %eax
801019e4:	ff 33                	pushl  (%ebx)
801019e6:	e8 e5 e6 ff ff       	call   801000d0 <bread>
801019eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801019f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	89 cf                	mov    %ecx,%edi
801019ff:	eb 0e                	jmp    80101a0f <iput+0x11f>
80101a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a08:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a0b:	39 fe                	cmp    %edi,%esi
80101a0d:	74 0f                	je     80101a1e <iput+0x12e>
      if(a[j])
80101a0f:	8b 16                	mov    (%esi),%edx
80101a11:	85 d2                	test   %edx,%edx
80101a13:	74 f3                	je     80101a08 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a15:	8b 03                	mov    (%ebx),%eax
80101a17:	e8 24 fb ff ff       	call   80101540 <bfree>
80101a1c:	eb ea                	jmp    80101a08 <iput+0x118>
    brelse(bp);
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a24:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a27:	e8 b4 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a2c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a32:	8b 03                	mov    (%ebx),%eax
80101a34:	e8 07 fb ff ff       	call   80101540 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a39:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a40:	00 00 00 
80101a43:	83 c4 10             	add    $0x10,%esp
80101a46:	e9 62 ff ff ff       	jmp    801019ad <iput+0xbd>
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a50 <iunlockput>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	53                   	push   %ebx
80101a54:	83 ec 10             	sub    $0x10,%esp
80101a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a5a:	53                   	push   %ebx
80101a5b:	e8 40 fe ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101a60:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a63:	83 c4 10             	add    $0x10,%esp
}
80101a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a69:	c9                   	leave  
  iput(ip);
80101a6a:	e9 81 fe ff ff       	jmp    801018f0 <iput>
80101a6f:	90                   	nop

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	90                   	nop
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ada:	89 f9                	mov    %edi,%ecx
80101adc:	01 f1                	add    %esi,%ecx
80101ade:	0f 82 ad 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ae4:	89 c2                	mov    %eax,%edx
80101ae6:	29 f2                	sub    %esi,%edx
80101ae8:	39 c8                	cmp    %ecx,%eax
80101aea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aed:	31 ff                	xor    %edi,%edi
80101aef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101af1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af4:	74 6c                	je     80101b62 <readi+0xc2>
80101af6:	8d 76 00             	lea    0x0(%esi),%esi
80101af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 11 f9 ff ff       	call   80101420 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	pushl  (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1f:	89 f0                	mov    %esi,%eax
80101b21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	29 fb                	sub    %edi,%ebx
80101b39:	39 d9                	cmp    %ebx,%ecx
80101b3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3e:	53                   	push   %ebx
80101b3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b47:	e8 54 2c 00 00       	call   801047a0 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 89 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	90                   	nop
80101b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	39 70 58             	cmp    %esi,0x58(%eax)
80101bcf:	0f 82 eb 00 00 00    	jb     80101cc0 <writei+0x120>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d4 00 00 00    	ja     80101cc0 <writei+0x120>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 cc 00 00 00    	jne    80101cc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	85 ff                	test   %edi,%edi
80101bf6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 11 f8 ff ff       	call   80101420 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	pushl  (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c22:	89 f0                	mov    %esi,%eax
80101c24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	39 d9                	cmp    %ebx,%ecx
80101c39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c3c:	53                   	push   %ebx
80101c3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	50                   	push   %eax
80101c43:	e8 58 2b 00 00       	call   801047a0 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 60 12 00 00       	call   80102eb0 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 88 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c5e:	83 c4 10             	add    $0x10,%esp
80101c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 36                	ja     80101cc0 <writei+0x120>
80101c8a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 2b                	je     80101cc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 59 fa ff ff       	call   80101710 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc5:	eb ad                	jmp    80101c74 <writei+0xd4>
80101cc7:	89 f6                	mov    %esi,%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	pushl  0xc(%ebp)
80101cdb:	ff 75 08             	pushl  0x8(%ebp)
80101cde:	e8 2d 2b 00 00       	call   80104810 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d34:	83 ec 04             	sub    $0x4,%esp
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	pushl  0xc(%ebp)
80101d3d:	e8 ce 2a 00 00       	call   80104810 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	90                   	nop
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 d9 f5 ff ff       	call   80101350 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 59 78 10 80       	push   $0x80107859
80101d87:	e8 04 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 47 78 10 80       	push   $0x80107847
80101d94:	e8 f7 e5 ff ff       	call   80100390 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 cf                	mov    %ecx,%edi
80101da8:	89 c3                	mov    %eax,%ebx
80101daa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101db0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101db3:	0f 84 67 01 00 00    	je     80101f20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101db9:	e8 62 1b 00 00       	call   80103920 <myproc>
  acquire(&icache.lock);
80101dbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc4:	68 00 1a 11 80       	push   $0x80111a00
80101dc9:	e8 62 27 00 00       	call   80104530 <acquire>
  ip->ref++;
80101dce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dd9:	e8 12 28 00 00       	call   801045f0 <release>
80101dde:	83 c4 10             	add    $0x10,%esp
80101de1:	eb 08                	jmp    80101deb <namex+0x4b>
80101de3:	90                   	nop
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 ee 00 00 00    	je     80101ee8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	3c 2f                	cmp    $0x2f,%al
80101dff:	0f 84 b3 00 00 00    	je     80101eb8 <namex+0x118>
80101e05:	84 c0                	test   %al,%al
80101e07:	89 da                	mov    %ebx,%edx
80101e09:	75 09                	jne    80101e14 <namex+0x74>
80101e0b:	e9 a8 00 00 00       	jmp    80101eb8 <namex+0x118>
80101e10:	84 c0                	test   %al,%al
80101e12:	74 0a                	je     80101e1e <namex+0x7e>
    path++;
80101e14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e17:	0f b6 02             	movzbl (%edx),%eax
80101e1a:	3c 2f                	cmp    $0x2f,%al
80101e1c:	75 f2                	jne    80101e10 <namex+0x70>
80101e1e:	89 d1                	mov    %edx,%ecx
80101e20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e22:	83 f9 0d             	cmp    $0xd,%ecx
80101e25:	0f 8e 91 00 00 00    	jle    80101ebc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e2b:	83 ec 04             	sub    $0x4,%esp
80101e2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e31:	6a 0e                	push   $0xe
80101e33:	53                   	push   %ebx
80101e34:	57                   	push   %edi
80101e35:	e8 66 29 00 00       	call   801047a0 <memmove>
    path++;
80101e3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101e3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101e40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101e42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e45:	75 11                	jne    80101e58 <namex+0xb8>
80101e47:	89 f6                	mov    %esi,%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101e50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e56:	74 f8                	je     80101e50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e58:	83 ec 0c             	sub    $0xc,%esp
80101e5b:	56                   	push   %esi
80101e5c:	e8 5f f9 ff ff       	call   801017c0 <ilock>
    if(ip->type != T_DIR){
80101e61:	83 c4 10             	add    $0x10,%esp
80101e64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e69:	0f 85 91 00 00 00    	jne    80101f00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e72:	85 d2                	test   %edx,%edx
80101e74:	74 09                	je     80101e7f <namex+0xdf>
80101e76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e79:	0f 84 b7 00 00 00    	je     80101f36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e7f:	83 ec 04             	sub    $0x4,%esp
80101e82:	6a 00                	push   $0x0
80101e84:	57                   	push   %edi
80101e85:	56                   	push   %esi
80101e86:	e8 65 fe ff ff       	call   80101cf0 <dirlookup>
80101e8b:	83 c4 10             	add    $0x10,%esp
80101e8e:	85 c0                	test   %eax,%eax
80101e90:	74 6e                	je     80101f00 <namex+0x160>
  iunlock(ip);
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e98:	56                   	push   %esi
80101e99:	e8 02 fa ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101e9e:	89 34 24             	mov    %esi,(%esp)
80101ea1:	e8 4a fa ff ff       	call   801018f0 <iput>
80101ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ea9:	83 c4 10             	add    $0x10,%esp
80101eac:	89 c6                	mov    %eax,%esi
80101eae:	e9 38 ff ff ff       	jmp    80101deb <namex+0x4b>
80101eb3:	90                   	nop
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101eb8:	89 da                	mov    %ebx,%edx
80101eba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101ebc:	83 ec 04             	sub    $0x4,%esp
80101ebf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ec2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ec5:	51                   	push   %ecx
80101ec6:	53                   	push   %ebx
80101ec7:	57                   	push   %edi
80101ec8:	e8 d3 28 00 00       	call   801047a0 <memmove>
    name[len] = 0;
80101ecd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ed0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ed3:	83 c4 10             	add    $0x10,%esp
80101ed6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101eda:	89 d3                	mov    %edx,%ebx
80101edc:	e9 61 ff ff ff       	jmp    80101e42 <namex+0xa2>
80101ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	75 5d                	jne    80101f4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef2:	89 f0                	mov    %esi,%eax
80101ef4:	5b                   	pop    %ebx
80101ef5:	5e                   	pop    %esi
80101ef6:	5f                   	pop    %edi
80101ef7:	5d                   	pop    %ebp
80101ef8:	c3                   	ret    
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f00:	83 ec 0c             	sub    $0xc,%esp
80101f03:	56                   	push   %esi
80101f04:	e8 97 f9 ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101f09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f0e:	e8 dd f9 ff ff       	call   801018f0 <iput>
      return 0;
80101f13:	83 c4 10             	add    $0x10,%esp
}
80101f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f19:	89 f0                	mov    %esi,%eax
80101f1b:	5b                   	pop    %ebx
80101f1c:	5e                   	pop    %esi
80101f1d:	5f                   	pop    %edi
80101f1e:	5d                   	pop    %ebp
80101f1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	e8 21 f4 ff ff       	call   80101350 <iget>
80101f2f:	89 c6                	mov    %eax,%esi
80101f31:	e9 b5 fe ff ff       	jmp    80101deb <namex+0x4b>
      iunlock(ip);
80101f36:	83 ec 0c             	sub    $0xc,%esp
80101f39:	56                   	push   %esi
80101f3a:	e8 61 f9 ff ff       	call   801018a0 <iunlock>
      return ip;
80101f3f:	83 c4 10             	add    $0x10,%esp
}
80101f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f45:	89 f0                	mov    %esi,%eax
80101f47:	5b                   	pop    %ebx
80101f48:	5e                   	pop    %esi
80101f49:	5f                   	pop    %edi
80101f4a:	5d                   	pop    %ebp
80101f4b:	c3                   	ret    
    iput(ip);
80101f4c:	83 ec 0c             	sub    $0xc,%esp
80101f4f:	56                   	push   %esi
    return 0;
80101f50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f52:	e8 99 f9 ff ff       	call   801018f0 <iput>
    return 0;
80101f57:	83 c4 10             	add    $0x10,%esp
80101f5a:	eb 93                	jmp    80101eef <namex+0x14f>
80101f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f60 <dirlink>:
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 20             	sub    $0x20,%esp
80101f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f6c:	6a 00                	push   $0x0
80101f6e:	ff 75 0c             	pushl  0xc(%ebp)
80101f71:	53                   	push   %ebx
80101f72:	e8 79 fd ff ff       	call   80101cf0 <dirlookup>
80101f77:	83 c4 10             	add    $0x10,%esp
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	75 67                	jne    80101fe5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	74 29                	je     80101fb1 <dirlink+0x51>
80101f88:	31 ff                	xor    %edi,%edi
80101f8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f8d:	eb 09                	jmp    80101f98 <dirlink+0x38>
80101f8f:	90                   	nop
80101f90:	83 c7 10             	add    $0x10,%edi
80101f93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f96:	73 19                	jae    80101fb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f98:	6a 10                	push   $0x10
80101f9a:	57                   	push   %edi
80101f9b:	56                   	push   %esi
80101f9c:	53                   	push   %ebx
80101f9d:	e8 fe fa ff ff       	call   80101aa0 <readi>
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	83 f8 10             	cmp    $0x10,%eax
80101fa8:	75 4e                	jne    80101ff8 <dirlink+0x98>
    if(de.inum == 0)
80101faa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101faf:	75 df                	jne    80101f90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101fb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fb4:	83 ec 04             	sub    $0x4,%esp
80101fb7:	6a 0e                	push   $0xe
80101fb9:	ff 75 0c             	pushl  0xc(%ebp)
80101fbc:	50                   	push   %eax
80101fbd:	e8 ae 28 00 00       	call   80104870 <strncpy>
  de.inum = inum;
80101fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc5:	6a 10                	push   $0x10
80101fc7:	57                   	push   %edi
80101fc8:	56                   	push   %esi
80101fc9:	53                   	push   %ebx
  de.inum = inum;
80101fca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fce:	e8 cd fb ff ff       	call   80101ba0 <writei>
80101fd3:	83 c4 20             	add    $0x20,%esp
80101fd6:	83 f8 10             	cmp    $0x10,%eax
80101fd9:	75 2a                	jne    80102005 <dirlink+0xa5>
  return 0;
80101fdb:	31 c0                	xor    %eax,%eax
}
80101fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe0:	5b                   	pop    %ebx
80101fe1:	5e                   	pop    %esi
80101fe2:	5f                   	pop    %edi
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret    
    iput(ip);
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	50                   	push   %eax
80101fe9:	e8 02 f9 ff ff       	call   801018f0 <iput>
    return -1;
80101fee:	83 c4 10             	add    $0x10,%esp
80101ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ff6:	eb e5                	jmp    80101fdd <dirlink+0x7d>
      panic("dirlink read");
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	68 68 78 10 80       	push   $0x80107868
80102000:	e8 8b e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 56 80 10 80       	push   $0x80108056
8010200d:	e8 7e e3 ff ff       	call   80100390 <panic>
80102012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <namei>:

struct inode*
namei(char *path)
{
80102020:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102021:	31 d2                	xor    %edx,%edx
{
80102023:	89 e5                	mov    %esp,%ebp
80102025:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102028:	8b 45 08             	mov    0x8(%ebp),%eax
8010202b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010202e:	e8 6d fd ff ff       	call   80101da0 <namex>
}
80102033:	c9                   	leave  
80102034:	c3                   	ret    
80102035:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102040:	55                   	push   %ebp
  return namex(path, 1, name);
80102041:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102046:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102048:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010204e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010204f:	e9 4c fd ff ff       	jmp    80101da0 <namex>
80102054:	66 90                	xchg   %ax,%ax
80102056:	66 90                	xchg   %ax,%ax
80102058:	66 90                	xchg   %ax,%ax
8010205a:	66 90                	xchg   %ax,%ax
8010205c:	66 90                	xchg   %ax,%ax
8010205e:	66 90                	xchg   %ax,%ax

80102060 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102069:	85 c0                	test   %eax,%eax
8010206b:	0f 84 b4 00 00 00    	je     80102125 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102071:	8b 58 08             	mov    0x8(%eax),%ebx
80102074:	89 c6                	mov    %eax,%esi
80102076:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010207c:	0f 87 96 00 00 00    	ja     80102118 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102082:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102087:	89 f6                	mov    %esi,%esi
80102089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102090:	89 ca                	mov    %ecx,%edx
80102092:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102093:	83 e0 c0             	and    $0xffffffc0,%eax
80102096:	3c 40                	cmp    $0x40,%al
80102098:	75 f6                	jne    80102090 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010209a:	31 ff                	xor    %edi,%edi
8010209c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020a1:	89 f8                	mov    %edi,%eax
801020a3:	ee                   	out    %al,(%dx)
801020a4:	b8 01 00 00 00       	mov    $0x1,%eax
801020a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ae:	ee                   	out    %al,(%dx)
801020af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020b4:	89 d8                	mov    %ebx,%eax
801020b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020b7:	89 d8                	mov    %ebx,%eax
801020b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020be:	c1 f8 08             	sar    $0x8,%eax
801020c1:	ee                   	out    %al,(%dx)
801020c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020c7:	89 f8                	mov    %edi,%eax
801020c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801020ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020d3:	c1 e0 04             	shl    $0x4,%eax
801020d6:	83 e0 10             	and    $0x10,%eax
801020d9:	83 c8 e0             	or     $0xffffffe0,%eax
801020dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020dd:	f6 06 04             	testb  $0x4,(%esi)
801020e0:	75 16                	jne    801020f8 <idestart+0x98>
801020e2:	b8 20 00 00 00       	mov    $0x20,%eax
801020e7:	89 ca                	mov    %ecx,%edx
801020e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ed:	5b                   	pop    %ebx
801020ee:	5e                   	pop    %esi
801020ef:	5f                   	pop    %edi
801020f0:	5d                   	pop    %ebp
801020f1:	c3                   	ret    
801020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020f8:	b8 30 00 00 00       	mov    $0x30,%eax
801020fd:	89 ca                	mov    %ecx,%edx
801020ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102100:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102105:	83 c6 5c             	add    $0x5c,%esi
80102108:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210d:	fc                   	cld    
8010210e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102110:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102113:	5b                   	pop    %ebx
80102114:	5e                   	pop    %esi
80102115:	5f                   	pop    %edi
80102116:	5d                   	pop    %ebp
80102117:	c3                   	ret    
    panic("incorrect blockno");
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	68 d4 78 10 80       	push   $0x801078d4
80102120:	e8 6b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102125:	83 ec 0c             	sub    $0xc,%esp
80102128:	68 cb 78 10 80       	push   $0x801078cb
8010212d:	e8 5e e2 ff ff       	call   80100390 <panic>
80102132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <ideinit>:
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102146:	68 e6 78 10 80       	push   $0x801078e6
8010214b:	68 80 b5 10 80       	push   $0x8010b580
80102150:	e8 9b 22 00 00       	call   801043f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102155:	58                   	pop    %eax
80102156:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010215b:	5a                   	pop    %edx
8010215c:	83 e8 01             	sub    $0x1,%eax
8010215f:	50                   	push   %eax
80102160:	6a 0e                	push   $0xe
80102162:	e8 a9 02 00 00       	call   80102410 <ioapicenable>
80102167:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010216a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010216f:	90                   	nop
80102170:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102171:	83 e0 c0             	and    $0xffffffc0,%eax
80102174:	3c 40                	cmp    $0x40,%al
80102176:	75 f8                	jne    80102170 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102178:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010217d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102182:	ee                   	out    %al,(%dx)
80102183:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102188:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010218d:	eb 06                	jmp    80102195 <ideinit+0x55>
8010218f:	90                   	nop
  for(i=0; i<1000; i++){
80102190:	83 e9 01             	sub    $0x1,%ecx
80102193:	74 0f                	je     801021a4 <ideinit+0x64>
80102195:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102196:	84 c0                	test   %al,%al
80102198:	74 f6                	je     80102190 <ideinit+0x50>
      havedisk1 = 1;
8010219a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ae:	ee                   	out    %al,(%dx)
}
801021af:	c9                   	leave  
801021b0:	c3                   	ret    
801021b1:	eb 0d                	jmp    801021c0 <ideintr>
801021b3:	90                   	nop
801021b4:	90                   	nop
801021b5:	90                   	nop
801021b6:	90                   	nop
801021b7:	90                   	nop
801021b8:	90                   	nop
801021b9:	90                   	nop
801021ba:	90                   	nop
801021bb:	90                   	nop
801021bc:	90                   	nop
801021bd:	90                   	nop
801021be:	90                   	nop
801021bf:	90                   	nop

801021c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021c9:	68 80 b5 10 80       	push   $0x8010b580
801021ce:	e8 5d 23 00 00       	call   80104530 <acquire>

  if((b = idequeue) == 0){
801021d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021d9:	83 c4 10             	add    $0x10,%esp
801021dc:	85 db                	test   %ebx,%ebx
801021de:	74 67                	je     80102247 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801021e0:	8b 43 58             	mov    0x58(%ebx),%eax
801021e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801021e8:	8b 3b                	mov    (%ebx),%edi
801021ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801021f0:	75 31                	jne    80102223 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f7:	89 f6                	mov    %esi,%esi
801021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102200:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102201:	89 c6                	mov    %eax,%esi
80102203:	83 e6 c0             	and    $0xffffffc0,%esi
80102206:	89 f1                	mov    %esi,%ecx
80102208:	80 f9 40             	cmp    $0x40,%cl
8010220b:	75 f3                	jne    80102200 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010220d:	a8 21                	test   $0x21,%al
8010220f:	75 12                	jne    80102223 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102211:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102214:	b9 80 00 00 00       	mov    $0x80,%ecx
80102219:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010221e:	fc                   	cld    
8010221f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102221:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102223:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102226:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102229:	89 f9                	mov    %edi,%ecx
8010222b:	83 c9 02             	or     $0x2,%ecx
8010222e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102230:	53                   	push   %ebx
80102231:	e8 ca 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102236:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010223b:	83 c4 10             	add    $0x10,%esp
8010223e:	85 c0                	test   %eax,%eax
80102240:	74 05                	je     80102247 <ideintr+0x87>
    idestart(idequeue);
80102242:	e8 19 fe ff ff       	call   80102060 <idestart>
    release(&idelock);
80102247:	83 ec 0c             	sub    $0xc,%esp
8010224a:	68 80 b5 10 80       	push   $0x8010b580
8010224f:	e8 9c 23 00 00       	call   801045f0 <release>

  release(&idelock);
}
80102254:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102257:	5b                   	pop    %ebx
80102258:	5e                   	pop    %esi
80102259:	5f                   	pop    %edi
8010225a:	5d                   	pop    %ebp
8010225b:	c3                   	ret    
8010225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102260 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	53                   	push   %ebx
80102264:	83 ec 10             	sub    $0x10,%esp
80102267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010226a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010226d:	50                   	push   %eax
8010226e:	e8 2d 21 00 00       	call   801043a0 <holdingsleep>
80102273:	83 c4 10             	add    $0x10,%esp
80102276:	85 c0                	test   %eax,%eax
80102278:	0f 84 c6 00 00 00    	je     80102344 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 e0 06             	and    $0x6,%eax
80102283:	83 f8 02             	cmp    $0x2,%eax
80102286:	0f 84 ab 00 00 00    	je     80102337 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010228c:	8b 53 04             	mov    0x4(%ebx),%edx
8010228f:	85 d2                	test   %edx,%edx
80102291:	74 0d                	je     801022a0 <iderw+0x40>
80102293:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102298:	85 c0                	test   %eax,%eax
8010229a:	0f 84 b1 00 00 00    	je     80102351 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022a0:	83 ec 0c             	sub    $0xc,%esp
801022a3:	68 80 b5 10 80       	push   $0x8010b580
801022a8:	e8 83 22 00 00       	call   80104530 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801022b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801022b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022bd:	85 d2                	test   %edx,%edx
801022bf:	75 09                	jne    801022ca <iderw+0x6a>
801022c1:	eb 6d                	jmp    80102330 <iderw+0xd0>
801022c3:	90                   	nop
801022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022c8:	89 c2                	mov    %eax,%edx
801022ca:	8b 42 58             	mov    0x58(%edx),%eax
801022cd:	85 c0                	test   %eax,%eax
801022cf:	75 f7                	jne    801022c8 <iderw+0x68>
801022d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022d6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022dc:	74 42                	je     80102320 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022de:	8b 03                	mov    (%ebx),%eax
801022e0:	83 e0 06             	and    $0x6,%eax
801022e3:	83 f8 02             	cmp    $0x2,%eax
801022e6:	74 23                	je     8010230b <iderw+0xab>
801022e8:	90                   	nop
801022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801022f0:	83 ec 08             	sub    $0x8,%esp
801022f3:	68 80 b5 10 80       	push   $0x8010b580
801022f8:	53                   	push   %ebx
801022f9:	e8 c2 1b 00 00       	call   80103ec0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 c4 10             	add    $0x10,%esp
80102303:	83 e0 06             	and    $0x6,%eax
80102306:	83 f8 02             	cmp    $0x2,%eax
80102309:	75 e5                	jne    801022f0 <iderw+0x90>
  }


  release(&idelock);
8010230b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102315:	c9                   	leave  
  release(&idelock);
80102316:	e9 d5 22 00 00       	jmp    801045f0 <release>
8010231b:	90                   	nop
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102320:	89 d8                	mov    %ebx,%eax
80102322:	e8 39 fd ff ff       	call   80102060 <idestart>
80102327:	eb b5                	jmp    801022de <iderw+0x7e>
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102330:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102335:	eb 9d                	jmp    801022d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 00 79 10 80       	push   $0x80107900
8010233f:	e8 4c e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102344:	83 ec 0c             	sub    $0xc,%esp
80102347:	68 ea 78 10 80       	push   $0x801078ea
8010234c:	e8 3f e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102351:	83 ec 0c             	sub    $0xc,%esp
80102354:	68 15 79 10 80       	push   $0x80107915
80102359:	e8 32 e0 ff ff       	call   80100390 <panic>
8010235e:	66 90                	xchg   %ax,%ax

80102360 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102360:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102361:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102368:	00 c0 fe 
{
8010236b:	89 e5                	mov    %esp,%ebp
8010236d:	56                   	push   %esi
8010236e:	53                   	push   %ebx
  ioapic->reg = reg;
8010236f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102376:	00 00 00 
  return ioapic->data;
80102379:	a1 54 36 11 80       	mov    0x80113654,%eax
8010237e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102387:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010238d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102394:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102397:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010239a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010239d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023a0:	39 c2                	cmp    %eax,%edx
801023a2:	74 16                	je     801023ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 34 79 10 80       	push   $0x80107934
801023ac:	e8 5f e3 ff ff       	call   80100710 <cprintf>
801023b1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801023b7:	83 c4 10             	add    $0x10,%esp
801023ba:	83 c3 21             	add    $0x21,%ebx
{
801023bd:	ba 10 00 00 00       	mov    $0x10,%edx
801023c2:	b8 20 00 00 00       	mov    $0x20,%eax
801023c7:	89 f6                	mov    %esi,%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801023d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801023d2:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023d8:	89 c6                	mov    %eax,%esi
801023da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801023e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023e3:	89 71 10             	mov    %esi,0x10(%ecx)
801023e6:	8d 72 01             	lea    0x1(%edx),%esi
801023e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801023ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801023ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801023f0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801023f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801023fd:	75 d1                	jne    801023d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102402:	5b                   	pop    %ebx
80102403:	5e                   	pop    %esi
80102404:	5d                   	pop    %ebp
80102405:	c3                   	ret    
80102406:	8d 76 00             	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102410:	55                   	push   %ebp
  ioapic->reg = reg;
80102411:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
80102417:	89 e5                	mov    %esp,%ebp
80102419:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010241c:	8d 50 20             	lea    0x20(%eax),%edx
8010241f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102423:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102425:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010242b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010242e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102431:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102434:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102436:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010243b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010243e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102441:	5d                   	pop    %ebp
80102442:	c3                   	ret    
80102443:	66 90                	xchg   %ax,%ax
80102445:	66 90                	xchg   %ax,%ax
80102447:	66 90                	xchg   %ax,%ax
80102449:	66 90                	xchg   %ax,%ax
8010244b:	66 90                	xchg   %ax,%ax
8010244d:	66 90                	xchg   %ax,%ax
8010244f:	90                   	nop

80102450 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 04             	sub    $0x4,%esp
80102457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010245a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102460:	75 70                	jne    801024d2 <kfree+0x82>
80102462:	81 fb e8 64 11 80    	cmp    $0x801164e8,%ebx
80102468:	72 68                	jb     801024d2 <kfree+0x82>
8010246a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102470:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102475:	77 5b                	ja     801024d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102477:	83 ec 04             	sub    $0x4,%esp
8010247a:	68 00 10 00 00       	push   $0x1000
8010247f:	6a 01                	push   $0x1
80102481:	53                   	push   %ebx
80102482:	e8 69 22 00 00       	call   801046f0 <memset>

  if(kmem.use_lock)
80102487:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010248d:	83 c4 10             	add    $0x10,%esp
80102490:	85 d2                	test   %edx,%edx
80102492:	75 2c                	jne    801024c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102494:	a1 98 36 11 80       	mov    0x80113698,%eax
80102499:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010249b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801024a0:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
801024a6:	85 c0                	test   %eax,%eax
801024a8:	75 06                	jne    801024b0 <kfree+0x60>
    release(&kmem.lock);
}
801024aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ad:	c9                   	leave  
801024ae:	c3                   	ret    
801024af:	90                   	nop
    release(&kmem.lock);
801024b0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801024b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ba:	c9                   	leave  
    release(&kmem.lock);
801024bb:	e9 30 21 00 00       	jmp    801045f0 <release>
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 60 36 11 80       	push   $0x80113660
801024c8:	e8 63 20 00 00       	call   80104530 <acquire>
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	eb c2                	jmp    80102494 <kfree+0x44>
    panic("kfree");
801024d2:	83 ec 0c             	sub    $0xc,%esp
801024d5:	68 66 79 10 80       	push   $0x80107966
801024da:	e8 b1 de ff ff       	call   80100390 <panic>
801024df:	90                   	nop

801024e0 <freerange>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024fd:	39 de                	cmp    %ebx,%esi
801024ff:	72 23                	jb     80102524 <freerange+0x44>
80102501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102508:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010250e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102511:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102517:	50                   	push   %eax
80102518:	e8 33 ff ff ff       	call   80102450 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	39 f3                	cmp    %esi,%ebx
80102522:	76 e4                	jbe    80102508 <freerange+0x28>
}
80102524:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102527:	5b                   	pop    %ebx
80102528:	5e                   	pop    %esi
80102529:	5d                   	pop    %ebp
8010252a:	c3                   	ret    
8010252b:	90                   	nop
8010252c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102530 <kinit1>:
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
80102534:	53                   	push   %ebx
80102535:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102538:	83 ec 08             	sub    $0x8,%esp
8010253b:	68 6c 79 10 80       	push   $0x8010796c
80102540:	68 60 36 11 80       	push   $0x80113660
80102545:	e8 a6 1e 00 00       	call   801043f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010254a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102550:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102557:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010255a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102560:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102566:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010256c:	39 de                	cmp    %ebx,%esi
8010256e:	72 1c                	jb     8010258c <kinit1+0x5c>
    kfree(p);
80102570:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102576:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102579:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010257f:	50                   	push   %eax
80102580:	e8 cb fe ff ff       	call   80102450 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102585:	83 c4 10             	add    $0x10,%esp
80102588:	39 de                	cmp    %ebx,%esi
8010258a:	73 e4                	jae    80102570 <kinit1+0x40>
}
8010258c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010258f:	5b                   	pop    %ebx
80102590:	5e                   	pop    %esi
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025a0 <kinit2>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
801025a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025bd:	39 de                	cmp    %ebx,%esi
801025bf:	72 23                	jb     801025e4 <kinit2+0x44>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 73 fe ff ff       	call   80102450 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 de                	cmp    %ebx,%esi
801025e2:	73 e4                	jae    801025c8 <kinit2+0x28>
  kmem.use_lock = 1;
801025e4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801025eb:	00 00 00 
}
801025ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f1:	5b                   	pop    %ebx
801025f2:	5e                   	pop    %esi
801025f3:	5d                   	pop    %ebp
801025f4:	c3                   	ret    
801025f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102600:	a1 94 36 11 80       	mov    0x80113694,%eax
80102605:	85 c0                	test   %eax,%eax
80102607:	75 1f                	jne    80102628 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102609:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010260e:	85 c0                	test   %eax,%eax
80102610:	74 0e                	je     80102620 <kalloc+0x20>
    kmem.freelist = r->next;
80102612:	8b 10                	mov    (%eax),%edx
80102614:	89 15 98 36 11 80    	mov    %edx,0x80113698
8010261a:	c3                   	ret    
8010261b:	90                   	nop
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102620:	f3 c3                	repz ret 
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102628:	55                   	push   %ebp
80102629:	89 e5                	mov    %esp,%ebp
8010262b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010262e:	68 60 36 11 80       	push   $0x80113660
80102633:	e8 f8 1e 00 00       	call   80104530 <acquire>
  r = kmem.freelist;
80102638:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102646:	85 c0                	test   %eax,%eax
80102648:	74 08                	je     80102652 <kalloc+0x52>
    kmem.freelist = r->next;
8010264a:	8b 08                	mov    (%eax),%ecx
8010264c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102652:	85 d2                	test   %edx,%edx
80102654:	74 16                	je     8010266c <kalloc+0x6c>
    release(&kmem.lock);
80102656:	83 ec 0c             	sub    $0xc,%esp
80102659:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010265c:	68 60 36 11 80       	push   $0x80113660
80102661:	e8 8a 1f 00 00       	call   801045f0 <release>
  return (char*)r;
80102666:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102669:	83 c4 10             	add    $0x10,%esp
}
8010266c:	c9                   	leave  
8010266d:	c3                   	ret    
8010266e:	66 90                	xchg   %ax,%ax

80102670 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102670:	ba 64 00 00 00       	mov    $0x64,%edx
80102675:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102676:	a8 01                	test   $0x1,%al
80102678:	0f 84 c2 00 00 00    	je     80102740 <kbdgetc+0xd0>
8010267e:	ba 60 00 00 00       	mov    $0x60,%edx
80102683:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102684:	0f b6 d0             	movzbl %al,%edx
80102687:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010268d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102693:	0f 84 7f 00 00 00    	je     80102718 <kbdgetc+0xa8>
{
80102699:	55                   	push   %ebp
8010269a:	89 e5                	mov    %esp,%ebp
8010269c:	53                   	push   %ebx
8010269d:	89 cb                	mov    %ecx,%ebx
8010269f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026a2:	84 c0                	test   %al,%al
801026a4:	78 4a                	js     801026f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026a6:	85 db                	test   %ebx,%ebx
801026a8:	74 09                	je     801026b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801026b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026b3:	0f b6 82 a0 7a 10 80 	movzbl -0x7fef8560(%edx),%eax
801026ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801026bc:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801026c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026d3:	8b 04 85 80 79 10 80 	mov    -0x7fef8680(,%eax,4),%eax
801026da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026de:	74 31                	je     80102711 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801026e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801026e3:	83 fa 19             	cmp    $0x19,%edx
801026e6:	77 40                	ja     80102728 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026eb:	5b                   	pop    %ebx
801026ec:	5d                   	pop    %ebp
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026f0:	83 e0 7f             	and    $0x7f,%eax
801026f3:	85 db                	test   %ebx,%ebx
801026f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801026f8:	0f b6 82 a0 7a 10 80 	movzbl -0x7fef8560(%edx),%eax
801026ff:	83 c8 40             	or     $0x40,%eax
80102702:	0f b6 c0             	movzbl %al,%eax
80102705:	f7 d0                	not    %eax
80102707:	21 c1                	and    %eax,%ecx
    return 0;
80102709:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010270b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102711:	5b                   	pop    %ebx
80102712:	5d                   	pop    %ebp
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102718:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010271b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010271d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102723:	c3                   	ret    
80102724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102728:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010272b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010272e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010272f:	83 f9 1a             	cmp    $0x1a,%ecx
80102732:	0f 42 c2             	cmovb  %edx,%eax
}
80102735:	5d                   	pop    %ebp
80102736:	c3                   	ret    
80102737:	89 f6                	mov    %esi,%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102745:	c3                   	ret    
80102746:	8d 76 00             	lea    0x0(%esi),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <kbdintr>:

void
kbdintr(void)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102756:	68 70 26 10 80       	push   $0x80102670
8010275b:	e8 60 e1 ff ff       	call   801008c0 <consoleintr>
}
80102760:	83 c4 10             	add    $0x10,%esp
80102763:	c9                   	leave  
80102764:	c3                   	ret    
80102765:	66 90                	xchg   %ax,%ax
80102767:	66 90                	xchg   %ax,%ax
80102769:	66 90                	xchg   %ax,%ax
8010276b:	66 90                	xchg   %ax,%ax
8010276d:	66 90                	xchg   %ax,%ax
8010276f:	90                   	nop

80102770 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102770:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	0f 84 c8 00 00 00    	je     80102848 <lapicinit+0xd8>
  lapic[index] = value;
80102780:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102787:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010278a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010278d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102794:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102797:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010279a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ce:	8b 50 30             	mov    0x30(%eax),%edx
801027d1:	c1 ea 10             	shr    $0x10,%edx
801027d4:	80 fa 03             	cmp    $0x3,%dl
801027d7:	77 77                	ja     80102850 <lapicinit+0xe0>
  lapic[index] = value;
801027d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102800:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102807:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102821:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
80102827:	89 f6                	mov    %esi,%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102830:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102836:	80 e6 10             	and    $0x10,%dh
80102839:	75 f5                	jne    80102830 <lapicinit+0xc0>
  lapic[index] = value;
8010283b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102842:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102845:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102850:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102857:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285a:	8b 50 20             	mov    0x20(%eax),%edx
8010285d:	e9 77 ff ff ff       	jmp    801027d9 <lapicinit+0x69>
80102862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102870:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102876:	55                   	push   %ebp
80102877:	31 c0                	xor    %eax,%eax
80102879:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010287b:	85 d2                	test   %edx,%edx
8010287d:	74 06                	je     80102885 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010287f:	8b 42 20             	mov    0x20(%edx),%eax
80102882:	c1 e8 18             	shr    $0x18,%eax
}
80102885:	5d                   	pop    %ebp
80102886:	c3                   	ret    
80102887:	89 f6                	mov    %esi,%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102890:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102895:	55                   	push   %ebp
80102896:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102898:	85 c0                	test   %eax,%eax
8010289a:	74 0d                	je     801028a9 <lapiceoi+0x19>
  lapic[index] = value;
8010289c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028a9:	5d                   	pop    %ebp
801028aa:	c3                   	ret    
801028ab:	90                   	nop
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
}
801028b3:	5d                   	pop    %ebp
801028b4:	c3                   	ret    
801028b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801028c6:	ba 70 00 00 00       	mov    $0x70,%edx
801028cb:	89 e5                	mov    %esp,%ebp
801028cd:	53                   	push   %ebx
801028ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028d4:	ee                   	out    %al,(%dx)
801028d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028da:	ba 71 00 00 00       	mov    $0x71,%edx
801028df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801028f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801028f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801028f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028fe:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102903:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102909:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010290c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102913:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102916:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102919:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102920:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102926:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010292c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010292f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102938:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102947:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010294a:	5b                   	pop    %ebx
8010294b:	5d                   	pop    %ebp
8010294c:	c3                   	ret    
8010294d:	8d 76 00             	lea    0x0(%esi),%esi

80102950 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102950:	55                   	push   %ebp
80102951:	b8 0b 00 00 00       	mov    $0xb,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	57                   	push   %edi
8010295e:	56                   	push   %esi
8010295f:	53                   	push   %ebx
80102960:	83 ec 4c             	sub    $0x4c,%esp
80102963:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102964:	ba 71 00 00 00       	mov    $0x71,%edx
80102969:	ec                   	in     (%dx),%al
8010296a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102972:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102975:	8d 76 00             	lea    0x0(%esi),%esi
80102978:	31 c0                	xor    %eax,%eax
8010297a:	89 da                	mov    %ebx,%edx
8010297c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102982:	89 ca                	mov    %ecx,%edx
80102984:	ec                   	in     (%dx),%al
80102985:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102988:	89 da                	mov    %ebx,%edx
8010298a:	b8 02 00 00 00       	mov    $0x2,%eax
8010298f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	89 ca                	mov    %ecx,%edx
80102992:	ec                   	in     (%dx),%al
80102993:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102996:	89 da                	mov    %ebx,%edx
80102998:	b8 04 00 00 00       	mov    $0x4,%eax
8010299d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299e:	89 ca                	mov    %ecx,%edx
801029a0:	ec                   	in     (%dx),%al
801029a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a4:	89 da                	mov    %ebx,%edx
801029a6:	b8 07 00 00 00       	mov    $0x7,%eax
801029ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ac:	89 ca                	mov    %ecx,%edx
801029ae:	ec                   	in     (%dx),%al
801029af:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b2:	89 da                	mov    %ebx,%edx
801029b4:	b8 08 00 00 00       	mov    $0x8,%eax
801029b9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ba:	89 ca                	mov    %ecx,%edx
801029bc:	ec                   	in     (%dx),%al
801029bd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029bf:	89 da                	mov    %ebx,%edx
801029c1:	b8 09 00 00 00       	mov    $0x9,%eax
801029c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c7:	89 ca                	mov    %ecx,%edx
801029c9:	ec                   	in     (%dx),%al
801029ca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cc:	89 da                	mov    %ebx,%edx
801029ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801029d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d4:	89 ca                	mov    %ecx,%edx
801029d6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029d7:	84 c0                	test   %al,%al
801029d9:	78 9d                	js     80102978 <cmostime+0x28>
  return inb(CMOS_RETURN);
801029db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029df:	89 fa                	mov    %edi,%edx
801029e1:	0f b6 fa             	movzbl %dl,%edi
801029e4:	89 f2                	mov    %esi,%edx
801029e6:	0f b6 f2             	movzbl %dl,%esi
801029e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a09:	31 c0                	xor    %eax,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a17:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1d:	89 ca                	mov    %ecx,%edx
80102a1f:	ec                   	in     (%dx),%al
80102a20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a23:	89 da                	mov    %ebx,%edx
80102a25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a39:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3f:	89 ca                	mov    %ecx,%edx
80102a41:	ec                   	in     (%dx),%al
80102a42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a45:	89 da                	mov    %ebx,%edx
80102a47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a50:	89 ca                	mov    %ecx,%edx
80102a52:	ec                   	in     (%dx),%al
80102a53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a56:	89 da                	mov    %ebx,%edx
80102a58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a61:	89 ca                	mov    %ecx,%edx
80102a63:	ec                   	in     (%dx),%al
80102a64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a70:	6a 18                	push   $0x18
80102a72:	50                   	push   %eax
80102a73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a76:	50                   	push   %eax
80102a77:	e8 c4 1c 00 00       	call   80104740 <memcmp>
80102a7c:	83 c4 10             	add    $0x10,%esp
80102a7f:	85 c0                	test   %eax,%eax
80102a81:	0f 85 f1 fe ff ff    	jne    80102978 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a8b:	75 78                	jne    80102b05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a90:	89 c2                	mov    %eax,%edx
80102a92:	83 e0 0f             	and    $0xf,%eax
80102a95:	c1 ea 04             	shr    $0x4,%edx
80102a98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102aa1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aa4:	89 c2                	mov    %eax,%edx
80102aa6:	83 e0 0f             	and    $0xf,%eax
80102aa9:	c1 ea 04             	shr    $0x4,%edx
80102aac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aaf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ab5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ab8:	89 c2                	mov    %eax,%edx
80102aba:	83 e0 0f             	and    $0xf,%eax
80102abd:	c1 ea 04             	shr    $0x4,%edx
80102ac0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ac3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ac6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102acc:	89 c2                	mov    %eax,%edx
80102ace:	83 e0 0f             	and    $0xf,%eax
80102ad1:	c1 ea 04             	shr    $0x4,%edx
80102ad4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ad7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ada:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102add:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ae0:	89 c2                	mov    %eax,%edx
80102ae2:	83 e0 0f             	and    $0xf,%eax
80102ae5:	c1 ea 04             	shr    $0x4,%edx
80102ae8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aeb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102af1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102af4:	89 c2                	mov    %eax,%edx
80102af6:	83 e0 0f             	and    $0xf,%eax
80102af9:	c1 ea 04             	shr    $0x4,%edx
80102afc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b05:	8b 75 08             	mov    0x8(%ebp),%esi
80102b08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b0b:	89 06                	mov    %eax,(%esi)
80102b0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b10:	89 46 04             	mov    %eax,0x4(%esi)
80102b13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b16:	89 46 08             	mov    %eax,0x8(%esi)
80102b19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b22:	89 46 10             	mov    %eax,0x10(%esi)
80102b25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b35:	5b                   	pop    %ebx
80102b36:	5e                   	pop    %esi
80102b37:	5f                   	pop    %edi
80102b38:	5d                   	pop    %ebp
80102b39:	c3                   	ret    
80102b3a:	66 90                	xchg   %ax,%ax
80102b3c:	66 90                	xchg   %ax,%ax
80102b3e:	66 90                	xchg   %ax,%ax

80102b40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b40:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102b46:	85 c9                	test   %ecx,%ecx
80102b48:	0f 8e 8a 00 00 00    	jle    80102bd8 <install_trans+0x98>
{
80102b4e:	55                   	push   %ebp
80102b4f:	89 e5                	mov    %esp,%ebp
80102b51:	57                   	push   %edi
80102b52:	56                   	push   %esi
80102b53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b54:	31 db                	xor    %ebx,%ebx
{
80102b56:	83 ec 0c             	sub    $0xc,%esp
80102b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b60:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102b65:	83 ec 08             	sub    $0x8,%esp
80102b68:	01 d8                	add    %ebx,%eax
80102b6a:	83 c0 01             	add    $0x1,%eax
80102b6d:	50                   	push   %eax
80102b6e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102b74:	e8 57 d5 ff ff       	call   801000d0 <bread>
80102b79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b7b:	58                   	pop    %eax
80102b7c:	5a                   	pop    %edx
80102b7d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102b84:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b8d:	e8 3e d5 ff ff       	call   801000d0 <bread>
80102b92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b97:	83 c4 0c             	add    $0xc,%esp
80102b9a:	68 00 02 00 00       	push   $0x200
80102b9f:	50                   	push   %eax
80102ba0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ba3:	50                   	push   %eax
80102ba4:	e8 f7 1b 00 00       	call   801047a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ba9:	89 34 24             	mov    %esi,(%esp)
80102bac:	e8 ef d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bb1:	89 3c 24             	mov    %edi,(%esp)
80102bb4:	e8 27 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102bb9:	89 34 24             	mov    %esi,(%esp)
80102bbc:	e8 1f d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc1:	83 c4 10             	add    $0x10,%esp
80102bc4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102bca:	7f 94                	jg     80102b60 <install_trans+0x20>
  }
}
80102bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bcf:	5b                   	pop    %ebx
80102bd0:	5e                   	pop    %esi
80102bd1:	5f                   	pop    %edi
80102bd2:	5d                   	pop    %ebp
80102bd3:	c3                   	ret    
80102bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bd8:	f3 c3                	repz ret 
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102be0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	56                   	push   %esi
80102be4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102bee:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102bf9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c09:	7e 16                	jle    80102c21 <write_head+0x41>
80102c0b:	c1 e3 02             	shl    $0x2,%ebx
80102c0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c10:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102c16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c1d:	39 da                	cmp    %ebx,%edx
80102c1f:	75 ef                	jne    80102c10 <write_head+0x30>
  }
  bwrite(buf);
80102c21:	83 ec 0c             	sub    $0xc,%esp
80102c24:	56                   	push   %esi
80102c25:	e8 76 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c2a:	89 34 24             	mov    %esi,(%esp)
80102c2d:	e8 ae d5 ff ff       	call   801001e0 <brelse>
}
80102c32:	83 c4 10             	add    $0x10,%esp
80102c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c38:	5b                   	pop    %ebx
80102c39:	5e                   	pop    %esi
80102c3a:	5d                   	pop    %ebp
80102c3b:	c3                   	ret    
80102c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c40 <initlog>:
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 2c             	sub    $0x2c,%esp
80102c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c4a:	68 a0 7b 10 80       	push   $0x80107ba0
80102c4f:	68 a0 36 11 80       	push   $0x801136a0
80102c54:	e8 97 17 00 00       	call   801043f0 <initlock>
  readsb(dev, &sb);
80102c59:	58                   	pop    %eax
80102c5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c5d:	5a                   	pop    %edx
80102c5e:	50                   	push   %eax
80102c5f:	53                   	push   %ebx
80102c60:	e8 9b e8 ff ff       	call   80101500 <readsb>
  log.size = sb.nlog;
80102c65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c6b:	59                   	pop    %ecx
  log.dev = dev;
80102c6c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102c72:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102c78:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102c7d:	5a                   	pop    %edx
80102c7e:	50                   	push   %eax
80102c7f:	53                   	push   %ebx
80102c80:	e8 4b d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102c85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
80102c8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102c8d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102c93:	7e 1c                	jle    80102cb1 <initlog+0x71>
80102c95:	c1 e3 02             	shl    $0x2,%ebx
80102c98:	31 d2                	xor    %edx,%edx
80102c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ca0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ca4:	83 c2 04             	add    $0x4,%edx
80102ca7:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102cad:	39 d3                	cmp    %edx,%ebx
80102caf:	75 ef                	jne    80102ca0 <initlog+0x60>
  brelse(buf);
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	50                   	push   %eax
80102cb5:	e8 26 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102cba:	e8 81 fe ff ff       	call   80102b40 <install_trans>
  log.lh.n = 0;
80102cbf:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102cc6:	00 00 00 
  write_head(); // clear the log
80102cc9:	e8 12 ff ff ff       	call   80102be0 <write_head>
}
80102cce:	83 c4 10             	add    $0x10,%esp
80102cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd4:	c9                   	leave  
80102cd5:	c3                   	ret    
80102cd6:	8d 76 00             	lea    0x0(%esi),%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ce0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ce6:	68 a0 36 11 80       	push   $0x801136a0
80102ceb:	e8 40 18 00 00       	call   80104530 <acquire>
80102cf0:	83 c4 10             	add    $0x10,%esp
80102cf3:	eb 18                	jmp    80102d0d <begin_op+0x2d>
80102cf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cf8:	83 ec 08             	sub    $0x8,%esp
80102cfb:	68 a0 36 11 80       	push   $0x801136a0
80102d00:	68 a0 36 11 80       	push   $0x801136a0
80102d05:	e8 b6 11 00 00       	call   80103ec0 <sleep>
80102d0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d0d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	75 e2                	jne    80102cf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d16:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d1b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d21:	83 c0 01             	add    $0x1,%eax
80102d24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d2a:	83 fa 1e             	cmp    $0x1e,%edx
80102d2d:	7f c9                	jg     80102cf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d32:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102d37:	68 a0 36 11 80       	push   $0x801136a0
80102d3c:	e8 af 18 00 00       	call   801045f0 <release>
      break;
    }
  }
}
80102d41:	83 c4 10             	add    $0x10,%esp
80102d44:	c9                   	leave  
80102d45:	c3                   	ret    
80102d46:	8d 76 00             	lea    0x0(%esi),%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	57                   	push   %edi
80102d54:	56                   	push   %esi
80102d55:	53                   	push   %ebx
80102d56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d59:	68 a0 36 11 80       	push   $0x801136a0
80102d5e:	e8 cd 17 00 00       	call   80104530 <acquire>
  log.outstanding -= 1;
80102d63:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102d68:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102d6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102d74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102d76:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102d7c:	0f 85 1a 01 00 00    	jne    80102e9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102d82:	85 db                	test   %ebx,%ebx
80102d84:	0f 85 ee 00 00 00    	jne    80102e78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102d8d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102d94:	00 00 00 
  release(&log.lock);
80102d97:	68 a0 36 11 80       	push   $0x801136a0
80102d9c:	e8 4f 18 00 00       	call   801045f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102da1:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102da7:	83 c4 10             	add    $0x10,%esp
80102daa:	85 c9                	test   %ecx,%ecx
80102dac:	0f 8e 85 00 00 00    	jle    80102e37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102db2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102db7:	83 ec 08             	sub    $0x8,%esp
80102dba:	01 d8                	add    %ebx,%eax
80102dbc:	83 c0 01             	add    $0x1,%eax
80102dbf:	50                   	push   %eax
80102dc0:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102dc6:	e8 05 d3 ff ff       	call   801000d0 <bread>
80102dcb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dcd:	58                   	pop    %eax
80102dce:	5a                   	pop    %edx
80102dcf:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102dd6:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ddc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ddf:	e8 ec d2 ff ff       	call   801000d0 <bread>
80102de4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102de6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102de9:	83 c4 0c             	add    $0xc,%esp
80102dec:	68 00 02 00 00       	push   $0x200
80102df1:	50                   	push   %eax
80102df2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102df5:	50                   	push   %eax
80102df6:	e8 a5 19 00 00       	call   801047a0 <memmove>
    bwrite(to);  // write the log
80102dfb:	89 34 24             	mov    %esi,(%esp)
80102dfe:	e8 9d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e03:	89 3c 24             	mov    %edi,(%esp)
80102e06:	e8 d5 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e0b:	89 34 24             	mov    %esi,(%esp)
80102e0e:	e8 cd d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e13:	83 c4 10             	add    $0x10,%esp
80102e16:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102e1c:	7c 94                	jl     80102db2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e1e:	e8 bd fd ff ff       	call   80102be0 <write_head>
    install_trans(); // Now install writes to home locations
80102e23:	e8 18 fd ff ff       	call   80102b40 <install_trans>
    log.lh.n = 0;
80102e28:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102e2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e32:	e8 a9 fd ff ff       	call   80102be0 <write_head>
    acquire(&log.lock);
80102e37:	83 ec 0c             	sub    $0xc,%esp
80102e3a:	68 a0 36 11 80       	push   $0x801136a0
80102e3f:	e8 ec 16 00 00       	call   80104530 <acquire>
    wakeup(&log);
80102e44:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e4b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e52:	00 00 00 
    wakeup(&log);
80102e55:	e8 a6 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e5a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e61:	e8 8a 17 00 00       	call   801045f0 <release>
80102e66:	83 c4 10             	add    $0x10,%esp
}
80102e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e6c:	5b                   	pop    %ebx
80102e6d:	5e                   	pop    %esi
80102e6e:	5f                   	pop    %edi
80102e6f:	5d                   	pop    %ebp
80102e70:	c3                   	ret    
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102e78:	83 ec 0c             	sub    $0xc,%esp
80102e7b:	68 a0 36 11 80       	push   $0x801136a0
80102e80:	e8 7b 12 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102e85:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e8c:	e8 5f 17 00 00       	call   801045f0 <release>
80102e91:	83 c4 10             	add    $0x10,%esp
}
80102e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e97:	5b                   	pop    %ebx
80102e98:	5e                   	pop    %esi
80102e99:	5f                   	pop    %edi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
    panic("log.committing");
80102e9c:	83 ec 0c             	sub    $0xc,%esp
80102e9f:	68 a4 7b 10 80       	push   $0x80107ba4
80102ea4:	e8 e7 d4 ff ff       	call   80100390 <panic>
80102ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102eb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
80102eb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102eb7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ec0:	83 fa 1d             	cmp    $0x1d,%edx
80102ec3:	0f 8f 9d 00 00 00    	jg     80102f66 <log_write+0xb6>
80102ec9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102ece:	83 e8 01             	sub    $0x1,%eax
80102ed1:	39 c2                	cmp    %eax,%edx
80102ed3:	0f 8d 8d 00 00 00    	jge    80102f66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ed9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102ede:	85 c0                	test   %eax,%eax
80102ee0:	0f 8e 8d 00 00 00    	jle    80102f73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ee6:	83 ec 0c             	sub    $0xc,%esp
80102ee9:	68 a0 36 11 80       	push   $0x801136a0
80102eee:	e8 3d 16 00 00       	call   80104530 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102ef9:	83 c4 10             	add    $0x10,%esp
80102efc:	83 f9 00             	cmp    $0x0,%ecx
80102eff:	7e 57                	jle    80102f58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f06:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102f0c:	75 0b                	jne    80102f19 <log_write+0x69>
80102f0e:	eb 38                	jmp    80102f48 <log_write+0x98>
80102f10:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102f17:	74 2f                	je     80102f48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f19:	83 c0 01             	add    $0x1,%eax
80102f1c:	39 c1                	cmp    %eax,%ecx
80102f1e:	75 f0                	jne    80102f10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f20:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f27:	83 c0 01             	add    $0x1,%eax
80102f2a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102f2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f32:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f3c:	c9                   	leave  
  release(&log.lock);
80102f3d:	e9 ae 16 00 00       	jmp    801045f0 <release>
80102f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f48:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102f4f:	eb de                	jmp    80102f2f <log_write+0x7f>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8b 43 08             	mov    0x8(%ebx),%eax
80102f5b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102f60:	75 cd                	jne    80102f2f <log_write+0x7f>
80102f62:	31 c0                	xor    %eax,%eax
80102f64:	eb c1                	jmp    80102f27 <log_write+0x77>
    panic("too big a transaction");
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	68 b3 7b 10 80       	push   $0x80107bb3
80102f6e:	e8 1d d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f73:	83 ec 0c             	sub    $0xc,%esp
80102f76:	68 c9 7b 10 80       	push   $0x80107bc9
80102f7b:	e8 10 d4 ff ff       	call   80100390 <panic>

80102f80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f87:	e8 74 09 00 00       	call   80103900 <cpuid>
80102f8c:	89 c3                	mov    %eax,%ebx
80102f8e:	e8 6d 09 00 00       	call   80103900 <cpuid>
80102f93:	83 ec 04             	sub    $0x4,%esp
80102f96:	53                   	push   %ebx
80102f97:	50                   	push   %eax
80102f98:	68 e4 7b 10 80       	push   $0x80107be4
80102f9d:	e8 6e d7 ff ff       	call   80100710 <cprintf>
  idtinit();       // load idt register
80102fa2:	e8 69 2f 00 00       	call   80105f10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fa7:	e8 d4 08 00 00       	call   80103880 <mycpu>
80102fac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fae:	b8 01 00 00 00       	mov    $0x1,%eax
80102fb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fba:	e8 21 0c 00 00       	call   80103be0 <scheduler>
80102fbf:	90                   	nop

80102fc0 <mpenter>:
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fc6:	e8 35 40 00 00       	call   80107000 <switchkvm>
  seginit();
80102fcb:	e8 a0 3f 00 00       	call   80106f70 <seginit>
  lapicinit();
80102fd0:	e8 9b f7 ff ff       	call   80102770 <lapicinit>
  mpmain();
80102fd5:	e8 a6 ff ff ff       	call   80102f80 <mpmain>
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <main>:
{
80102fe0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fe4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fe7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fea:	55                   	push   %ebp
80102feb:	89 e5                	mov    %esp,%ebp
80102fed:	53                   	push   %ebx
80102fee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fef:	83 ec 08             	sub    $0x8,%esp
80102ff2:	68 00 00 40 80       	push   $0x80400000
80102ff7:	68 e8 64 11 80       	push   $0x801164e8
80102ffc:	e8 2f f5 ff ff       	call   80102530 <kinit1>
  kvmalloc();      // kernel page table
80103001:	e8 ca 44 00 00       	call   801074d0 <kvmalloc>
  mpinit();        // detect other processors
80103006:	e8 75 01 00 00       	call   80103180 <mpinit>
  lapicinit();     // interrupt controller
8010300b:	e8 60 f7 ff ff       	call   80102770 <lapicinit>
  seginit();       // segment descriptors
80103010:	e8 5b 3f 00 00       	call   80106f70 <seginit>
  picinit();       // disable pic
80103015:	e8 46 03 00 00       	call   80103360 <picinit>
  ioapicinit();    // another interrupt controller
8010301a:	e8 41 f3 ff ff       	call   80102360 <ioapicinit>
  consoleinit();   // console hardware
8010301f:	e8 cc da ff ff       	call   80100af0 <consoleinit>
  uartinit();      // serial port
80103024:	e8 17 32 00 00       	call   80106240 <uartinit>
  pinit();         // process table
80103029:	e8 32 08 00 00       	call   80103860 <pinit>
  tvinit();        // trap vectors
8010302e:	e8 5d 2e 00 00       	call   80105e90 <tvinit>
  binit();         // buffer cache
80103033:	e8 08 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103038:	e8 53 de ff ff       	call   80100e90 <fileinit>
  ideinit();       // disk 
8010303d:	e8 fe f0 ff ff       	call   80102140 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103042:	83 c4 0c             	add    $0xc,%esp
80103045:	68 8a 00 00 00       	push   $0x8a
8010304a:	68 8c b4 10 80       	push   $0x8010b48c
8010304f:	68 00 70 00 80       	push   $0x80007000
80103054:	e8 47 17 00 00       	call   801047a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103059:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103060:	00 00 00 
80103063:	83 c4 10             	add    $0x10,%esp
80103066:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010306b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103070:	76 71                	jbe    801030e3 <main+0x103>
80103072:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80103077:	89 f6                	mov    %esi,%esi
80103079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103080:	e8 fb 07 00 00       	call   80103880 <mycpu>
80103085:	39 d8                	cmp    %ebx,%eax
80103087:	74 41                	je     801030ca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103089:	e8 72 f5 ff ff       	call   80102600 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010308e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103093:	c7 05 f8 6f 00 80 c0 	movl   $0x80102fc0,0x80006ff8
8010309a:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010309d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801030a4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030a7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801030ac:	0f b6 03             	movzbl (%ebx),%eax
801030af:	83 ec 08             	sub    $0x8,%esp
801030b2:	68 00 70 00 00       	push   $0x7000
801030b7:	50                   	push   %eax
801030b8:	e8 03 f8 ff ff       	call   801028c0 <lapicstartap>
801030bd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030c6:	85 c0                	test   %eax,%eax
801030c8:	74 f6                	je     801030c0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801030ca:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801030d1:	00 00 00 
801030d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030da:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030df:	39 c3                	cmp    %eax,%ebx
801030e1:	72 9d                	jb     80103080 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030e3:	83 ec 08             	sub    $0x8,%esp
801030e6:	68 00 00 00 8e       	push   $0x8e000000
801030eb:	68 00 00 40 80       	push   $0x80400000
801030f0:	e8 ab f4 ff ff       	call   801025a0 <kinit2>
  userinit();      // first user process
801030f5:	e8 56 08 00 00       	call   80103950 <userinit>
  mpmain();        // finish this processor's setup
801030fa:	e8 81 fe ff ff       	call   80102f80 <mpmain>
801030ff:	90                   	nop

80103100 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	57                   	push   %edi
80103104:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103105:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010310b:	53                   	push   %ebx
  e = addr+len;
8010310c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010310f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103112:	39 de                	cmp    %ebx,%esi
80103114:	72 10                	jb     80103126 <mpsearch1+0x26>
80103116:	eb 50                	jmp    80103168 <mpsearch1+0x68>
80103118:	90                   	nop
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103120:	39 fb                	cmp    %edi,%ebx
80103122:	89 fe                	mov    %edi,%esi
80103124:	76 42                	jbe    80103168 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103126:	83 ec 04             	sub    $0x4,%esp
80103129:	8d 7e 10             	lea    0x10(%esi),%edi
8010312c:	6a 04                	push   $0x4
8010312e:	68 f8 7b 10 80       	push   $0x80107bf8
80103133:	56                   	push   %esi
80103134:	e8 07 16 00 00       	call   80104740 <memcmp>
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	85 c0                	test   %eax,%eax
8010313e:	75 e0                	jne    80103120 <mpsearch1+0x20>
80103140:	89 f1                	mov    %esi,%ecx
80103142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103148:	0f b6 11             	movzbl (%ecx),%edx
8010314b:	83 c1 01             	add    $0x1,%ecx
8010314e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103150:	39 f9                	cmp    %edi,%ecx
80103152:	75 f4                	jne    80103148 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103154:	84 c0                	test   %al,%al
80103156:	75 c8                	jne    80103120 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010315b:	89 f0                	mov    %esi,%eax
8010315d:	5b                   	pop    %ebx
8010315e:	5e                   	pop    %esi
8010315f:	5f                   	pop    %edi
80103160:	5d                   	pop    %ebp
80103161:	c3                   	ret    
80103162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103168:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010316b:	31 f6                	xor    %esi,%esi
}
8010316d:	89 f0                	mov    %esi,%eax
8010316f:	5b                   	pop    %ebx
80103170:	5e                   	pop    %esi
80103171:	5f                   	pop    %edi
80103172:	5d                   	pop    %ebp
80103173:	c3                   	ret    
80103174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010317a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103180 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103189:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103190:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103197:	c1 e0 08             	shl    $0x8,%eax
8010319a:	09 d0                	or     %edx,%eax
8010319c:	c1 e0 04             	shl    $0x4,%eax
8010319f:	85 c0                	test   %eax,%eax
801031a1:	75 1b                	jne    801031be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031b1:	c1 e0 08             	shl    $0x8,%eax
801031b4:	09 d0                	or     %edx,%eax
801031b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031be:	ba 00 04 00 00       	mov    $0x400,%edx
801031c3:	e8 38 ff ff ff       	call   80103100 <mpsearch1>
801031c8:	85 c0                	test   %eax,%eax
801031ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031cd:	0f 84 3d 01 00 00    	je     80103310 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031d6:	8b 58 04             	mov    0x4(%eax),%ebx
801031d9:	85 db                	test   %ebx,%ebx
801031db:	0f 84 4f 01 00 00    	je     80103330 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801031e7:	83 ec 04             	sub    $0x4,%esp
801031ea:	6a 04                	push   $0x4
801031ec:	68 15 7c 10 80       	push   $0x80107c15
801031f1:	56                   	push   %esi
801031f2:	e8 49 15 00 00       	call   80104740 <memcmp>
801031f7:	83 c4 10             	add    $0x10,%esp
801031fa:	85 c0                	test   %eax,%eax
801031fc:	0f 85 2e 01 00 00    	jne    80103330 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103202:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103209:	3c 01                	cmp    $0x1,%al
8010320b:	0f 95 c2             	setne  %dl
8010320e:	3c 04                	cmp    $0x4,%al
80103210:	0f 95 c0             	setne  %al
80103213:	20 c2                	and    %al,%dl
80103215:	0f 85 15 01 00 00    	jne    80103330 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010321b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103222:	66 85 ff             	test   %di,%di
80103225:	74 1a                	je     80103241 <mpinit+0xc1>
80103227:	89 f0                	mov    %esi,%eax
80103229:	01 f7                	add    %esi,%edi
  sum = 0;
8010322b:	31 d2                	xor    %edx,%edx
8010322d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103230:	0f b6 08             	movzbl (%eax),%ecx
80103233:	83 c0 01             	add    $0x1,%eax
80103236:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103238:	39 c7                	cmp    %eax,%edi
8010323a:	75 f4                	jne    80103230 <mpinit+0xb0>
8010323c:	84 d2                	test   %dl,%dl
8010323e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103241:	85 f6                	test   %esi,%esi
80103243:	0f 84 e7 00 00 00    	je     80103330 <mpinit+0x1b0>
80103249:	84 d2                	test   %dl,%dl
8010324b:	0f 85 df 00 00 00    	jne    80103330 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103251:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103257:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010325c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103263:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103269:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010326e:	01 d6                	add    %edx,%esi
80103270:	39 c6                	cmp    %eax,%esi
80103272:	76 23                	jbe    80103297 <mpinit+0x117>
    switch(*p){
80103274:	0f b6 10             	movzbl (%eax),%edx
80103277:	80 fa 04             	cmp    $0x4,%dl
8010327a:	0f 87 ca 00 00 00    	ja     8010334a <mpinit+0x1ca>
80103280:	ff 24 95 3c 7c 10 80 	jmp    *-0x7fef83c4(,%edx,4)
80103287:	89 f6                	mov    %esi,%esi
80103289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103290:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103293:	39 c6                	cmp    %eax,%esi
80103295:	77 dd                	ja     80103274 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103297:	85 db                	test   %ebx,%ebx
80103299:	0f 84 9e 00 00 00    	je     8010333d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010329f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801032a6:	74 15                	je     801032bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a8:	b8 70 00 00 00       	mov    $0x70,%eax
801032ad:	ba 22 00 00 00       	mov    $0x22,%edx
801032b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b3:	ba 23 00 00 00       	mov    $0x23,%edx
801032b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032bc:	ee                   	out    %al,(%dx)
  }
}
801032bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032c0:	5b                   	pop    %ebx
801032c1:	5e                   	pop    %esi
801032c2:	5f                   	pop    %edi
801032c3:	5d                   	pop    %ebp
801032c4:	c3                   	ret    
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801032c8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801032ce:	83 f9 07             	cmp    $0x7,%ecx
801032d1:	7f 19                	jg     801032ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801032dd:	83 c1 01             	add    $0x1,%ecx
801032e0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032e6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801032ec:	83 c0 14             	add    $0x14,%eax
      continue;
801032ef:	e9 7c ff ff ff       	jmp    80103270 <mpinit+0xf0>
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801032f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032ff:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
80103305:	e9 66 ff ff ff       	jmp    80103270 <mpinit+0xf0>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103310:	ba 00 00 01 00       	mov    $0x10000,%edx
80103315:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010331a:	e8 e1 fd ff ff       	call   80103100 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010331f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103321:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103324:	0f 85 a9 fe ff ff    	jne    801031d3 <mpinit+0x53>
8010332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103330:	83 ec 0c             	sub    $0xc,%esp
80103333:	68 fd 7b 10 80       	push   $0x80107bfd
80103338:	e8 53 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010333d:	83 ec 0c             	sub    $0xc,%esp
80103340:	68 1c 7c 10 80       	push   $0x80107c1c
80103345:	e8 46 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
8010334a:	31 db                	xor    %ebx,%ebx
8010334c:	e9 26 ff ff ff       	jmp    80103277 <mpinit+0xf7>
80103351:	66 90                	xchg   %ax,%ax
80103353:	66 90                	xchg   %ax,%ax
80103355:	66 90                	xchg   %ax,%ax
80103357:	66 90                	xchg   %ax,%ax
80103359:	66 90                	xchg   %ax,%ax
8010335b:	66 90                	xchg   %ax,%ax
8010335d:	66 90                	xchg   %ax,%ax
8010335f:	90                   	nop

80103360 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103360:	55                   	push   %ebp
80103361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103366:	ba 21 00 00 00       	mov    $0x21,%edx
8010336b:	89 e5                	mov    %esp,%ebp
8010336d:	ee                   	out    %al,(%dx)
8010336e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103373:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103374:	5d                   	pop    %ebp
80103375:	c3                   	ret    
80103376:	66 90                	xchg   %ax,%ax
80103378:	66 90                	xchg   %ax,%ax
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010338c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010338f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103395:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010339b:	e8 10 db ff ff       	call   80100eb0 <filealloc>
801033a0:	85 c0                	test   %eax,%eax
801033a2:	89 03                	mov    %eax,(%ebx)
801033a4:	74 22                	je     801033c8 <pipealloc+0x48>
801033a6:	e8 05 db ff ff       	call   80100eb0 <filealloc>
801033ab:	85 c0                	test   %eax,%eax
801033ad:	89 06                	mov    %eax,(%esi)
801033af:	74 3f                	je     801033f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033b1:	e8 4a f2 ff ff       	call   80102600 <kalloc>
801033b6:	85 c0                	test   %eax,%eax
801033b8:	89 c7                	mov    %eax,%edi
801033ba:	75 54                	jne    80103410 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033bc:	8b 03                	mov    (%ebx),%eax
801033be:	85 c0                	test   %eax,%eax
801033c0:	75 34                	jne    801033f6 <pipealloc+0x76>
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801033c8:	8b 06                	mov    (%esi),%eax
801033ca:	85 c0                	test   %eax,%eax
801033cc:	74 0c                	je     801033da <pipealloc+0x5a>
    fileclose(*f1);
801033ce:	83 ec 0c             	sub    $0xc,%esp
801033d1:	50                   	push   %eax
801033d2:	e8 99 db ff ff       	call   80100f70 <fileclose>
801033d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801033da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801033dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5f                   	pop    %edi
801033e5:	5d                   	pop    %ebp
801033e6:	c3                   	ret    
801033e7:	89 f6                	mov    %esi,%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801033f0:	8b 03                	mov    (%ebx),%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	74 e4                	je     801033da <pipealloc+0x5a>
    fileclose(*f0);
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	50                   	push   %eax
801033fa:	e8 71 db ff ff       	call   80100f70 <fileclose>
  if(*f1)
801033ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103401:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103404:	85 c0                	test   %eax,%eax
80103406:	75 c6                	jne    801033ce <pipealloc+0x4e>
80103408:	eb d0                	jmp    801033da <pipealloc+0x5a>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103410:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103413:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010341a:	00 00 00 
  p->writeopen = 1;
8010341d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103424:	00 00 00 
  p->nwrite = 0;
80103427:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010342e:	00 00 00 
  p->nread = 0;
80103431:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103438:	00 00 00 
  initlock(&p->lock, "pipe");
8010343b:	68 50 7c 10 80       	push   $0x80107c50
80103440:	50                   	push   %eax
80103441:	e8 aa 0f 00 00       	call   801043f0 <initlock>
  (*f0)->type = FD_PIPE;
80103446:	8b 03                	mov    (%ebx),%eax
  return 0;
80103448:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010344b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103451:	8b 03                	mov    (%ebx),%eax
80103453:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103457:	8b 03                	mov    (%ebx),%eax
80103459:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010345d:	8b 03                	mov    (%ebx),%eax
8010345f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103462:	8b 06                	mov    (%esi),%eax
80103464:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010346a:	8b 06                	mov    (%esi),%eax
8010346c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103470:	8b 06                	mov    (%esi),%eax
80103472:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103476:	8b 06                	mov    (%esi),%eax
80103478:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010347b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010347e:	31 c0                	xor    %eax,%eax
}
80103480:	5b                   	pop    %ebx
80103481:	5e                   	pop    %esi
80103482:	5f                   	pop    %edi
80103483:	5d                   	pop    %ebp
80103484:	c3                   	ret    
80103485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103490 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	56                   	push   %esi
80103494:	53                   	push   %ebx
80103495:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103498:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	53                   	push   %ebx
8010349f:	e8 8c 10 00 00       	call   80104530 <acquire>
  if(writable){
801034a4:	83 c4 10             	add    $0x10,%esp
801034a7:	85 f6                	test   %esi,%esi
801034a9:	74 45                	je     801034f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801034b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034bb:	00 00 00 
    wakeup(&p->nread);
801034be:	50                   	push   %eax
801034bf:	e8 3c 0c 00 00       	call   80104100 <wakeup>
801034c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034cd:	85 d2                	test   %edx,%edx
801034cf:	75 0a                	jne    801034db <pipeclose+0x4b>
801034d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034d7:	85 c0                	test   %eax,%eax
801034d9:	74 35                	je     80103510 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034e1:	5b                   	pop    %ebx
801034e2:	5e                   	pop    %esi
801034e3:	5d                   	pop    %ebp
    release(&p->lock);
801034e4:	e9 07 11 00 00       	jmp    801045f0 <release>
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801034f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801034f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103500:	00 00 00 
    wakeup(&p->nwrite);
80103503:	50                   	push   %eax
80103504:	e8 f7 0b 00 00       	call   80104100 <wakeup>
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	eb b9                	jmp    801034c7 <pipeclose+0x37>
8010350e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103510:	83 ec 0c             	sub    $0xc,%esp
80103513:	53                   	push   %ebx
80103514:	e8 d7 10 00 00       	call   801045f0 <release>
    kfree((char*)p);
80103519:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010351c:	83 c4 10             	add    $0x10,%esp
}
8010351f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103522:	5b                   	pop    %ebx
80103523:	5e                   	pop    %esi
80103524:	5d                   	pop    %ebp
    kfree((char*)p);
80103525:	e9 26 ef ff ff       	jmp    80102450 <kfree>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103530 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 28             	sub    $0x28,%esp
80103539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010353c:	53                   	push   %ebx
8010353d:	e8 ee 0f 00 00       	call   80104530 <acquire>
  for(i = 0; i < n; i++){
80103542:	8b 45 10             	mov    0x10(%ebp),%eax
80103545:	83 c4 10             	add    $0x10,%esp
80103548:	85 c0                	test   %eax,%eax
8010354a:	0f 8e c9 00 00 00    	jle    80103619 <pipewrite+0xe9>
80103550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103553:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103559:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010355f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103562:	03 4d 10             	add    0x10(%ebp),%ecx
80103565:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103568:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010356e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103574:	39 d0                	cmp    %edx,%eax
80103576:	75 71                	jne    801035e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103578:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010357e:	85 c0                	test   %eax,%eax
80103580:	74 4e                	je     801035d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103582:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103588:	eb 3a                	jmp    801035c4 <pipewrite+0x94>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	57                   	push   %edi
80103594:	e8 67 0b 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103599:	5a                   	pop    %edx
8010359a:	59                   	pop    %ecx
8010359b:	53                   	push   %ebx
8010359c:	56                   	push   %esi
8010359d:	e8 1e 09 00 00       	call   80103ec0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035ae:	83 c4 10             	add    $0x10,%esp
801035b1:	05 00 02 00 00       	add    $0x200,%eax
801035b6:	39 c2                	cmp    %eax,%edx
801035b8:	75 36                	jne    801035f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801035ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035c0:	85 c0                	test   %eax,%eax
801035c2:	74 0c                	je     801035d0 <pipewrite+0xa0>
801035c4:	e8 57 03 00 00       	call   80103920 <myproc>
801035c9:	8b 40 24             	mov    0x24(%eax),%eax
801035cc:	85 c0                	test   %eax,%eax
801035ce:	74 c0                	je     80103590 <pipewrite+0x60>
        release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 17 10 00 00       	call   801045f0 <release>
        return -1;
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e4:	5b                   	pop    %ebx
801035e5:	5e                   	pop    %esi
801035e6:	5f                   	pop    %edi
801035e7:	5d                   	pop    %ebp
801035e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e9:	89 c2                	mov    %eax,%edx
801035eb:	90                   	nop
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035f3:	8d 42 01             	lea    0x1(%edx),%eax
801035f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103602:	83 c6 01             	add    $0x1,%esi
80103605:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103609:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010360c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010360f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103613:	0f 85 4f ff ff ff    	jne    80103568 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103619:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010361f:	83 ec 0c             	sub    $0xc,%esp
80103622:	50                   	push   %eax
80103623:	e8 d8 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
80103628:	89 1c 24             	mov    %ebx,(%esp)
8010362b:	e8 c0 0f 00 00       	call   801045f0 <release>
  return n;
80103630:	83 c4 10             	add    $0x10,%esp
80103633:	8b 45 10             	mov    0x10(%ebp),%eax
80103636:	eb a9                	jmp    801035e1 <pipewrite+0xb1>
80103638:	90                   	nop
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103640 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 18             	sub    $0x18,%esp
80103649:	8b 75 08             	mov    0x8(%ebp),%esi
8010364c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010364f:	56                   	push   %esi
80103650:	e8 db 0e 00 00       	call   80104530 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010365e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103664:	75 6a                	jne    801036d0 <piperead+0x90>
80103666:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010366c:	85 db                	test   %ebx,%ebx
8010366e:	0f 84 c4 00 00 00    	je     80103738 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103674:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010367a:	eb 2d                	jmp    801036a9 <piperead+0x69>
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103680:	83 ec 08             	sub    $0x8,%esp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	e8 36 08 00 00       	call   80103ec0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010368a:	83 c4 10             	add    $0x10,%esp
8010368d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103693:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103699:	75 35                	jne    801036d0 <piperead+0x90>
8010369b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801036a1:	85 d2                	test   %edx,%edx
801036a3:	0f 84 8f 00 00 00    	je     80103738 <piperead+0xf8>
    if(myproc()->killed){
801036a9:	e8 72 02 00 00       	call   80103920 <myproc>
801036ae:	8b 48 24             	mov    0x24(%eax),%ecx
801036b1:	85 c9                	test   %ecx,%ecx
801036b3:	74 cb                	je     80103680 <piperead+0x40>
      release(&p->lock);
801036b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801036b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801036bd:	56                   	push   %esi
801036be:	e8 2d 0f 00 00       	call   801045f0 <release>
      return -1;
801036c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c9:	89 d8                	mov    %ebx,%eax
801036cb:	5b                   	pop    %ebx
801036cc:	5e                   	pop    %esi
801036cd:	5f                   	pop    %edi
801036ce:	5d                   	pop    %ebp
801036cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036d0:	8b 45 10             	mov    0x10(%ebp),%eax
801036d3:	85 c0                	test   %eax,%eax
801036d5:	7e 61                	jle    80103738 <piperead+0xf8>
    if(p->nread == p->nwrite)
801036d7:	31 db                	xor    %ebx,%ebx
801036d9:	eb 13                	jmp    801036ee <piperead+0xae>
801036db:	90                   	nop
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036ec:	74 1f                	je     8010370d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036ee:	8d 41 01             	lea    0x1(%ecx),%eax
801036f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103702:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103705:	83 c3 01             	add    $0x1,%ebx
80103708:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010370b:	75 d3                	jne    801036e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010370d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103713:	83 ec 0c             	sub    $0xc,%esp
80103716:	50                   	push   %eax
80103717:	e8 e4 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010371c:	89 34 24             	mov    %esi,(%esp)
8010371f:	e8 cc 0e 00 00       	call   801045f0 <release>
  return i;
80103724:	83 c4 10             	add    $0x10,%esp
}
80103727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010372a:	89 d8                	mov    %ebx,%eax
8010372c:	5b                   	pop    %ebx
8010372d:	5e                   	pop    %esi
8010372e:	5f                   	pop    %edi
8010372f:	5d                   	pop    %ebp
80103730:	c3                   	ret    
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	eb d1                	jmp    8010370d <piperead+0xcd>
8010373c:	66 90                	xchg   %ax,%ax
8010373e:	66 90                	xchg   %ax,%ax

80103740 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103744:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103749:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010374c:	68 40 3d 11 80       	push   $0x80113d40
80103751:	e8 da 0d 00 00       	call   80104530 <acquire>
80103756:	83 c4 10             	add    $0x10,%esp
80103759:	eb 10                	jmp    8010376b <allocproc+0x2b>
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103760:	83 c3 7c             	add    $0x7c,%ebx
80103763:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80103769:	73 75                	jae    801037e0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010376b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010376e:	85 c0                	test   %eax,%eax
80103770:	75 ee                	jne    80103760 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103772:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103777:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010377a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103781:	8d 50 01             	lea    0x1(%eax),%edx
80103784:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103787:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
8010378c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103792:	e8 59 0e 00 00       	call   801045f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103797:	e8 64 ee ff ff       	call   80102600 <kalloc>
8010379c:	83 c4 10             	add    $0x10,%esp
8010379f:	85 c0                	test   %eax,%eax
801037a1:	89 43 08             	mov    %eax,0x8(%ebx)
801037a4:	74 53                	je     801037f9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037a6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ac:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037af:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037b4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037b7:	c7 40 14 77 5e 10 80 	movl   $0x80105e77,0x14(%eax)
  p->context = (struct context*)sp;
801037be:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037c1:	6a 14                	push   $0x14
801037c3:	6a 00                	push   $0x0
801037c5:	50                   	push   %eax
801037c6:	e8 25 0f 00 00       	call   801046f0 <memset>
  p->context->eip = (uint)forkret;
801037cb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037ce:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037d1:	c7 40 10 10 38 10 80 	movl   $0x80103810,0x10(%eax)
}
801037d8:	89 d8                	mov    %ebx,%eax
801037da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037dd:	c9                   	leave  
801037de:	c3                   	ret    
801037df:	90                   	nop
  release(&ptable.lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037e5:	68 40 3d 11 80       	push   $0x80113d40
801037ea:	e8 01 0e 00 00       	call   801045f0 <release>
}
801037ef:	89 d8                	mov    %ebx,%eax
  return 0;
801037f1:	83 c4 10             	add    $0x10,%esp
}
801037f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    
    p->state = UNUSED;
801037f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103800:	31 db                	xor    %ebx,%ebx
80103802:	eb d4                	jmp    801037d8 <allocproc+0x98>
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103816:	68 40 3d 11 80       	push   $0x80113d40
8010381b:	e8 d0 0d 00 00       	call   801045f0 <release>

  if (first) {
80103820:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	85 c0                	test   %eax,%eax
8010382a:	75 04                	jne    80103830 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010382c:	c9                   	leave  
8010382d:	c3                   	ret    
8010382e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103830:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103833:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010383a:	00 00 00 
    iinit(ROOTDEV);
8010383d:	6a 01                	push   $0x1
8010383f:	e8 7c dd ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010384b:	e8 f0 f3 ff ff       	call   80102c40 <initlog>
80103850:	83 c4 10             	add    $0x10,%esp
}
80103853:	c9                   	leave  
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <pinit>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103866:	68 55 7c 10 80       	push   $0x80107c55
8010386b:	68 40 3d 11 80       	push   $0x80113d40
80103870:	e8 7b 0b 00 00       	call   801043f0 <initlock>
}
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	c9                   	leave  
80103879:	c3                   	ret    
8010387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103880 <mycpu>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103885:	9c                   	pushf  
80103886:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103887:	f6 c4 02             	test   $0x2,%ah
8010388a:	75 5e                	jne    801038ea <mycpu+0x6a>
  apicid = lapicid();
8010388c:	e8 df ef ff ff       	call   80102870 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103891:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103897:	85 f6                	test   %esi,%esi
80103899:	7e 42                	jle    801038dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010389b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
801038a2:	39 d0                	cmp    %edx,%eax
801038a4:	74 30                	je     801038d6 <mycpu+0x56>
801038a6:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
801038ab:	31 d2                	xor    %edx,%edx
801038ad:	8d 76 00             	lea    0x0(%esi),%esi
801038b0:	83 c2 01             	add    $0x1,%edx
801038b3:	39 f2                	cmp    %esi,%edx
801038b5:	74 26                	je     801038dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038b7:	0f b6 19             	movzbl (%ecx),%ebx
801038ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038c0:	39 c3                	cmp    %eax,%ebx
801038c2:	75 ec                	jne    801038b0 <mycpu+0x30>
801038c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038ca:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
801038cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d2:	5b                   	pop    %ebx
801038d3:	5e                   	pop    %esi
801038d4:	5d                   	pop    %ebp
801038d5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038d6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
801038db:	eb f2                	jmp    801038cf <mycpu+0x4f>
  panic("unknown apicid\n");
801038dd:	83 ec 0c             	sub    $0xc,%esp
801038e0:	68 5c 7c 10 80       	push   $0x80107c5c
801038e5:	e8 a6 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	68 38 7d 10 80       	push   $0x80107d38
801038f2:	e8 99 ca ff ff       	call   80100390 <panic>
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103900 <cpuid>:
cpuid() {
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103906:	e8 75 ff ff ff       	call   80103880 <mycpu>
8010390b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103910:	c9                   	leave  
  return mycpu()-cpus;
80103911:	c1 f8 04             	sar    $0x4,%eax
80103914:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010391a:	c3                   	ret    
8010391b:	90                   	nop
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <myproc>:
myproc(void) {
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103927:	e8 34 0b 00 00       	call   80104460 <pushcli>
  c = mycpu();
8010392c:	e8 4f ff ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103931:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103937:	e8 64 0b 00 00       	call   801044a0 <popcli>
}
8010393c:	83 c4 04             	add    $0x4,%esp
8010393f:	89 d8                	mov    %ebx,%eax
80103941:	5b                   	pop    %ebx
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <userinit>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	53                   	push   %ebx
80103954:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103957:	e8 e4 fd ff ff       	call   80103740 <allocproc>
8010395c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010395e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103963:	e8 e8 3a 00 00       	call   80107450 <setupkvm>
80103968:	85 c0                	test   %eax,%eax
8010396a:	89 43 04             	mov    %eax,0x4(%ebx)
8010396d:	0f 84 bd 00 00 00    	je     80103a30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103973:	83 ec 04             	sub    $0x4,%esp
80103976:	68 2c 00 00 00       	push   $0x2c
8010397b:	68 60 b4 10 80       	push   $0x8010b460
80103980:	50                   	push   %eax
80103981:	e8 aa 37 00 00       	call   80107130 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103986:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103989:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010398f:	6a 4c                	push   $0x4c
80103991:	6a 00                	push   $0x0
80103993:	ff 73 18             	pushl  0x18(%ebx)
80103996:	e8 55 0d 00 00       	call   801046f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399b:	8b 43 18             	mov    0x18(%ebx),%eax
8010399e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039a3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039a8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039af:	8b 43 18             	mov    0x18(%ebx),%eax
801039b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039b6:	8b 43 18             	mov    0x18(%ebx),%eax
801039b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039bd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039c1:	8b 43 18             	mov    0x18(%ebx),%eax
801039c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039c8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039cc:	8b 43 18             	mov    0x18(%ebx),%eax
801039cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039d6:	8b 43 18             	mov    0x18(%ebx),%eax
801039d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039e0:	8b 43 18             	mov    0x18(%ebx),%eax
801039e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ea:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039ed:	6a 10                	push   $0x10
801039ef:	68 85 7c 10 80       	push   $0x80107c85
801039f4:	50                   	push   %eax
801039f5:	e8 d6 0e 00 00       	call   801048d0 <safestrcpy>
  p->cwd = namei("/");
801039fa:	c7 04 24 8e 7c 10 80 	movl   $0x80107c8e,(%esp)
80103a01:	e8 1a e6 ff ff       	call   80102020 <namei>
80103a06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a09:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103a10:	e8 1b 0b 00 00       	call   80104530 <acquire>
  p->state = RUNNABLE;
80103a15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a1c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103a23:	e8 c8 0b 00 00       	call   801045f0 <release>
}
80103a28:	83 c4 10             	add    $0x10,%esp
80103a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2e:	c9                   	leave  
80103a2f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	68 6c 7c 10 80       	push   $0x80107c6c
80103a38:	e8 53 c9 ff ff       	call   80100390 <panic>
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi

80103a40 <growproc>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
80103a45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a48:	e8 13 0a 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103a4d:	e8 2e fe ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103a52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a58:	e8 43 0a 00 00       	call   801044a0 <popcli>
  if(n > 0){
80103a5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a62:	7f 1c                	jg     80103a80 <growproc+0x40>
  } else if(n < 0){
80103a64:	75 3a                	jne    80103aa0 <growproc+0x60>
  switchuvm(curproc);
80103a66:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a69:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a6b:	53                   	push   %ebx
80103a6c:	e8 af 35 00 00       	call   80107020 <switchuvm>
  return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
80103a74:	31 c0                	xor    %eax,%eax
}
80103a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a79:	5b                   	pop    %ebx
80103a7a:	5e                   	pop    %esi
80103a7b:	5d                   	pop    %ebp
80103a7c:	c3                   	ret    
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 e1 37 00 00       	call   80107270 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d0                	jne    80103a66 <growproc+0x26>
      return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb d9                	jmp    80103a76 <growproc+0x36>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 f1 38 00 00       	call   801073a0 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b0                	jne    80103a66 <growproc+0x26>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x56>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <fork>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ac9:	e8 92 09 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103ace:	e8 ad fd ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103ad3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad9:	e8 c2 09 00 00       	call   801044a0 <popcli>
  if((np = allocproc()) == 0){
80103ade:	e8 5d fc ff ff       	call   80103740 <allocproc>
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ae8:	0f 84 b7 00 00 00    	je     80103ba5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aee:	83 ec 08             	sub    $0x8,%esp
80103af1:	ff 33                	pushl  (%ebx)
80103af3:	ff 73 04             	pushl  0x4(%ebx)
80103af6:	89 c7                	mov    %eax,%edi
80103af8:	e8 23 3a 00 00       	call   80107520 <copyuvm>
80103afd:	83 c4 10             	add    $0x10,%esp
80103b00:	85 c0                	test   %eax,%eax
80103b02:	89 47 04             	mov    %eax,0x4(%edi)
80103b05:	0f 84 a1 00 00 00    	je     80103bac <fork+0xec>
  np->sz = curproc->sz;
80103b0b:	8b 03                	mov    (%ebx),%eax
80103b0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b10:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b12:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b15:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b17:	8b 79 18             	mov    0x18(%ecx),%edi
80103b1a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b1d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b26:	8b 40 18             	mov    0x18(%eax),%eax
80103b29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b34:	85 c0                	test   %eax,%eax
80103b36:	74 13                	je     80103b4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b38:	83 ec 0c             	sub    $0xc,%esp
80103b3b:	50                   	push   %eax
80103b3c:	e8 df d3 ff ff       	call   80100f20 <filedup>
80103b41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b44:	83 c4 10             	add    $0x10,%esp
80103b47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b4b:	83 c6 01             	add    $0x1,%esi
80103b4e:	83 fe 10             	cmp    $0x10,%esi
80103b51:	75 dd                	jne    80103b30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b53:	83 ec 0c             	sub    $0xc,%esp
80103b56:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b5c:	e8 2f dc ff ff       	call   80101790 <idup>
80103b61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b6d:	6a 10                	push   $0x10
80103b6f:	53                   	push   %ebx
80103b70:	50                   	push   %eax
80103b71:	e8 5a 0d 00 00       	call   801048d0 <safestrcpy>
  pid = np->pid;
80103b76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b79:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103b80:	e8 ab 09 00 00       	call   80104530 <acquire>
  np->state = RUNNABLE;
80103b85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b8c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103b93:	e8 58 0a 00 00       	call   801045f0 <release>
  return pid;
80103b98:	83 c4 10             	add    $0x10,%esp
}
80103b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b9e:	89 d8                	mov    %ebx,%eax
80103ba0:	5b                   	pop    %ebx
80103ba1:	5e                   	pop    %esi
80103ba2:	5f                   	pop    %edi
80103ba3:	5d                   	pop    %ebp
80103ba4:	c3                   	ret    
    return -1;
80103ba5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103baa:	eb ef                	jmp    80103b9b <fork+0xdb>
    kfree(np->kstack);
80103bac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103baf:	83 ec 0c             	sub    $0xc,%esp
80103bb2:	ff 73 08             	pushl  0x8(%ebx)
80103bb5:	e8 96 e8 ff ff       	call   80102450 <kfree>
    np->kstack = 0;
80103bba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103bc1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bd0:	eb c9                	jmp    80103b9b <fork+0xdb>
80103bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <scheduler>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103be9:	e8 92 fc ff ff       	call   80103880 <mycpu>
80103bee:	8d 78 04             	lea    0x4(%eax),%edi
80103bf1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103bf3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bfa:	00 00 00 
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c00:	fb                   	sti    
    acquire(&ptable.lock);
80103c01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c04:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80103c09:	68 40 3d 11 80       	push   $0x80113d40
80103c0e:	e8 1d 09 00 00       	call   80104530 <acquire>
80103c13:	83 c4 10             	add    $0x10,%esp
80103c16:	8d 76 00             	lea    0x0(%esi),%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c24:	75 33                	jne    80103c59 <scheduler+0x79>
      switchuvm(p);
80103c26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c2f:	53                   	push   %ebx
80103c30:	e8 eb 33 00 00       	call   80107020 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c35:	58                   	pop    %eax
80103c36:	5a                   	pop    %edx
80103c37:	ff 73 1c             	pushl  0x1c(%ebx)
80103c3a:	57                   	push   %edi
      p->state = RUNNING;
80103c3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c42:	e8 e4 0c 00 00       	call   8010492b <swtch>
      switchkvm();
80103c47:	e8 b4 33 00 00       	call   80107000 <switchkvm>
      c->proc = 0;
80103c4c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c53:	00 00 00 
80103c56:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c59:	83 c3 7c             	add    $0x7c,%ebx
80103c5c:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80103c62:	72 bc                	jb     80103c20 <scheduler+0x40>
    release(&ptable.lock);
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	68 40 3d 11 80       	push   $0x80113d40
80103c6c:	e8 7f 09 00 00       	call   801045f0 <release>
    sti();
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	eb 8a                	jmp    80103c00 <scheduler+0x20>
80103c76:	8d 76 00             	lea    0x0(%esi),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <sched>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
  pushcli();
80103c85:	e8 d6 07 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103c8a:	e8 f1 fb ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103c8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c95:	e8 06 08 00 00       	call   801044a0 <popcli>
  if(!holding(&ptable.lock))
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	68 40 3d 11 80       	push   $0x80113d40
80103ca2:	e8 59 08 00 00       	call   80104500 <holding>
80103ca7:	83 c4 10             	add    $0x10,%esp
80103caa:	85 c0                	test   %eax,%eax
80103cac:	74 4f                	je     80103cfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cae:	e8 cd fb ff ff       	call   80103880 <mycpu>
80103cb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cba:	75 68                	jne    80103d24 <sched+0xa4>
  if(p->state == RUNNING)
80103cbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cc0:	74 55                	je     80103d17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cc2:	9c                   	pushf  
80103cc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cc4:	f6 c4 02             	test   $0x2,%ah
80103cc7:	75 41                	jne    80103d0a <sched+0x8a>
  intena = mycpu()->intena;
80103cc9:	e8 b2 fb ff ff       	call   80103880 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cd7:	e8 a4 fb ff ff       	call   80103880 <mycpu>
80103cdc:	83 ec 08             	sub    $0x8,%esp
80103cdf:	ff 70 04             	pushl  0x4(%eax)
80103ce2:	53                   	push   %ebx
80103ce3:	e8 43 0c 00 00       	call   8010492b <swtch>
  mycpu()->intena = intena;
80103ce8:	e8 93 fb ff ff       	call   80103880 <mycpu>
}
80103ced:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cf0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf9:	5b                   	pop    %ebx
80103cfa:	5e                   	pop    %esi
80103cfb:	5d                   	pop    %ebp
80103cfc:	c3                   	ret    
    panic("sched ptable.lock");
80103cfd:	83 ec 0c             	sub    $0xc,%esp
80103d00:	68 90 7c 10 80       	push   $0x80107c90
80103d05:	e8 86 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 bc 7c 10 80       	push   $0x80107cbc
80103d12:	e8 79 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d17:	83 ec 0c             	sub    $0xc,%esp
80103d1a:	68 ae 7c 10 80       	push   $0x80107cae
80103d1f:	e8 6c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d24:	83 ec 0c             	sub    $0xc,%esp
80103d27:	68 a2 7c 10 80       	push   $0x80107ca2
80103d2c:	e8 5f c6 ff ff       	call   80100390 <panic>
80103d31:	eb 0d                	jmp    80103d40 <exit>
80103d33:	90                   	nop
80103d34:	90                   	nop
80103d35:	90                   	nop
80103d36:	90                   	nop
80103d37:	90                   	nop
80103d38:	90                   	nop
80103d39:	90                   	nop
80103d3a:	90                   	nop
80103d3b:	90                   	nop
80103d3c:	90                   	nop
80103d3d:	90                   	nop
80103d3e:	90                   	nop
80103d3f:	90                   	nop

80103d40 <exit>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d49:	e8 12 07 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103d4e:	e8 2d fb ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103d53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d59:	e8 42 07 00 00       	call   801044a0 <popcli>
  if(curproc == initproc)
80103d5e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103d64:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d67:	8d 7e 68             	lea    0x68(%esi),%edi
80103d6a:	0f 84 e7 00 00 00    	je     80103e57 <exit+0x117>
    if(curproc->ofile[fd]){
80103d70:	8b 03                	mov    (%ebx),%eax
80103d72:	85 c0                	test   %eax,%eax
80103d74:	74 12                	je     80103d88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d76:	83 ec 0c             	sub    $0xc,%esp
80103d79:	50                   	push   %eax
80103d7a:	e8 f1 d1 ff ff       	call   80100f70 <fileclose>
      curproc->ofile[fd] = 0;
80103d7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d8b:	39 fb                	cmp    %edi,%ebx
80103d8d:	75 e1                	jne    80103d70 <exit+0x30>
  begin_op();
80103d8f:	e8 4c ef ff ff       	call   80102ce0 <begin_op>
  iput(curproc->cwd);
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	ff 76 68             	pushl  0x68(%esi)
80103d9a:	e8 51 db ff ff       	call   801018f0 <iput>
  end_op();
80103d9f:	e8 ac ef ff ff       	call   80102d50 <end_op>
  curproc->cwd = 0;
80103da4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103dab:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103db2:	e8 79 07 00 00       	call   80104530 <acquire>
  wakeup1(curproc->parent);
80103db7:	8b 56 14             	mov    0x14(%esi),%edx
80103dba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dbd:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80103dc2:	eb 0e                	jmp    80103dd2 <exit+0x92>
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc8:	83 c0 7c             	add    $0x7c,%eax
80103dcb:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103dd0:	73 1c                	jae    80103dee <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103dd2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dd6:	75 f0                	jne    80103dc8 <exit+0x88>
80103dd8:	3b 50 20             	cmp    0x20(%eax),%edx
80103ddb:	75 eb                	jne    80103dc8 <exit+0x88>
      p->state = RUNNABLE;
80103ddd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de4:	83 c0 7c             	add    $0x7c,%eax
80103de7:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103dec:	72 e4                	jb     80103dd2 <exit+0x92>
      p->parent = initproc;
80103dee:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df4:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80103df9:	eb 10                	jmp    80103e0b <exit+0xcb>
80103dfb:	90                   	nop
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e00:	83 c2 7c             	add    $0x7c,%edx
80103e03:	81 fa 74 5c 11 80    	cmp    $0x80115c74,%edx
80103e09:	73 33                	jae    80103e3e <exit+0xfe>
    if(p->parent == curproc){
80103e0b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e0e:	75 f0                	jne    80103e00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e10:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e14:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e17:	75 e7                	jne    80103e00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e19:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80103e1e:	eb 0a                	jmp    80103e2a <exit+0xea>
80103e20:	83 c0 7c             	add    $0x7c,%eax
80103e23:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103e28:	73 d6                	jae    80103e00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0xe0>
80103e30:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e33:	75 eb                	jne    80103e20 <exit+0xe0>
      p->state = RUNNABLE;
80103e35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e3c:	eb e2                	jmp    80103e20 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e3e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e45:	e8 36 fe ff ff       	call   80103c80 <sched>
  panic("zombie exit");
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 dd 7c 10 80       	push   $0x80107cdd
80103e52:	e8 39 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 d0 7c 10 80       	push   $0x80107cd0
80103e5f:	e8 2c c5 ff ff       	call   80100390 <panic>
80103e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e70 <yield>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	53                   	push   %ebx
80103e74:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e77:	68 40 3d 11 80       	push   $0x80113d40
80103e7c:	e8 af 06 00 00       	call   80104530 <acquire>
  pushcli();
80103e81:	e8 da 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103e86:	e8 f5 f9 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103e8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e91:	e8 0a 06 00 00       	call   801044a0 <popcli>
  myproc()->state = RUNNABLE;
80103e96:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e9d:	e8 de fd ff ff       	call   80103c80 <sched>
  release(&ptable.lock);
80103ea2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ea9:	e8 42 07 00 00       	call   801045f0 <release>
}
80103eae:	83 c4 10             	add    $0x10,%esp
80103eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eb4:	c9                   	leave  
80103eb5:	c3                   	ret    
80103eb6:	8d 76 00             	lea    0x0(%esi),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <sleep>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ecc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ecf:	e8 8c 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103ed4:	e8 a7 f9 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103ed9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103edf:	e8 bc 05 00 00       	call   801044a0 <popcli>
  if(p == 0)
80103ee4:	85 db                	test   %ebx,%ebx
80103ee6:	0f 84 87 00 00 00    	je     80103f73 <sleep+0xb3>
  if(lk == 0)
80103eec:	85 f6                	test   %esi,%esi
80103eee:	74 76                	je     80103f66 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ef0:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80103ef6:	74 50                	je     80103f48 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	68 40 3d 11 80       	push   $0x80113d40
80103f00:	e8 2b 06 00 00       	call   80104530 <acquire>
    release(lk);
80103f05:	89 34 24             	mov    %esi,(%esp)
80103f08:	e8 e3 06 00 00       	call   801045f0 <release>
  p->chan = chan;
80103f0d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f10:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f17:	e8 64 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f1c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f23:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f2a:	e8 c1 06 00 00       	call   801045f0 <release>
    acquire(lk);
80103f2f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f32:	83 c4 10             	add    $0x10,%esp
}
80103f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f38:	5b                   	pop    %ebx
80103f39:	5e                   	pop    %esi
80103f3a:	5f                   	pop    %edi
80103f3b:	5d                   	pop    %ebp
    acquire(lk);
80103f3c:	e9 ef 05 00 00       	jmp    80104530 <acquire>
80103f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f48:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f4b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f52:	e8 29 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f57:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f61:	5b                   	pop    %ebx
80103f62:	5e                   	pop    %esi
80103f63:	5f                   	pop    %edi
80103f64:	5d                   	pop    %ebp
80103f65:	c3                   	ret    
    panic("sleep without lk");
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	68 ef 7c 10 80       	push   $0x80107cef
80103f6e:	e8 1d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	68 e9 7c 10 80       	push   $0x80107ce9
80103f7b:	e8 10 c4 ff ff       	call   80100390 <panic>

80103f80 <wait>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 d6 04 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103f8a:	e8 f1 f8 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103f8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f95:	e8 06 05 00 00       	call   801044a0 <popcli>
  acquire(&ptable.lock);
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 40 3d 11 80       	push   $0x80113d40
80103fa2:	e8 89 05 00 00       	call   80104530 <acquire>
80103fa7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103faa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80103fb1:	eb 10                	jmp    80103fc3 <wait+0x43>
80103fb3:	90                   	nop
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	83 c3 7c             	add    $0x7c,%ebx
80103fbb:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80103fc1:	73 1b                	jae    80103fde <wait+0x5e>
      if(p->parent != curproc)
80103fc3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fc6:	75 f0                	jne    80103fb8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fc8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fcc:	74 32                	je     80104000 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fd1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd6:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80103fdc:	72 e5                	jb     80103fc3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	74 74                	je     80104056 <wait+0xd6>
80103fe2:	8b 46 24             	mov    0x24(%esi),%eax
80103fe5:	85 c0                	test   %eax,%eax
80103fe7:	75 6d                	jne    80104056 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fe9:	83 ec 08             	sub    $0x8,%esp
80103fec:	68 40 3d 11 80       	push   $0x80113d40
80103ff1:	56                   	push   %esi
80103ff2:	e8 c9 fe ff ff       	call   80103ec0 <sleep>
    havekids = 0;
80103ff7:	83 c4 10             	add    $0x10,%esp
80103ffa:	eb ae                	jmp    80103faa <wait+0x2a>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104006:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104009:	e8 42 e4 ff ff       	call   80102450 <kfree>
        freevm(p->pgdir);
8010400e:	5a                   	pop    %edx
8010400f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104019:	e8 b2 33 00 00       	call   801073d0 <freevm>
        release(&ptable.lock);
8010401e:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
80104025:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010402c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104033:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104037:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010403e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104045:	e8 a6 05 00 00       	call   801045f0 <release>
        return pid;
8010404a:	83 c4 10             	add    $0x10,%esp
}
8010404d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104050:	89 f0                	mov    %esi,%eax
80104052:	5b                   	pop    %ebx
80104053:	5e                   	pop    %esi
80104054:	5d                   	pop    %ebp
80104055:	c3                   	ret    
      release(&ptable.lock);
80104056:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104059:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010405e:	68 40 3d 11 80       	push   $0x80113d40
80104063:	e8 88 05 00 00       	call   801045f0 <release>
      return -1;
80104068:	83 c4 10             	add    $0x10,%esp
8010406b:	eb e0                	jmp    8010404d <wait+0xcd>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <ticket_sleep>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	56                   	push   %esi
80104074:	53                   	push   %ebx
80104075:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104078:	e8 e3 03 00 00       	call   80104460 <pushcli>
  c = mycpu();
8010407d:	e8 fe f7 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80104082:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104088:	e8 13 04 00 00       	call   801044a0 <popcli>
  if(p == 0)
8010408d:	85 db                	test   %ebx,%ebx
8010408f:	74 46                	je     801040d7 <ticket_sleep+0x67>
  if(lk == 0)
80104091:	85 f6                	test   %esi,%esi
80104093:	74 4f                	je     801040e4 <ticket_sleep+0x74>
  acquire(&ptable.lock);
80104095:	83 ec 0c             	sub    $0xc,%esp
80104098:	68 40 3d 11 80       	push   $0x80113d40
8010409d:	e8 8e 04 00 00       	call   80104530 <acquire>
  p->chan = lk;
801040a2:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040a5:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  popcli();
801040ac:	e8 ef 03 00 00       	call   801044a0 <popcli>
  sched();
801040b1:	e8 ca fb ff ff       	call   80103c80 <sched>
  pushcli();
801040b6:	e8 a5 03 00 00       	call   80104460 <pushcli>
  p->chan = 0;
801040bb:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  release(&ptable.lock);
801040c2:	83 c4 10             	add    $0x10,%esp
801040c5:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
801040cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040cf:	5b                   	pop    %ebx
801040d0:	5e                   	pop    %esi
801040d1:	5d                   	pop    %ebp
  release(&ptable.lock);
801040d2:	e9 19 05 00 00       	jmp    801045f0 <release>
    panic("sleep");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 e9 7c 10 80       	push   $0x80107ce9
801040df:	e8 ac c2 ff ff       	call   80100390 <panic>
    panic("sleep without lk");
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	68 ef 7c 10 80       	push   $0x80107cef
801040ec:	e8 9f c2 ff ff       	call   80100390 <panic>
801040f1:	eb 0d                	jmp    80104100 <wakeup>
801040f3:	90                   	nop
801040f4:	90                   	nop
801040f5:	90                   	nop
801040f6:	90                   	nop
801040f7:	90                   	nop
801040f8:	90                   	nop
801040f9:	90                   	nop
801040fa:	90                   	nop
801040fb:	90                   	nop
801040fc:	90                   	nop
801040fd:	90                   	nop
801040fe:	90                   	nop
801040ff:	90                   	nop

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410a:	68 40 3d 11 80       	push   $0x80113d40
8010410f:	e8 1c 04 00 00       	call   80104530 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104117:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010411c:	eb 0c                	jmp    8010412a <wakeup+0x2a>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	83 c0 7c             	add    $0x7c,%eax
80104123:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104128:	73 1c                	jae    80104146 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010412e:	75 f0                	jne    80104120 <wakeup+0x20>
80104130:	3b 58 20             	cmp    0x20(%eax),%ebx
80104133:	75 eb                	jne    80104120 <wakeup+0x20>
      p->state = RUNNABLE;
80104135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413c:	83 c0 7c             	add    $0x7c,%eax
8010413f:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104144:	72 e4                	jb     8010412a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104146:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
8010414d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104150:	c9                   	leave  
  release(&ptable.lock);
80104151:	e9 9a 04 00 00       	jmp    801045f0 <release>
80104156:	8d 76 00             	lea    0x0(%esi),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416a:	68 40 3d 11 80       	push   $0x80113d40
8010416f:	e8 bc 03 00 00       	call   80104530 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104177:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010417c:	eb 0c                	jmp    8010418a <kill+0x2a>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	83 c0 7c             	add    $0x7c,%eax
80104183:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104188:	73 36                	jae    801041c0 <kill+0x60>
    if(p->pid == pid){
8010418a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010418d:	75 f1                	jne    80104180 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010418f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104193:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010419a:	75 07                	jne    801041a3 <kill+0x43>
        p->state = RUNNABLE;
8010419c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 40 3d 11 80       	push   $0x80113d40
801041ab:	e8 40 04 00 00       	call   801045f0 <release>
      return 0;
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 40 3d 11 80       	push   $0x80113d40
801041c8:	e8 23 04 00 00       	call   801045f0 <release>
  return -1;
801041cd:	83 c4 10             	add    $0x10,%esp
801041d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e9:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
801041ee:	83 ec 3c             	sub    $0x3c,%esp
801041f1:	eb 24                	jmp    80104217 <procdump+0x37>
801041f3:	90                   	nop
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 6f 82 10 80       	push   $0x8010826f
80104200:	e8 0b c5 ff ff       	call   80100710 <cprintf>
80104205:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104208:	83 c3 7c             	add    $0x7c,%ebx
8010420b:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104211:	0f 83 81 00 00 00    	jae    80104298 <procdump+0xb8>
    if(p->state == UNUSED)
80104217:	8b 43 0c             	mov    0xc(%ebx),%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 ea                	je     80104208 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010421e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104221:	ba 00 7d 10 80       	mov    $0x80107d00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104226:	77 11                	ja     80104239 <procdump+0x59>
80104228:	8b 14 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%edx
      state = "???";
8010422f:	b8 00 7d 10 80       	mov    $0x80107d00,%eax
80104234:	85 d2                	test   %edx,%edx
80104236:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104239:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010423c:	50                   	push   %eax
8010423d:	52                   	push   %edx
8010423e:	ff 73 10             	pushl  0x10(%ebx)
80104241:	68 04 7d 10 80       	push   $0x80107d04
80104246:	e8 c5 c4 ff ff       	call   80100710 <cprintf>
    if(p->state == SLEEPING){
8010424b:	83 c4 10             	add    $0x10,%esp
8010424e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104252:	75 a4                	jne    801041f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104254:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104257:	83 ec 08             	sub    $0x8,%esp
8010425a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010425d:	50                   	push   %eax
8010425e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104261:	8b 40 0c             	mov    0xc(%eax),%eax
80104264:	83 c0 08             	add    $0x8,%eax
80104267:	50                   	push   %eax
80104268:	e8 a3 01 00 00       	call   80104410 <getcallerpcs>
8010426d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104270:	8b 17                	mov    (%edi),%edx
80104272:	85 d2                	test   %edx,%edx
80104274:	74 82                	je     801041f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104276:	83 ec 08             	sub    $0x8,%esp
80104279:	83 c7 04             	add    $0x4,%edi
8010427c:	52                   	push   %edx
8010427d:	68 41 77 10 80       	push   $0x80107741
80104282:	e8 89 c4 ff ff       	call   80100710 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	39 fe                	cmp    %edi,%esi
8010428c:	75 e2                	jne    80104270 <procdump+0x90>
8010428e:	e9 65 ff ff ff       	jmp    801041f8 <procdump+0x18>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429b:	5b                   	pop    %ebx
8010429c:	5e                   	pop    %esi
8010429d:	5f                   	pop    %edi
8010429e:	5d                   	pop    %ebp
8010429f:	c3                   	ret    

801042a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042aa:	68 78 7d 10 80       	push   $0x80107d78
801042af:	8d 43 04             	lea    0x4(%ebx),%eax
801042b2:	50                   	push   %eax
801042b3:	e8 38 01 00 00       	call   801043f0 <initlock>
  lk->name = name;
801042b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave  
801042d2:	c3                   	ret    
801042d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
801042e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	8d 73 04             	lea    0x4(%ebx),%esi
801042ee:	56                   	push   %esi
801042ef:	e8 3c 02 00 00       	call   80104530 <acquire>
  while (lk->locked) {
801042f4:	8b 13                	mov    (%ebx),%edx
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	85 d2                	test   %edx,%edx
801042fb:	74 16                	je     80104313 <acquiresleep+0x33>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104300:	83 ec 08             	sub    $0x8,%esp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	e8 b6 fb ff ff       	call   80103ec0 <sleep>
  while (lk->locked) {
8010430a:	8b 03                	mov    (%ebx),%eax
8010430c:	83 c4 10             	add    $0x10,%esp
8010430f:	85 c0                	test   %eax,%eax
80104311:	75 ed                	jne    80104300 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104313:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104319:	e8 02 f6 ff ff       	call   80103920 <myproc>
8010431e:	8b 40 10             	mov    0x10(%eax),%eax
80104321:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104324:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104327:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432a:	5b                   	pop    %ebx
8010432b:	5e                   	pop    %esi
8010432c:	5d                   	pop    %ebp
  release(&lk->lk);
8010432d:	e9 be 02 00 00       	jmp    801045f0 <release>
80104332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(lk->pid != (myproc())->pid) return;
80104348:	8b 73 3c             	mov    0x3c(%ebx),%esi
8010434b:	e8 d0 f5 ff ff       	call   80103920 <myproc>
80104350:	3b 70 10             	cmp    0x10(%eax),%esi
80104353:	74 0b                	je     80104360 <releasesleep+0x20>
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
}
80104355:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104358:	5b                   	pop    %ebx
80104359:	5e                   	pop    %esi
8010435a:	5d                   	pop    %ebp
8010435b:	c3                   	ret    
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&lk->lk);
80104360:	8d 73 04             	lea    0x4(%ebx),%esi
80104363:	83 ec 0c             	sub    $0xc,%esp
80104366:	56                   	push   %esi
80104367:	e8 c4 01 00 00       	call   80104530 <acquire>
  lk->locked = 0;
8010436c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104372:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104379:	89 1c 24             	mov    %ebx,(%esp)
8010437c:	e8 7f fd ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
80104381:	89 75 08             	mov    %esi,0x8(%ebp)
80104384:	83 c4 10             	add    $0x10,%esp
}
80104387:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010438a:	5b                   	pop    %ebx
8010438b:	5e                   	pop    %esi
8010438c:	5d                   	pop    %ebp
  release(&lk->lk);
8010438d:	e9 5e 02 00 00       	jmp    801045f0 <release>
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	31 ff                	xor    %edi,%edi
801043a8:	83 ec 18             	sub    $0x18,%esp
801043ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043ae:	8d 73 04             	lea    0x4(%ebx),%esi
801043b1:	56                   	push   %esi
801043b2:	e8 79 01 00 00       	call   80104530 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043b7:	8b 03                	mov    (%ebx),%eax
801043b9:	83 c4 10             	add    $0x10,%esp
801043bc:	85 c0                	test   %eax,%eax
801043be:	74 13                	je     801043d3 <holdingsleep+0x33>
801043c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043c3:	e8 58 f5 ff ff       	call   80103920 <myproc>
801043c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801043cb:	0f 94 c0             	sete   %al
801043ce:	0f b6 c0             	movzbl %al,%eax
801043d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	56                   	push   %esi
801043d7:	e8 14 02 00 00       	call   801045f0 <release>
  return r;
}
801043dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043df:	89 f8                	mov    %edi,%eax
801043e1:	5b                   	pop    %ebx
801043e2:	5e                   	pop    %esi
801043e3:	5f                   	pop    %edi
801043e4:	5d                   	pop    %ebp
801043e5:	c3                   	ret    
801043e6:	66 90                	xchg   %ax,%ax
801043e8:	66 90                	xchg   %ax,%ax
801043ea:	66 90                	xchg   %ax,%ax
801043ec:	66 90                	xchg   %ax,%ax
801043ee:	66 90                	xchg   %ax,%ax

801043f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104410 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104410:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104411:	31 d2                	xor    %edx,%edx
{
80104413:	89 e5                	mov    %esp,%ebp
80104415:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104416:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010441c:	83 e8 08             	sub    $0x8,%eax
8010441f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104420:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104426:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010442c:	77 1a                	ja     80104448 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010442e:	8b 58 04             	mov    0x4(%eax),%ebx
80104431:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104434:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104437:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104439:	83 fa 0a             	cmp    $0xa,%edx
8010443c:	75 e2                	jne    80104420 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010443e:	5b                   	pop    %ebx
8010443f:	5d                   	pop    %ebp
80104440:	c3                   	ret    
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104448:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010444b:	83 c1 28             	add    $0x28,%ecx
8010444e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104456:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104459:	39 c1                	cmp    %eax,%ecx
8010445b:	75 f3                	jne    80104450 <getcallerpcs+0x40>
}
8010445d:	5b                   	pop    %ebx
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    

80104460 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	9c                   	pushf  
80104468:	5b                   	pop    %ebx
  asm volatile("cli");
80104469:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010446a:	e8 11 f4 ff ff       	call   80103880 <mycpu>
8010446f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104475:	85 c0                	test   %eax,%eax
80104477:	75 11                	jne    8010448a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104479:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010447f:	e8 fc f3 ff ff       	call   80103880 <mycpu>
80104484:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010448a:	e8 f1 f3 ff ff       	call   80103880 <mycpu>
8010448f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104496:	83 c4 04             	add    $0x4,%esp
80104499:	5b                   	pop    %ebx
8010449a:	5d                   	pop    %ebp
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <popcli>:

void
popcli(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044a6:	9c                   	pushf  
801044a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044a8:	f6 c4 02             	test   $0x2,%ah
801044ab:	75 35                	jne    801044e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044ad:	e8 ce f3 ff ff       	call   80103880 <mycpu>
801044b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044b9:	78 34                	js     801044ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044bb:	e8 c0 f3 ff ff       	call   80103880 <mycpu>
801044c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044c6:	85 d2                	test   %edx,%edx
801044c8:	74 06                	je     801044d0 <popcli+0x30>
    sti();
}
801044ca:	c9                   	leave  
801044cb:	c3                   	ret    
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044d0:	e8 ab f3 ff ff       	call   80103880 <mycpu>
801044d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044db:	85 c0                	test   %eax,%eax
801044dd:	74 eb                	je     801044ca <popcli+0x2a>
  asm volatile("sti");
801044df:	fb                   	sti    
}
801044e0:	c9                   	leave  
801044e1:	c3                   	ret    
    panic("popcli - interruptible");
801044e2:	83 ec 0c             	sub    $0xc,%esp
801044e5:	68 83 7d 10 80       	push   $0x80107d83
801044ea:	e8 a1 be ff ff       	call   80100390 <panic>
    panic("popcli");
801044ef:	83 ec 0c             	sub    $0xc,%esp
801044f2:	68 9a 7d 10 80       	push   $0x80107d9a
801044f7:	e8 94 be ff ff       	call   80100390 <panic>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <holding>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 75 08             	mov    0x8(%ebp),%esi
80104508:	31 db                	xor    %ebx,%ebx
  pushcli();
8010450a:	e8 51 ff ff ff       	call   80104460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010450f:	8b 06                	mov    (%esi),%eax
80104511:	85 c0                	test   %eax,%eax
80104513:	74 10                	je     80104525 <holding+0x25>
80104515:	8b 5e 08             	mov    0x8(%esi),%ebx
80104518:	e8 63 f3 ff ff       	call   80103880 <mycpu>
8010451d:	39 c3                	cmp    %eax,%ebx
8010451f:	0f 94 c3             	sete   %bl
80104522:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104525:	e8 76 ff ff ff       	call   801044a0 <popcli>
}
8010452a:	89 d8                	mov    %ebx,%eax
8010452c:	5b                   	pop    %ebx
8010452d:	5e                   	pop    %esi
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <acquire>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104535:	e8 26 ff ff ff       	call   80104460 <pushcli>
  if(holding(lk))
8010453a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010453d:	83 ec 0c             	sub    $0xc,%esp
80104540:	53                   	push   %ebx
80104541:	e8 ba ff ff ff       	call   80104500 <holding>
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 c0                	test   %eax,%eax
8010454b:	0f 85 83 00 00 00    	jne    801045d4 <acquire+0xa4>
80104551:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104553:	ba 01 00 00 00       	mov    $0x1,%edx
80104558:	eb 09                	jmp    80104563 <acquire+0x33>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104560:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104563:	89 d0                	mov    %edx,%eax
80104565:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104568:	85 c0                	test   %eax,%eax
8010456a:	75 f4                	jne    80104560 <acquire+0x30>
  __sync_synchronize();
8010456c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104571:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104574:	e8 07 f3 ff ff       	call   80103880 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104579:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010457c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010457f:	89 e8                	mov    %ebp,%eax
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104588:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010458e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104594:	77 1a                	ja     801045b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104596:	8b 48 04             	mov    0x4(%eax),%ecx
80104599:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010459c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010459f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045a1:	83 fe 0a             	cmp    $0xa,%esi
801045a4:	75 e2                	jne    80104588 <acquire+0x58>
}
801045a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a9:	5b                   	pop    %ebx
801045aa:	5e                   	pop    %esi
801045ab:	5d                   	pop    %ebp
801045ac:	c3                   	ret    
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
801045b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801045b3:	83 c2 28             	add    $0x28,%edx
801045b6:	8d 76 00             	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801045c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045c9:	39 d0                	cmp    %edx,%eax
801045cb:	75 f3                	jne    801045c0 <acquire+0x90>
}
801045cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d0:	5b                   	pop    %ebx
801045d1:	5e                   	pop    %esi
801045d2:	5d                   	pop    %ebp
801045d3:	c3                   	ret    
    panic("acquire");
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	68 a1 7d 10 80       	push   $0x80107da1
801045dc:	e8 af bd ff ff       	call   80100390 <panic>
801045e1:	eb 0d                	jmp    801045f0 <release>
801045e3:	90                   	nop
801045e4:	90                   	nop
801045e5:	90                   	nop
801045e6:	90                   	nop
801045e7:	90                   	nop
801045e8:	90                   	nop
801045e9:	90                   	nop
801045ea:	90                   	nop
801045eb:	90                   	nop
801045ec:	90                   	nop
801045ed:	90                   	nop
801045ee:	90                   	nop
801045ef:	90                   	nop

801045f0 <release>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 10             	sub    $0x10,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801045fa:	53                   	push   %ebx
801045fb:	e8 00 ff ff ff       	call   80104500 <holding>
80104600:	83 c4 10             	add    $0x10,%esp
80104603:	85 c0                	test   %eax,%eax
80104605:	74 22                	je     80104629 <release+0x39>
  lk->pcs[0] = 0;
80104607:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010460e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104615:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010461a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104620:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104623:	c9                   	leave  
  popcli();
80104624:	e9 77 fe ff ff       	jmp    801044a0 <popcli>
    panic("release");
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	68 a9 7d 10 80       	push   $0x80107da9
80104631:	e8 5a bd ff ff       	call   80100390 <panic>
80104636:	66 90                	xchg   %ax,%ax
80104638:	66 90                	xchg   %ax,%ax
8010463a:	66 90                	xchg   %ax,%ax
8010463c:	66 90                	xchg   %ax,%ax
8010463e:	66 90                	xchg   %ax,%ax

80104640 <initlock_t>:
#include "ticketlock.h"

struct ticketlock global_lock;

void initlock_t()
{
80104640:	55                   	push   %ebp
    global_lock.proc = 0;
80104641:	c7 05 7c 5c 11 80 00 	movl   $0x0,0x80115c7c
80104648:	00 00 00 
    global_lock.ticket = 0;
8010464b:	c7 05 74 5c 11 80 00 	movl   $0x0,0x80115c74
80104652:	00 00 00 
    global_lock.turn = 0;
80104655:	c7 05 78 5c 11 80 00 	movl   $0x0,0x80115c78
8010465c:	00 00 00 
{
8010465f:	89 e5                	mov    %esp,%ebp
}
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <acquire_t>:


void acquire_t()
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 04             	sub    $0x4,%esp
    uint ticket;
    pushcli(); 
80104677:	e8 e4 fd ff ff       	call   80104460 <pushcli>
//Added inline assembly
static inline uint
fetch_and_inc(volatile uint *addr)
{
  uint value = 1;
  asm volatile("lock; xaddl %%eax, %2;" :
8010467c:	b8 01 00 00 00       	mov    $0x1,%eax
80104681:	f0 0f c1 05 74 5c 11 	lock xadd %eax,0x80115c74
80104688:	80 
    // if(global_lock.ticket != 0)
    //     panic("acquire");

    ticket = fetch_and_inc(&global_lock.ticket);
    while(global_lock.turn != ticket)
80104689:	3b 05 78 5c 11 80    	cmp    0x80115c78,%eax
8010468f:	74 1f                	je     801046b0 <acquire_t+0x40>
80104691:	89 c3                	mov    %eax,%ebx
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ticket_sleep(&global_lock);
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 74 5c 11 80       	push   $0x80115c74
801046a0:	e8 cb f9 ff ff       	call   80104070 <ticket_sleep>
    while(global_lock.turn != ticket)
801046a5:	83 c4 10             	add    $0x10,%esp
801046a8:	39 1d 78 5c 11 80    	cmp    %ebx,0x80115c78
801046ae:	75 e8                	jne    80104698 <acquire_t+0x28>

    global_lock.proc = myproc();
801046b0:	e8 6b f2 ff ff       	call   80103920 <myproc>
}
801046b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    global_lock.proc = myproc();
801046b8:	a3 7c 5c 11 80       	mov    %eax,0x80115c7c
}
801046bd:	c9                   	leave  
801046be:	c3                   	ret    
801046bf:	90                   	nop

801046c0 <release_t>:

void release_t()
{
801046c0:	55                   	push   %ebp
801046c1:	b8 01 00 00 00       	mov    $0x1,%eax
801046c6:	89 e5                	mov    %esp,%ebp
801046c8:	83 ec 14             	sub    $0x14,%esp
    // if(global_lock.ticket == 0)
    //     panic("release");

    global_lock.proc = 0;
801046cb:	c7 05 7c 5c 11 80 00 	movl   $0x0,0x80115c7c
801046d2:	00 00 00 
801046d5:	f0 0f c1 05 78 5c 11 	lock xadd %eax,0x80115c78
801046dc:	80 

    fetch_and_inc(&global_lock.turn);
    wakeup(&global_lock);
801046dd:	68 74 5c 11 80       	push   $0x80115c74
801046e2:	e8 19 fa ff ff       	call   80104100 <wakeup>
    popcli();
801046e7:	83 c4 10             	add    $0x10,%esp
}
801046ea:	c9                   	leave  
    popcli();
801046eb:	e9 b0 fd ff ff       	jmp    801044a0 <popcli>

801046f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	53                   	push   %ebx
801046f5:	8b 55 08             	mov    0x8(%ebp),%edx
801046f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046fb:	f6 c2 03             	test   $0x3,%dl
801046fe:	75 05                	jne    80104705 <memset+0x15>
80104700:	f6 c1 03             	test   $0x3,%cl
80104703:	74 13                	je     80104718 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104705:	89 d7                	mov    %edx,%edi
80104707:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470a:	fc                   	cld    
8010470b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010470d:	5b                   	pop    %ebx
8010470e:	89 d0                	mov    %edx,%eax
80104710:	5f                   	pop    %edi
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104718:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010471c:	c1 e9 02             	shr    $0x2,%ecx
8010471f:	89 f8                	mov    %edi,%eax
80104721:	89 fb                	mov    %edi,%ebx
80104723:	c1 e0 18             	shl    $0x18,%eax
80104726:	c1 e3 10             	shl    $0x10,%ebx
80104729:	09 d8                	or     %ebx,%eax
8010472b:	09 f8                	or     %edi,%eax
8010472d:	c1 e7 08             	shl    $0x8,%edi
80104730:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104732:	89 d7                	mov    %edx,%edi
80104734:	fc                   	cld    
80104735:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104737:	5b                   	pop    %ebx
80104738:	89 d0                	mov    %edx,%eax
8010473a:	5f                   	pop    %edi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret    
8010473d:	8d 76 00             	lea    0x0(%esi),%esi

80104740 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104749:	8b 75 08             	mov    0x8(%ebp),%esi
8010474c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010474f:	85 db                	test   %ebx,%ebx
80104751:	74 29                	je     8010477c <memcmp+0x3c>
    if(*s1 != *s2)
80104753:	0f b6 16             	movzbl (%esi),%edx
80104756:	0f b6 0f             	movzbl (%edi),%ecx
80104759:	38 d1                	cmp    %dl,%cl
8010475b:	75 2b                	jne    80104788 <memcmp+0x48>
8010475d:	b8 01 00 00 00       	mov    $0x1,%eax
80104762:	eb 14                	jmp    80104778 <memcmp+0x38>
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104768:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010476c:	83 c0 01             	add    $0x1,%eax
8010476f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104774:	38 ca                	cmp    %cl,%dl
80104776:	75 10                	jne    80104788 <memcmp+0x48>
  while(n-- > 0){
80104778:	39 d8                	cmp    %ebx,%eax
8010477a:	75 ec                	jne    80104768 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010477c:	5b                   	pop    %ebx
  return 0;
8010477d:	31 c0                	xor    %eax,%eax
}
8010477f:	5e                   	pop    %esi
80104780:	5f                   	pop    %edi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104788:	0f b6 c2             	movzbl %dl,%eax
}
8010478b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010478c:	29 c8                	sub    %ecx,%eax
}
8010478e:	5e                   	pop    %esi
8010478f:	5f                   	pop    %edi
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 45 08             	mov    0x8(%ebp),%eax
801047a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ae:	39 c3                	cmp    %eax,%ebx
801047b0:	73 26                	jae    801047d8 <memmove+0x38>
801047b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047b5:	39 c8                	cmp    %ecx,%eax
801047b7:	73 1f                	jae    801047d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047b9:	85 f6                	test   %esi,%esi
801047bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047be:	74 0f                	je     801047cf <memmove+0x2f>
      *--d = *--s;
801047c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047c7:	83 ea 01             	sub    $0x1,%edx
801047ca:	83 fa ff             	cmp    $0xffffffff,%edx
801047cd:	75 f1                	jne    801047c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047cf:	5b                   	pop    %ebx
801047d0:	5e                   	pop    %esi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    
801047d3:	90                   	nop
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801047d8:	31 d2                	xor    %edx,%edx
801047da:	85 f6                	test   %esi,%esi
801047dc:	74 f1                	je     801047cf <memmove+0x2f>
801047de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801047e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801047e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801047ea:	39 d6                	cmp    %edx,%esi
801047ec:	75 f2                	jne    801047e0 <memmove+0x40>
}
801047ee:	5b                   	pop    %ebx
801047ef:	5e                   	pop    %esi
801047f0:	5d                   	pop    %ebp
801047f1:	c3                   	ret    
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104803:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104804:	eb 9a                	jmp    801047a0 <memmove>
80104806:	8d 76 00             	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	8b 7d 10             	mov    0x10(%ebp),%edi
80104818:	53                   	push   %ebx
80104819:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010481c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010481f:	85 ff                	test   %edi,%edi
80104821:	74 2f                	je     80104852 <strncmp+0x42>
80104823:	0f b6 01             	movzbl (%ecx),%eax
80104826:	0f b6 1e             	movzbl (%esi),%ebx
80104829:	84 c0                	test   %al,%al
8010482b:	74 37                	je     80104864 <strncmp+0x54>
8010482d:	38 c3                	cmp    %al,%bl
8010482f:	75 33                	jne    80104864 <strncmp+0x54>
80104831:	01 f7                	add    %esi,%edi
80104833:	eb 13                	jmp    80104848 <strncmp+0x38>
80104835:	8d 76 00             	lea    0x0(%esi),%esi
80104838:	0f b6 01             	movzbl (%ecx),%eax
8010483b:	84 c0                	test   %al,%al
8010483d:	74 21                	je     80104860 <strncmp+0x50>
8010483f:	0f b6 1a             	movzbl (%edx),%ebx
80104842:	89 d6                	mov    %edx,%esi
80104844:	38 d8                	cmp    %bl,%al
80104846:	75 1c                	jne    80104864 <strncmp+0x54>
    n--, p++, q++;
80104848:	8d 56 01             	lea    0x1(%esi),%edx
8010484b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010484e:	39 fa                	cmp    %edi,%edx
80104850:	75 e6                	jne    80104838 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104852:	5b                   	pop    %ebx
    return 0;
80104853:	31 c0                	xor    %eax,%eax
}
80104855:	5e                   	pop    %esi
80104856:	5f                   	pop    %edi
80104857:	5d                   	pop    %ebp
80104858:	c3                   	ret    
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104860:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104864:	29 d8                	sub    %ebx,%eax
}
80104866:	5b                   	pop    %ebx
80104867:	5e                   	pop    %esi
80104868:	5f                   	pop    %edi
80104869:	5d                   	pop    %ebp
8010486a:	c3                   	ret    
8010486b:	90                   	nop
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 45 08             	mov    0x8(%ebp),%eax
80104878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010487b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010487e:	89 c2                	mov    %eax,%edx
80104880:	eb 19                	jmp    8010489b <strncpy+0x2b>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104888:	83 c3 01             	add    $0x1,%ebx
8010488b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010488f:	83 c2 01             	add    $0x1,%edx
80104892:	84 c9                	test   %cl,%cl
80104894:	88 4a ff             	mov    %cl,-0x1(%edx)
80104897:	74 09                	je     801048a2 <strncpy+0x32>
80104899:	89 f1                	mov    %esi,%ecx
8010489b:	85 c9                	test   %ecx,%ecx
8010489d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048a0:	7f e6                	jg     80104888 <strncpy+0x18>
    ;
  while(n-- > 0)
801048a2:	31 c9                	xor    %ecx,%ecx
801048a4:	85 f6                	test   %esi,%esi
801048a6:	7e 17                	jle    801048bf <strncpy+0x4f>
801048a8:	90                   	nop
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048b4:	89 f3                	mov    %esi,%ebx
801048b6:	83 c1 01             	add    $0x1,%ecx
801048b9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048bb:	85 db                	test   %ebx,%ebx
801048bd:	7f f1                	jg     801048b0 <strncpy+0x40>
  return os;
}
801048bf:	5b                   	pop    %ebx
801048c0:	5e                   	pop    %esi
801048c1:	5d                   	pop    %ebp
801048c2:	c3                   	ret    
801048c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048d8:	8b 45 08             	mov    0x8(%ebp),%eax
801048db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801048de:	85 c9                	test   %ecx,%ecx
801048e0:	7e 26                	jle    80104908 <safestrcpy+0x38>
801048e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801048e6:	89 c1                	mov    %eax,%ecx
801048e8:	eb 17                	jmp    80104901 <safestrcpy+0x31>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048f0:	83 c2 01             	add    $0x1,%edx
801048f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801048f7:	83 c1 01             	add    $0x1,%ecx
801048fa:	84 db                	test   %bl,%bl
801048fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801048ff:	74 04                	je     80104905 <safestrcpy+0x35>
80104901:	39 f2                	cmp    %esi,%edx
80104903:	75 eb                	jne    801048f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104905:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104908:	5b                   	pop    %ebx
80104909:	5e                   	pop    %esi
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <strlen>:

int
strlen(const char *s)
{
80104910:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104911:	31 c0                	xor    %eax,%eax
{
80104913:	89 e5                	mov    %esp,%ebp
80104915:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104918:	80 3a 00             	cmpb   $0x0,(%edx)
8010491b:	74 0c                	je     80104929 <strlen+0x19>
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	83 c0 01             	add    $0x1,%eax
80104923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104927:	75 f7                	jne    80104920 <strlen+0x10>
    ;
  return n;
}
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    

8010492b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010492b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010492f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104933:	55                   	push   %ebp
  pushl %ebx
80104934:	53                   	push   %ebx
  pushl %esi
80104935:	56                   	push   %esi
  pushl %edi
80104936:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104937:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104939:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010493b:	5f                   	pop    %edi
  popl %esi
8010493c:	5e                   	pop    %esi
  popl %ebx
8010493d:	5b                   	pop    %ebx
  popl %ebp
8010493e:	5d                   	pop    %ebp
  ret
8010493f:	c3                   	ret    

80104940 <fetchint>:

int shared_var;

int
fetchint(uint addr, int *ip)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010494a:	e8 d1 ef ff ff       	call   80103920 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010494f:	8b 00                	mov    (%eax),%eax
80104951:	39 d8                	cmp    %ebx,%eax
80104953:	76 1b                	jbe    80104970 <fetchint+0x30>
80104955:	8d 53 04             	lea    0x4(%ebx),%edx
80104958:	39 d0                	cmp    %edx,%eax
8010495a:	72 14                	jb     80104970 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010495c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495f:	8b 13                	mov    (%ebx),%edx
80104961:	89 10                	mov    %edx,(%eax)
  return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	83 c4 04             	add    $0x4,%esp
80104968:	5b                   	pop    %ebx
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    
8010496b:	90                   	nop
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104975:	eb ee                	jmp    80104965 <fetchint+0x25>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010498a:	e8 91 ef ff ff       	call   80103920 <myproc>

  if(addr >= curproc->sz)
8010498f:	39 18                	cmp    %ebx,(%eax)
80104991:	76 29                	jbe    801049bc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104996:	89 da                	mov    %ebx,%edx
80104998:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010499a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010499c:	39 c3                	cmp    %eax,%ebx
8010499e:	73 1c                	jae    801049bc <fetchstr+0x3c>
    if(*s == 0)
801049a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049a3:	75 10                	jne    801049b5 <fetchstr+0x35>
801049a5:	eb 39                	jmp    801049e0 <fetchstr+0x60>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049b0:	80 3a 00             	cmpb   $0x0,(%edx)
801049b3:	74 1b                	je     801049d0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049b5:	83 c2 01             	add    $0x1,%edx
801049b8:	39 d0                	cmp    %edx,%eax
801049ba:	77 f4                	ja     801049b0 <fetchstr+0x30>
    return -1;
801049bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049c1:	83 c4 04             	add    $0x4,%esp
801049c4:	5b                   	pop    %ebx
801049c5:	5d                   	pop    %ebp
801049c6:	c3                   	ret    
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049d0:	83 c4 04             	add    $0x4,%esp
801049d3:	89 d0                	mov    %edx,%eax
801049d5:	29 d8                	sub    %ebx,%eax
801049d7:	5b                   	pop    %ebx
801049d8:	5d                   	pop    %ebp
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801049e0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801049e2:	eb dd                	jmp    801049c1 <fetchstr+0x41>
801049e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f5:	e8 26 ef ff ff       	call   80103920 <myproc>
801049fa:	8b 40 18             	mov    0x18(%eax),%eax
801049fd:	8b 55 08             	mov    0x8(%ebp),%edx
80104a00:	8b 40 44             	mov    0x44(%eax),%eax
80104a03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a06:	e8 15 ef ff ff       	call   80103920 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a0b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a0d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a10:	39 c6                	cmp    %eax,%esi
80104a12:	73 1c                	jae    80104a30 <argint+0x40>
80104a14:	8d 53 08             	lea    0x8(%ebx),%edx
80104a17:	39 d0                	cmp    %edx,%eax
80104a19:	72 15                	jb     80104a30 <argint+0x40>
  *ip = *(int*)(addr);
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a21:	89 10                	mov    %edx,(%eax)
  return 0;
80104a23:	31 c0                	xor    %eax,%eax
}
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
80104a28:	c3                   	ret    
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	eb ee                	jmp    80104a25 <argint+0x35>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	83 ec 10             	sub    $0x10,%esp
80104a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a4b:	e8 d0 ee ff ff       	call   80103920 <myproc>
80104a50:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a55:	83 ec 08             	sub    $0x8,%esp
80104a58:	50                   	push   %eax
80104a59:	ff 75 08             	pushl  0x8(%ebp)
80104a5c:	e8 8f ff ff ff       	call   801049f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a61:	83 c4 10             	add    $0x10,%esp
80104a64:	85 c0                	test   %eax,%eax
80104a66:	78 28                	js     80104a90 <argptr+0x50>
80104a68:	85 db                	test   %ebx,%ebx
80104a6a:	78 24                	js     80104a90 <argptr+0x50>
80104a6c:	8b 16                	mov    (%esi),%edx
80104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a71:	39 c2                	cmp    %eax,%edx
80104a73:	76 1b                	jbe    80104a90 <argptr+0x50>
80104a75:	01 c3                	add    %eax,%ebx
80104a77:	39 da                	cmp    %ebx,%edx
80104a79:	72 15                	jb     80104a90 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a7e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a80:	31 c0                	xor    %eax,%eax
}
80104a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb eb                	jmp    80104a82 <argptr+0x42>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa9:	50                   	push   %eax
80104aaa:	ff 75 08             	pushl  0x8(%ebp)
80104aad:	e8 3e ff ff ff       	call   801049f0 <argint>
80104ab2:	83 c4 10             	add    $0x10,%esp
80104ab5:	85 c0                	test   %eax,%eax
80104ab7:	78 17                	js     80104ad0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ab9:	83 ec 08             	sub    $0x8,%esp
80104abc:	ff 75 0c             	pushl  0xc(%ebp)
80104abf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ac2:	e8 b9 fe ff ff       	call   80104980 <fetchstr>
80104ac7:	83 c4 10             	add    $0x10,%esp
}
80104aca:	c9                   	leave  
80104acb:	c3                   	ret    
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ad5:	c9                   	leave  
80104ad6:	c3                   	ret    
80104ad7:	89 f6                	mov    %esi,%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <find_history_of_process>:

struct _my_history* _History = 0;
struct _my_history _Global_History;

struct _my_history* find_history_of_process(uint pid) {
  if(!_History)
80104ae0:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
struct _my_history* find_history_of_process(uint pid) {
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
  if(!_History)
80104ae8:	85 c0                	test   %eax,%eax
struct _my_history* find_history_of_process(uint pid) {
80104aea:	8b 55 08             	mov    0x8(%ebp),%edx
  if(!_History)
80104aed:	75 10                	jne    80104aff <find_history_of_process+0x1f>
80104aef:	eb 12                	jmp    80104b03 <find_history_of_process+0x23>
80104af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  struct _my_history* curr = _History;
  while(1) {
    if(curr->pid == pid)
      return curr;
    if(curr->next)
80104af8:	8b 40 04             	mov    0x4(%eax),%eax
80104afb:	85 c0                	test   %eax,%eax
80104afd:	74 04                	je     80104b03 <find_history_of_process+0x23>
    if(curr->pid == pid)
80104aff:	39 10                	cmp    %edx,(%eax)
80104b01:	75 f5                	jne    80104af8 <find_history_of_process+0x18>
      curr = curr->next;
    else
      return 0;
  }

}
80104b03:	5d                   	pop    %ebp
80104b04:	c3                   	ret    
80104b05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <_add_history>:

struct _my_history* 
_add_history(uint pid) {
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
  // struct _my_history* new_node = (struct _my_history*)malloc(sizeof(struct _my_history));
  struct _my_history* new_node = (struct _my_history*)kalloc();
80104b17:	e8 e4 da ff ff       	call   80102600 <kalloc>
  memset(new_node, 0, sizeof(struct _my_history));
80104b1c:	83 ec 04             	sub    $0x4,%esp
  struct _my_history* new_node = (struct _my_history*)kalloc();
80104b1f:	89 c3                	mov    %eax,%ebx
  memset(new_node, 0, sizeof(struct _my_history));
80104b21:	6a 0c                	push   $0xc
80104b23:	6a 00                	push   $0x0
80104b25:	50                   	push   %eax
80104b26:	e8 c5 fb ff ff       	call   801046f0 <memset>
  if(!new_node)
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	85 db                	test   %ebx,%ebx
80104b30:	74 4b                	je     80104b7d <_add_history+0x6d>
  {
    cprintf("failed to save history.\n");
    return 0;
  }
  new_node->pid = pid;
80104b32:	8b 45 08             	mov    0x8(%ebp),%eax
  new_node->next = 0;
80104b35:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  new_node->calls = 0;
80104b3c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  new_node->pid = pid;
80104b43:	89 03                	mov    %eax,(%ebx)

  struct _my_history* curr = _History;
80104b45:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
  if(!curr) {
80104b4b:	85 d2                	test   %edx,%edx
80104b4d:	75 0b                	jne    80104b5a <_add_history+0x4a>
80104b4f:	eb 1f                	jmp    80104b70 <_add_history+0x60>
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b58:	89 c2                	mov    %eax,%edx
    _History = new_node;
  }
  else {
    while(curr->next)
80104b5a:	8b 42 04             	mov    0x4(%edx),%eax
80104b5d:	85 c0                	test   %eax,%eax
80104b5f:	75 f7                	jne    80104b58 <_add_history+0x48>
      curr = curr->next;
    curr->next = new_node;
80104b61:	89 5a 04             	mov    %ebx,0x4(%edx)
  }

  return new_node;
  
}
80104b64:	89 d8                	mov    %ebx,%eax
80104b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b69:	c9                   	leave  
80104b6a:	c3                   	ret    
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    _History = new_node;
80104b70:	89 1d c0 b5 10 80    	mov    %ebx,0x8010b5c0
}
80104b76:	89 d8                	mov    %ebx,%eax
80104b78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b7b:	c9                   	leave  
80104b7c:	c3                   	ret    
    cprintf("failed to save history.\n");
80104b7d:	83 ec 0c             	sub    $0xc,%esp
80104b80:	68 b1 7d 10 80       	push   $0x80107db1
80104b85:	e8 86 bb ff ff       	call   80100710 <cprintf>
    return 0;
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	eb d5                	jmp    80104b64 <_add_history+0x54>
80104b8f:	90                   	nop

80104b90 <_add_call>:

void 
_add_call(struct _my_history* history, int num, int pid) {
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	53                   	push   %ebx
80104b96:	83 ec 1c             	sub    $0x1c,%esp
80104b99:	8b 45 10             	mov    0x10(%ebp),%eax
80104b9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  // struct _my_syscall_history* new_node = (struct _my_syscall_history*)malloc(sizeof(struct _my_syscall_history));
  struct _my_syscall_history* new_node = (struct _my_syscall_history*)kalloc();
80104ba5:	e8 56 da ff ff       	call   80102600 <kalloc>
  memset(new_node, 0, sizeof(struct _my_syscall_history));
80104baa:	83 ec 04             	sub    $0x4,%esp
  struct _my_syscall_history* new_node = (struct _my_syscall_history*)kalloc();
80104bad:	89 c6                	mov    %eax,%esi
  memset(new_node, 0, sizeof(struct _my_syscall_history));
80104baf:	6a 18                	push   $0x18
80104bb1:	6a 00                	push   $0x0
80104bb3:	50                   	push   %eax
80104bb4:	e8 37 fb ff ff       	call   801046f0 <memset>
  if(!new_node)
80104bb9:	83 c4 10             	add    $0x10,%esp
80104bbc:	85 f6                	test   %esi,%esi
80104bbe:	74 70                	je     80104c30 <_add_call+0xa0>
  {
    cprintf("failed to save history.\n");
    return;
  }
  cmostime(new_node->date);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	ff 76 08             	pushl  0x8(%esi)
80104bc6:	e8 85 dd ff ff       	call   80102950 <cmostime>
  new_node->num = num;
  new_node->pid = pid;
80104bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  new_node->num = num;
80104bce:	89 3e                	mov    %edi,(%esi)
  new_node->next = 0;
  new_node->global_next = 0;
  new_node->prev = 0;

  if(!history->calls) {
80104bd0:	83 c4 10             	add    $0x10,%esp
  new_node->next = 0;
80104bd3:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  new_node->global_next = 0;
80104bda:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
  new_node->prev = 0;
80104be1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  new_node->pid = pid;
80104be8:	89 46 04             	mov    %eax,0x4(%esi)
  if(!history->calls) {
80104beb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80104bee:	85 c9                	test   %ecx,%ecx
80104bf0:	75 08                	jne    80104bfa <_add_call+0x6a>
80104bf2:	eb 54                	jmp    80104c48 <_add_call+0xb8>
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf8:	89 c1                	mov    %eax,%ecx
    history->calls = new_node;
  }
  else {
    struct _my_syscall_history* curr = history->calls;
    while(curr->next)
80104bfa:	8b 41 0c             	mov    0xc(%ecx),%eax
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	75 f7                	jne    80104bf8 <_add_call+0x68>
      curr = curr->next;
    curr->next = new_node;
80104c01:	89 71 0c             	mov    %esi,0xc(%ecx)
    new_node->prev = curr;
80104c04:	89 4e 14             	mov    %ecx,0x14(%esi)
  }
  struct _my_syscall_history* curr = _Global_History.calls;
80104c07:	8b 0d 8c 5c 11 80    	mov    0x80115c8c,%ecx
  if(!curr) {
80104c0d:	85 c9                	test   %ecx,%ecx
80104c0f:	75 09                	jne    80104c1a <_add_call+0x8a>
80104c11:	eb 42                	jmp    80104c55 <_add_call+0xc5>
80104c13:	90                   	nop
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c18:	89 c1                	mov    %eax,%ecx
    _Global_History.calls = new_node;
  }
  else {
    while(curr->global_next)
80104c1a:	8b 41 10             	mov    0x10(%ecx),%eax
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	75 f7                	jne    80104c18 <_add_call+0x88>
      curr = curr->global_next;
    curr->global_next = new_node;
80104c21:	89 71 10             	mov    %esi,0x10(%ecx)
  
  }
}
80104c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c27:	5b                   	pop    %ebx
80104c28:	5e                   	pop    %esi
80104c29:	5f                   	pop    %edi
80104c2a:	5d                   	pop    %ebp
80104c2b:	c3                   	ret    
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("failed to save history.\n");
80104c30:	c7 45 08 b1 7d 10 80 	movl   $0x80107db1,0x8(%ebp)
}
80104c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c3a:	5b                   	pop    %ebx
80104c3b:	5e                   	pop    %esi
80104c3c:	5f                   	pop    %edi
80104c3d:	5d                   	pop    %ebp
    cprintf("failed to save history.\n");
80104c3e:	e9 cd ba ff ff       	jmp    80100710 <cprintf>
80104c43:	90                   	nop
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    history->calls = new_node;
80104c48:	89 73 08             	mov    %esi,0x8(%ebx)
  struct _my_syscall_history* curr = _Global_History.calls;
80104c4b:	8b 0d 8c 5c 11 80    	mov    0x80115c8c,%ecx
  if(!curr) {
80104c51:	85 c9                	test   %ecx,%ecx
80104c53:	75 c5                	jne    80104c1a <_add_call+0x8a>
    _Global_History.calls = new_node;
80104c55:	89 35 8c 5c 11 80    	mov    %esi,0x80115c8c
}
80104c5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c5e:	5b                   	pop    %ebx
80104c5f:	5e                   	pop    %esi
80104c60:	5f                   	pop    %edi
80104c61:	5d                   	pop    %ebp
80104c62:	c3                   	ret    
80104c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <syscall_called_event>:
  if(!_History)
80104c70:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax

void
syscall_called_event(uint pid, int num)
{
80104c75:	55                   	push   %ebp
80104c76:	89 e5                	mov    %esp,%ebp
80104c78:	56                   	push   %esi
80104c79:	53                   	push   %ebx
  if(!_History)
80104c7a:	85 c0                	test   %eax,%eax
{
80104c7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!_History)
80104c82:	75 13                	jne    80104c97 <syscall_called_event+0x27>
80104c84:	eb 2a                	jmp    80104cb0 <syscall_called_event+0x40>
80104c86:	8d 76 00             	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curr->next)
80104c90:	8b 40 04             	mov    0x4(%eax),%eax
80104c93:	85 c0                	test   %eax,%eax
80104c95:	74 19                	je     80104cb0 <syscall_called_event+0x40>
    if(curr->pid == pid)
80104c97:	3b 18                	cmp    (%eax),%ebx
80104c99:	75 f5                	jne    80104c90 <syscall_called_event+0x20>
      cprintf("failed to save history.\n");
      return;
    }
  }

  _add_call(this_pid, num, pid);
80104c9b:	83 ec 04             	sub    $0x4,%esp
80104c9e:	53                   	push   %ebx
80104c9f:	56                   	push   %esi
80104ca0:	50                   	push   %eax
80104ca1:	e8 ea fe ff ff       	call   80104b90 <_add_call>
80104ca6:	83 c4 10             	add    $0x10,%esp
}
80104ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cac:	5b                   	pop    %ebx
80104cad:	5e                   	pop    %esi
80104cae:	5d                   	pop    %ebp
80104caf:	c3                   	ret    
    this_pid = _add_history(pid);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
80104cb3:	53                   	push   %ebx
80104cb4:	e8 57 fe ff ff       	call   80104b10 <_add_history>
    if(!this_pid) {
80104cb9:	83 c4 10             	add    $0x10,%esp
80104cbc:	85 c0                	test   %eax,%eax
80104cbe:	75 db                	jne    80104c9b <syscall_called_event+0x2b>
      cprintf("failed to save history.\n");
80104cc0:	c7 45 08 b1 7d 10 80 	movl   $0x80107db1,0x8(%ebp)
}
80104cc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cca:	5b                   	pop    %ebx
80104ccb:	5e                   	pop    %esi
80104ccc:	5d                   	pop    %ebp
      cprintf("failed to save history.\n");
80104ccd:	e9 3e ba ff ff       	jmp    80100710 <cprintf>
80104cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <syscall>:

int my_flag = 0;

void
syscall(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104ce5:	e8 36 ec ff ff       	call   80103920 <myproc>
80104cea:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cec:	8b 40 18             	mov    0x18(%eax),%eax
80104cef:	8b 40 1c             	mov    0x1c(%eax),%eax

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cf2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf5:	83 fa 1a             	cmp    $0x1a,%edx
80104cf8:	77 36                	ja     80104d30 <syscall+0x50>
80104cfa:	8b 34 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%esi
80104d01:	85 f6                	test   %esi,%esi
80104d03:	74 2b                	je     80104d30 <syscall+0x50>
    
    if(my_flag) {
80104d05:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80104d0b:	85 d2                	test   %edx,%edx
80104d0d:	74 0f                	je     80104d1e <syscall+0x3e>
      syscall_called_event(curproc->pid, num);
80104d0f:	83 ec 08             	sub    $0x8,%esp
80104d12:	50                   	push   %eax
80104d13:	ff 73 10             	pushl  0x10(%ebx)
80104d16:	e8 55 ff ff ff       	call   80104c70 <syscall_called_event>
80104d1b:	83 c4 10             	add    $0x10,%esp
    }
    curproc->tf->eax = syscalls[num]();
80104d1e:	ff d6                	call   *%esi
80104d20:	8b 53 18             	mov    0x18(%ebx),%edx
80104d23:	89 42 1c             	mov    %eax,0x1c(%edx)
  //     }
  //     curr = curr->next; 
  //   }
  //   cprintf("=== END\n");
  // }
}
80104d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d29:	5b                   	pop    %ebx
80104d2a:	5e                   	pop    %esi
80104d2b:	5d                   	pop    %ebp
80104d2c:	c3                   	ret    
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d34:	50                   	push   %eax
80104d35:	ff 73 10             	pushl  0x10(%ebx)
80104d38:	68 ca 7d 10 80       	push   $0x80107dca
80104d3d:	e8 ce b9 ff ff       	call   80100710 <cprintf>
    curproc->tf->eax = -1;
80104d42:	8b 43 18             	mov    0x18(%ebx),%eax
80104d45:	83 c4 10             	add    $0x10,%esp
80104d48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d 76 00             	lea    0x0(%esi),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <print_invoked_syscalls>:


void 
print_invoked_syscalls(uint pid)
{
  if(!my_flag) {
80104d60:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80104d65:	55                   	push   %ebp
80104d66:	89 e5                	mov    %esp,%ebp
80104d68:	56                   	push   %esi
80104d69:	53                   	push   %ebx
  if(!my_flag) {
80104d6a:	85 c0                	test   %eax,%eax
{
80104d6c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(!my_flag) {
80104d6f:	75 14                	jne    80104d85 <print_invoked_syscalls+0x25>
    my_flag = 1;
80104d71:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80104d78:	00 00 00 
    _Global_History.calls = 0;
80104d7b:	c7 05 8c 5c 11 80 00 	movl   $0x0,0x80115c8c
80104d82:	00 00 00 
  if(!_History)
80104d85:	8b 1d c0 b5 10 80    	mov    0x8010b5c0,%ebx
80104d8b:	85 db                	test   %ebx,%ebx
80104d8d:	75 10                	jne    80104d9f <print_invoked_syscalls+0x3f>
80104d8f:	eb 77                	jmp    80104e08 <print_invoked_syscalls+0xa8>
80104d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curr->next)
80104d98:	8b 5b 04             	mov    0x4(%ebx),%ebx
80104d9b:	85 db                	test   %ebx,%ebx
80104d9d:	74 69                	je     80104e08 <print_invoked_syscalls+0xa8>
    if(curr->pid == pid)
80104d9f:	3b 33                	cmp    (%ebx),%esi
80104da1:	75 f5                	jne    80104d98 <print_invoked_syscalls+0x38>
  if(!history) {
    cprintf("The process number %d never called any system call.\n", pid);
    return;
  }

  cprintf("=> Start list of syscalls of process %d\n", pid);
80104da3:	83 ec 08             	sub    $0x8,%esp
80104da6:	56                   	push   %esi
80104da7:	68 74 7e 10 80       	push   $0x80107e74
80104dac:	e8 5f b9 ff ff       	call   80100710 <cprintf>
  struct _my_syscall_history* curr = history->calls;
80104db1:	8b 5b 08             	mov    0x8(%ebx),%ebx
  while(curr) {
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 db                	test   %ebx,%ebx
80104db9:	74 2f                	je     80104dea <print_invoked_syscalls+0x8a>
80104dbb:	90                   	nop
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("-> system call %d   %d/%d/%d  %d:%d\':%d\"\n", curr->num, curr->date->year, curr->date->month, curr->date->day, curr->date->hour, curr->date->minute, curr->date->second);
80104dc0:	8b 43 08             	mov    0x8(%ebx),%eax
80104dc3:	ff 30                	pushl  (%eax)
80104dc5:	ff 70 04             	pushl  0x4(%eax)
80104dc8:	ff 70 08             	pushl  0x8(%eax)
80104dcb:	ff 70 0c             	pushl  0xc(%eax)
80104dce:	ff 70 10             	pushl  0x10(%eax)
80104dd1:	ff 70 14             	pushl  0x14(%eax)
80104dd4:	ff 33                	pushl  (%ebx)
80104dd6:	68 20 7e 10 80       	push   $0x80107e20
80104ddb:	e8 30 b9 ff ff       	call   80100710 <cprintf>
    curr = curr->next;
80104de0:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  while(curr) {
80104de3:	83 c4 20             	add    $0x20,%esp
80104de6:	85 db                	test   %ebx,%ebx
80104de8:	75 d6                	jne    80104dc0 <print_invoked_syscalls+0x60>
  }
  cprintf("=> End list of syscalls of process %d\n", pid);
80104dea:	83 ec 08             	sub    $0x8,%esp
80104ded:	56                   	push   %esi
80104dee:	68 4c 7e 10 80       	push   $0x80107e4c
80104df3:	e8 18 b9 ff ff       	call   80100710 <cprintf>
80104df8:	83 c4 10             	add    $0x10,%esp

}
80104dfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dfe:	5b                   	pop    %ebx
80104dff:	5e                   	pop    %esi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret    
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("The process number %d never called any system call.\n", pid);
80104e08:	83 ec 08             	sub    $0x8,%esp
80104e0b:	56                   	push   %esi
80104e0c:	68 e8 7d 10 80       	push   $0x80107de8
80104e11:	e8 fa b8 ff ff       	call   80100710 <cprintf>
    return;
80104e16:	83 c4 10             	add    $0x10,%esp
}
80104e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1c:	5b                   	pop    %ebx
80104e1d:	5e                   	pop    %esi
80104e1e:	5d                   	pop    %ebp
80104e1f:	c3                   	ret    

80104e20 <swap>:

void swap(struct _my_syscall_history* a, struct _my_syscall_history* b) 
{ 
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	8b 55 08             	mov    0x8(%ebp),%edx
80104e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  // b->next->prev = a;
  // b->next = a;
  // b->prev = a->prev;
  // a->prev->next = b;
  // a->prev = b;
  int num = a->num;
80104e2a:	8b 0a                	mov    (%edx),%ecx
  a->num = b->num;
80104e2c:	8b 18                	mov    (%eax),%ebx
80104e2e:	89 1a                	mov    %ebx,(%edx)
  b->num = num;
80104e30:	89 08                	mov    %ecx,(%eax)
} 
80104e32:	5b                   	pop    %ebx
80104e33:	5d                   	pop    %ebp
80104e34:	c3                   	ret    
80104e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <my_sort_syscalls>:

void 
my_sort_syscalls(uint pid) {
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
80104e46:	83 ec 1c             	sub    $0x1c,%esp
  if(!_History)
80104e49:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
my_sort_syscalls(uint pid) {
80104e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  if(!_History)
80104e51:	85 c0                	test   %eax,%eax
80104e53:	75 12                	jne    80104e67 <my_sort_syscalls+0x27>
80104e55:	eb 69                	jmp    80104ec0 <my_sort_syscalls+0x80>
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curr->next)
80104e60:	8b 40 04             	mov    0x4(%eax),%eax
80104e63:	85 c0                	test   %eax,%eax
80104e65:	74 59                	je     80104ec0 <my_sort_syscalls+0x80>
    if(curr->pid == pid)
80104e67:	3b 10                	cmp    (%eax),%edx
80104e69:	75 f5                	jne    80104e60 <my_sort_syscalls+0x20>
    cprintf("The process number %d never called any system call.\n", pid);
    return;
  }

  int swapped;
  struct _my_syscall_history* start = history->calls; 
80104e6b:	8b 40 08             	mov    0x8(%eax),%eax
  struct _my_syscall_history* ptr1; 
  struct _my_syscall_history* lptr = 0; 
80104e6e:	31 f6                	xor    %esi,%esi

  if (start == 0) 
80104e70:	85 c0                	test   %eax,%eax
  struct _my_syscall_history* start = history->calls; 
80104e72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (start == 0) 
80104e75:	74 3a                	je     80104eb1 <my_sort_syscalls+0x71>
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  do
  { 
      swapped = 0; 
      ptr1 = start; 

      while (ptr1->next != lptr) 
80104e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e83:	8b 50 0c             	mov    0xc(%eax),%edx
80104e86:	39 d6                	cmp    %edx,%esi
80104e88:	74 27                	je     80104eb1 <my_sort_syscalls+0x71>
      swapped = 0; 
80104e8a:	31 ff                	xor    %edi,%edi
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      { 
          if (ptr1->num > ptr1->next->num) 
80104e90:	8b 08                	mov    (%eax),%ecx
80104e92:	8b 1a                	mov    (%edx),%ebx
80104e94:	39 d9                	cmp    %ebx,%ecx
80104e96:	76 09                	jbe    80104ea1 <my_sort_syscalls+0x61>
  a->num = b->num;
80104e98:	89 18                	mov    %ebx,(%eax)
          {  
              swap(ptr1, ptr1->next); 
              swapped = 1; 
80104e9a:	bf 01 00 00 00       	mov    $0x1,%edi
  b->num = num;
80104e9f:	89 0a                	mov    %ecx,(%edx)
          } 
          ptr1 = ptr1->next; 
80104ea1:	8b 40 0c             	mov    0xc(%eax),%eax
      while (ptr1->next != lptr) 
80104ea4:	8b 50 0c             	mov    0xc(%eax),%edx
80104ea7:	39 f2                	cmp    %esi,%edx
80104ea9:	75 e5                	jne    80104e90 <my_sort_syscalls+0x50>
      } 
      lptr = ptr1; 
  } 
  while (swapped);
80104eab:	85 ff                	test   %edi,%edi
          ptr1 = ptr1->next; 
80104ead:	89 c6                	mov    %eax,%esi
  while (swapped);
80104eaf:	75 cf                	jne    80104e80 <my_sort_syscalls+0x40>
}
80104eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb4:	5b                   	pop    %ebx
80104eb5:	5e                   	pop    %esi
80104eb6:	5f                   	pop    %edi
80104eb7:	5d                   	pop    %ebp
80104eb8:	c3                   	ret    
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("The process number %d never called any system call.\n", pid);
80104ec0:	83 ec 08             	sub    $0x8,%esp
80104ec3:	52                   	push   %edx
80104ec4:	68 e8 7d 10 80       	push   $0x80107de8
80104ec9:	e8 42 b8 ff ff       	call   80100710 <cprintf>
    return;
80104ece:	83 c4 10             	add    $0x10,%esp
}
80104ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed4:	5b                   	pop    %ebx
80104ed5:	5e                   	pop    %esi
80104ed6:	5f                   	pop    %edi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <my_get_count>:
  if(!_History)
80104ee0:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax

void 
my_get_count(uint pid, uint sysnum) {
80104ee5:	55                   	push   %ebp
80104ee6:	89 e5                	mov    %esp,%ebp
80104ee8:	56                   	push   %esi
80104ee9:	53                   	push   %ebx
  if(!_History)
80104eea:	85 c0                	test   %eax,%eax
my_get_count(uint pid, uint sysnum) {
80104eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eef:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!_History)
80104ef2:	75 13                	jne    80104f07 <my_get_count+0x27>
80104ef4:	eb 4a                	jmp    80104f40 <my_get_count+0x60>
80104ef6:	8d 76 00             	lea    0x0(%esi),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curr->next)
80104f00:	8b 40 04             	mov    0x4(%eax),%eax
80104f03:	85 c0                	test   %eax,%eax
80104f05:	74 39                	je     80104f40 <my_get_count+0x60>
    if(curr->pid == pid)
80104f07:	3b 08                	cmp    (%eax),%ecx
80104f09:	75 f5                	jne    80104f00 <my_get_count+0x20>
  if(!history) {
    cprintf("The process number %d never called any system call.\n", pid);
    return;
  }

  struct _my_syscall_history* curr = history->calls;
80104f0b:	8b 40 08             	mov    0x8(%eax),%eax
  int count = 0;
80104f0e:	31 d2                	xor    %edx,%edx

  while(curr) {
80104f10:	85 c0                	test   %eax,%eax
80104f12:	74 14                	je     80104f28 <my_get_count+0x48>
80104f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curr->num == sysnum)
      count++;
80104f18:	31 db                	xor    %ebx,%ebx
80104f1a:	39 30                	cmp    %esi,(%eax)
    curr = curr->next;
80104f1c:	8b 40 0c             	mov    0xc(%eax),%eax
      count++;
80104f1f:	0f 94 c3             	sete   %bl
80104f22:	01 da                	add    %ebx,%edx
  while(curr) {
80104f24:	85 c0                	test   %eax,%eax
80104f26:	75 f0                	jne    80104f18 <my_get_count+0x38>
  }

  cprintf("The PID %d called %dth syscall by %d times.\n", pid, sysnum, count);
80104f28:	52                   	push   %edx
80104f29:	56                   	push   %esi
80104f2a:	51                   	push   %ecx
80104f2b:	68 a0 7e 10 80       	push   $0x80107ea0
80104f30:	e8 db b7 ff ff       	call   80100710 <cprintf>
80104f35:	83 c4 10             	add    $0x10,%esp
}
80104f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f3b:	5b                   	pop    %ebx
80104f3c:	5e                   	pop    %esi
80104f3d:	5d                   	pop    %ebp
80104f3e:	c3                   	ret    
80104f3f:	90                   	nop
    cprintf("The process number %d never called any system call.\n", pid);
80104f40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104f43:	c7 45 08 e8 7d 10 80 	movl   $0x80107de8,0x8(%ebp)
}
80104f4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f4d:	5b                   	pop    %ebx
80104f4e:	5e                   	pop    %esi
80104f4f:	5d                   	pop    %ebp
    cprintf("The process number %d never called any system call.\n", pid);
80104f50:	e9 bb b7 ff ff       	jmp    80100710 <cprintf>
80104f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <my_log_syscalls>:

void 
my_log_syscalls(void) 
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 10             	sub    $0x10,%esp
  cprintf("=> Start list of all syscalls sort by time\n");
80104f67:	68 d0 7e 10 80       	push   $0x80107ed0
80104f6c:	e8 9f b7 ff ff       	call   80100710 <cprintf>
  struct _my_syscall_history* curr = _Global_History.calls;
80104f71:	8b 1d 8c 5c 11 80    	mov    0x80115c8c,%ebx
  while(curr) {
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	85 db                	test   %ebx,%ebx
80104f7c:	74 32                	je     80104fb0 <my_log_syscalls+0x50>
80104f7e:	66 90                	xchg   %ax,%ax
    cprintf("-> pid %d system call %d   %d/%d/%d  %d:%d\':%d\"\n", curr->pid, curr->num, curr->date->year, curr->date->month, curr->date->day, curr->date->hour, curr->date->minute, curr->date->second);
80104f80:	8b 43 08             	mov    0x8(%ebx),%eax
80104f83:	83 ec 0c             	sub    $0xc,%esp
80104f86:	ff 30                	pushl  (%eax)
80104f88:	ff 70 04             	pushl  0x4(%eax)
80104f8b:	ff 70 08             	pushl  0x8(%eax)
80104f8e:	ff 70 0c             	pushl  0xc(%eax)
80104f91:	ff 70 10             	pushl  0x10(%eax)
80104f94:	ff 70 14             	pushl  0x14(%eax)
80104f97:	ff 33                	pushl  (%ebx)
80104f99:	ff 73 04             	pushl  0x4(%ebx)
80104f9c:	68 fc 7e 10 80       	push   $0x80107efc
80104fa1:	e8 6a b7 ff ff       	call   80100710 <cprintf>
    curr = curr->global_next;
80104fa6:	8b 5b 10             	mov    0x10(%ebx),%ebx
  while(curr) {
80104fa9:	83 c4 30             	add    $0x30,%esp
80104fac:	85 db                	test   %ebx,%ebx
80104fae:	75 d0                	jne    80104f80 <my_log_syscalls+0x20>
  }
  cprintf("=> End list of all syscalls sort by time\n");
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	68 30 7f 10 80       	push   $0x80107f30
80104fb8:	e8 53 b7 ff ff       	call   80100710 <cprintf>
}
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc3:	c9                   	leave  
80104fc4:	c3                   	ret    
80104fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <my_ticketlockinit>:

void 
my_ticketlockinit(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 08             	sub    $0x8,%esp
  // cprintf("my ticketlockinit is ok\n");
  initlock_t();
80104fd6:	e8 65 f6 ff ff       	call   80104640 <initlock_t>
  shared_var = 0;
  cprintf("shared variable value is: %d\n\n", shared_var);
80104fdb:	83 ec 08             	sub    $0x8,%esp
  shared_var = 0;
80104fde:	c7 05 80 5c 11 80 00 	movl   $0x0,0x80115c80
80104fe5:	00 00 00 
  cprintf("shared variable value is: %d\n\n", shared_var);
80104fe8:	6a 00                	push   $0x0
80104fea:	68 5c 7f 10 80       	push   $0x80107f5c
80104fef:	e8 1c b7 ff ff       	call   80100710 <cprintf>
}
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	c9                   	leave  
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105000 <my_ticketlocktest>:

void 
my_ticketlocktest(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 08             	sub    $0x8,%esp
  // cprintf("my ticketlocktest is ok\n");
  acquire_t();
80105006:	e8 65 f6 ff ff       	call   80104670 <acquire_t>
  shared_var += 1;
8010500b:	a1 80 5c 11 80       	mov    0x80115c80,%eax
  cprintf("shared variable changed, new value is: %d\n\n", shared_var);
80105010:	83 ec 08             	sub    $0x8,%esp
  shared_var += 1;
80105013:	83 c0 01             	add    $0x1,%eax
  cprintf("shared variable changed, new value is: %d\n\n", shared_var);
80105016:	50                   	push   %eax
80105017:	68 7c 7f 10 80       	push   $0x80107f7c
  shared_var += 1;
8010501c:	a3 80 5c 11 80       	mov    %eax,0x80115c80
  cprintf("shared variable changed, new value is: %d\n\n", shared_var);
80105021:	e8 ea b6 ff ff       	call   80100710 <cprintf>
  release_t();
80105026:	83 c4 10             	add    $0x10,%esp

}
80105029:	c9                   	leave  
  release_t();
8010502a:	e9 91 f6 ff ff       	jmp    801046c0 <release_t>
8010502f:	90                   	nop

80105030 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105036:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105039:	83 ec 44             	sub    $0x44,%esp
8010503c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010503f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105042:	56                   	push   %esi
80105043:	50                   	push   %eax
{
80105044:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105047:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010504a:	e8 f1 cf ff ff       	call   80102040 <nameiparent>
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	85 c0                	test   %eax,%eax
80105054:	0f 84 46 01 00 00    	je     801051a0 <create+0x170>
    return 0;
  ilock(dp);
8010505a:	83 ec 0c             	sub    $0xc,%esp
8010505d:	89 c3                	mov    %eax,%ebx
8010505f:	50                   	push   %eax
80105060:	e8 5b c7 ff ff       	call   801017c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105068:	83 c4 0c             	add    $0xc,%esp
8010506b:	50                   	push   %eax
8010506c:	56                   	push   %esi
8010506d:	53                   	push   %ebx
8010506e:	e8 7d cc ff ff       	call   80101cf0 <dirlookup>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	89 c7                	mov    %eax,%edi
8010507a:	74 34                	je     801050b0 <create+0x80>
    iunlockput(dp);
8010507c:	83 ec 0c             	sub    $0xc,%esp
8010507f:	53                   	push   %ebx
80105080:	e8 cb c9 ff ff       	call   80101a50 <iunlockput>
    ilock(ip);
80105085:	89 3c 24             	mov    %edi,(%esp)
80105088:	e8 33 c7 ff ff       	call   801017c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105095:	0f 85 95 00 00 00    	jne    80105130 <create+0x100>
8010509b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801050a0:	0f 85 8a 00 00 00    	jne    80105130 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a9:	89 f8                	mov    %edi,%eax
801050ab:	5b                   	pop    %ebx
801050ac:	5e                   	pop    %esi
801050ad:	5f                   	pop    %edi
801050ae:	5d                   	pop    %ebp
801050af:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801050b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801050b4:	83 ec 08             	sub    $0x8,%esp
801050b7:	50                   	push   %eax
801050b8:	ff 33                	pushl  (%ebx)
801050ba:	e8 91 c5 ff ff       	call   80101650 <ialloc>
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	85 c0                	test   %eax,%eax
801050c4:	89 c7                	mov    %eax,%edi
801050c6:	0f 84 e8 00 00 00    	je     801051b4 <create+0x184>
  ilock(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	50                   	push   %eax
801050d0:	e8 eb c6 ff ff       	call   801017c0 <ilock>
  ip->major = major;
801050d5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801050d9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801050dd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801050e1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801050e5:	b8 01 00 00 00       	mov    $0x1,%eax
801050ea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801050ee:	89 3c 24             	mov    %edi,(%esp)
801050f1:	e8 1a c6 ff ff       	call   80101710 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801050fe:	74 50                	je     80105150 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	ff 77 04             	pushl  0x4(%edi)
80105106:	56                   	push   %esi
80105107:	53                   	push   %ebx
80105108:	e8 53 ce ff ff       	call   80101f60 <dirlink>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	0f 88 8f 00 00 00    	js     801051a7 <create+0x177>
  iunlockput(dp);
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	53                   	push   %ebx
8010511c:	e8 2f c9 ff ff       	call   80101a50 <iunlockput>
  return ip;
80105121:	83 c4 10             	add    $0x10,%esp
}
80105124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105127:	89 f8                	mov    %edi,%eax
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5f                   	pop    %edi
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	57                   	push   %edi
    return 0;
80105134:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105136:	e8 15 c9 ff ff       	call   80101a50 <iunlockput>
    return 0;
8010513b:	83 c4 10             	add    $0x10,%esp
}
8010513e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105141:	89 f8                	mov    %edi,%eax
80105143:	5b                   	pop    %ebx
80105144:	5e                   	pop    %esi
80105145:	5f                   	pop    %edi
80105146:	5d                   	pop    %ebp
80105147:	c3                   	ret    
80105148:	90                   	nop
80105149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105150:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105155:	83 ec 0c             	sub    $0xc,%esp
80105158:	53                   	push   %ebx
80105159:	e8 b2 c5 ff ff       	call   80101710 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010515e:	83 c4 0c             	add    $0xc,%esp
80105161:	ff 77 04             	pushl  0x4(%edi)
80105164:	68 4c 80 10 80       	push   $0x8010804c
80105169:	57                   	push   %edi
8010516a:	e8 f1 cd ff ff       	call   80101f60 <dirlink>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	78 1c                	js     80105192 <create+0x162>
80105176:	83 ec 04             	sub    $0x4,%esp
80105179:	ff 73 04             	pushl  0x4(%ebx)
8010517c:	68 4b 80 10 80       	push   $0x8010804b
80105181:	57                   	push   %edi
80105182:	e8 d9 cd ff ff       	call   80101f60 <dirlink>
80105187:	83 c4 10             	add    $0x10,%esp
8010518a:	85 c0                	test   %eax,%eax
8010518c:	0f 89 6e ff ff ff    	jns    80105100 <create+0xd0>
      panic("create dots");
80105192:	83 ec 0c             	sub    $0xc,%esp
80105195:	68 3f 80 10 80       	push   $0x8010803f
8010519a:	e8 f1 b1 ff ff       	call   80100390 <panic>
8010519f:	90                   	nop
    return 0;
801051a0:	31 ff                	xor    %edi,%edi
801051a2:	e9 ff fe ff ff       	jmp    801050a6 <create+0x76>
    panic("create: dirlink");
801051a7:	83 ec 0c             	sub    $0xc,%esp
801051aa:	68 4e 80 10 80       	push   $0x8010804e
801051af:	e8 dc b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	68 30 80 10 80       	push   $0x80108030
801051bc:	e8 cf b1 ff ff       	call   80100390 <panic>
801051c1:	eb 0d                	jmp    801051d0 <argfd.constprop.0>
801051c3:	90                   	nop
801051c4:	90                   	nop
801051c5:	90                   	nop
801051c6:	90                   	nop
801051c7:	90                   	nop
801051c8:	90                   	nop
801051c9:	90                   	nop
801051ca:	90                   	nop
801051cb:	90                   	nop
801051cc:	90                   	nop
801051cd:	90                   	nop
801051ce:	90                   	nop
801051cf:	90                   	nop

801051d0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801051d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801051da:	89 d6                	mov    %edx,%esi
801051dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051df:	50                   	push   %eax
801051e0:	6a 00                	push   $0x0
801051e2:	e8 09 f8 ff ff       	call   801049f0 <argint>
801051e7:	83 c4 10             	add    $0x10,%esp
801051ea:	85 c0                	test   %eax,%eax
801051ec:	78 2a                	js     80105218 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051f2:	77 24                	ja     80105218 <argfd.constprop.0+0x48>
801051f4:	e8 27 e7 ff ff       	call   80103920 <myproc>
801051f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051fc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105200:	85 c0                	test   %eax,%eax
80105202:	74 14                	je     80105218 <argfd.constprop.0+0x48>
  if(pfd)
80105204:	85 db                	test   %ebx,%ebx
80105206:	74 02                	je     8010520a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105208:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010520a:	89 06                	mov    %eax,(%esi)
  return 0;
8010520c:	31 c0                	xor    %eax,%eax
}
8010520e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105211:	5b                   	pop    %ebx
80105212:	5e                   	pop    %esi
80105213:	5d                   	pop    %ebp
80105214:	c3                   	ret    
80105215:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521d:	eb ef                	jmp    8010520e <argfd.constprop.0+0x3e>
8010521f:	90                   	nop

80105220 <sys_dup>:
{
80105220:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105221:	31 c0                	xor    %eax,%eax
{
80105223:	89 e5                	mov    %esp,%ebp
80105225:	56                   	push   %esi
80105226:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105227:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010522a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010522d:	e8 9e ff ff ff       	call   801051d0 <argfd.constprop.0>
80105232:	85 c0                	test   %eax,%eax
80105234:	78 42                	js     80105278 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105236:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105239:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010523b:	e8 e0 e6 ff ff       	call   80103920 <myproc>
80105240:	eb 0e                	jmp    80105250 <sys_dup+0x30>
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105248:	83 c3 01             	add    $0x1,%ebx
8010524b:	83 fb 10             	cmp    $0x10,%ebx
8010524e:	74 28                	je     80105278 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105250:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105254:	85 d2                	test   %edx,%edx
80105256:	75 f0                	jne    80105248 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105258:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010525c:	83 ec 0c             	sub    $0xc,%esp
8010525f:	ff 75 f4             	pushl  -0xc(%ebp)
80105262:	e8 b9 bc ff ff       	call   80100f20 <filedup>
  return fd;
80105267:	83 c4 10             	add    $0x10,%esp
}
8010526a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010526d:	89 d8                	mov    %ebx,%eax
8010526f:	5b                   	pop    %ebx
80105270:	5e                   	pop    %esi
80105271:	5d                   	pop    %ebp
80105272:	c3                   	ret    
80105273:	90                   	nop
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105278:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010527b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105280:	89 d8                	mov    %ebx,%eax
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_read>:
{
80105290:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105291:	31 c0                	xor    %eax,%eax
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105298:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010529b:	e8 30 ff ff ff       	call   801051d0 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 4c                	js     801052f0 <sys_read+0x60>
801052a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a7:	83 ec 08             	sub    $0x8,%esp
801052aa:	50                   	push   %eax
801052ab:	6a 02                	push   $0x2
801052ad:	e8 3e f7 ff ff       	call   801049f0 <argint>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 37                	js     801052f0 <sys_read+0x60>
801052b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052bc:	83 ec 04             	sub    $0x4,%esp
801052bf:	ff 75 f0             	pushl  -0x10(%ebp)
801052c2:	50                   	push   %eax
801052c3:	6a 01                	push   $0x1
801052c5:	e8 76 f7 ff ff       	call   80104a40 <argptr>
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	85 c0                	test   %eax,%eax
801052cf:	78 1f                	js     801052f0 <sys_read+0x60>
  return fileread(f, p, n);
801052d1:	83 ec 04             	sub    $0x4,%esp
801052d4:	ff 75 f0             	pushl  -0x10(%ebp)
801052d7:	ff 75 f4             	pushl  -0xc(%ebp)
801052da:	ff 75 ec             	pushl  -0x14(%ebp)
801052dd:	e8 ae bd ff ff       	call   80101090 <fileread>
801052e2:	83 c4 10             	add    $0x10,%esp
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_write>:
{
80105300:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105301:	31 c0                	xor    %eax,%eax
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105308:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010530b:	e8 c0 fe ff ff       	call   801051d0 <argfd.constprop.0>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 4c                	js     80105360 <sys_write+0x60>
80105314:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105317:	83 ec 08             	sub    $0x8,%esp
8010531a:	50                   	push   %eax
8010531b:	6a 02                	push   $0x2
8010531d:	e8 ce f6 ff ff       	call   801049f0 <argint>
80105322:	83 c4 10             	add    $0x10,%esp
80105325:	85 c0                	test   %eax,%eax
80105327:	78 37                	js     80105360 <sys_write+0x60>
80105329:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532c:	83 ec 04             	sub    $0x4,%esp
8010532f:	ff 75 f0             	pushl  -0x10(%ebp)
80105332:	50                   	push   %eax
80105333:	6a 01                	push   $0x1
80105335:	e8 06 f7 ff ff       	call   80104a40 <argptr>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	78 1f                	js     80105360 <sys_write+0x60>
  return filewrite(f, p, n);
80105341:	83 ec 04             	sub    $0x4,%esp
80105344:	ff 75 f0             	pushl  -0x10(%ebp)
80105347:	ff 75 f4             	pushl  -0xc(%ebp)
8010534a:	ff 75 ec             	pushl  -0x14(%ebp)
8010534d:	e8 ce bd ff ff       	call   80101120 <filewrite>
80105352:	83 c4 10             	add    $0x10,%esp
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105365:	c9                   	leave  
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <sys_close>:
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105376:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105379:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010537c:	e8 4f fe ff ff       	call   801051d0 <argfd.constprop.0>
80105381:	85 c0                	test   %eax,%eax
80105383:	78 2b                	js     801053b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105385:	e8 96 e5 ff ff       	call   80103920 <myproc>
8010538a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010538d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105390:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105397:	00 
  fileclose(f);
80105398:	ff 75 f4             	pushl  -0xc(%ebp)
8010539b:	e8 d0 bb ff ff       	call   80100f70 <fileclose>
  return 0;
801053a0:	83 c4 10             	add    $0x10,%esp
801053a3:	31 c0                	xor    %eax,%eax
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_fstat>:
{
801053c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053c1:	31 c0                	xor    %eax,%eax
{
801053c3:	89 e5                	mov    %esp,%ebp
801053c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801053cb:	e8 00 fe ff ff       	call   801051d0 <argfd.constprop.0>
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 2c                	js     80105400 <sys_fstat+0x40>
801053d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d7:	83 ec 04             	sub    $0x4,%esp
801053da:	6a 14                	push   $0x14
801053dc:	50                   	push   %eax
801053dd:	6a 01                	push   $0x1
801053df:	e8 5c f6 ff ff       	call   80104a40 <argptr>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	78 15                	js     80105400 <sys_fstat+0x40>
  return filestat(f, st);
801053eb:	83 ec 08             	sub    $0x8,%esp
801053ee:	ff 75 f4             	pushl  -0xc(%ebp)
801053f1:	ff 75 f0             	pushl  -0x10(%ebp)
801053f4:	e8 47 bc ff ff       	call   80101040 <filestat>
801053f9:	83 c4 10             	add    $0x10,%esp
}
801053fc:	c9                   	leave  
801053fd:	c3                   	ret    
801053fe:	66 90                	xchg   %ax,%ax
    return -1;
80105400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_link>:
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105416:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105419:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010541c:	50                   	push   %eax
8010541d:	6a 00                	push   $0x0
8010541f:	e8 7c f6 ff ff       	call   80104aa0 <argstr>
80105424:	83 c4 10             	add    $0x10,%esp
80105427:	85 c0                	test   %eax,%eax
80105429:	0f 88 fb 00 00 00    	js     8010552a <sys_link+0x11a>
8010542f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105432:	83 ec 08             	sub    $0x8,%esp
80105435:	50                   	push   %eax
80105436:	6a 01                	push   $0x1
80105438:	e8 63 f6 ff ff       	call   80104aa0 <argstr>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	0f 88 e2 00 00 00    	js     8010552a <sys_link+0x11a>
  begin_op();
80105448:	e8 93 d8 ff ff       	call   80102ce0 <begin_op>
  if((ip = namei(old)) == 0){
8010544d:	83 ec 0c             	sub    $0xc,%esp
80105450:	ff 75 d4             	pushl  -0x2c(%ebp)
80105453:	e8 c8 cb ff ff       	call   80102020 <namei>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	89 c3                	mov    %eax,%ebx
8010545f:	0f 84 ea 00 00 00    	je     8010554f <sys_link+0x13f>
  ilock(ip);
80105465:	83 ec 0c             	sub    $0xc,%esp
80105468:	50                   	push   %eax
80105469:	e8 52 c3 ff ff       	call   801017c0 <ilock>
  if(ip->type == T_DIR){
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105476:	0f 84 bb 00 00 00    	je     80105537 <sys_link+0x127>
  ip->nlink++;
8010547c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105481:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105484:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105487:	53                   	push   %ebx
80105488:	e8 83 c2 ff ff       	call   80101710 <iupdate>
  iunlock(ip);
8010548d:	89 1c 24             	mov    %ebx,(%esp)
80105490:	e8 0b c4 ff ff       	call   801018a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105495:	58                   	pop    %eax
80105496:	5a                   	pop    %edx
80105497:	57                   	push   %edi
80105498:	ff 75 d0             	pushl  -0x30(%ebp)
8010549b:	e8 a0 cb ff ff       	call   80102040 <nameiparent>
801054a0:	83 c4 10             	add    $0x10,%esp
801054a3:	85 c0                	test   %eax,%eax
801054a5:	89 c6                	mov    %eax,%esi
801054a7:	74 5b                	je     80105504 <sys_link+0xf4>
  ilock(dp);
801054a9:	83 ec 0c             	sub    $0xc,%esp
801054ac:	50                   	push   %eax
801054ad:	e8 0e c3 ff ff       	call   801017c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	8b 03                	mov    (%ebx),%eax
801054b7:	39 06                	cmp    %eax,(%esi)
801054b9:	75 3d                	jne    801054f8 <sys_link+0xe8>
801054bb:	83 ec 04             	sub    $0x4,%esp
801054be:	ff 73 04             	pushl  0x4(%ebx)
801054c1:	57                   	push   %edi
801054c2:	56                   	push   %esi
801054c3:	e8 98 ca ff ff       	call   80101f60 <dirlink>
801054c8:	83 c4 10             	add    $0x10,%esp
801054cb:	85 c0                	test   %eax,%eax
801054cd:	78 29                	js     801054f8 <sys_link+0xe8>
  iunlockput(dp);
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	56                   	push   %esi
801054d3:	e8 78 c5 ff ff       	call   80101a50 <iunlockput>
  iput(ip);
801054d8:	89 1c 24             	mov    %ebx,(%esp)
801054db:	e8 10 c4 ff ff       	call   801018f0 <iput>
  end_op();
801054e0:	e8 6b d8 ff ff       	call   80102d50 <end_op>
  return 0;
801054e5:	83 c4 10             	add    $0x10,%esp
801054e8:	31 c0                	xor    %eax,%eax
}
801054ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054ed:	5b                   	pop    %ebx
801054ee:	5e                   	pop    %esi
801054ef:	5f                   	pop    %edi
801054f0:	5d                   	pop    %ebp
801054f1:	c3                   	ret    
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	56                   	push   %esi
801054fc:	e8 4f c5 ff ff       	call   80101a50 <iunlockput>
    goto bad;
80105501:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	53                   	push   %ebx
80105508:	e8 b3 c2 ff ff       	call   801017c0 <ilock>
  ip->nlink--;
8010550d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105512:	89 1c 24             	mov    %ebx,(%esp)
80105515:	e8 f6 c1 ff ff       	call   80101710 <iupdate>
  iunlockput(ip);
8010551a:	89 1c 24             	mov    %ebx,(%esp)
8010551d:	e8 2e c5 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105522:	e8 29 d8 ff ff       	call   80102d50 <end_op>
  return -1;
80105527:	83 c4 10             	add    $0x10,%esp
}
8010552a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010552d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105532:	5b                   	pop    %ebx
80105533:	5e                   	pop    %esi
80105534:	5f                   	pop    %edi
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
    iunlockput(ip);
80105537:	83 ec 0c             	sub    $0xc,%esp
8010553a:	53                   	push   %ebx
8010553b:	e8 10 c5 ff ff       	call   80101a50 <iunlockput>
    end_op();
80105540:	e8 0b d8 ff ff       	call   80102d50 <end_op>
    return -1;
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	eb 9b                	jmp    801054ea <sys_link+0xda>
    end_op();
8010554f:	e8 fc d7 ff ff       	call   80102d50 <end_op>
    return -1;
80105554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105559:	eb 8f                	jmp    801054ea <sys_link+0xda>
8010555b:	90                   	nop
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_unlink>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105566:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105569:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010556c:	50                   	push   %eax
8010556d:	6a 00                	push   $0x0
8010556f:	e8 2c f5 ff ff       	call   80104aa0 <argstr>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	0f 88 77 01 00 00    	js     801056f6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010557f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105582:	e8 59 d7 ff ff       	call   80102ce0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105587:	83 ec 08             	sub    $0x8,%esp
8010558a:	53                   	push   %ebx
8010558b:	ff 75 c0             	pushl  -0x40(%ebp)
8010558e:	e8 ad ca ff ff       	call   80102040 <nameiparent>
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	89 c6                	mov    %eax,%esi
8010559a:	0f 84 60 01 00 00    	je     80105700 <sys_unlink+0x1a0>
  ilock(dp);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	50                   	push   %eax
801055a4:	e8 17 c2 ff ff       	call   801017c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055a9:	58                   	pop    %eax
801055aa:	5a                   	pop    %edx
801055ab:	68 4c 80 10 80       	push   $0x8010804c
801055b0:	53                   	push   %ebx
801055b1:	e8 1a c7 ff ff       	call   80101cd0 <namecmp>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	0f 84 03 01 00 00    	je     801056c4 <sys_unlink+0x164>
801055c1:	83 ec 08             	sub    $0x8,%esp
801055c4:	68 4b 80 10 80       	push   $0x8010804b
801055c9:	53                   	push   %ebx
801055ca:	e8 01 c7 ff ff       	call   80101cd0 <namecmp>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	85 c0                	test   %eax,%eax
801055d4:	0f 84 ea 00 00 00    	je     801056c4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801055da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	50                   	push   %eax
801055e1:	53                   	push   %ebx
801055e2:	56                   	push   %esi
801055e3:	e8 08 c7 ff ff       	call   80101cf0 <dirlookup>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	89 c3                	mov    %eax,%ebx
801055ef:	0f 84 cf 00 00 00    	je     801056c4 <sys_unlink+0x164>
  ilock(ip);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	50                   	push   %eax
801055f9:	e8 c2 c1 ff ff       	call   801017c0 <ilock>
  if(ip->nlink < 1)
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105606:	0f 8e 10 01 00 00    	jle    8010571c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010560c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105611:	74 6d                	je     80105680 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105613:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105616:	83 ec 04             	sub    $0x4,%esp
80105619:	6a 10                	push   $0x10
8010561b:	6a 00                	push   $0x0
8010561d:	50                   	push   %eax
8010561e:	e8 cd f0 ff ff       	call   801046f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105623:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105626:	6a 10                	push   $0x10
80105628:	ff 75 c4             	pushl  -0x3c(%ebp)
8010562b:	50                   	push   %eax
8010562c:	56                   	push   %esi
8010562d:	e8 6e c5 ff ff       	call   80101ba0 <writei>
80105632:	83 c4 20             	add    $0x20,%esp
80105635:	83 f8 10             	cmp    $0x10,%eax
80105638:	0f 85 eb 00 00 00    	jne    80105729 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010563e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105643:	0f 84 97 00 00 00    	je     801056e0 <sys_unlink+0x180>
  iunlockput(dp);
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	56                   	push   %esi
8010564d:	e8 fe c3 ff ff       	call   80101a50 <iunlockput>
  ip->nlink--;
80105652:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105657:	89 1c 24             	mov    %ebx,(%esp)
8010565a:	e8 b1 c0 ff ff       	call   80101710 <iupdate>
  iunlockput(ip);
8010565f:	89 1c 24             	mov    %ebx,(%esp)
80105662:	e8 e9 c3 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105667:	e8 e4 d6 ff ff       	call   80102d50 <end_op>
  return 0;
8010566c:	83 c4 10             	add    $0x10,%esp
8010566f:	31 c0                	xor    %eax,%eax
}
80105671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105674:	5b                   	pop    %ebx
80105675:	5e                   	pop    %esi
80105676:	5f                   	pop    %edi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105680:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105684:	76 8d                	jbe    80105613 <sys_unlink+0xb3>
80105686:	bf 20 00 00 00       	mov    $0x20,%edi
8010568b:	eb 0f                	jmp    8010569c <sys_unlink+0x13c>
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
80105690:	83 c7 10             	add    $0x10,%edi
80105693:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105696:	0f 83 77 ff ff ff    	jae    80105613 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010569c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010569f:	6a 10                	push   $0x10
801056a1:	57                   	push   %edi
801056a2:	50                   	push   %eax
801056a3:	53                   	push   %ebx
801056a4:	e8 f7 c3 ff ff       	call   80101aa0 <readi>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	83 f8 10             	cmp    $0x10,%eax
801056af:	75 5e                	jne    8010570f <sys_unlink+0x1af>
    if(de.inum != 0)
801056b1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056b6:	74 d8                	je     80105690 <sys_unlink+0x130>
    iunlockput(ip);
801056b8:	83 ec 0c             	sub    $0xc,%esp
801056bb:	53                   	push   %ebx
801056bc:	e8 8f c3 ff ff       	call   80101a50 <iunlockput>
    goto bad;
801056c1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	56                   	push   %esi
801056c8:	e8 83 c3 ff ff       	call   80101a50 <iunlockput>
  end_op();
801056cd:	e8 7e d6 ff ff       	call   80102d50 <end_op>
  return -1;
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056da:	eb 95                	jmp    80105671 <sys_unlink+0x111>
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801056e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801056e5:	83 ec 0c             	sub    $0xc,%esp
801056e8:	56                   	push   %esi
801056e9:	e8 22 c0 ff ff       	call   80101710 <iupdate>
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	e9 53 ff ff ff       	jmp    80105649 <sys_unlink+0xe9>
    return -1;
801056f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fb:	e9 71 ff ff ff       	jmp    80105671 <sys_unlink+0x111>
    end_op();
80105700:	e8 4b d6 ff ff       	call   80102d50 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570a:	e9 62 ff ff ff       	jmp    80105671 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	68 70 80 10 80       	push   $0x80108070
80105717:	e8 74 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	68 5e 80 10 80       	push   $0x8010805e
80105724:	e8 67 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	68 82 80 10 80       	push   $0x80108082
80105731:	e8 5a ac ff ff       	call   80100390 <panic>
80105736:	8d 76 00             	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <sys_open>:

int
sys_open(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
80105745:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105746:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105749:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010574c:	50                   	push   %eax
8010574d:	6a 00                	push   $0x0
8010574f:	e8 4c f3 ff ff       	call   80104aa0 <argstr>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	0f 88 1d 01 00 00    	js     8010587c <sys_open+0x13c>
8010575f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105762:	83 ec 08             	sub    $0x8,%esp
80105765:	50                   	push   %eax
80105766:	6a 01                	push   $0x1
80105768:	e8 83 f2 ff ff       	call   801049f0 <argint>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	0f 88 04 01 00 00    	js     8010587c <sys_open+0x13c>
    return -1;

  begin_op();
80105778:	e8 63 d5 ff ff       	call   80102ce0 <begin_op>

  if(omode & O_CREATE){
8010577d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105781:	0f 85 a9 00 00 00    	jne    80105830 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105787:	83 ec 0c             	sub    $0xc,%esp
8010578a:	ff 75 e0             	pushl  -0x20(%ebp)
8010578d:	e8 8e c8 ff ff       	call   80102020 <namei>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	85 c0                	test   %eax,%eax
80105797:	89 c6                	mov    %eax,%esi
80105799:	0f 84 b2 00 00 00    	je     80105851 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010579f:	83 ec 0c             	sub    $0xc,%esp
801057a2:	50                   	push   %eax
801057a3:	e8 18 c0 ff ff       	call   801017c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057b0:	0f 84 aa 00 00 00    	je     80105860 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057b6:	e8 f5 b6 ff ff       	call   80100eb0 <filealloc>
801057bb:	85 c0                	test   %eax,%eax
801057bd:	89 c7                	mov    %eax,%edi
801057bf:	0f 84 a6 00 00 00    	je     8010586b <sys_open+0x12b>
  struct proc *curproc = myproc();
801057c5:	e8 56 e1 ff ff       	call   80103920 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ca:	31 db                	xor    %ebx,%ebx
801057cc:	eb 0e                	jmp    801057dc <sys_open+0x9c>
801057ce:	66 90                	xchg   %ax,%ax
801057d0:	83 c3 01             	add    $0x1,%ebx
801057d3:	83 fb 10             	cmp    $0x10,%ebx
801057d6:	0f 84 ac 00 00 00    	je     80105888 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801057dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e0:	85 d2                	test   %edx,%edx
801057e2:	75 ec                	jne    801057d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801057eb:	56                   	push   %esi
801057ec:	e8 af c0 ff ff       	call   801018a0 <iunlock>
  end_op();
801057f1:	e8 5a d5 ff ff       	call   80102d50 <end_op>

  f->type = FD_INODE;
801057f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105802:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105805:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010580c:	89 d0                	mov    %edx,%eax
8010580e:	f7 d0                	not    %eax
80105810:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105813:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105816:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105819:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010581d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105820:	89 d8                	mov    %ebx,%eax
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5f                   	pop    %edi
80105825:	5d                   	pop    %ebp
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105836:	31 c9                	xor    %ecx,%ecx
80105838:	6a 00                	push   $0x0
8010583a:	ba 02 00 00 00       	mov    $0x2,%edx
8010583f:	e8 ec f7 ff ff       	call   80105030 <create>
    if(ip == 0){
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105849:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010584b:	0f 85 65 ff ff ff    	jne    801057b6 <sys_open+0x76>
      end_op();
80105851:	e8 fa d4 ff ff       	call   80102d50 <end_op>
      return -1;
80105856:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010585b:	eb c0                	jmp    8010581d <sys_open+0xdd>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105860:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105863:	85 c9                	test   %ecx,%ecx
80105865:	0f 84 4b ff ff ff    	je     801057b6 <sys_open+0x76>
    iunlockput(ip);
8010586b:	83 ec 0c             	sub    $0xc,%esp
8010586e:	56                   	push   %esi
8010586f:	e8 dc c1 ff ff       	call   80101a50 <iunlockput>
    end_op();
80105874:	e8 d7 d4 ff ff       	call   80102d50 <end_op>
    return -1;
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105881:	eb 9a                	jmp    8010581d <sys_open+0xdd>
80105883:	90                   	nop
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	57                   	push   %edi
8010588c:	e8 df b6 ff ff       	call   80100f70 <fileclose>
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	eb d5                	jmp    8010586b <sys_open+0x12b>
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058a6:	e8 35 d4 ff ff       	call   80102ce0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ae:	83 ec 08             	sub    $0x8,%esp
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 e7 f1 ff ff       	call   80104aa0 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 30                	js     801058f0 <sys_mkdir+0x50>
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	31 c9                	xor    %ecx,%ecx
801058c8:	6a 00                	push   $0x0
801058ca:	ba 01 00 00 00       	mov    $0x1,%edx
801058cf:	e8 5c f7 ff ff       	call   80105030 <create>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	74 15                	je     801058f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058db:	83 ec 0c             	sub    $0xc,%esp
801058de:	50                   	push   %eax
801058df:	e8 6c c1 ff ff       	call   80101a50 <iunlockput>
  end_op();
801058e4:	e8 67 d4 ff ff       	call   80102d50 <end_op>
  return 0;
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	31 c0                	xor    %eax,%eax
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    
    end_op();
801058f0:	e8 5b d4 ff ff       	call   80102d50 <end_op>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_mknod>:

int
sys_mknod(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105906:	e8 d5 d3 ff ff       	call   80102ce0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010590b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010590e:	83 ec 08             	sub    $0x8,%esp
80105911:	50                   	push   %eax
80105912:	6a 00                	push   $0x0
80105914:	e8 87 f1 ff ff       	call   80104aa0 <argstr>
80105919:	83 c4 10             	add    $0x10,%esp
8010591c:	85 c0                	test   %eax,%eax
8010591e:	78 60                	js     80105980 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105920:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105923:	83 ec 08             	sub    $0x8,%esp
80105926:	50                   	push   %eax
80105927:	6a 01                	push   $0x1
80105929:	e8 c2 f0 ff ff       	call   801049f0 <argint>
  if((argstr(0, &path)) < 0 ||
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	78 4b                	js     80105980 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105935:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105938:	83 ec 08             	sub    $0x8,%esp
8010593b:	50                   	push   %eax
8010593c:	6a 02                	push   $0x2
8010593e:	e8 ad f0 ff ff       	call   801049f0 <argint>
     argint(1, &major) < 0 ||
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 36                	js     80105980 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010594a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010594e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105951:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105955:	ba 03 00 00 00       	mov    $0x3,%edx
8010595a:	50                   	push   %eax
8010595b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010595e:	e8 cd f6 ff ff       	call   80105030 <create>
80105963:	83 c4 10             	add    $0x10,%esp
80105966:	85 c0                	test   %eax,%eax
80105968:	74 16                	je     80105980 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010596a:	83 ec 0c             	sub    $0xc,%esp
8010596d:	50                   	push   %eax
8010596e:	e8 dd c0 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105973:	e8 d8 d3 ff ff       	call   80102d50 <end_op>
  return 0;
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	31 c0                	xor    %eax,%eax
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    
8010597f:	90                   	nop
    end_op();
80105980:	e8 cb d3 ff ff       	call   80102d50 <end_op>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_chdir>:

int
sys_chdir(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	53                   	push   %ebx
80105995:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105998:	e8 83 df ff ff       	call   80103920 <myproc>
8010599d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010599f:	e8 3c d3 ff ff       	call   80102ce0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 ee f0 ff ff       	call   80104aa0 <argstr>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 77                	js     80105a30 <sys_chdir+0xa0>
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f4             	pushl  -0xc(%ebp)
801059bf:	e8 5c c6 ff ff       	call   80102020 <namei>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	85 c0                	test   %eax,%eax
801059c9:	89 c3                	mov    %eax,%ebx
801059cb:	74 63                	je     80105a30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	50                   	push   %eax
801059d1:	e8 ea bd ff ff       	call   801017c0 <ilock>
  if(ip->type != T_DIR){
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059de:	75 30                	jne    80105a10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	53                   	push   %ebx
801059e4:	e8 b7 be ff ff       	call   801018a0 <iunlock>
  iput(curproc->cwd);
801059e9:	58                   	pop    %eax
801059ea:	ff 76 68             	pushl  0x68(%esi)
801059ed:	e8 fe be ff ff       	call   801018f0 <iput>
  end_op();
801059f2:	e8 59 d3 ff ff       	call   80102d50 <end_op>
  curproc->cwd = ip;
801059f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	31 c0                	xor    %eax,%eax
}
801059ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a02:	5b                   	pop    %ebx
80105a03:	5e                   	pop    %esi
80105a04:	5d                   	pop    %ebp
80105a05:	c3                   	ret    
80105a06:	8d 76 00             	lea    0x0(%esi),%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	53                   	push   %ebx
80105a14:	e8 37 c0 ff ff       	call   80101a50 <iunlockput>
    end_op();
80105a19:	e8 32 d3 ff ff       	call   80102d50 <end_op>
    return -1;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a26:	eb d7                	jmp    801059ff <sys_chdir+0x6f>
80105a28:	90                   	nop
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a30:	e8 1b d3 ff ff       	call   80102d50 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb c3                	jmp    801059ff <sys_chdir+0x6f>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exec>:

int
sys_exec(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a46:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a52:	50                   	push   %eax
80105a53:	6a 00                	push   $0x0
80105a55:	e8 46 f0 ff ff       	call   80104aa0 <argstr>
80105a5a:	83 c4 10             	add    $0x10,%esp
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	0f 88 87 00 00 00    	js     80105aec <sys_exec+0xac>
80105a65:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a6b:	83 ec 08             	sub    $0x8,%esp
80105a6e:	50                   	push   %eax
80105a6f:	6a 01                	push   $0x1
80105a71:	e8 7a ef ff ff       	call   801049f0 <argint>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	78 6f                	js     80105aec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a7d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a83:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105a86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a88:	68 80 00 00 00       	push   $0x80
80105a8d:	6a 00                	push   $0x0
80105a8f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a95:	50                   	push   %eax
80105a96:	e8 55 ec ff ff       	call   801046f0 <memset>
80105a9b:	83 c4 10             	add    $0x10,%esp
80105a9e:	eb 2c                	jmp    80105acc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105aa0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	74 56                	je     80105b00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105aaa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105ab6:	52                   	push   %edx
80105ab7:	50                   	push   %eax
80105ab8:	e8 c3 ee ff ff       	call   80104980 <fetchstr>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	78 28                	js     80105aec <sys_exec+0xac>
  for(i=0;; i++){
80105ac4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ac7:	83 fb 20             	cmp    $0x20,%ebx
80105aca:	74 20                	je     80105aec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105acc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ad2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ad9:	83 ec 08             	sub    $0x8,%esp
80105adc:	57                   	push   %edi
80105add:	01 f0                	add    %esi,%eax
80105adf:	50                   	push   %eax
80105ae0:	e8 5b ee ff ff       	call   80104940 <fetchint>
80105ae5:	83 c4 10             	add    $0x10,%esp
80105ae8:	85 c0                	test   %eax,%eax
80105aea:	79 b4                	jns    80105aa0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af4:	5b                   	pop    %ebx
80105af5:	5e                   	pop    %esi
80105af6:	5f                   	pop    %edi
80105af7:	5d                   	pop    %ebp
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b06:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105b09:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b10:	00 00 00 00 
  return exec(path, argv);
80105b14:	50                   	push   %eax
80105b15:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b1b:	e8 20 b0 ff ff       	call   80100b40 <exec>
80105b20:	83 c4 10             	add    $0x10,%esp
}
80105b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_pipe>:

int
sys_pipe(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
80105b35:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b36:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b3c:	6a 08                	push   $0x8
80105b3e:	50                   	push   %eax
80105b3f:	6a 00                	push   $0x0
80105b41:	e8 fa ee ff ff       	call   80104a40 <argptr>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	0f 88 ae 00 00 00    	js     80105bff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b54:	83 ec 08             	sub    $0x8,%esp
80105b57:	50                   	push   %eax
80105b58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b5b:	50                   	push   %eax
80105b5c:	e8 1f d8 ff ff       	call   80103380 <pipealloc>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	0f 88 93 00 00 00    	js     80105bff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b6c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b6f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b71:	e8 aa dd ff ff       	call   80103920 <myproc>
80105b76:	eb 10                	jmp    80105b88 <sys_pipe+0x58>
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b80:	83 c3 01             	add    $0x1,%ebx
80105b83:	83 fb 10             	cmp    $0x10,%ebx
80105b86:	74 60                	je     80105be8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105b88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b8c:	85 f6                	test   %esi,%esi
80105b8e:	75 f0                	jne    80105b80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b90:	8d 73 08             	lea    0x8(%ebx),%esi
80105b93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b9a:	e8 81 dd ff ff       	call   80103920 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b9f:	31 d2                	xor    %edx,%edx
80105ba1:	eb 0d                	jmp    80105bb0 <sys_pipe+0x80>
80105ba3:	90                   	nop
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ba8:	83 c2 01             	add    $0x1,%edx
80105bab:	83 fa 10             	cmp    $0x10,%edx
80105bae:	74 28                	je     80105bd8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105bb0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bb4:	85 c9                	test   %ecx,%ecx
80105bb6:	75 f0                	jne    80105ba8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105bb8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105bbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bbf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bc4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bc7:	31 c0                	xor    %eax,%eax
}
80105bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bcc:	5b                   	pop    %ebx
80105bcd:	5e                   	pop    %esi
80105bce:	5f                   	pop    %edi
80105bcf:	5d                   	pop    %ebp
80105bd0:	c3                   	ret    
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105bd8:	e8 43 dd ff ff       	call   80103920 <myproc>
80105bdd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105be4:	00 
80105be5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105be8:	83 ec 0c             	sub    $0xc,%esp
80105beb:	ff 75 e0             	pushl  -0x20(%ebp)
80105bee:	e8 7d b3 ff ff       	call   80100f70 <fileclose>
    fileclose(wf);
80105bf3:	58                   	pop    %eax
80105bf4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bf7:	e8 74 b3 ff ff       	call   80100f70 <fileclose>
    return -1;
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c04:	eb c3                	jmp    80105bc9 <sys_pipe+0x99>
80105c06:	66 90                	xchg   %ax,%ax
80105c08:	66 90                	xchg   %ax,%ax
80105c0a:	66 90                	xchg   %ax,%ax
80105c0c:	66 90                	xchg   %ax,%ax
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105c13:	5d                   	pop    %ebp
  return fork();
80105c14:	e9 a7 de ff ff       	jmp    80103ac0 <fork>
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <sys_exit>:

int
sys_exit(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c26:	e8 15 e1 ff ff       	call   80103d40 <exit>
  return 0;  // not reached
}
80105c2b:	31 c0                	xor    %eax,%eax
80105c2d:	c9                   	leave  
80105c2e:	c3                   	ret    
80105c2f:	90                   	nop

80105c30 <sys_wait>:

int
sys_wait(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c33:	5d                   	pop    %ebp
  return wait();
80105c34:	e9 47 e3 ff ff       	jmp    80103f80 <wait>
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_kill>:

int
sys_kill(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c49:	50                   	push   %eax
80105c4a:	6a 00                	push   $0x0
80105c4c:	e8 9f ed ff ff       	call   801049f0 <argint>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 18                	js     80105c70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c5e:	e8 fd e4 ff ff       	call   80104160 <kill>
80105c63:	83 c4 10             	add    $0x10,%esp
}
80105c66:	c9                   	leave  
80105c67:	c3                   	ret    
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <sys_getpid>:

int
sys_getpid(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c86:	e8 95 dc ff ff       	call   80103920 <myproc>
80105c8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c8e:	c9                   	leave  
80105c8f:	c3                   	ret    

80105c90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 4e ed ff ff       	call   801049f0 <argint>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	78 27                	js     80105cd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ca9:	e8 72 dc ff ff       	call   80103920 <myproc>
  if(growproc(n) < 0)
80105cae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105cb1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb6:	e8 85 dd ff ff       	call   80103a40 <growproc>
80105cbb:	83 c4 10             	add    $0x10,%esp
80105cbe:	85 c0                	test   %eax,%eax
80105cc0:	78 0e                	js     80105cd0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cc2:	89 d8                	mov    %ebx,%eax
80105cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cc7:	c9                   	leave  
80105cc8:	c3                   	ret    
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cd5:	eb eb                	jmp    80105cc2 <sys_sbrk+0x32>
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ce0 <sys_sleep>:

int
sys_sleep(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ce7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cea:	50                   	push   %eax
80105ceb:	6a 00                	push   $0x0
80105ced:	e8 fe ec ff ff       	call   801049f0 <argint>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	0f 88 8a 00 00 00    	js     80105d87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 a0 5c 11 80       	push   $0x80115ca0
80105d05:	e8 26 e8 ff ff       	call   80104530 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d0d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105d10:	8b 1d e0 64 11 80    	mov    0x801164e0,%ebx
  while(ticks - ticks0 < n){
80105d16:	85 d2                	test   %edx,%edx
80105d18:	75 27                	jne    80105d41 <sys_sleep+0x61>
80105d1a:	eb 54                	jmp    80105d70 <sys_sleep+0x90>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	68 a0 5c 11 80       	push   $0x80115ca0
80105d28:	68 e0 64 11 80       	push   $0x801164e0
80105d2d:	e8 8e e1 ff ff       	call   80103ec0 <sleep>
  while(ticks - ticks0 < n){
80105d32:	a1 e0 64 11 80       	mov    0x801164e0,%eax
80105d37:	83 c4 10             	add    $0x10,%esp
80105d3a:	29 d8                	sub    %ebx,%eax
80105d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d3f:	73 2f                	jae    80105d70 <sys_sleep+0x90>
    if(myproc()->killed){
80105d41:	e8 da db ff ff       	call   80103920 <myproc>
80105d46:	8b 40 24             	mov    0x24(%eax),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 d3                	je     80105d20 <sys_sleep+0x40>
      release(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 a0 5c 11 80       	push   $0x80115ca0
80105d55:	e8 96 e8 ff ff       	call   801045f0 <release>
      return -1;
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	68 a0 5c 11 80       	push   $0x80115ca0
80105d78:	e8 73 e8 ff ff       	call   801045f0 <release>
  return 0;
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	31 c0                	xor    %eax,%eax
}
80105d82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8c:	eb f4                	jmp    80105d82 <sys_sleep+0xa2>
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	53                   	push   %ebx
80105d94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d97:	68 a0 5c 11 80       	push   $0x80115ca0
80105d9c:	e8 8f e7 ff ff       	call   80104530 <acquire>
  xticks = ticks;
80105da1:	8b 1d e0 64 11 80    	mov    0x801164e0,%ebx
  release(&tickslock);
80105da7:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
80105dae:	e8 3d e8 ff ff       	call   801045f0 <release>
  return xticks;
}
80105db3:	89 d8                	mov    %ebx,%eax
80105db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db8:	c9                   	leave  
80105db9:	c3                   	ret    
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dc0 <sys_invoked_syscalls>:

extern void print_invoked_syscalls(uint pid);
int
sys_invoked_syscalls(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
80105dc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc9:	50                   	push   %eax
80105dca:	6a 00                	push   $0x0
80105dcc:	e8 1f ec ff ff       	call   801049f0 <argint>
  print_invoked_syscalls(pid);
80105dd1:	58                   	pop    %eax
80105dd2:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd5:	e8 86 ef ff ff       	call   80104d60 <print_invoked_syscalls>
  return 0;
}
80105dda:	31 c0                	xor    %eax,%eax
80105ddc:	c9                   	leave  
80105ddd:	c3                   	ret    
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_sort_syscalls>:

extern void my_sort_syscalls(uint pid);
int
sys_sort_syscalls(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
80105de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 00                	push   $0x0
80105dec:	e8 ff eb ff ff       	call   801049f0 <argint>
  my_sort_syscalls(pid);
80105df1:	58                   	pop    %eax
80105df2:	ff 75 f4             	pushl  -0xc(%ebp)
80105df5:	e8 46 f0 ff ff       	call   80104e40 <my_sort_syscalls>
  return 0;
}
80105dfa:	31 c0                	xor    %eax,%eax
80105dfc:	c9                   	leave  
80105dfd:	c3                   	ret    
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <sys_get_count>:

extern void my_get_count(uint pid, uint sysnum);
int
sys_get_count(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
80105e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e09:	50                   	push   %eax
80105e0a:	6a 00                	push   $0x0
80105e0c:	e8 df eb ff ff       	call   801049f0 <argint>
  int num;
  argint(1, &num);
80105e11:	58                   	pop    %eax
80105e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e15:	5a                   	pop    %edx
80105e16:	50                   	push   %eax
80105e17:	6a 01                	push   $0x1
80105e19:	e8 d2 eb ff ff       	call   801049f0 <argint>
  my_get_count(pid, num);
80105e1e:	59                   	pop    %ecx
80105e1f:	58                   	pop    %eax
80105e20:	ff 75 f4             	pushl  -0xc(%ebp)
80105e23:	ff 75 f0             	pushl  -0x10(%ebp)
80105e26:	e8 b5 f0 ff ff       	call   80104ee0 <my_get_count>
  return 0;
}
80105e2b:	31 c0                	xor    %eax,%eax
80105e2d:	c9                   	leave  
80105e2e:	c3                   	ret    
80105e2f:	90                   	nop

80105e30 <sys_log_syscalls>:

extern void my_log_syscalls(void);
int
sys_log_syscalls(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 08             	sub    $0x8,%esp
  my_log_syscalls();
80105e36:	e8 25 f1 ff ff       	call   80104f60 <my_log_syscalls>
  return 0;
}
80105e3b:	31 c0                	xor    %eax,%eax
80105e3d:	c9                   	leave  
80105e3e:	c3                   	ret    
80105e3f:	90                   	nop

80105e40 <sys_ticketlockinit>:

extern void my_ticketlockinit(void);
int
sys_ticketlockinit(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 08             	sub    $0x8,%esp
  my_ticketlockinit();
80105e46:	e8 85 f1 ff ff       	call   80104fd0 <my_ticketlockinit>
  return 0;
}
80105e4b:	31 c0                	xor    %eax,%eax
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    
80105e4f:	90                   	nop

80105e50 <sys_ticketlocktest>:

extern void my_ticketlocktest(void);
int
sys_ticketlocktest(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 08             	sub    $0x8,%esp
  my_ticketlocktest();
80105e56:	e8 a5 f1 ff ff       	call   80105000 <my_ticketlocktest>
  return 0;
}
80105e5b:	31 c0                	xor    %eax,%eax
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    

80105e5f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e5f:	1e                   	push   %ds
  pushl %es
80105e60:	06                   	push   %es
  pushl %fs
80105e61:	0f a0                	push   %fs
  pushl %gs
80105e63:	0f a8                	push   %gs
  pushal
80105e65:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e66:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e6a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e6c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e6e:	54                   	push   %esp
  call trap
80105e6f:	e8 cc 00 00 00       	call   80105f40 <trap>
  addl $4, %esp
80105e74:	83 c4 04             	add    $0x4,%esp

80105e77 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e77:	61                   	popa   
  popl %gs
80105e78:	0f a9                	pop    %gs
  popl %fs
80105e7a:	0f a1                	pop    %fs
  popl %es
80105e7c:	07                   	pop    %es
  popl %ds
80105e7d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e7e:	83 c4 08             	add    $0x8,%esp
  iret
80105e81:	cf                   	iret   
80105e82:	66 90                	xchg   %ax,%ax
80105e84:	66 90                	xchg   %ax,%ax
80105e86:	66 90                	xchg   %ax,%ax
80105e88:	66 90                	xchg   %ax,%ax
80105e8a:	66 90                	xchg   %ax,%ax
80105e8c:	66 90                	xchg   %ax,%ax
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e91:	31 c0                	xor    %eax,%eax
{
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	83 ec 08             	sub    $0x8,%esp
80105e98:	90                   	nop
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ea0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ea7:	c7 04 c5 e2 5c 11 80 	movl   $0x8e000008,-0x7feea31e(,%eax,8)
80105eae:	08 00 00 8e 
80105eb2:	66 89 14 c5 e0 5c 11 	mov    %dx,-0x7feea320(,%eax,8)
80105eb9:	80 
80105eba:	c1 ea 10             	shr    $0x10,%edx
80105ebd:	66 89 14 c5 e6 5c 11 	mov    %dx,-0x7feea31a(,%eax,8)
80105ec4:	80 
  for(i = 0; i < 256; i++)
80105ec5:	83 c0 01             	add    $0x1,%eax
80105ec8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ecd:	75 d1                	jne    80105ea0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ecf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ed4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ed7:	c7 05 e2 5e 11 80 08 	movl   $0xef000008,0x80115ee2
80105ede:	00 00 ef 
  initlock(&tickslock, "time");
80105ee1:	68 91 80 10 80       	push   $0x80108091
80105ee6:	68 a0 5c 11 80       	push   $0x80115ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105eeb:	66 a3 e0 5e 11 80    	mov    %ax,0x80115ee0
80105ef1:	c1 e8 10             	shr    $0x10,%eax
80105ef4:	66 a3 e6 5e 11 80    	mov    %ax,0x80115ee6
  initlock(&tickslock, "time");
80105efa:	e8 f1 e4 ff ff       	call   801043f0 <initlock>
}
80105eff:	83 c4 10             	add    $0x10,%esp
80105f02:	c9                   	leave  
80105f03:	c3                   	ret    
80105f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f10 <idtinit>:

void
idtinit(void)
{
80105f10:	55                   	push   %ebp
  pd[0] = size-1;
80105f11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f16:	89 e5                	mov    %esp,%ebp
80105f18:	83 ec 10             	sub    $0x10,%esp
80105f1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f1f:	b8 e0 5c 11 80       	mov    $0x80115ce0,%eax
80105f24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f28:	c1 e8 10             	shr    $0x10,%eax
80105f2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f35:	c9                   	leave  
80105f36:	c3                   	ret    
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
80105f46:	83 ec 1c             	sub    $0x1c,%esp
80105f49:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f4c:	8b 47 30             	mov    0x30(%edi),%eax
80105f4f:	83 f8 40             	cmp    $0x40,%eax
80105f52:	0f 84 f0 00 00 00    	je     80106048 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f58:	83 e8 20             	sub    $0x20,%eax
80105f5b:	83 f8 1f             	cmp    $0x1f,%eax
80105f5e:	77 10                	ja     80105f70 <trap+0x30>
80105f60:	ff 24 85 38 81 10 80 	jmp    *-0x7fef7ec8(,%eax,4)
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f70:	e8 ab d9 ff ff       	call   80103920 <myproc>
80105f75:	85 c0                	test   %eax,%eax
80105f77:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f7a:	0f 84 14 02 00 00    	je     80106194 <trap+0x254>
80105f80:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f84:	0f 84 0a 02 00 00    	je     80106194 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f8a:	0f 20 d1             	mov    %cr2,%ecx
80105f8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f90:	e8 6b d9 ff ff       	call   80103900 <cpuid>
80105f95:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f98:	8b 47 34             	mov    0x34(%edi),%eax
80105f9b:	8b 77 30             	mov    0x30(%edi),%esi
80105f9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fa1:	e8 7a d9 ff ff       	call   80103920 <myproc>
80105fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fa9:	e8 72 d9 ff ff       	call   80103920 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fb4:	51                   	push   %ecx
80105fb5:	53                   	push   %ebx
80105fb6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fba:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fbd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fbe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fc1:	52                   	push   %edx
80105fc2:	ff 70 10             	pushl  0x10(%eax)
80105fc5:	68 f4 80 10 80       	push   $0x801080f4
80105fca:	e8 41 a7 ff ff       	call   80100710 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fcf:	83 c4 20             	add    $0x20,%esp
80105fd2:	e8 49 d9 ff ff       	call   80103920 <myproc>
80105fd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fde:	e8 3d d9 ff ff       	call   80103920 <myproc>
80105fe3:	85 c0                	test   %eax,%eax
80105fe5:	74 1d                	je     80106004 <trap+0xc4>
80105fe7:	e8 34 d9 ff ff       	call   80103920 <myproc>
80105fec:	8b 50 24             	mov    0x24(%eax),%edx
80105fef:	85 d2                	test   %edx,%edx
80105ff1:	74 11                	je     80106004 <trap+0xc4>
80105ff3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ff7:	83 e0 03             	and    $0x3,%eax
80105ffa:	66 83 f8 03          	cmp    $0x3,%ax
80105ffe:	0f 84 4c 01 00 00    	je     80106150 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106004:	e8 17 d9 ff ff       	call   80103920 <myproc>
80106009:	85 c0                	test   %eax,%eax
8010600b:	74 0b                	je     80106018 <trap+0xd8>
8010600d:	e8 0e d9 ff ff       	call   80103920 <myproc>
80106012:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106016:	74 68                	je     80106080 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106018:	e8 03 d9 ff ff       	call   80103920 <myproc>
8010601d:	85 c0                	test   %eax,%eax
8010601f:	74 19                	je     8010603a <trap+0xfa>
80106021:	e8 fa d8 ff ff       	call   80103920 <myproc>
80106026:	8b 40 24             	mov    0x24(%eax),%eax
80106029:	85 c0                	test   %eax,%eax
8010602b:	74 0d                	je     8010603a <trap+0xfa>
8010602d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106031:	83 e0 03             	and    $0x3,%eax
80106034:	66 83 f8 03          	cmp    $0x3,%ax
80106038:	74 37                	je     80106071 <trap+0x131>
    exit();
}
8010603a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010603d:	5b                   	pop    %ebx
8010603e:	5e                   	pop    %esi
8010603f:	5f                   	pop    %edi
80106040:	5d                   	pop    %ebp
80106041:	c3                   	ret    
80106042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106048:	e8 d3 d8 ff ff       	call   80103920 <myproc>
8010604d:	8b 58 24             	mov    0x24(%eax),%ebx
80106050:	85 db                	test   %ebx,%ebx
80106052:	0f 85 e8 00 00 00    	jne    80106140 <trap+0x200>
    myproc()->tf = tf;
80106058:	e8 c3 d8 ff ff       	call   80103920 <myproc>
8010605d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106060:	e8 7b ec ff ff       	call   80104ce0 <syscall>
    if(myproc()->killed)
80106065:	e8 b6 d8 ff ff       	call   80103920 <myproc>
8010606a:	8b 48 24             	mov    0x24(%eax),%ecx
8010606d:	85 c9                	test   %ecx,%ecx
8010606f:	74 c9                	je     8010603a <trap+0xfa>
}
80106071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106074:	5b                   	pop    %ebx
80106075:	5e                   	pop    %esi
80106076:	5f                   	pop    %edi
80106077:	5d                   	pop    %ebp
      exit();
80106078:	e9 c3 dc ff ff       	jmp    80103d40 <exit>
8010607d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106080:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106084:	75 92                	jne    80106018 <trap+0xd8>
    yield();
80106086:	e8 e5 dd ff ff       	call   80103e70 <yield>
8010608b:	eb 8b                	jmp    80106018 <trap+0xd8>
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106090:	e8 6b d8 ff ff       	call   80103900 <cpuid>
80106095:	85 c0                	test   %eax,%eax
80106097:	0f 84 c3 00 00 00    	je     80106160 <trap+0x220>
    lapiceoi();
8010609d:	e8 ee c7 ff ff       	call   80102890 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060a2:	e8 79 d8 ff ff       	call   80103920 <myproc>
801060a7:	85 c0                	test   %eax,%eax
801060a9:	0f 85 38 ff ff ff    	jne    80105fe7 <trap+0xa7>
801060af:	e9 50 ff ff ff       	jmp    80106004 <trap+0xc4>
801060b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801060b8:	e8 93 c6 ff ff       	call   80102750 <kbdintr>
    lapiceoi();
801060bd:	e8 ce c7 ff ff       	call   80102890 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060c2:	e8 59 d8 ff ff       	call   80103920 <myproc>
801060c7:	85 c0                	test   %eax,%eax
801060c9:	0f 85 18 ff ff ff    	jne    80105fe7 <trap+0xa7>
801060cf:	e9 30 ff ff ff       	jmp    80106004 <trap+0xc4>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801060d8:	e8 53 02 00 00       	call   80106330 <uartintr>
    lapiceoi();
801060dd:	e8 ae c7 ff ff       	call   80102890 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060e2:	e8 39 d8 ff ff       	call   80103920 <myproc>
801060e7:	85 c0                	test   %eax,%eax
801060e9:	0f 85 f8 fe ff ff    	jne    80105fe7 <trap+0xa7>
801060ef:	e9 10 ff ff ff       	jmp    80106004 <trap+0xc4>
801060f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060f8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060fc:	8b 77 38             	mov    0x38(%edi),%esi
801060ff:	e8 fc d7 ff ff       	call   80103900 <cpuid>
80106104:	56                   	push   %esi
80106105:	53                   	push   %ebx
80106106:	50                   	push   %eax
80106107:	68 9c 80 10 80       	push   $0x8010809c
8010610c:	e8 ff a5 ff ff       	call   80100710 <cprintf>
    lapiceoi();
80106111:	e8 7a c7 ff ff       	call   80102890 <lapiceoi>
    break;
80106116:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106119:	e8 02 d8 ff ff       	call   80103920 <myproc>
8010611e:	85 c0                	test   %eax,%eax
80106120:	0f 85 c1 fe ff ff    	jne    80105fe7 <trap+0xa7>
80106126:	e9 d9 fe ff ff       	jmp    80106004 <trap+0xc4>
8010612b:	90                   	nop
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106130:	e8 8b c0 ff ff       	call   801021c0 <ideintr>
80106135:	e9 63 ff ff ff       	jmp    8010609d <trap+0x15d>
8010613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106140:	e8 fb db ff ff       	call   80103d40 <exit>
80106145:	e9 0e ff ff ff       	jmp    80106058 <trap+0x118>
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106150:	e8 eb db ff ff       	call   80103d40 <exit>
80106155:	e9 aa fe ff ff       	jmp    80106004 <trap+0xc4>
8010615a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	68 a0 5c 11 80       	push   $0x80115ca0
80106168:	e8 c3 e3 ff ff       	call   80104530 <acquire>
      wakeup(&ticks);
8010616d:	c7 04 24 e0 64 11 80 	movl   $0x801164e0,(%esp)
      ticks++;
80106174:	83 05 e0 64 11 80 01 	addl   $0x1,0x801164e0
      wakeup(&ticks);
8010617b:	e8 80 df ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80106180:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
80106187:	e8 64 e4 ff ff       	call   801045f0 <release>
8010618c:	83 c4 10             	add    $0x10,%esp
8010618f:	e9 09 ff ff ff       	jmp    8010609d <trap+0x15d>
80106194:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106197:	e8 64 d7 ff ff       	call   80103900 <cpuid>
8010619c:	83 ec 0c             	sub    $0xc,%esp
8010619f:	56                   	push   %esi
801061a0:	53                   	push   %ebx
801061a1:	50                   	push   %eax
801061a2:	ff 77 30             	pushl  0x30(%edi)
801061a5:	68 c0 80 10 80       	push   $0x801080c0
801061aa:	e8 61 a5 ff ff       	call   80100710 <cprintf>
      panic("trap");
801061af:	83 c4 14             	add    $0x14,%esp
801061b2:	68 96 80 10 80       	push   $0x80108096
801061b7:	e8 d4 a1 ff ff       	call   80100390 <panic>
801061bc:	66 90                	xchg   %ax,%ax
801061be:	66 90                	xchg   %ax,%ax

801061c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801061c0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
801061c5:	55                   	push   %ebp
801061c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061c8:	85 c0                	test   %eax,%eax
801061ca:	74 1c                	je     801061e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801061d2:	a8 01                	test   $0x1,%al
801061d4:	74 12                	je     801061e8 <uartgetc+0x28>
801061d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061db:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801061dc:	0f b6 c0             	movzbl %al,%eax
}
801061df:	5d                   	pop    %ebp
801061e0:	c3                   	ret    
801061e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ed:	5d                   	pop    %ebp
801061ee:	c3                   	ret    
801061ef:	90                   	nop

801061f0 <uartputc.part.0>:
uartputc(int c)
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	57                   	push   %edi
801061f4:	56                   	push   %esi
801061f5:	53                   	push   %ebx
801061f6:	89 c7                	mov    %eax,%edi
801061f8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106202:	83 ec 0c             	sub    $0xc,%esp
80106205:	eb 1b                	jmp    80106222 <uartputc.part.0+0x32>
80106207:	89 f6                	mov    %esi,%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	6a 0a                	push   $0xa
80106215:	e8 96 c6 ff ff       	call   801028b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010621a:	83 c4 10             	add    $0x10,%esp
8010621d:	83 eb 01             	sub    $0x1,%ebx
80106220:	74 07                	je     80106229 <uartputc.part.0+0x39>
80106222:	89 f2                	mov    %esi,%edx
80106224:	ec                   	in     (%dx),%al
80106225:	a8 20                	test   $0x20,%al
80106227:	74 e7                	je     80106210 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106229:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010622e:	89 f8                	mov    %edi,%eax
80106230:	ee                   	out    %al,(%dx)
}
80106231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106234:	5b                   	pop    %ebx
80106235:	5e                   	pop    %esi
80106236:	5f                   	pop    %edi
80106237:	5d                   	pop    %ebp
80106238:	c3                   	ret    
80106239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106240 <uartinit>:
{
80106240:	55                   	push   %ebp
80106241:	31 c9                	xor    %ecx,%ecx
80106243:	89 c8                	mov    %ecx,%eax
80106245:	89 e5                	mov    %esp,%ebp
80106247:	57                   	push   %edi
80106248:	56                   	push   %esi
80106249:	53                   	push   %ebx
8010624a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010624f:	89 da                	mov    %ebx,%edx
80106251:	83 ec 0c             	sub    $0xc,%esp
80106254:	ee                   	out    %al,(%dx)
80106255:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010625a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010625f:	89 fa                	mov    %edi,%edx
80106261:	ee                   	out    %al,(%dx)
80106262:	b8 0c 00 00 00       	mov    $0xc,%eax
80106267:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626c:	ee                   	out    %al,(%dx)
8010626d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106272:	89 c8                	mov    %ecx,%eax
80106274:	89 f2                	mov    %esi,%edx
80106276:	ee                   	out    %al,(%dx)
80106277:	b8 03 00 00 00       	mov    $0x3,%eax
8010627c:	89 fa                	mov    %edi,%edx
8010627e:	ee                   	out    %al,(%dx)
8010627f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106284:	89 c8                	mov    %ecx,%eax
80106286:	ee                   	out    %al,(%dx)
80106287:	b8 01 00 00 00       	mov    $0x1,%eax
8010628c:	89 f2                	mov    %esi,%edx
8010628e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010628f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106294:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106295:	3c ff                	cmp    $0xff,%al
80106297:	74 5a                	je     801062f3 <uartinit+0xb3>
  uart = 1;
80106299:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
801062a0:	00 00 00 
801062a3:	89 da                	mov    %ebx,%edx
801062a5:	ec                   	in     (%dx),%al
801062a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801062ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801062af:	bb b8 81 10 80       	mov    $0x801081b8,%ebx
  ioapicenable(IRQ_COM1, 0);
801062b4:	6a 00                	push   $0x0
801062b6:	6a 04                	push   $0x4
801062b8:	e8 53 c1 ff ff       	call   80102410 <ioapicenable>
801062bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801062c0:	b8 78 00 00 00       	mov    $0x78,%eax
801062c5:	eb 13                	jmp    801062da <uartinit+0x9a>
801062c7:	89 f6                	mov    %esi,%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062d0:	83 c3 01             	add    $0x1,%ebx
801062d3:	0f be 03             	movsbl (%ebx),%eax
801062d6:	84 c0                	test   %al,%al
801062d8:	74 19                	je     801062f3 <uartinit+0xb3>
  if(!uart)
801062da:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
801062e0:	85 d2                	test   %edx,%edx
801062e2:	74 ec                	je     801062d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801062e4:	83 c3 01             	add    $0x1,%ebx
801062e7:	e8 04 ff ff ff       	call   801061f0 <uartputc.part.0>
801062ec:	0f be 03             	movsbl (%ebx),%eax
801062ef:	84 c0                	test   %al,%al
801062f1:	75 e7                	jne    801062da <uartinit+0x9a>
}
801062f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f6:	5b                   	pop    %ebx
801062f7:	5e                   	pop    %esi
801062f8:	5f                   	pop    %edi
801062f9:	5d                   	pop    %ebp
801062fa:	c3                   	ret    
801062fb:	90                   	nop
801062fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106300 <uartputc>:
  if(!uart)
80106300:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
80106306:	55                   	push   %ebp
80106307:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106309:	85 d2                	test   %edx,%edx
{
8010630b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010630e:	74 10                	je     80106320 <uartputc+0x20>
}
80106310:	5d                   	pop    %ebp
80106311:	e9 da fe ff ff       	jmp    801061f0 <uartputc.part.0>
80106316:	8d 76 00             	lea    0x0(%esi),%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106320:	5d                   	pop    %ebp
80106321:	c3                   	ret    
80106322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106330 <uartintr>:

void
uartintr(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106336:	68 c0 61 10 80       	push   $0x801061c0
8010633b:	e8 80 a5 ff ff       	call   801008c0 <consoleintr>
}
80106340:	83 c4 10             	add    $0x10,%esp
80106343:	c9                   	leave  
80106344:	c3                   	ret    

80106345 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $0
80106347:	6a 00                	push   $0x0
  jmp alltraps
80106349:	e9 11 fb ff ff       	jmp    80105e5f <alltraps>

8010634e <vector1>:
.globl vector1
vector1:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $1
80106350:	6a 01                	push   $0x1
  jmp alltraps
80106352:	e9 08 fb ff ff       	jmp    80105e5f <alltraps>

80106357 <vector2>:
.globl vector2
vector2:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $2
80106359:	6a 02                	push   $0x2
  jmp alltraps
8010635b:	e9 ff fa ff ff       	jmp    80105e5f <alltraps>

80106360 <vector3>:
.globl vector3
vector3:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $3
80106362:	6a 03                	push   $0x3
  jmp alltraps
80106364:	e9 f6 fa ff ff       	jmp    80105e5f <alltraps>

80106369 <vector4>:
.globl vector4
vector4:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $4
8010636b:	6a 04                	push   $0x4
  jmp alltraps
8010636d:	e9 ed fa ff ff       	jmp    80105e5f <alltraps>

80106372 <vector5>:
.globl vector5
vector5:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $5
80106374:	6a 05                	push   $0x5
  jmp alltraps
80106376:	e9 e4 fa ff ff       	jmp    80105e5f <alltraps>

8010637b <vector6>:
.globl vector6
vector6:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $6
8010637d:	6a 06                	push   $0x6
  jmp alltraps
8010637f:	e9 db fa ff ff       	jmp    80105e5f <alltraps>

80106384 <vector7>:
.globl vector7
vector7:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $7
80106386:	6a 07                	push   $0x7
  jmp alltraps
80106388:	e9 d2 fa ff ff       	jmp    80105e5f <alltraps>

8010638d <vector8>:
.globl vector8
vector8:
  pushl $8
8010638d:	6a 08                	push   $0x8
  jmp alltraps
8010638f:	e9 cb fa ff ff       	jmp    80105e5f <alltraps>

80106394 <vector9>:
.globl vector9
vector9:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $9
80106396:	6a 09                	push   $0x9
  jmp alltraps
80106398:	e9 c2 fa ff ff       	jmp    80105e5f <alltraps>

8010639d <vector10>:
.globl vector10
vector10:
  pushl $10
8010639d:	6a 0a                	push   $0xa
  jmp alltraps
8010639f:	e9 bb fa ff ff       	jmp    80105e5f <alltraps>

801063a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063a4:	6a 0b                	push   $0xb
  jmp alltraps
801063a6:	e9 b4 fa ff ff       	jmp    80105e5f <alltraps>

801063ab <vector12>:
.globl vector12
vector12:
  pushl $12
801063ab:	6a 0c                	push   $0xc
  jmp alltraps
801063ad:	e9 ad fa ff ff       	jmp    80105e5f <alltraps>

801063b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801063b2:	6a 0d                	push   $0xd
  jmp alltraps
801063b4:	e9 a6 fa ff ff       	jmp    80105e5f <alltraps>

801063b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801063b9:	6a 0e                	push   $0xe
  jmp alltraps
801063bb:	e9 9f fa ff ff       	jmp    80105e5f <alltraps>

801063c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $15
801063c2:	6a 0f                	push   $0xf
  jmp alltraps
801063c4:	e9 96 fa ff ff       	jmp    80105e5f <alltraps>

801063c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $16
801063cb:	6a 10                	push   $0x10
  jmp alltraps
801063cd:	e9 8d fa ff ff       	jmp    80105e5f <alltraps>

801063d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801063d2:	6a 11                	push   $0x11
  jmp alltraps
801063d4:	e9 86 fa ff ff       	jmp    80105e5f <alltraps>

801063d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $18
801063db:	6a 12                	push   $0x12
  jmp alltraps
801063dd:	e9 7d fa ff ff       	jmp    80105e5f <alltraps>

801063e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $19
801063e4:	6a 13                	push   $0x13
  jmp alltraps
801063e6:	e9 74 fa ff ff       	jmp    80105e5f <alltraps>

801063eb <vector20>:
.globl vector20
vector20:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $20
801063ed:	6a 14                	push   $0x14
  jmp alltraps
801063ef:	e9 6b fa ff ff       	jmp    80105e5f <alltraps>

801063f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $21
801063f6:	6a 15                	push   $0x15
  jmp alltraps
801063f8:	e9 62 fa ff ff       	jmp    80105e5f <alltraps>

801063fd <vector22>:
.globl vector22
vector22:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $22
801063ff:	6a 16                	push   $0x16
  jmp alltraps
80106401:	e9 59 fa ff ff       	jmp    80105e5f <alltraps>

80106406 <vector23>:
.globl vector23
vector23:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $23
80106408:	6a 17                	push   $0x17
  jmp alltraps
8010640a:	e9 50 fa ff ff       	jmp    80105e5f <alltraps>

8010640f <vector24>:
.globl vector24
vector24:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $24
80106411:	6a 18                	push   $0x18
  jmp alltraps
80106413:	e9 47 fa ff ff       	jmp    80105e5f <alltraps>

80106418 <vector25>:
.globl vector25
vector25:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $25
8010641a:	6a 19                	push   $0x19
  jmp alltraps
8010641c:	e9 3e fa ff ff       	jmp    80105e5f <alltraps>

80106421 <vector26>:
.globl vector26
vector26:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $26
80106423:	6a 1a                	push   $0x1a
  jmp alltraps
80106425:	e9 35 fa ff ff       	jmp    80105e5f <alltraps>

8010642a <vector27>:
.globl vector27
vector27:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $27
8010642c:	6a 1b                	push   $0x1b
  jmp alltraps
8010642e:	e9 2c fa ff ff       	jmp    80105e5f <alltraps>

80106433 <vector28>:
.globl vector28
vector28:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $28
80106435:	6a 1c                	push   $0x1c
  jmp alltraps
80106437:	e9 23 fa ff ff       	jmp    80105e5f <alltraps>

8010643c <vector29>:
.globl vector29
vector29:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $29
8010643e:	6a 1d                	push   $0x1d
  jmp alltraps
80106440:	e9 1a fa ff ff       	jmp    80105e5f <alltraps>

80106445 <vector30>:
.globl vector30
vector30:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $30
80106447:	6a 1e                	push   $0x1e
  jmp alltraps
80106449:	e9 11 fa ff ff       	jmp    80105e5f <alltraps>

8010644e <vector31>:
.globl vector31
vector31:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $31
80106450:	6a 1f                	push   $0x1f
  jmp alltraps
80106452:	e9 08 fa ff ff       	jmp    80105e5f <alltraps>

80106457 <vector32>:
.globl vector32
vector32:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $32
80106459:	6a 20                	push   $0x20
  jmp alltraps
8010645b:	e9 ff f9 ff ff       	jmp    80105e5f <alltraps>

80106460 <vector33>:
.globl vector33
vector33:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $33
80106462:	6a 21                	push   $0x21
  jmp alltraps
80106464:	e9 f6 f9 ff ff       	jmp    80105e5f <alltraps>

80106469 <vector34>:
.globl vector34
vector34:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $34
8010646b:	6a 22                	push   $0x22
  jmp alltraps
8010646d:	e9 ed f9 ff ff       	jmp    80105e5f <alltraps>

80106472 <vector35>:
.globl vector35
vector35:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $35
80106474:	6a 23                	push   $0x23
  jmp alltraps
80106476:	e9 e4 f9 ff ff       	jmp    80105e5f <alltraps>

8010647b <vector36>:
.globl vector36
vector36:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $36
8010647d:	6a 24                	push   $0x24
  jmp alltraps
8010647f:	e9 db f9 ff ff       	jmp    80105e5f <alltraps>

80106484 <vector37>:
.globl vector37
vector37:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $37
80106486:	6a 25                	push   $0x25
  jmp alltraps
80106488:	e9 d2 f9 ff ff       	jmp    80105e5f <alltraps>

8010648d <vector38>:
.globl vector38
vector38:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $38
8010648f:	6a 26                	push   $0x26
  jmp alltraps
80106491:	e9 c9 f9 ff ff       	jmp    80105e5f <alltraps>

80106496 <vector39>:
.globl vector39
vector39:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $39
80106498:	6a 27                	push   $0x27
  jmp alltraps
8010649a:	e9 c0 f9 ff ff       	jmp    80105e5f <alltraps>

8010649f <vector40>:
.globl vector40
vector40:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $40
801064a1:	6a 28                	push   $0x28
  jmp alltraps
801064a3:	e9 b7 f9 ff ff       	jmp    80105e5f <alltraps>

801064a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $41
801064aa:	6a 29                	push   $0x29
  jmp alltraps
801064ac:	e9 ae f9 ff ff       	jmp    80105e5f <alltraps>

801064b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $42
801064b3:	6a 2a                	push   $0x2a
  jmp alltraps
801064b5:	e9 a5 f9 ff ff       	jmp    80105e5f <alltraps>

801064ba <vector43>:
.globl vector43
vector43:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $43
801064bc:	6a 2b                	push   $0x2b
  jmp alltraps
801064be:	e9 9c f9 ff ff       	jmp    80105e5f <alltraps>

801064c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $44
801064c5:	6a 2c                	push   $0x2c
  jmp alltraps
801064c7:	e9 93 f9 ff ff       	jmp    80105e5f <alltraps>

801064cc <vector45>:
.globl vector45
vector45:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $45
801064ce:	6a 2d                	push   $0x2d
  jmp alltraps
801064d0:	e9 8a f9 ff ff       	jmp    80105e5f <alltraps>

801064d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $46
801064d7:	6a 2e                	push   $0x2e
  jmp alltraps
801064d9:	e9 81 f9 ff ff       	jmp    80105e5f <alltraps>

801064de <vector47>:
.globl vector47
vector47:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $47
801064e0:	6a 2f                	push   $0x2f
  jmp alltraps
801064e2:	e9 78 f9 ff ff       	jmp    80105e5f <alltraps>

801064e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $48
801064e9:	6a 30                	push   $0x30
  jmp alltraps
801064eb:	e9 6f f9 ff ff       	jmp    80105e5f <alltraps>

801064f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $49
801064f2:	6a 31                	push   $0x31
  jmp alltraps
801064f4:	e9 66 f9 ff ff       	jmp    80105e5f <alltraps>

801064f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $50
801064fb:	6a 32                	push   $0x32
  jmp alltraps
801064fd:	e9 5d f9 ff ff       	jmp    80105e5f <alltraps>

80106502 <vector51>:
.globl vector51
vector51:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $51
80106504:	6a 33                	push   $0x33
  jmp alltraps
80106506:	e9 54 f9 ff ff       	jmp    80105e5f <alltraps>

8010650b <vector52>:
.globl vector52
vector52:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $52
8010650d:	6a 34                	push   $0x34
  jmp alltraps
8010650f:	e9 4b f9 ff ff       	jmp    80105e5f <alltraps>

80106514 <vector53>:
.globl vector53
vector53:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $53
80106516:	6a 35                	push   $0x35
  jmp alltraps
80106518:	e9 42 f9 ff ff       	jmp    80105e5f <alltraps>

8010651d <vector54>:
.globl vector54
vector54:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $54
8010651f:	6a 36                	push   $0x36
  jmp alltraps
80106521:	e9 39 f9 ff ff       	jmp    80105e5f <alltraps>

80106526 <vector55>:
.globl vector55
vector55:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $55
80106528:	6a 37                	push   $0x37
  jmp alltraps
8010652a:	e9 30 f9 ff ff       	jmp    80105e5f <alltraps>

8010652f <vector56>:
.globl vector56
vector56:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $56
80106531:	6a 38                	push   $0x38
  jmp alltraps
80106533:	e9 27 f9 ff ff       	jmp    80105e5f <alltraps>

80106538 <vector57>:
.globl vector57
vector57:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $57
8010653a:	6a 39                	push   $0x39
  jmp alltraps
8010653c:	e9 1e f9 ff ff       	jmp    80105e5f <alltraps>

80106541 <vector58>:
.globl vector58
vector58:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $58
80106543:	6a 3a                	push   $0x3a
  jmp alltraps
80106545:	e9 15 f9 ff ff       	jmp    80105e5f <alltraps>

8010654a <vector59>:
.globl vector59
vector59:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $59
8010654c:	6a 3b                	push   $0x3b
  jmp alltraps
8010654e:	e9 0c f9 ff ff       	jmp    80105e5f <alltraps>

80106553 <vector60>:
.globl vector60
vector60:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $60
80106555:	6a 3c                	push   $0x3c
  jmp alltraps
80106557:	e9 03 f9 ff ff       	jmp    80105e5f <alltraps>

8010655c <vector61>:
.globl vector61
vector61:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $61
8010655e:	6a 3d                	push   $0x3d
  jmp alltraps
80106560:	e9 fa f8 ff ff       	jmp    80105e5f <alltraps>

80106565 <vector62>:
.globl vector62
vector62:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $62
80106567:	6a 3e                	push   $0x3e
  jmp alltraps
80106569:	e9 f1 f8 ff ff       	jmp    80105e5f <alltraps>

8010656e <vector63>:
.globl vector63
vector63:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $63
80106570:	6a 3f                	push   $0x3f
  jmp alltraps
80106572:	e9 e8 f8 ff ff       	jmp    80105e5f <alltraps>

80106577 <vector64>:
.globl vector64
vector64:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $64
80106579:	6a 40                	push   $0x40
  jmp alltraps
8010657b:	e9 df f8 ff ff       	jmp    80105e5f <alltraps>

80106580 <vector65>:
.globl vector65
vector65:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $65
80106582:	6a 41                	push   $0x41
  jmp alltraps
80106584:	e9 d6 f8 ff ff       	jmp    80105e5f <alltraps>

80106589 <vector66>:
.globl vector66
vector66:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $66
8010658b:	6a 42                	push   $0x42
  jmp alltraps
8010658d:	e9 cd f8 ff ff       	jmp    80105e5f <alltraps>

80106592 <vector67>:
.globl vector67
vector67:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $67
80106594:	6a 43                	push   $0x43
  jmp alltraps
80106596:	e9 c4 f8 ff ff       	jmp    80105e5f <alltraps>

8010659b <vector68>:
.globl vector68
vector68:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $68
8010659d:	6a 44                	push   $0x44
  jmp alltraps
8010659f:	e9 bb f8 ff ff       	jmp    80105e5f <alltraps>

801065a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $69
801065a6:	6a 45                	push   $0x45
  jmp alltraps
801065a8:	e9 b2 f8 ff ff       	jmp    80105e5f <alltraps>

801065ad <vector70>:
.globl vector70
vector70:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $70
801065af:	6a 46                	push   $0x46
  jmp alltraps
801065b1:	e9 a9 f8 ff ff       	jmp    80105e5f <alltraps>

801065b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $71
801065b8:	6a 47                	push   $0x47
  jmp alltraps
801065ba:	e9 a0 f8 ff ff       	jmp    80105e5f <alltraps>

801065bf <vector72>:
.globl vector72
vector72:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $72
801065c1:	6a 48                	push   $0x48
  jmp alltraps
801065c3:	e9 97 f8 ff ff       	jmp    80105e5f <alltraps>

801065c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $73
801065ca:	6a 49                	push   $0x49
  jmp alltraps
801065cc:	e9 8e f8 ff ff       	jmp    80105e5f <alltraps>

801065d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $74
801065d3:	6a 4a                	push   $0x4a
  jmp alltraps
801065d5:	e9 85 f8 ff ff       	jmp    80105e5f <alltraps>

801065da <vector75>:
.globl vector75
vector75:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $75
801065dc:	6a 4b                	push   $0x4b
  jmp alltraps
801065de:	e9 7c f8 ff ff       	jmp    80105e5f <alltraps>

801065e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $76
801065e5:	6a 4c                	push   $0x4c
  jmp alltraps
801065e7:	e9 73 f8 ff ff       	jmp    80105e5f <alltraps>

801065ec <vector77>:
.globl vector77
vector77:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $77
801065ee:	6a 4d                	push   $0x4d
  jmp alltraps
801065f0:	e9 6a f8 ff ff       	jmp    80105e5f <alltraps>

801065f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $78
801065f7:	6a 4e                	push   $0x4e
  jmp alltraps
801065f9:	e9 61 f8 ff ff       	jmp    80105e5f <alltraps>

801065fe <vector79>:
.globl vector79
vector79:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $79
80106600:	6a 4f                	push   $0x4f
  jmp alltraps
80106602:	e9 58 f8 ff ff       	jmp    80105e5f <alltraps>

80106607 <vector80>:
.globl vector80
vector80:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $80
80106609:	6a 50                	push   $0x50
  jmp alltraps
8010660b:	e9 4f f8 ff ff       	jmp    80105e5f <alltraps>

80106610 <vector81>:
.globl vector81
vector81:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $81
80106612:	6a 51                	push   $0x51
  jmp alltraps
80106614:	e9 46 f8 ff ff       	jmp    80105e5f <alltraps>

80106619 <vector82>:
.globl vector82
vector82:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $82
8010661b:	6a 52                	push   $0x52
  jmp alltraps
8010661d:	e9 3d f8 ff ff       	jmp    80105e5f <alltraps>

80106622 <vector83>:
.globl vector83
vector83:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $83
80106624:	6a 53                	push   $0x53
  jmp alltraps
80106626:	e9 34 f8 ff ff       	jmp    80105e5f <alltraps>

8010662b <vector84>:
.globl vector84
vector84:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $84
8010662d:	6a 54                	push   $0x54
  jmp alltraps
8010662f:	e9 2b f8 ff ff       	jmp    80105e5f <alltraps>

80106634 <vector85>:
.globl vector85
vector85:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $85
80106636:	6a 55                	push   $0x55
  jmp alltraps
80106638:	e9 22 f8 ff ff       	jmp    80105e5f <alltraps>

8010663d <vector86>:
.globl vector86
vector86:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $86
8010663f:	6a 56                	push   $0x56
  jmp alltraps
80106641:	e9 19 f8 ff ff       	jmp    80105e5f <alltraps>

80106646 <vector87>:
.globl vector87
vector87:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $87
80106648:	6a 57                	push   $0x57
  jmp alltraps
8010664a:	e9 10 f8 ff ff       	jmp    80105e5f <alltraps>

8010664f <vector88>:
.globl vector88
vector88:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $88
80106651:	6a 58                	push   $0x58
  jmp alltraps
80106653:	e9 07 f8 ff ff       	jmp    80105e5f <alltraps>

80106658 <vector89>:
.globl vector89
vector89:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $89
8010665a:	6a 59                	push   $0x59
  jmp alltraps
8010665c:	e9 fe f7 ff ff       	jmp    80105e5f <alltraps>

80106661 <vector90>:
.globl vector90
vector90:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $90
80106663:	6a 5a                	push   $0x5a
  jmp alltraps
80106665:	e9 f5 f7 ff ff       	jmp    80105e5f <alltraps>

8010666a <vector91>:
.globl vector91
vector91:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $91
8010666c:	6a 5b                	push   $0x5b
  jmp alltraps
8010666e:	e9 ec f7 ff ff       	jmp    80105e5f <alltraps>

80106673 <vector92>:
.globl vector92
vector92:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $92
80106675:	6a 5c                	push   $0x5c
  jmp alltraps
80106677:	e9 e3 f7 ff ff       	jmp    80105e5f <alltraps>

8010667c <vector93>:
.globl vector93
vector93:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $93
8010667e:	6a 5d                	push   $0x5d
  jmp alltraps
80106680:	e9 da f7 ff ff       	jmp    80105e5f <alltraps>

80106685 <vector94>:
.globl vector94
vector94:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $94
80106687:	6a 5e                	push   $0x5e
  jmp alltraps
80106689:	e9 d1 f7 ff ff       	jmp    80105e5f <alltraps>

8010668e <vector95>:
.globl vector95
vector95:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $95
80106690:	6a 5f                	push   $0x5f
  jmp alltraps
80106692:	e9 c8 f7 ff ff       	jmp    80105e5f <alltraps>

80106697 <vector96>:
.globl vector96
vector96:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $96
80106699:	6a 60                	push   $0x60
  jmp alltraps
8010669b:	e9 bf f7 ff ff       	jmp    80105e5f <alltraps>

801066a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $97
801066a2:	6a 61                	push   $0x61
  jmp alltraps
801066a4:	e9 b6 f7 ff ff       	jmp    80105e5f <alltraps>

801066a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $98
801066ab:	6a 62                	push   $0x62
  jmp alltraps
801066ad:	e9 ad f7 ff ff       	jmp    80105e5f <alltraps>

801066b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $99
801066b4:	6a 63                	push   $0x63
  jmp alltraps
801066b6:	e9 a4 f7 ff ff       	jmp    80105e5f <alltraps>

801066bb <vector100>:
.globl vector100
vector100:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $100
801066bd:	6a 64                	push   $0x64
  jmp alltraps
801066bf:	e9 9b f7 ff ff       	jmp    80105e5f <alltraps>

801066c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $101
801066c6:	6a 65                	push   $0x65
  jmp alltraps
801066c8:	e9 92 f7 ff ff       	jmp    80105e5f <alltraps>

801066cd <vector102>:
.globl vector102
vector102:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $102
801066cf:	6a 66                	push   $0x66
  jmp alltraps
801066d1:	e9 89 f7 ff ff       	jmp    80105e5f <alltraps>

801066d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $103
801066d8:	6a 67                	push   $0x67
  jmp alltraps
801066da:	e9 80 f7 ff ff       	jmp    80105e5f <alltraps>

801066df <vector104>:
.globl vector104
vector104:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $104
801066e1:	6a 68                	push   $0x68
  jmp alltraps
801066e3:	e9 77 f7 ff ff       	jmp    80105e5f <alltraps>

801066e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $105
801066ea:	6a 69                	push   $0x69
  jmp alltraps
801066ec:	e9 6e f7 ff ff       	jmp    80105e5f <alltraps>

801066f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $106
801066f3:	6a 6a                	push   $0x6a
  jmp alltraps
801066f5:	e9 65 f7 ff ff       	jmp    80105e5f <alltraps>

801066fa <vector107>:
.globl vector107
vector107:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $107
801066fc:	6a 6b                	push   $0x6b
  jmp alltraps
801066fe:	e9 5c f7 ff ff       	jmp    80105e5f <alltraps>

80106703 <vector108>:
.globl vector108
vector108:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $108
80106705:	6a 6c                	push   $0x6c
  jmp alltraps
80106707:	e9 53 f7 ff ff       	jmp    80105e5f <alltraps>

8010670c <vector109>:
.globl vector109
vector109:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $109
8010670e:	6a 6d                	push   $0x6d
  jmp alltraps
80106710:	e9 4a f7 ff ff       	jmp    80105e5f <alltraps>

80106715 <vector110>:
.globl vector110
vector110:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $110
80106717:	6a 6e                	push   $0x6e
  jmp alltraps
80106719:	e9 41 f7 ff ff       	jmp    80105e5f <alltraps>

8010671e <vector111>:
.globl vector111
vector111:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $111
80106720:	6a 6f                	push   $0x6f
  jmp alltraps
80106722:	e9 38 f7 ff ff       	jmp    80105e5f <alltraps>

80106727 <vector112>:
.globl vector112
vector112:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $112
80106729:	6a 70                	push   $0x70
  jmp alltraps
8010672b:	e9 2f f7 ff ff       	jmp    80105e5f <alltraps>

80106730 <vector113>:
.globl vector113
vector113:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $113
80106732:	6a 71                	push   $0x71
  jmp alltraps
80106734:	e9 26 f7 ff ff       	jmp    80105e5f <alltraps>

80106739 <vector114>:
.globl vector114
vector114:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $114
8010673b:	6a 72                	push   $0x72
  jmp alltraps
8010673d:	e9 1d f7 ff ff       	jmp    80105e5f <alltraps>

80106742 <vector115>:
.globl vector115
vector115:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $115
80106744:	6a 73                	push   $0x73
  jmp alltraps
80106746:	e9 14 f7 ff ff       	jmp    80105e5f <alltraps>

8010674b <vector116>:
.globl vector116
vector116:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $116
8010674d:	6a 74                	push   $0x74
  jmp alltraps
8010674f:	e9 0b f7 ff ff       	jmp    80105e5f <alltraps>

80106754 <vector117>:
.globl vector117
vector117:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $117
80106756:	6a 75                	push   $0x75
  jmp alltraps
80106758:	e9 02 f7 ff ff       	jmp    80105e5f <alltraps>

8010675d <vector118>:
.globl vector118
vector118:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $118
8010675f:	6a 76                	push   $0x76
  jmp alltraps
80106761:	e9 f9 f6 ff ff       	jmp    80105e5f <alltraps>

80106766 <vector119>:
.globl vector119
vector119:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $119
80106768:	6a 77                	push   $0x77
  jmp alltraps
8010676a:	e9 f0 f6 ff ff       	jmp    80105e5f <alltraps>

8010676f <vector120>:
.globl vector120
vector120:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $120
80106771:	6a 78                	push   $0x78
  jmp alltraps
80106773:	e9 e7 f6 ff ff       	jmp    80105e5f <alltraps>

80106778 <vector121>:
.globl vector121
vector121:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $121
8010677a:	6a 79                	push   $0x79
  jmp alltraps
8010677c:	e9 de f6 ff ff       	jmp    80105e5f <alltraps>

80106781 <vector122>:
.globl vector122
vector122:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $122
80106783:	6a 7a                	push   $0x7a
  jmp alltraps
80106785:	e9 d5 f6 ff ff       	jmp    80105e5f <alltraps>

8010678a <vector123>:
.globl vector123
vector123:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $123
8010678c:	6a 7b                	push   $0x7b
  jmp alltraps
8010678e:	e9 cc f6 ff ff       	jmp    80105e5f <alltraps>

80106793 <vector124>:
.globl vector124
vector124:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $124
80106795:	6a 7c                	push   $0x7c
  jmp alltraps
80106797:	e9 c3 f6 ff ff       	jmp    80105e5f <alltraps>

8010679c <vector125>:
.globl vector125
vector125:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $125
8010679e:	6a 7d                	push   $0x7d
  jmp alltraps
801067a0:	e9 ba f6 ff ff       	jmp    80105e5f <alltraps>

801067a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $126
801067a7:	6a 7e                	push   $0x7e
  jmp alltraps
801067a9:	e9 b1 f6 ff ff       	jmp    80105e5f <alltraps>

801067ae <vector127>:
.globl vector127
vector127:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $127
801067b0:	6a 7f                	push   $0x7f
  jmp alltraps
801067b2:	e9 a8 f6 ff ff       	jmp    80105e5f <alltraps>

801067b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $128
801067b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067be:	e9 9c f6 ff ff       	jmp    80105e5f <alltraps>

801067c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $129
801067c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801067ca:	e9 90 f6 ff ff       	jmp    80105e5f <alltraps>

801067cf <vector130>:
.globl vector130
vector130:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $130
801067d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801067d6:	e9 84 f6 ff ff       	jmp    80105e5f <alltraps>

801067db <vector131>:
.globl vector131
vector131:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $131
801067dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067e2:	e9 78 f6 ff ff       	jmp    80105e5f <alltraps>

801067e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $132
801067e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067ee:	e9 6c f6 ff ff       	jmp    80105e5f <alltraps>

801067f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $133
801067f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067fa:	e9 60 f6 ff ff       	jmp    80105e5f <alltraps>

801067ff <vector134>:
.globl vector134
vector134:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $134
80106801:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106806:	e9 54 f6 ff ff       	jmp    80105e5f <alltraps>

8010680b <vector135>:
.globl vector135
vector135:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $135
8010680d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106812:	e9 48 f6 ff ff       	jmp    80105e5f <alltraps>

80106817 <vector136>:
.globl vector136
vector136:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $136
80106819:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010681e:	e9 3c f6 ff ff       	jmp    80105e5f <alltraps>

80106823 <vector137>:
.globl vector137
vector137:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $137
80106825:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010682a:	e9 30 f6 ff ff       	jmp    80105e5f <alltraps>

8010682f <vector138>:
.globl vector138
vector138:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $138
80106831:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106836:	e9 24 f6 ff ff       	jmp    80105e5f <alltraps>

8010683b <vector139>:
.globl vector139
vector139:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $139
8010683d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106842:	e9 18 f6 ff ff       	jmp    80105e5f <alltraps>

80106847 <vector140>:
.globl vector140
vector140:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $140
80106849:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010684e:	e9 0c f6 ff ff       	jmp    80105e5f <alltraps>

80106853 <vector141>:
.globl vector141
vector141:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $141
80106855:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010685a:	e9 00 f6 ff ff       	jmp    80105e5f <alltraps>

8010685f <vector142>:
.globl vector142
vector142:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $142
80106861:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106866:	e9 f4 f5 ff ff       	jmp    80105e5f <alltraps>

8010686b <vector143>:
.globl vector143
vector143:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $143
8010686d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106872:	e9 e8 f5 ff ff       	jmp    80105e5f <alltraps>

80106877 <vector144>:
.globl vector144
vector144:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $144
80106879:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010687e:	e9 dc f5 ff ff       	jmp    80105e5f <alltraps>

80106883 <vector145>:
.globl vector145
vector145:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $145
80106885:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010688a:	e9 d0 f5 ff ff       	jmp    80105e5f <alltraps>

8010688f <vector146>:
.globl vector146
vector146:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $146
80106891:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106896:	e9 c4 f5 ff ff       	jmp    80105e5f <alltraps>

8010689b <vector147>:
.globl vector147
vector147:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $147
8010689d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068a2:	e9 b8 f5 ff ff       	jmp    80105e5f <alltraps>

801068a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $148
801068a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068ae:	e9 ac f5 ff ff       	jmp    80105e5f <alltraps>

801068b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $149
801068b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068ba:	e9 a0 f5 ff ff       	jmp    80105e5f <alltraps>

801068bf <vector150>:
.globl vector150
vector150:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $150
801068c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801068c6:	e9 94 f5 ff ff       	jmp    80105e5f <alltraps>

801068cb <vector151>:
.globl vector151
vector151:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $151
801068cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801068d2:	e9 88 f5 ff ff       	jmp    80105e5f <alltraps>

801068d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $152
801068d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801068de:	e9 7c f5 ff ff       	jmp    80105e5f <alltraps>

801068e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $153
801068e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068ea:	e9 70 f5 ff ff       	jmp    80105e5f <alltraps>

801068ef <vector154>:
.globl vector154
vector154:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $154
801068f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068f6:	e9 64 f5 ff ff       	jmp    80105e5f <alltraps>

801068fb <vector155>:
.globl vector155
vector155:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $155
801068fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106902:	e9 58 f5 ff ff       	jmp    80105e5f <alltraps>

80106907 <vector156>:
.globl vector156
vector156:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $156
80106909:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010690e:	e9 4c f5 ff ff       	jmp    80105e5f <alltraps>

80106913 <vector157>:
.globl vector157
vector157:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $157
80106915:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010691a:	e9 40 f5 ff ff       	jmp    80105e5f <alltraps>

8010691f <vector158>:
.globl vector158
vector158:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $158
80106921:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106926:	e9 34 f5 ff ff       	jmp    80105e5f <alltraps>

8010692b <vector159>:
.globl vector159
vector159:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $159
8010692d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106932:	e9 28 f5 ff ff       	jmp    80105e5f <alltraps>

80106937 <vector160>:
.globl vector160
vector160:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $160
80106939:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010693e:	e9 1c f5 ff ff       	jmp    80105e5f <alltraps>

80106943 <vector161>:
.globl vector161
vector161:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $161
80106945:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010694a:	e9 10 f5 ff ff       	jmp    80105e5f <alltraps>

8010694f <vector162>:
.globl vector162
vector162:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $162
80106951:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106956:	e9 04 f5 ff ff       	jmp    80105e5f <alltraps>

8010695b <vector163>:
.globl vector163
vector163:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $163
8010695d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106962:	e9 f8 f4 ff ff       	jmp    80105e5f <alltraps>

80106967 <vector164>:
.globl vector164
vector164:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $164
80106969:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010696e:	e9 ec f4 ff ff       	jmp    80105e5f <alltraps>

80106973 <vector165>:
.globl vector165
vector165:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $165
80106975:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010697a:	e9 e0 f4 ff ff       	jmp    80105e5f <alltraps>

8010697f <vector166>:
.globl vector166
vector166:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $166
80106981:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106986:	e9 d4 f4 ff ff       	jmp    80105e5f <alltraps>

8010698b <vector167>:
.globl vector167
vector167:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $167
8010698d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106992:	e9 c8 f4 ff ff       	jmp    80105e5f <alltraps>

80106997 <vector168>:
.globl vector168
vector168:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $168
80106999:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010699e:	e9 bc f4 ff ff       	jmp    80105e5f <alltraps>

801069a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $169
801069a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069aa:	e9 b0 f4 ff ff       	jmp    80105e5f <alltraps>

801069af <vector170>:
.globl vector170
vector170:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $170
801069b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069b6:	e9 a4 f4 ff ff       	jmp    80105e5f <alltraps>

801069bb <vector171>:
.globl vector171
vector171:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $171
801069bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801069c2:	e9 98 f4 ff ff       	jmp    80105e5f <alltraps>

801069c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $172
801069c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801069ce:	e9 8c f4 ff ff       	jmp    80105e5f <alltraps>

801069d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $173
801069d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801069da:	e9 80 f4 ff ff       	jmp    80105e5f <alltraps>

801069df <vector174>:
.globl vector174
vector174:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $174
801069e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069e6:	e9 74 f4 ff ff       	jmp    80105e5f <alltraps>

801069eb <vector175>:
.globl vector175
vector175:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $175
801069ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069f2:	e9 68 f4 ff ff       	jmp    80105e5f <alltraps>

801069f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $176
801069f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069fe:	e9 5c f4 ff ff       	jmp    80105e5f <alltraps>

80106a03 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $177
80106a05:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a0a:	e9 50 f4 ff ff       	jmp    80105e5f <alltraps>

80106a0f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $178
80106a11:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a16:	e9 44 f4 ff ff       	jmp    80105e5f <alltraps>

80106a1b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $179
80106a1d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a22:	e9 38 f4 ff ff       	jmp    80105e5f <alltraps>

80106a27 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $180
80106a29:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a2e:	e9 2c f4 ff ff       	jmp    80105e5f <alltraps>

80106a33 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $181
80106a35:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a3a:	e9 20 f4 ff ff       	jmp    80105e5f <alltraps>

80106a3f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $182
80106a41:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a46:	e9 14 f4 ff ff       	jmp    80105e5f <alltraps>

80106a4b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $183
80106a4d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a52:	e9 08 f4 ff ff       	jmp    80105e5f <alltraps>

80106a57 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $184
80106a59:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a5e:	e9 fc f3 ff ff       	jmp    80105e5f <alltraps>

80106a63 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $185
80106a65:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a6a:	e9 f0 f3 ff ff       	jmp    80105e5f <alltraps>

80106a6f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $186
80106a71:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a76:	e9 e4 f3 ff ff       	jmp    80105e5f <alltraps>

80106a7b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $187
80106a7d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a82:	e9 d8 f3 ff ff       	jmp    80105e5f <alltraps>

80106a87 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $188
80106a89:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a8e:	e9 cc f3 ff ff       	jmp    80105e5f <alltraps>

80106a93 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $189
80106a95:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a9a:	e9 c0 f3 ff ff       	jmp    80105e5f <alltraps>

80106a9f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $190
80106aa1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106aa6:	e9 b4 f3 ff ff       	jmp    80105e5f <alltraps>

80106aab <vector191>:
.globl vector191
vector191:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $191
80106aad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ab2:	e9 a8 f3 ff ff       	jmp    80105e5f <alltraps>

80106ab7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $192
80106ab9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106abe:	e9 9c f3 ff ff       	jmp    80105e5f <alltraps>

80106ac3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $193
80106ac5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106aca:	e9 90 f3 ff ff       	jmp    80105e5f <alltraps>

80106acf <vector194>:
.globl vector194
vector194:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $194
80106ad1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ad6:	e9 84 f3 ff ff       	jmp    80105e5f <alltraps>

80106adb <vector195>:
.globl vector195
vector195:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $195
80106add:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ae2:	e9 78 f3 ff ff       	jmp    80105e5f <alltraps>

80106ae7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $196
80106ae9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106aee:	e9 6c f3 ff ff       	jmp    80105e5f <alltraps>

80106af3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $197
80106af5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106afa:	e9 60 f3 ff ff       	jmp    80105e5f <alltraps>

80106aff <vector198>:
.globl vector198
vector198:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $198
80106b01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b06:	e9 54 f3 ff ff       	jmp    80105e5f <alltraps>

80106b0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $199
80106b0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b12:	e9 48 f3 ff ff       	jmp    80105e5f <alltraps>

80106b17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $200
80106b19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b1e:	e9 3c f3 ff ff       	jmp    80105e5f <alltraps>

80106b23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $201
80106b25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b2a:	e9 30 f3 ff ff       	jmp    80105e5f <alltraps>

80106b2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $202
80106b31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b36:	e9 24 f3 ff ff       	jmp    80105e5f <alltraps>

80106b3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $203
80106b3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b42:	e9 18 f3 ff ff       	jmp    80105e5f <alltraps>

80106b47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $204
80106b49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b4e:	e9 0c f3 ff ff       	jmp    80105e5f <alltraps>

80106b53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $205
80106b55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b5a:	e9 00 f3 ff ff       	jmp    80105e5f <alltraps>

80106b5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $206
80106b61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b66:	e9 f4 f2 ff ff       	jmp    80105e5f <alltraps>

80106b6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $207
80106b6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b72:	e9 e8 f2 ff ff       	jmp    80105e5f <alltraps>

80106b77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $208
80106b79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b7e:	e9 dc f2 ff ff       	jmp    80105e5f <alltraps>

80106b83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $209
80106b85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b8a:	e9 d0 f2 ff ff       	jmp    80105e5f <alltraps>

80106b8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $210
80106b91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b96:	e9 c4 f2 ff ff       	jmp    80105e5f <alltraps>

80106b9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $211
80106b9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ba2:	e9 b8 f2 ff ff       	jmp    80105e5f <alltraps>

80106ba7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $212
80106ba9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bae:	e9 ac f2 ff ff       	jmp    80105e5f <alltraps>

80106bb3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $213
80106bb5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bba:	e9 a0 f2 ff ff       	jmp    80105e5f <alltraps>

80106bbf <vector214>:
.globl vector214
vector214:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $214
80106bc1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106bc6:	e9 94 f2 ff ff       	jmp    80105e5f <alltraps>

80106bcb <vector215>:
.globl vector215
vector215:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $215
80106bcd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106bd2:	e9 88 f2 ff ff       	jmp    80105e5f <alltraps>

80106bd7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $216
80106bd9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106bde:	e9 7c f2 ff ff       	jmp    80105e5f <alltraps>

80106be3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $217
80106be5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106bea:	e9 70 f2 ff ff       	jmp    80105e5f <alltraps>

80106bef <vector218>:
.globl vector218
vector218:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $218
80106bf1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106bf6:	e9 64 f2 ff ff       	jmp    80105e5f <alltraps>

80106bfb <vector219>:
.globl vector219
vector219:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $219
80106bfd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c02:	e9 58 f2 ff ff       	jmp    80105e5f <alltraps>

80106c07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $220
80106c09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c0e:	e9 4c f2 ff ff       	jmp    80105e5f <alltraps>

80106c13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $221
80106c15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c1a:	e9 40 f2 ff ff       	jmp    80105e5f <alltraps>

80106c1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $222
80106c21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c26:	e9 34 f2 ff ff       	jmp    80105e5f <alltraps>

80106c2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $223
80106c2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c32:	e9 28 f2 ff ff       	jmp    80105e5f <alltraps>

80106c37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $224
80106c39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c3e:	e9 1c f2 ff ff       	jmp    80105e5f <alltraps>

80106c43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $225
80106c45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c4a:	e9 10 f2 ff ff       	jmp    80105e5f <alltraps>

80106c4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $226
80106c51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c56:	e9 04 f2 ff ff       	jmp    80105e5f <alltraps>

80106c5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $227
80106c5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c62:	e9 f8 f1 ff ff       	jmp    80105e5f <alltraps>

80106c67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $228
80106c69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c6e:	e9 ec f1 ff ff       	jmp    80105e5f <alltraps>

80106c73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $229
80106c75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c7a:	e9 e0 f1 ff ff       	jmp    80105e5f <alltraps>

80106c7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $230
80106c81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c86:	e9 d4 f1 ff ff       	jmp    80105e5f <alltraps>

80106c8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $231
80106c8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c92:	e9 c8 f1 ff ff       	jmp    80105e5f <alltraps>

80106c97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $232
80106c99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c9e:	e9 bc f1 ff ff       	jmp    80105e5f <alltraps>

80106ca3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $233
80106ca5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106caa:	e9 b0 f1 ff ff       	jmp    80105e5f <alltraps>

80106caf <vector234>:
.globl vector234
vector234:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $234
80106cb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106cb6:	e9 a4 f1 ff ff       	jmp    80105e5f <alltraps>

80106cbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $235
80106cbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106cc2:	e9 98 f1 ff ff       	jmp    80105e5f <alltraps>

80106cc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $236
80106cc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106cce:	e9 8c f1 ff ff       	jmp    80105e5f <alltraps>

80106cd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $237
80106cd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106cda:	e9 80 f1 ff ff       	jmp    80105e5f <alltraps>

80106cdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $238
80106ce1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ce6:	e9 74 f1 ff ff       	jmp    80105e5f <alltraps>

80106ceb <vector239>:
.globl vector239
vector239:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $239
80106ced:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106cf2:	e9 68 f1 ff ff       	jmp    80105e5f <alltraps>

80106cf7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $240
80106cf9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cfe:	e9 5c f1 ff ff       	jmp    80105e5f <alltraps>

80106d03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $241
80106d05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d0a:	e9 50 f1 ff ff       	jmp    80105e5f <alltraps>

80106d0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $242
80106d11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d16:	e9 44 f1 ff ff       	jmp    80105e5f <alltraps>

80106d1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $243
80106d1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d22:	e9 38 f1 ff ff       	jmp    80105e5f <alltraps>

80106d27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $244
80106d29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d2e:	e9 2c f1 ff ff       	jmp    80105e5f <alltraps>

80106d33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $245
80106d35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d3a:	e9 20 f1 ff ff       	jmp    80105e5f <alltraps>

80106d3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $246
80106d41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d46:	e9 14 f1 ff ff       	jmp    80105e5f <alltraps>

80106d4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $247
80106d4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d52:	e9 08 f1 ff ff       	jmp    80105e5f <alltraps>

80106d57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $248
80106d59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d5e:	e9 fc f0 ff ff       	jmp    80105e5f <alltraps>

80106d63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $249
80106d65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d6a:	e9 f0 f0 ff ff       	jmp    80105e5f <alltraps>

80106d6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $250
80106d71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d76:	e9 e4 f0 ff ff       	jmp    80105e5f <alltraps>

80106d7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $251
80106d7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d82:	e9 d8 f0 ff ff       	jmp    80105e5f <alltraps>

80106d87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $252
80106d89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d8e:	e9 cc f0 ff ff       	jmp    80105e5f <alltraps>

80106d93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $253
80106d95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d9a:	e9 c0 f0 ff ff       	jmp    80105e5f <alltraps>

80106d9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $254
80106da1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106da6:	e9 b4 f0 ff ff       	jmp    80105e5f <alltraps>

80106dab <vector255>:
.globl vector255
vector255:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $255
80106dad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106db2:	e9 a8 f0 ff ff       	jmp    80105e5f <alltraps>
80106db7:	66 90                	xchg   %ax,%ax
80106db9:	66 90                	xchg   %ax,%ax
80106dbb:	66 90                	xchg   %ax,%ax
80106dbd:	66 90                	xchg   %ax,%ax
80106dbf:	90                   	nop

80106dc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106dc6:	89 d3                	mov    %edx,%ebx
{
80106dc8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106dca:	c1 eb 16             	shr    $0x16,%ebx
80106dcd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106dd0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106dd3:	8b 06                	mov    (%esi),%eax
80106dd5:	a8 01                	test   $0x1,%al
80106dd7:	74 27                	je     80106e00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dde:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106de4:	c1 ef 0a             	shr    $0xa,%edi
}
80106de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106dea:	89 fa                	mov    %edi,%edx
80106dec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106df2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e00:	85 c9                	test   %ecx,%ecx
80106e02:	74 2c                	je     80106e30 <walkpgdir+0x70>
80106e04:	e8 f7 b7 ff ff       	call   80102600 <kalloc>
80106e09:	85 c0                	test   %eax,%eax
80106e0b:	89 c3                	mov    %eax,%ebx
80106e0d:	74 21                	je     80106e30 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e0f:	83 ec 04             	sub    $0x4,%esp
80106e12:	68 00 10 00 00       	push   $0x1000
80106e17:	6a 00                	push   $0x0
80106e19:	50                   	push   %eax
80106e1a:	e8 d1 d8 ff ff       	call   801046f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e25:	83 c4 10             	add    $0x10,%esp
80106e28:	83 c8 07             	or     $0x7,%eax
80106e2b:	89 06                	mov    %eax,(%esi)
80106e2d:	eb b5                	jmp    80106de4 <walkpgdir+0x24>
80106e2f:	90                   	nop
}
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e33:	31 c0                	xor    %eax,%eax
}
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5f                   	pop    %edi
80106e38:	5d                   	pop    %ebp
80106e39:	c3                   	ret    
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e46:	89 d3                	mov    %edx,%ebx
80106e48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e4e:	83 ec 1c             	sub    $0x1c,%esp
80106e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e66:	29 df                	sub    %ebx,%edi
80106e68:	83 c8 01             	or     $0x1,%eax
80106e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e6e:	eb 15                	jmp    80106e85 <mappages+0x45>
    if(*pte & PTE_P)
80106e70:	f6 00 01             	testb  $0x1,(%eax)
80106e73:	75 45                	jne    80106eba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106e75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106e7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e7d:	74 31                	je     80106eb0 <mappages+0x70>
      break;
    a += PGSIZE;
80106e7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e8d:	89 da                	mov    %ebx,%edx
80106e8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e92:	e8 29 ff ff ff       	call   80106dc0 <walkpgdir>
80106e97:	85 c0                	test   %eax,%eax
80106e99:	75 d5                	jne    80106e70 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ea3:	5b                   	pop    %ebx
80106ea4:	5e                   	pop    %esi
80106ea5:	5f                   	pop    %edi
80106ea6:	5d                   	pop    %ebp
80106ea7:	c3                   	ret    
80106ea8:	90                   	nop
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106eb3:	31 c0                	xor    %eax,%eax
}
80106eb5:	5b                   	pop    %ebx
80106eb6:	5e                   	pop    %esi
80106eb7:	5f                   	pop    %edi
80106eb8:	5d                   	pop    %ebp
80106eb9:	c3                   	ret    
      panic("remap");
80106eba:	83 ec 0c             	sub    $0xc,%esp
80106ebd:	68 c0 81 10 80       	push   $0x801081c0
80106ec2:	e8 c9 94 ff ff       	call   80100390 <panic>
80106ec7:	89 f6                	mov    %esi,%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ed6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106edc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106ede:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ee4:	83 ec 1c             	sub    $0x1c,%esp
80106ee7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106eea:	39 d3                	cmp    %edx,%ebx
80106eec:	73 66                	jae    80106f54 <deallocuvm.part.0+0x84>
80106eee:	89 d6                	mov    %edx,%esi
80106ef0:	eb 3d                	jmp    80106f2f <deallocuvm.part.0+0x5f>
80106ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ef8:	8b 10                	mov    (%eax),%edx
80106efa:	f6 c2 01             	test   $0x1,%dl
80106efd:	74 26                	je     80106f25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106eff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f05:	74 58                	je     80106f5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f07:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106f13:	52                   	push   %edx
80106f14:	e8 37 b5 ff ff       	call   80102450 <kfree>
      *pte = 0;
80106f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f1c:	83 c4 10             	add    $0x10,%esp
80106f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106f25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f2b:	39 f3                	cmp    %esi,%ebx
80106f2d:	73 25                	jae    80106f54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f2f:	31 c9                	xor    %ecx,%ecx
80106f31:	89 da                	mov    %ebx,%edx
80106f33:	89 f8                	mov    %edi,%eax
80106f35:	e8 86 fe ff ff       	call   80106dc0 <walkpgdir>
    if(!pte)
80106f3a:	85 c0                	test   %eax,%eax
80106f3c:	75 ba                	jne    80106ef8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f50:	39 f3                	cmp    %esi,%ebx
80106f52:	72 db                	jb     80106f2f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5a:	5b                   	pop    %ebx
80106f5b:	5e                   	pop    %esi
80106f5c:	5f                   	pop    %edi
80106f5d:	5d                   	pop    %ebp
80106f5e:	c3                   	ret    
        panic("kfree");
80106f5f:	83 ec 0c             	sub    $0xc,%esp
80106f62:	68 66 79 10 80       	push   $0x80107966
80106f67:	e8 24 94 ff ff       	call   80100390 <panic>
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f70 <seginit>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f76:	e8 85 c9 ff ff       	call   80103900 <cpuid>
80106f7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f8a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106f91:	ff 00 00 
80106f94:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80106f9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f9e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106fa5:	ff 00 00 
80106fa8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106faf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fb2:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106fb9:	ff 00 00 
80106fbc:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106fc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fc6:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106fcd:	ff 00 00 
80106fd0:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106fd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fda:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106fdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fe3:	c1 e8 10             	shr    $0x10,%eax
80106fe6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fed:	0f 01 10             	lgdtl  (%eax)
}
80106ff0:	c9                   	leave  
80106ff1:	c3                   	ret    
80106ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107000:	a1 e4 64 11 80       	mov    0x801164e4,%eax
{
80107005:	55                   	push   %ebp
80107006:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107008:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010700d:	0f 22 d8             	mov    %eax,%cr3
}
80107010:	5d                   	pop    %ebp
80107011:	c3                   	ret    
80107012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107020 <switchuvm>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 1c             	sub    $0x1c,%esp
80107029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010702c:	85 db                	test   %ebx,%ebx
8010702e:	0f 84 cb 00 00 00    	je     801070ff <switchuvm+0xdf>
  if(p->kstack == 0)
80107034:	8b 43 08             	mov    0x8(%ebx),%eax
80107037:	85 c0                	test   %eax,%eax
80107039:	0f 84 da 00 00 00    	je     80107119 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010703f:	8b 43 04             	mov    0x4(%ebx),%eax
80107042:	85 c0                	test   %eax,%eax
80107044:	0f 84 c2 00 00 00    	je     8010710c <switchuvm+0xec>
  pushcli();
8010704a:	e8 11 d4 ff ff       	call   80104460 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010704f:	e8 2c c8 ff ff       	call   80103880 <mycpu>
80107054:	89 c6                	mov    %eax,%esi
80107056:	e8 25 c8 ff ff       	call   80103880 <mycpu>
8010705b:	89 c7                	mov    %eax,%edi
8010705d:	e8 1e c8 ff ff       	call   80103880 <mycpu>
80107062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107065:	83 c7 08             	add    $0x8,%edi
80107068:	e8 13 c8 ff ff       	call   80103880 <mycpu>
8010706d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107070:	83 c0 08             	add    $0x8,%eax
80107073:	ba 67 00 00 00       	mov    $0x67,%edx
80107078:	c1 e8 18             	shr    $0x18,%eax
8010707b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107082:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107089:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010708f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107094:	83 c1 08             	add    $0x8,%ecx
80107097:	c1 e9 10             	shr    $0x10,%ecx
8010709a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801070a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070a5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070ac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801070b1:	e8 ca c7 ff ff       	call   80103880 <mycpu>
801070b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070bd:	e8 be c7 ff ff       	call   80103880 <mycpu>
801070c2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070c6:	8b 73 08             	mov    0x8(%ebx),%esi
801070c9:	e8 b2 c7 ff ff       	call   80103880 <mycpu>
801070ce:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070d4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070d7:	e8 a4 c7 ff ff       	call   80103880 <mycpu>
801070dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070e0:	b8 28 00 00 00       	mov    $0x28,%eax
801070e5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070e8:	8b 43 04             	mov    0x4(%ebx),%eax
801070eb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070f0:	0f 22 d8             	mov    %eax,%cr3
}
801070f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f6:	5b                   	pop    %ebx
801070f7:	5e                   	pop    %esi
801070f8:	5f                   	pop    %edi
801070f9:	5d                   	pop    %ebp
  popcli();
801070fa:	e9 a1 d3 ff ff       	jmp    801044a0 <popcli>
    panic("switchuvm: no process");
801070ff:	83 ec 0c             	sub    $0xc,%esp
80107102:	68 c6 81 10 80       	push   $0x801081c6
80107107:	e8 84 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010710c:	83 ec 0c             	sub    $0xc,%esp
8010710f:	68 f1 81 10 80       	push   $0x801081f1
80107114:	e8 77 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107119:	83 ec 0c             	sub    $0xc,%esp
8010711c:	68 dc 81 10 80       	push   $0x801081dc
80107121:	e8 6a 92 ff ff       	call   80100390 <panic>
80107126:	8d 76 00             	lea    0x0(%esi),%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107130 <inituvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
80107139:	8b 75 10             	mov    0x10(%ebp),%esi
8010713c:	8b 45 08             	mov    0x8(%ebp),%eax
8010713f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107142:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107148:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010714b:	77 49                	ja     80107196 <inituvm+0x66>
  mem = kalloc();
8010714d:	e8 ae b4 ff ff       	call   80102600 <kalloc>
  memset(mem, 0, PGSIZE);
80107152:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107155:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107157:	68 00 10 00 00       	push   $0x1000
8010715c:	6a 00                	push   $0x0
8010715e:	50                   	push   %eax
8010715f:	e8 8c d5 ff ff       	call   801046f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107164:	58                   	pop    %eax
80107165:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010716b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107170:	5a                   	pop    %edx
80107171:	6a 06                	push   $0x6
80107173:	50                   	push   %eax
80107174:	31 d2                	xor    %edx,%edx
80107176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107179:	e8 c2 fc ff ff       	call   80106e40 <mappages>
  memmove(mem, init, sz);
8010717e:	89 75 10             	mov    %esi,0x10(%ebp)
80107181:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107184:	83 c4 10             	add    $0x10,%esp
80107187:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010718a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010718d:	5b                   	pop    %ebx
8010718e:	5e                   	pop    %esi
8010718f:	5f                   	pop    %edi
80107190:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107191:	e9 0a d6 ff ff       	jmp    801047a0 <memmove>
    panic("inituvm: more than a page");
80107196:	83 ec 0c             	sub    $0xc,%esp
80107199:	68 05 82 10 80       	push   $0x80108205
8010719e:	e8 ed 91 ff ff       	call   80100390 <panic>
801071a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <loaduvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801071b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801071c0:	0f 85 91 00 00 00    	jne    80107257 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801071c6:	8b 75 18             	mov    0x18(%ebp),%esi
801071c9:	31 db                	xor    %ebx,%ebx
801071cb:	85 f6                	test   %esi,%esi
801071cd:	75 1a                	jne    801071e9 <loaduvm+0x39>
801071cf:	eb 6f                	jmp    80107240 <loaduvm+0x90>
801071d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071e7:	76 57                	jbe    80107240 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ec:	8b 45 08             	mov    0x8(%ebp),%eax
801071ef:	31 c9                	xor    %ecx,%ecx
801071f1:	01 da                	add    %ebx,%edx
801071f3:	e8 c8 fb ff ff       	call   80106dc0 <walkpgdir>
801071f8:	85 c0                	test   %eax,%eax
801071fa:	74 4e                	je     8010724a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801071fc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107201:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107206:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010720b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107211:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107214:	01 d9                	add    %ebx,%ecx
80107216:	05 00 00 00 80       	add    $0x80000000,%eax
8010721b:	57                   	push   %edi
8010721c:	51                   	push   %ecx
8010721d:	50                   	push   %eax
8010721e:	ff 75 10             	pushl  0x10(%ebp)
80107221:	e8 7a a8 ff ff       	call   80101aa0 <readi>
80107226:	83 c4 10             	add    $0x10,%esp
80107229:	39 f8                	cmp    %edi,%eax
8010722b:	74 ab                	je     801071d8 <loaduvm+0x28>
}
8010722d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
8010723a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107243:	31 c0                	xor    %eax,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
      panic("loaduvm: address should exist");
8010724a:	83 ec 0c             	sub    $0xc,%esp
8010724d:	68 1f 82 10 80       	push   $0x8010821f
80107252:	e8 39 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107257:	83 ec 0c             	sub    $0xc,%esp
8010725a:	68 c0 82 10 80       	push   $0x801082c0
8010725f:	e8 2c 91 ff ff       	call   80100390 <panic>
80107264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010726a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107270 <allocuvm>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107279:	8b 7d 10             	mov    0x10(%ebp),%edi
8010727c:	85 ff                	test   %edi,%edi
8010727e:	0f 88 8e 00 00 00    	js     80107312 <allocuvm+0xa2>
  if(newsz < oldsz)
80107284:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107287:	0f 82 93 00 00 00    	jb     80107320 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010728d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107290:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107296:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010729c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010729f:	0f 86 7e 00 00 00    	jbe    80107323 <allocuvm+0xb3>
801072a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801072a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801072ab:	eb 42                	jmp    801072ef <allocuvm+0x7f>
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801072b0:	83 ec 04             	sub    $0x4,%esp
801072b3:	68 00 10 00 00       	push   $0x1000
801072b8:	6a 00                	push   $0x0
801072ba:	50                   	push   %eax
801072bb:	e8 30 d4 ff ff       	call   801046f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801072c0:	58                   	pop    %eax
801072c1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801072c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072cc:	5a                   	pop    %edx
801072cd:	6a 06                	push   $0x6
801072cf:	50                   	push   %eax
801072d0:	89 da                	mov    %ebx,%edx
801072d2:	89 f8                	mov    %edi,%eax
801072d4:	e8 67 fb ff ff       	call   80106e40 <mappages>
801072d9:	83 c4 10             	add    $0x10,%esp
801072dc:	85 c0                	test   %eax,%eax
801072de:	78 50                	js     80107330 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801072e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072e9:	0f 86 81 00 00 00    	jbe    80107370 <allocuvm+0x100>
    mem = kalloc();
801072ef:	e8 0c b3 ff ff       	call   80102600 <kalloc>
    if(mem == 0){
801072f4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801072f6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801072f8:	75 b6                	jne    801072b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801072fa:	83 ec 0c             	sub    $0xc,%esp
801072fd:	68 3d 82 10 80       	push   $0x8010823d
80107302:	e8 09 94 ff ff       	call   80100710 <cprintf>
  if(newsz >= oldsz)
80107307:	83 c4 10             	add    $0x10,%esp
8010730a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010730d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107310:	77 6e                	ja     80107380 <allocuvm+0x110>
}
80107312:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107315:	31 ff                	xor    %edi,%edi
}
80107317:	89 f8                	mov    %edi,%eax
80107319:	5b                   	pop    %ebx
8010731a:	5e                   	pop    %esi
8010731b:	5f                   	pop    %edi
8010731c:	5d                   	pop    %ebp
8010731d:	c3                   	ret    
8010731e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107320:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	89 f8                	mov    %edi,%eax
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107330:	83 ec 0c             	sub    $0xc,%esp
80107333:	68 55 82 10 80       	push   $0x80108255
80107338:	e8 d3 93 ff ff       	call   80100710 <cprintf>
  if(newsz >= oldsz)
8010733d:	83 c4 10             	add    $0x10,%esp
80107340:	8b 45 0c             	mov    0xc(%ebp),%eax
80107343:	39 45 10             	cmp    %eax,0x10(%ebp)
80107346:	76 0d                	jbe    80107355 <allocuvm+0xe5>
80107348:	89 c1                	mov    %eax,%ecx
8010734a:	8b 55 10             	mov    0x10(%ebp),%edx
8010734d:	8b 45 08             	mov    0x8(%ebp),%eax
80107350:	e8 7b fb ff ff       	call   80106ed0 <deallocuvm.part.0>
      kfree(mem);
80107355:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107358:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010735a:	56                   	push   %esi
8010735b:	e8 f0 b0 ff ff       	call   80102450 <kfree>
      return 0;
80107360:	83 c4 10             	add    $0x10,%esp
}
80107363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107366:	89 f8                	mov    %edi,%eax
80107368:	5b                   	pop    %ebx
80107369:	5e                   	pop    %esi
8010736a:	5f                   	pop    %edi
8010736b:	5d                   	pop    %ebp
8010736c:	c3                   	ret    
8010736d:	8d 76 00             	lea    0x0(%esi),%esi
80107370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107373:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107376:	5b                   	pop    %ebx
80107377:	89 f8                	mov    %edi,%eax
80107379:	5e                   	pop    %esi
8010737a:	5f                   	pop    %edi
8010737b:	5d                   	pop    %ebp
8010737c:	c3                   	ret    
8010737d:	8d 76 00             	lea    0x0(%esi),%esi
80107380:	89 c1                	mov    %eax,%ecx
80107382:	8b 55 10             	mov    0x10(%ebp),%edx
80107385:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107388:	31 ff                	xor    %edi,%edi
8010738a:	e8 41 fb ff ff       	call   80106ed0 <deallocuvm.part.0>
8010738f:	eb 92                	jmp    80107323 <allocuvm+0xb3>
80107391:	eb 0d                	jmp    801073a0 <deallocuvm>
80107393:	90                   	nop
80107394:	90                   	nop
80107395:	90                   	nop
80107396:	90                   	nop
80107397:	90                   	nop
80107398:	90                   	nop
80107399:	90                   	nop
8010739a:	90                   	nop
8010739b:	90                   	nop
8010739c:	90                   	nop
8010739d:	90                   	nop
8010739e:	90                   	nop
8010739f:	90                   	nop

801073a0 <deallocuvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073ac:	39 d1                	cmp    %edx,%ecx
801073ae:	73 10                	jae    801073c0 <deallocuvm+0x20>
}
801073b0:	5d                   	pop    %ebp
801073b1:	e9 1a fb ff ff       	jmp    80106ed0 <deallocuvm.part.0>
801073b6:	8d 76 00             	lea    0x0(%esi),%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801073c0:	89 d0                	mov    %edx,%eax
801073c2:	5d                   	pop    %ebp
801073c3:	c3                   	ret    
801073c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073dc:	85 f6                	test   %esi,%esi
801073de:	74 59                	je     80107439 <freevm+0x69>
801073e0:	31 c9                	xor    %ecx,%ecx
801073e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073e7:	89 f0                	mov    %esi,%eax
801073e9:	e8 e2 fa ff ff       	call   80106ed0 <deallocuvm.part.0>
801073ee:	89 f3                	mov    %esi,%ebx
801073f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073f6:	eb 0f                	jmp    80107407 <freevm+0x37>
801073f8:	90                   	nop
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107400:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107403:	39 fb                	cmp    %edi,%ebx
80107405:	74 23                	je     8010742a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107407:	8b 03                	mov    (%ebx),%eax
80107409:	a8 01                	test   $0x1,%al
8010740b:	74 f3                	je     80107400 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010740d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107412:	83 ec 0c             	sub    $0xc,%esp
80107415:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107418:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010741d:	50                   	push   %eax
8010741e:	e8 2d b0 ff ff       	call   80102450 <kfree>
80107423:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107426:	39 fb                	cmp    %edi,%ebx
80107428:	75 dd                	jne    80107407 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010742a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010742d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107430:	5b                   	pop    %ebx
80107431:	5e                   	pop    %esi
80107432:	5f                   	pop    %edi
80107433:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107434:	e9 17 b0 ff ff       	jmp    80102450 <kfree>
    panic("freevm: no pgdir");
80107439:	83 ec 0c             	sub    $0xc,%esp
8010743c:	68 71 82 10 80       	push   $0x80108271
80107441:	e8 4a 8f ff ff       	call   80100390 <panic>
80107446:	8d 76 00             	lea    0x0(%esi),%esi
80107449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107450 <setupkvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	56                   	push   %esi
80107454:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107455:	e8 a6 b1 ff ff       	call   80102600 <kalloc>
8010745a:	85 c0                	test   %eax,%eax
8010745c:	89 c6                	mov    %eax,%esi
8010745e:	74 42                	je     801074a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107460:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107463:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107468:	68 00 10 00 00       	push   $0x1000
8010746d:	6a 00                	push   $0x0
8010746f:	50                   	push   %eax
80107470:	e8 7b d2 ff ff       	call   801046f0 <memset>
80107475:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107478:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010747b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010747e:	83 ec 08             	sub    $0x8,%esp
80107481:	8b 13                	mov    (%ebx),%edx
80107483:	ff 73 0c             	pushl  0xc(%ebx)
80107486:	50                   	push   %eax
80107487:	29 c1                	sub    %eax,%ecx
80107489:	89 f0                	mov    %esi,%eax
8010748b:	e8 b0 f9 ff ff       	call   80106e40 <mappages>
80107490:	83 c4 10             	add    $0x10,%esp
80107493:	85 c0                	test   %eax,%eax
80107495:	78 19                	js     801074b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107497:	83 c3 10             	add    $0x10,%ebx
8010749a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074a0:	75 d6                	jne    80107478 <setupkvm+0x28>
}
801074a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074a5:	89 f0                	mov    %esi,%eax
801074a7:	5b                   	pop    %ebx
801074a8:	5e                   	pop    %esi
801074a9:	5d                   	pop    %ebp
801074aa:	c3                   	ret    
801074ab:	90                   	nop
801074ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	56                   	push   %esi
      return 0;
801074b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801074b6:	e8 15 ff ff ff       	call   801073d0 <freevm>
      return 0;
801074bb:	83 c4 10             	add    $0x10,%esp
}
801074be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074c1:	89 f0                	mov    %esi,%eax
801074c3:	5b                   	pop    %ebx
801074c4:	5e                   	pop    %esi
801074c5:	5d                   	pop    %ebp
801074c6:	c3                   	ret    
801074c7:	89 f6                	mov    %esi,%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <kvmalloc>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074d6:	e8 75 ff ff ff       	call   80107450 <setupkvm>
801074db:	a3 e4 64 11 80       	mov    %eax,0x801164e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074e0:	05 00 00 00 80       	add    $0x80000000,%eax
801074e5:	0f 22 d8             	mov    %eax,%cr3
}
801074e8:	c9                   	leave  
801074e9:	c3                   	ret    
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074f1:	31 c9                	xor    %ecx,%ecx
{
801074f3:	89 e5                	mov    %esp,%ebp
801074f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074fb:	8b 45 08             	mov    0x8(%ebp),%eax
801074fe:	e8 bd f8 ff ff       	call   80106dc0 <walkpgdir>
  if(pte == 0)
80107503:	85 c0                	test   %eax,%eax
80107505:	74 05                	je     8010750c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107507:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010750a:	c9                   	leave  
8010750b:	c3                   	ret    
    panic("clearpteu");
8010750c:	83 ec 0c             	sub    $0xc,%esp
8010750f:	68 82 82 10 80       	push   $0x80108282
80107514:	e8 77 8e ff ff       	call   80100390 <panic>
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107520 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107529:	e8 22 ff ff ff       	call   80107450 <setupkvm>
8010752e:	85 c0                	test   %eax,%eax
80107530:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107533:	0f 84 9f 00 00 00    	je     801075d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010753c:	85 c9                	test   %ecx,%ecx
8010753e:	0f 84 94 00 00 00    	je     801075d8 <copyuvm+0xb8>
80107544:	31 ff                	xor    %edi,%edi
80107546:	eb 4a                	jmp    80107592 <copyuvm+0x72>
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107550:	83 ec 04             	sub    $0x4,%esp
80107553:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107559:	68 00 10 00 00       	push   $0x1000
8010755e:	53                   	push   %ebx
8010755f:	50                   	push   %eax
80107560:	e8 3b d2 ff ff       	call   801047a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107565:	58                   	pop    %eax
80107566:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010756c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107571:	5a                   	pop    %edx
80107572:	ff 75 e4             	pushl  -0x1c(%ebp)
80107575:	50                   	push   %eax
80107576:	89 fa                	mov    %edi,%edx
80107578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010757b:	e8 c0 f8 ff ff       	call   80106e40 <mappages>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 61                	js     801075e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107587:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010758d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107590:	76 46                	jbe    801075d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107592:	8b 45 08             	mov    0x8(%ebp),%eax
80107595:	31 c9                	xor    %ecx,%ecx
80107597:	89 fa                	mov    %edi,%edx
80107599:	e8 22 f8 ff ff       	call   80106dc0 <walkpgdir>
8010759e:	85 c0                	test   %eax,%eax
801075a0:	74 61                	je     80107603 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801075a2:	8b 00                	mov    (%eax),%eax
801075a4:	a8 01                	test   $0x1,%al
801075a6:	74 4e                	je     801075f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801075a8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801075aa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801075af:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801075b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801075b8:	e8 43 b0 ff ff       	call   80102600 <kalloc>
801075bd:	85 c0                	test   %eax,%eax
801075bf:	89 c6                	mov    %eax,%esi
801075c1:	75 8d                	jne    80107550 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801075c3:	83 ec 0c             	sub    $0xc,%esp
801075c6:	ff 75 e0             	pushl  -0x20(%ebp)
801075c9:	e8 02 fe ff ff       	call   801073d0 <freevm>
  return 0;
801075ce:	83 c4 10             	add    $0x10,%esp
801075d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801075d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075de:	5b                   	pop    %ebx
801075df:	5e                   	pop    %esi
801075e0:	5f                   	pop    %edi
801075e1:	5d                   	pop    %ebp
801075e2:	c3                   	ret    
801075e3:	90                   	nop
801075e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075e8:	83 ec 0c             	sub    $0xc,%esp
801075eb:	56                   	push   %esi
801075ec:	e8 5f ae ff ff       	call   80102450 <kfree>
      goto bad;
801075f1:	83 c4 10             	add    $0x10,%esp
801075f4:	eb cd                	jmp    801075c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	68 a6 82 10 80       	push   $0x801082a6
801075fe:	e8 8d 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107603:	83 ec 0c             	sub    $0xc,%esp
80107606:	68 8c 82 10 80       	push   $0x8010828c
8010760b:	e8 80 8d ff ff       	call   80100390 <panic>

80107610 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107610:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107611:	31 c9                	xor    %ecx,%ecx
{
80107613:	89 e5                	mov    %esp,%ebp
80107615:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107618:	8b 55 0c             	mov    0xc(%ebp),%edx
8010761b:	8b 45 08             	mov    0x8(%ebp),%eax
8010761e:	e8 9d f7 ff ff       	call   80106dc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107623:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107625:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107626:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107628:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010762d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107630:	05 00 00 00 80       	add    $0x80000000,%eax
80107635:	83 fa 05             	cmp    $0x5,%edx
80107638:	ba 00 00 00 00       	mov    $0x0,%edx
8010763d:	0f 45 c2             	cmovne %edx,%eax
}
80107640:	c3                   	ret    
80107641:	eb 0d                	jmp    80107650 <copyout>
80107643:	90                   	nop
80107644:	90                   	nop
80107645:	90                   	nop
80107646:	90                   	nop
80107647:	90                   	nop
80107648:	90                   	nop
80107649:	90                   	nop
8010764a:	90                   	nop
8010764b:	90                   	nop
8010764c:	90                   	nop
8010764d:	90                   	nop
8010764e:	90                   	nop
8010764f:	90                   	nop

80107650 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	57                   	push   %edi
80107654:	56                   	push   %esi
80107655:	53                   	push   %ebx
80107656:	83 ec 1c             	sub    $0x1c,%esp
80107659:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010765c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010765f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107662:	85 db                	test   %ebx,%ebx
80107664:	75 40                	jne    801076a6 <copyout+0x56>
80107666:	eb 70                	jmp    801076d8 <copyout+0x88>
80107668:	90                   	nop
80107669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107673:	89 f1                	mov    %esi,%ecx
80107675:	29 d1                	sub    %edx,%ecx
80107677:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010767d:	39 d9                	cmp    %ebx,%ecx
8010767f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107682:	29 f2                	sub    %esi,%edx
80107684:	83 ec 04             	sub    $0x4,%esp
80107687:	01 d0                	add    %edx,%eax
80107689:	51                   	push   %ecx
8010768a:	57                   	push   %edi
8010768b:	50                   	push   %eax
8010768c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010768f:	e8 0c d1 ff ff       	call   801047a0 <memmove>
    len -= n;
    buf += n;
80107694:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107697:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010769a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801076a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801076a2:	29 cb                	sub    %ecx,%ebx
801076a4:	74 32                	je     801076d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801076a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801076a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801076ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801076ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801076b4:	56                   	push   %esi
801076b5:	ff 75 08             	pushl  0x8(%ebp)
801076b8:	e8 53 ff ff ff       	call   80107610 <uva2ka>
    if(pa0 == 0)
801076bd:	83 c4 10             	add    $0x10,%esp
801076c0:	85 c0                	test   %eax,%eax
801076c2:	75 ac                	jne    80107670 <copyout+0x20>
  }
  return 0;
}
801076c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076cc:	5b                   	pop    %ebx
801076cd:	5e                   	pop    %esi
801076ce:	5f                   	pop    %edi
801076cf:	5d                   	pop    %ebp
801076d0:	c3                   	ret    
801076d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076db:	31 c0                	xor    %eax,%eax
}
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret    
