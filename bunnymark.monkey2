Namespace bunnies

' Load up the assets
#Import "assets/atlas.png"
#Import "assets/atlas.xml"

' Load up imports
#Import "<std>"
#Import "<mojo>"
#Import "<tinyxml2>"
Using std..
Using mojo..
Using tinyxml2..

Global images := New Stack<Image>

Function GrabImage:Image( sourceImage:Image, el:XMLElement )
	Local left 	 := Int( el.Attribute("x") )
	Local top  	 := Int( el.Attribute("y") )
	Local width	 := Int( el.Attribute("w") )
	Local height := Int( el.Attribute("h") )
	Return New Image( sourceImage, New Recti( left, top, left + width, top + height ))
End

Class Bunnymark Extends Window 
	Const BUNNY_AMT := 1000
	Field bunnies := New Stack<Bunny>
	
	Method New()
		Super.New("Bunnymark", 1024, 768, WindowFlags.Resizable )
		
		LoadAtlas()

		For Local i:=0 Until BUNNY_AMT
			bunnies.Push( New Bunny( 0, 0 ) )
		Next
	End
	
	Method LoadAtlas()
		Local atlasPng := Image.Load("asset::atlas.png")
		
		Local doc := New XMLDocument()
		If doc.Parse( LoadString("asset::atlas.xml") ) = XMLError.XML_SUCCESS
			Local imgEl := doc.LastChild().FirstChildElement()
			While imgEl <> Null 
				images.Push( GrabImage( atlasPng, imgEl ) )
				imgEl = imgEl.NextSiblingElement()
			Wend
		Endif			
	End
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		
		For Local bunny:=Eachin bunnies
			bunny.Update()
			bunny.Draw(canvas)
		Next
		
		canvas.Color = Color.White 
		canvas.DrawRect( 0, 0, App.ActiveWindow.Width, 25 )
		
		canvas.Color = Color.Black
		canvas.DrawText("The Bunnymark ( " + bunnies.Length + " )",0,0)
		canvas.DrawText(" FPS: " + App.FPS, 300, 0 ) ' App.FPS suggested by abakobo
	End
	
	Method OnMouseEvent( event:MouseEvent ) Override
		If event.Type = EventType.MouseDown Then 
			Local _len := 0 
			Select event.Button
				Case MouseButton.Left 	_len = 10
				Case MouseButton.Right 	_len = 1000
				Case MouseButton.Middle _len = -100
			End
			For Local i:=0 Until Abs(_len)
			 	If _len > 0 bunnies.Push(New Bunny( Mouse.X, Mouse.Y )) Else bunnies.Pop()
			End
		Endif 	
	End

End

Class Bunny 
	Field pos:Vec2f
	Field speed:Vec2f = New Vec2f
	Field texture: Image
	Global gravity := 0.5
	
	Method New( x: Float, y: Float )
		pos = New Vec2f( x, y )
		texture = images[ Floor( random.Rnd( images.Length  ))]
		speed.x = random.Rnd( 20 ) - 10
	End
	
	Method Update:Void( )
		speed.y += gravity
		pos += speed
		
		If pos.y >= App.ActiveWindow.Height Then 
			pos.y = App.ActiveWindow.Height 
			speed.y = -random.Rnd( 35 )
		Endif 
		
		If pos.x < 0 Or pos.x > App.ActiveWindow.Width Then 
			speed.x *= -1
			pos.x = Clamp( pos.x, 0.0, Float(App.ActiveWindow.Width))
		Endif 
	End
	
	Method Draw(canvas:Canvas)
		canvas.DrawImage( texture, pos )
	End	
End


Function Main()
	New AppInstance
	New Bunnymark
	App.Run()
End Function
