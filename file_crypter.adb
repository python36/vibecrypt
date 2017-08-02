package body file_crypter is
  procedure init_key(key : key_s) is
  begin
    raiden.init_key(key);
  end init_key;

  procedure file_crypt(in_file : byte_io.File_Type; out_file : out byte_io.File_Type; mode_crypt : mode) is
  type raiden_access is access procedure (x : in byte_array_8; y : out byte_array_8);
  raiden_operation : raiden_access;
  t_b : byte;
  in_buf, out_buf : byte_array_8;
  in_ind : earth := 0;
  t_i : integer := 7;
begin
  if mode_crypt = mode'(encrypt) then
    raiden_operation := raiden.raiden_encrypt'access;
  else
    raiden_operation := raiden.raiden_decrypt'access;
  end if;
  loop
    if byte_io.end_of_file(in_file) then
      if in_ind /= 0 then
        for i in in_ind..7 loop
          in_buf(integer(i)) := 0;
        end loop;
      else
        exit;
      end if;
      in_ind := 0;
    else
      byte_io.read(in_file, t_b);
      in_buf(integer(in_ind)) := t_b;
      increment(in_ind);
    end if;
    if in_ind = 0 then
      raiden_operation(in_buf, out_buf);
      if byte_io.end_of_file(in_file) then
        for i in reverse 0..7 loop
          if out_buf(i) /= 0 then
            t_i := i;
            exit;
          end if;
        end loop;
      end if;
      for i in 0..t_i loop
        byte_io.write(out_file, out_buf(i));
      end loop;
    end if;
  end loop;
end file_crypt;
end file_crypter;