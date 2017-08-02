with byte_package; use byte_package;
with raiden;

package file_crypter is
  subtype key_s is raiden.key_s;
  type mode is (encrypt, decrypt);
  procedure init_key(key : raiden.key_s);
  procedure file_crypt(in_file : byte_io.File_Type; out_file : out byte_io.File_Type; mode_crypt : mode);
end file_crypter;
