with byte_package; use byte_package;

package raiden is
  subtype key_s is String(1..16);
  procedure init_key(key_init : key_s);
  procedure raiden_encrypt(m : in byte_array_8; c : out byte_array_8);
  procedure raiden_decrypt(c : in byte_array_8; m : out byte_array_8);
private
  type key_t is array(integer range 0..3) of dword;
  key : key_t := (16#9cab2f30#, 16#ecbb1044#, 16#143b0000#, 16#00ff145a#);
  t_k : key_t;
end raiden;