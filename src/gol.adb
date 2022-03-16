with Ada.Numerics.Discrete_Random;

package body gol is
   procedure Init is
      subtype Random_Range is Integer range 0 .. 2;
      package R is new Ada.Numerics.Discrete_Random (Random_Range);
      use R;

      G : Generator;
   begin
      Reset (G);

      for X in Grid'Range (1) loop
         for Y in Grid'Range (2) loop
            Grid (X, Y) := Random (G) /= 1;
         end loop;
      end loop;
   end Init;

   procedure Next_Gen is
      type NumNeighborsType is range 0 .. 8;
      type XType is range 1 .. WIDTH;
      type YType is range 1 .. HEIGHT;

      function Neighbors (X : XType; Y : YType) return NumNeighborsType is
         Count      : NumNeighborsType := 0;
         Neighbor_X : Integer;
         Neighbor_Y : Integer;
      begin
         for DX in -1 .. 1 loop
            for DY in -1 .. 1 loop
               Neighbor_X := DX + Integer (X);
               Neighbor_Y := DY + Integer (Y);
               if
                 ((Neighbor_X = Integer (X)
                   and then (Neighbor_Y = Integer (Y))))
                 or else (Neighbor_X < 1) or else (Neighbor_X > WIDTH)
                 or else (Neighbor_Y < 1) or else (Neighbor_Y > HEIGHT)
               then
                  goto Continue;
               end if;

               if Grid (Neighbor_X, Neighbor_Y) then
                  Count := Count + 1;
               end if;

               <<Continue>>
            end loop;
         end loop;
         return Count;
      end Neighbors;

      Next_Grid    : GridType := Grid;
      IsAlive      : Boolean;
      NumNeighbors : NumNeighborsType;
   begin
      for X in Grid'Range (1) loop
         for Y in Grid'Range (2) loop
            IsAlive      := Grid (X, Y);
            NumNeighbors := Neighbors (XType (X), YType (Y));

            if IsAlive then
               if NumNeighbors < 2 or else NumNeighbors > 3 then
                  Next_Grid (X, Y) := False;
               end if;
            else
               Next_Grid (X, Y) := NumNeighbors = 3;
            end if;
         end loop;
      end loop;

      Grid := Next_Grid;
   end Next_Gen;
end gol;
