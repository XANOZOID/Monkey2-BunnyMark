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


Const VWIDTH:=1024
Const VHEIGHT:=768

Class Bunnymark Extends Window 
	Field frames: Int = 1
	Field elapsed: Int = 1
	Field bunnies:Bunny[] = New Bunny[0]
	Field images:Image[]
	Field lastMilli := Millisecs()
	
	Method New()
		Super.New("Bunnymark", VWIDTH, VHEIGHT, WindowFlags.Resizable )
		
		LoadAtlas()

		For Local i:=0 Until bunnies.Length
			bunnies[i] = New Bunny( 0, 0, images[ Floor( random.Rnd( images.Length )) ] )
		Next
		
	End
	
	Method LoadAtlas()
		Local atlasPng := Image.Load("asset::atlas.png")
		
		Local xml := LoadString("asset::atlas.xml")
		Local doc := New XMLDocument()
		If doc.Parse(xml) <> XMLError.XML_SUCCESS Then 
			Print "Failed to parse embedded XML!"
			Return
		Endif		
		
		' load in all images ...
		images = New Image[4]
		Local atlasNode := doc.FirstChild().NextSiblingElement()
		Local imgEl := atlasNode.FirstChildElement()
		Local i := 0
		While imgEl <> Null 
			images[i] = GrabImage( atlasPng, imgEl )
			imgEl = imgEl.NextSiblingElement()
			i += 1
		Wend	
	End
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		
		For Local bunny:=Eachin bunnies
			bunny.Update()
			bunny.Draw(canvas)
		Next
		
		canvas.Color = Color.White 
		canvas.DrawRect( 0, 0, VWIDTH, 25 )
		
		canvas.Color = Color.Black
		canvas.DrawText("The Bunnymark ( " + bunnies.Length + " )",0,0)
		canvas.DrawText(" FPS: " + App.FPS, 300, 0 ) ' App.FPS suggested by abakobo
	End Method	
	
	Method OnMouseEvent( event:MouseEvent ) Override
		If event.Type = EventType.MouseDown
			Local _len := 0 
			If event.Button = MouseButton.Left
				_len = 10
			Elseif event.Button = MouseButton.Right
				_len = 1000
			Elseif event.Button = MouseButton.Middle
				_len = -100	
			End  
			' Extra functionality ( RightButton / Middle ) added by @therevills
			bunnies = bunnies.Resize( bunnies.Length + _len )
			For Local i:=1 Until _len + 1
			 bunnies[bunnies.Length-i] = New Bunny( Mouse.X, Mouse.Y, images[ Floor( random.Rnd( images.Length  )) ] )
			End
		End 	
	End Method	

End

Class Bunny 
	Field pos:Vec2f
	Field speed:Vec2f = New Vec2f
	Field texture: Image
	Global gravity := 0.5
	
	Method New( x: Float, y: Float, _texture:Image )
		pos = New Vec2f( x, y )
		texture = _texture
		speed.x = random.Rnd( 20 ) - 10
	End
	
	Method Update:Void( )
		speed.y += gravity
		pos += speed
		
		If pos.y >= VHEIGHT Then 
			pos.y = VHEIGHT 
			speed.y = -random.Rnd( 35 )
		Endif 
		If pos.x < 0 Or pos.x > VWIDTH Then 
			speed.x *= -1
			pos.x = Clamp( pos.x, 0.0, Float(VWIDTH))
		Endif 
	End
	
	Method Draw(canvas:Canvas)
		canvas.DrawImage( texture, pos )
	End	
End

Function GrabImage:Image( sourceImage:Image, el:XMLElement )
	Local left 	 := Int( el.Attribute("x") )
	Local top  	 := Int( el.Attribute("y") )
	Local width	 := Int( el.Attribute("w") )
	Local height := Int( el.Attribute("h") )
	Return New Image( sourceImage, New Recti( left, top, left + width, top + height ))
End


Function Main()
	New AppInstance
	New Bunnymark
	App.Run()
End Function
