# Link layer

- Hosts and routers are **nodes**
- **links** are communication channels that connect adjacent nodes along communication paths
  - wired, wireless, LAN
- layer 2 packet is a **frame**
- services
  - framing, link access
    - encapsulate data in frame, add header and trailer
    - channel access if shared medium
    - MAC addresses used in frame headers to identify source, dest (different than IP)
      - hardcoded in network card
  - reliable delivery between adjacent nodes
  - flow control
  - error detection
  - error correction
  - half-duplex, full-duplex

## Error detection
- EDC: Error detection and correction bits (redundancy)
- Error detection not 100% reliable
- larger EDC field yields better detection and correction
- Parity checking
  - Single bit: detect single bit errors (odd: # of ones is odd in frame; even: number of ones is even in frame)
  - 2D bit parity: Add a row and column that does single bit checking on the row/column index.
- Cyclic redundancy check
  - View data bits, $D$ as a binary number
  - choose $r+1$ bit pattern (generator), $G$
  - goal: choose $r$ CRC bits, $R$, such that:
    - $\langle D, R\rangle$ exactly divisible by $G \mod 2$
    - receiver knows $G$, divides $\langle D,R\rangle$ by $G$. If nonzero remainder, error is detected
    - can detect all burst errors less than $r+1$ bits
  - used in ethernet, wifi, ATM
