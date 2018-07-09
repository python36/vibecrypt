with Ada.Text_IO;
with file_crypter;
with byte_package;
with Ada.Command_Line;
with System.os_lib;
with Ada.Exceptions;

procedure vibecrypt is
  in_file : byte_package.byte_io.File_Type;
  out_file : byte_package.byte_io.File_Type;

  mode : file_crypter.mode;
  password : file_crypter.key_s;

  procedure help is
  begin
    Ada.text_io.put_line(
      "Vibecrypt is very simple tool to encrypt/decrypt your file." & ASCII.FF & ASCII.CR &
      "Written in Ada. Uses Raiden cypher (http://raiden-cipher.sourceforge.net/)" & ASCII.FF & ASCII.CR &
      "Help:" & ASCII.FF & ASCII.CR &
      " vibecrypter -h" & ASCII.FF & ASCII.CR &
      "Usage:" & ASCII.FF & ASCII.CR &
      " vibecrypt key -e|-d in_file out_file [-r]" & ASCII.FF & ASCII.CR &
      "  key: length from 6 to 16 characters."  & ASCII.FF & ASCII.CR &
      "       if length < 16 - will be supplemented with underscores ('_')." & ASCII.FF & ASCII.CR &
      "       if length > 16 - will be truncated to 16 characters" & ASCII.FF & ASCII.CR &
      "  -e: encryption" & ASCII.FF & ASCII.CR &
      "  -d: decryption" & ASCII.FF & ASCII.CR &
      "  -r: rewrite file" & ASCII.FF & ASCII.CR &
      "Example:" & ASCII.FF & ASCII.CR &
      " vibecrypt " & '"' & "0123456789abcdef" & '"' & "-e test_m.txt test_c.txt -r" & ASCII.FF & ASCII.CR &
      "The key can contain one of the characters:"  & ASCII.FF & ASCII.CR &
      " ' ', '!', '" & '"' & "', '#', '$', '%', '&'," & ASCII.FF & ASCII.CR &
      " ''', '(', ')', '*', '+', ',', '-', '.', '/', '0'," & ASCII.FF & ASCII.CR &
      " '1', '2', '3', '4', '5', '6', '7', '8', '9', ':'," & ASCII.FF & ASCII.CR &
      " ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D'," & ASCII.FF & ASCII.CR &
      " 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'," & ASCII.FF & ASCII.CR &
      " 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X'," & ASCII.FF & ASCII.CR &
      " 'Y', 'Z', '[', '\', ']', '^', '_', '`', 'a', 'b'," & ASCII.FF & ASCII.CR &
      " 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l'," & ASCII.FF & ASCII.CR &
      " 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v'," & ASCII.FF & ASCII.CR &
      " 'w', 'x', 'y', 'z', '{', '|', '}', '~'");
  end help;

begin
  if Ada.Command_Line.Argument_Count = 1 and Ada.Command_Line.Argument(1) = "-h" then
    help;
    system.os_lib.os_exit(0);
  elsif Ada.Command_Line.Argument_Count not in 4..5 then
    Ada.text_io.put_line("see format");
    system.os_lib.os_exit(0);
  end if;

  if Ada.Command_Line.Argument(1)'length < 6 then
    Ada.text_io.put_line("Minimum key length - 6");
    system.os_lib.os_exit(0);
  elsif Ada.Command_Line.Argument(1)'length >= 16 then
    password := Ada.Command_Line.Argument(1)(1..16);
  else
    password(1..Ada.Command_Line.Argument(1)'length) := Ada.Command_Line.Argument(1);
    for i in (Ada.Command_Line.Argument(1)'length + 1)..16 loop
      password(i) := character'val(character'pos(' ') + i);
    end loop;
  end if;
  for i in 1..16 loop
    ada.text_io.put_line(" " & password(i));
    if password(i) not in ' '..'~' then
      Ada.text_io.put_line("The key contains an invalid character");
      system.os_lib.os_exit(0);
    end if;
  end loop;

  file_crypter.init_key(password);

  if Ada.Command_Line.Argument(2) = "-e" then
    mode := file_crypter.mode'(file_crypter.encrypt);
  elsif Ada.Command_Line.Argument(2) = "-d" then
    mode := file_crypter.mode'(file_crypter.decrypt);
  else
    Ada.text_io.put_line("The first argument must be -e or -d");
    system.os_lib.os_exit(0);
  end if;

  if not system.os_lib.Is_Regular_File(Ada.Command_Line.Argument(3)) then
    Ada.text_io.put_line(Ada.Command_Line.Argument(3) & "  is not a regular file");
    system.os_lib.os_exit(0);
  else
    byte_package.byte_io.open(in_file, byte_package.byte_io.In_File, Ada.Command_Line.Argument(3), "");
  end if; 

  if Ada.Command_Line.Argument_Count = 5 then
    if Ada.Command_Line.Argument(5) /= "-r" then
      Ada.text_io.put_line("The fifth argument can be only -r");
      system.os_lib.os_exit(0);
    end if;
    if not system.os_lib.Is_Writable_File(Ada.Command_Line.Argument(4)) then
      Ada.text_io.put_line(Ada.Command_Line.Argument(4) & " is not a writable file");
      system.os_lib.os_exit(0);
    end if;
    byte_package.byte_io.open(out_file, byte_package.byte_io.Out_File, Ada.Command_Line.Argument(4), "");
  else
    if system.os_lib.Is_Regular_File(Ada.Command_Line.Argument(4)) then
      Ada.text_io.put_line(Ada.Command_Line.Argument(4) & " already exists. Use -r to overwrite");
      system.os_lib.os_exit(0);
    end if;
    byte_package.byte_io.create(out_file, byte_package.byte_io.Out_File, Ada.Command_Line.Argument(4), "");
  end if;

  file_crypter.file_crypt(in_file, out_file, mode);

  byte_package.byte_io.close(in_file);
  byte_package.byte_io.close(out_file);

  exception
    when Error: others =>
      Ada.Text_IO.Put_Line("Error: " & Ada.Exceptions.Exception_Message(Error));
end vibecrypt;
