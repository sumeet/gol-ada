with Ada.Text_IO;
with SDL;
with SDL.Video.Renderers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Windows.Makers;
with SDL.Events.Events;
with SDL.Events.Keyboards;

with gol;
with Interfaces.C;

procedure Main is
   SCREEN_W : constant := gol.WIDTH * 4;
   SCREEN_H : constant := gol.HEIGHT * 4;

   use SDL.Video.Windows;
   use SDL.Video.Renderers;
   use Ada.Text_IO;
   use Interfaces.C;
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

begin
   --  Look like Audio has to be enabled otherwise crash at shutdown
   if not SDL.Initialise (SDL.Enable_Audio) then
      raise Program_Error with "Could not initialise SDL";
   end if;

   SDL.Video.Windows.Makers.Create
     (Window, Title => "GoL", Position => (1_000, 1_500),
      Size          => (SCREEN_W, SCREEN_H), Flags => 0);

   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);

   gol.Init;

   loop
      declare
         use SDL.Events;
         use type SDL.Events.Keyboards.Key_Codes;

         Event : SDL.Events.Events.Events;
      begin
         if Events.Poll (Event) then
            exit when Event.Common.Event_Type = Quit;
            exit when Event.Common.Event_Type = Keyboards.Key_Down and
              Event.Keyboard.Key_Sym.Key_Code =
                SDL.Events.Keyboards.Code_Escape;
         else
            delay 0.001;
         end if;
      end;

      Renderer.Set_Draw_Colour ((0, 0, 0, 255));
      Renderer.Fill (Rectangle => (0, 0, SCREEN_W, SCREEN_H));

      Renderer.Set_Draw_Colour ((255, 255, 255, 255));
      for X in gol.Grid'Range (1) loop
         for Y in gol.Grid'Range (2) loop

            if gol.Grid (X, Y) then
               Renderer.Fill
                 (Rectangle => ((int (X) - 1) * 4, (int (Y) - 1) * 4, 4, 4));
            end if;
         end loop;
      end loop;

      Window.Update_Surface;

      gol.Next_Gen;

   end loop;

   SDL.Finalise;
end Main;
