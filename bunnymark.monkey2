Namespace bunnies

' Load up the assets

#Import "assets/wabbit_alpha.png"
#Import "assets/wabbit_alpha2.png"
#Import "assets/wabbit_alpha3.png"
#Import "assets/wabbit_alpha4.png"

' Load up imports
#Import "<std>"
#Import "<mojo>"
Using std..
Using mojo..


Const VWIDTH:=1024
Const VHEIGHT:=768

Class Bunnymark Extends Window 
	Field frames: Int = 1
	Field elapsed: Int = 1
	Field bunnies:Bunny[] = New Bunny[20]
	Field images:Image[] = New Image[]( 
			Image.Load("asset::wabbit_alpha.png"),
			Image.Load("asset::wabbit_alpha2.png"),
			Image.Load("asset::wabbit_alpha3.png"),
			Image.Load("asset::wabbit_alpha4.png") )
	Field lastMilli := Millisecs()
	
	Method New()
		Super.New("Bunnymark", VWIDTH, VHEIGHT, WindowFlags.Resizable )
		For Local i:=0 Until bunnies.Length
			bunnies[i] = New Bunny( 0, 0, images[ Floor( random.Rnd( 3 )) ] )
		Next
		
	End
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		
		For Local bunny:=Eachin bunnies
			bunny.Update()
			bunny.Draw(canvas)
		Next
		
		elapsed += Millisecs() - lastMilli
		Local avg :=  1000/( ( elapsed /frames) )
		
		canvas.Color = Color.White 
		canvas.DrawRect( 0, 0, VWIDTH, 25 )
		
		canvas.Color = Color.Black
		canvas.DrawText("The Bunnymark ( " + bunnies.Length + " )",0,0)
		canvas.DrawText(" FPS: " + avg, 300, 0 )
		
		frames += 1
		If frames > 100 
			frames = 1
			elapsed = 1
		Endif 
		lastMilli = Millisecs()
	End Method	
	
	Method OnMouseEvent( event:MouseEvent ) Override
		If event.Type = EventType.MouseDown
			Local _len := 0 
			If event.Button = MouseButton.Left
				_len = 10
			Elseif event.Button = MouseButton.Right
				_len = 100
			End  
			bunnies = bunnies.Resize( bunnies.Length + _len )
			For Local i:=1 Until _len + 1
			 bunnies[bunnies.Length-i] = New Bunny( Mouse.X, Mouse.Y, images[ Floor( random.Rnd( 4 )) ] )
			End
		End 	
	End Method	

End

Class Bunny 
	Field x: Float 
	Field y: Float 
	Field xspeed: Float
	Field yspeed: Float 
	Field texture: Image
	Global  gravity := 0.5
	
	Method New( x: Float, y: Float, texture:Image )
		Self.x = x
		Self.y = y
		Self.texture = texture
		xspeed = random.Rnd( 10 )
	End
	
	Method Update:Void( )
		yspeed += gravity 
		y += yspeed
		x += xspeed
		
		If y >= VHEIGHT
			y = VHEIGHT 
			yspeed = -random.Rnd( 35 )
		Endif 
		If x < 0 Or x > VWIDTH 
			xspeed *= -1
			x = Clamp(x, 0.0, Float(VWIDTH)	 )
		Endif 
	End
	
	Method Draw(canvas:Canvas)
		canvas.DrawImage( texture, x, y )
	End	
End

Function Main()
	New AppInstance
	New Bunnymark
	App.Run()
End Function
