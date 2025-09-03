# Veil Encryption Overview

Veil uses **Signal Protocol** for end-to-end encryption:
- Curve25519 (ECDH key exchange)
- ChaCha20-Poly1305 (message encryption)
- HMAC-SHA256 (authentication)
- Perfect Forward Secrecy (key rotation)

Server **cannot decrypt** any user message.
