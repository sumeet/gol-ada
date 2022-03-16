package gol is
   WIDTH  : constant := 500;
   HEIGHT : constant := 500;

   type GridType is array (1 .. WIDTH, 1 .. HEIGHT) of Boolean;
   Grid : GridType := (others => (others => False));

   procedure Init;
   procedure Next_Gen;

end gol;
