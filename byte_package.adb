package body byte_package is
  procedure to_byte (in_dword : in dword; b1, b2, b3, b4 : out byte) is
  begin
    b4 := byte(in_dword and 16#ff#);
    b3 := byte(dword_shift_right(in_dword, 8) and 16#ff#);
    b2 := byte(dword_shift_right(in_dword, 16) and 16#ff#);
    b1 := byte(dword_shift_right(in_dword, 24));
  end to_byte;

  function to_dword (b1, b2, b3, b4 : byte) return dword is
  begin
    return dword_shift_left(dword(b1), 24) or dword_shift_left(dword(b2), 16) or dword_shift_left(dword(b3), 8) or dword(b4);
  end;

  function dword_shift_left (value : dword; amount : integer := 1) return dword is
  begin
    return dword(Interfaces.Shift_Left(
      Value => Interfaces.Unsigned_32(value), Amount => amount));
  end;

  function dword_shift_right (value : dword; amount : integer := 1) return dword is
  begin
    return dword(Interfaces.Shift_Right(
      Value => Interfaces.Unsigned_32(value), Amount => amount));
  end;

  procedure increment (e : in out earth) is
  begin
    e := e + 1;
  end increment;
end byte_package;