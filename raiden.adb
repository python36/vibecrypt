package body raiden is
  procedure init_key(key_init : key_s) is
  begin
    for i in 0..3 loop
      key(i) := to_dword(
        byte(Character'pos(key_init(1 + 4 * i))),
        byte(Character'pos(key_init(2 + 4 * i))),
        byte(Character'pos(key_init(3 + 4 * i))),
        byte(Character'pos(key_init(4 + 4 * i))));
    end loop;
  end init_key;

  procedure raiden_encrypt (m : in byte_array_8; c : out byte_array_8) is
    b0 : dword := to_dword(m(0), m(1), m(2), m(3));
    b1 : dword := to_dword(m(4), m(5), m(6), m(7));
  begin
    t_k := key;
    for i in 0..15 loop
      t_k(i mod 4) := (t_k(0) + t_k(1)) + (((t_k(2) + t_k(3)) xor dword_shift_left(t_k(0), integer(t_k(2) and 16#1F#))));
      b0 := b0 + (dword_shift_left(t_k(i mod 4) + b1, 9) xor ((t_k(i mod 4) - b1) xor dword_shift_right((t_k(i mod 4) + b1), 14)));
      b1 := b1 + (dword_shift_left(t_k(i mod 4) + b0, 9) xor ((t_k(i mod 4) - b0) xor dword_shift_right((t_k(i mod 4) + b0), 14)));
    end loop;
    to_byte(b0, c(0), c(1), c(2), c(3));
    to_byte(b1, c(4), c(5), c(6), c(7));
  end raiden_encrypt;

  procedure raiden_decrypt (c : in byte_array_8; m : out byte_array_8) is
    b0 : dword := to_dword(c(0), c(1), c(2), c(3));
    b1 : dword := to_dword(c(4), c(5), c(6), c(7));
    subkeys : array (integer range 0..15) of dword;
  begin
    t_k := key;
    for i in 0..15 loop
      subkeys(i) := (t_k(0) + t_k(1)) + (((t_k(2) + t_k(3)) xor dword_shift_left(t_k(0), integer(t_k(2) and 16#1F#))));
      t_k(i mod 4) := subkeys(i);
    end loop;
    for i in reverse 0..15 loop
      b1 := b1 - (dword_shift_left(subkeys(i) + b0, 9) xor ((subkeys(i) - b0) xor dword_shift_right((subkeys(i) + b0), 14)));
      b0 := b0 - (dword_shift_left(subkeys(i) + b1, 9) xor ((subkeys(i) - b1) xor dword_shift_right((subkeys(i) + b1), 14)));
    end loop;
    to_byte(b0, m(0), m(1), m(2), m(3));
    to_byte(b1, m(4), m(5), m(6), m(7));
  end raiden_decrypt;
end raiden;
