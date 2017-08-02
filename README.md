Vibecrypt is very simple tool to encrypt/decrypt your file.
Written in Ada. Uses Raiden cypher (http://raiden-cipher.sourceforge.net/)

Requirments:
 gnat

Install:
 > cd vibecrypt
 > mkdir obj_ali
 > gnatmake vibecrypt.adb -D ./obj_ali/

Help:
 vibecrypter -h
Usage:
 vibecrypt key -e|-d in_file out_file [-r]
  key: length from 6 to 16 characters.
       if length < 16 - will be supplemented with underscores ('_').
       if length > 16 - will be truncated to 16 characters
  -e: encryption
  -d: decryption
  -r: rewrite file
Example:
 vibecrypt "0123456789abcdef" test_m.txt test_c.txt -r
The key can contain one of the characters:
 ' ', '!', '"', '#', '$', '%', '&',
 ''', '(', ')', '*', '+', ',', '-', '.', '/', '0',
 '1', '2', '3', '4', '5', '6', '7', '8', '9', ':',
 ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D',
 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
 'Y', 'Z', '[', '\', ']', '^', '_', '`', 'a', 'b',
 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
 'w', 'x', 'y', 'z', '{', '|', '}', '~'
