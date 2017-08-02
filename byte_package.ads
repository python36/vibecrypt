with ada.text_io;
with interfaces;
with Ada.Sequential_IO;

package byte_package is
  type earth is mod 2**3;
  type byte is mod 2**8;
  type dword is mod 2**32;
  type byte_array_8 is array (0..7) of byte;
  procedure to_byte (in_dword : in dword; b1, b2, b3, b4 : out byte);
  function to_dword (b1, b2, b3, b4 : byte) return dword;
  function dword_shift_right (value : dword; amount : integer := 1) return dword;
  function dword_shift_left (value : dword; amount : integer := 1) return dword;
  procedure increment (e : in out earth);

  package byte_io is new Ada.Sequential_IO(byte);





function byte_shift_right (value : byte; amount : integer := 1) return byte;
  procedure byte_print (b : byte);
    

end byte_package;