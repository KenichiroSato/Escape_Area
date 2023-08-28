
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
answer_device := class(creative_device):

    @editable Button1 :button_device = button_device{}
    @editable Button2 :button_device = button_device{}
    @editable Button3 :button_device = button_device{}
    @editable Button4 :button_device = button_device{}
    @editable Button5 :button_device = button_device{}
    @editable Button6 :button_device = button_device{}
    @editable Button7 :button_device = button_device{}
    @editable Button8 :button_device = button_device{}
    @editable Button9 :button_device = button_device{}
    @editable Button0 :button_device = button_device{}
    @editable ButtonClear :button_device = button_device{}
    @editable ButtonEnter :button_device = button_device{}

    @editable AnswerBoard : billboard_device = billboard_device{}
    @editable CorrectAnswer: string = ""

    @editable Gatemover: prop_mover_device = prop_mover_device{}
    @editable GateSpeaker: audio_player_device = audio_player_device{}
    @editable SoundEffectSpeaker: audio_player_device = audio_player_device{}
    @editable SoundEffectInput: audio_player_device = audio_player_device{}
    @editable MonsterMover: monster_device = monster_device{}


    var CurrentInput<private>: string = ""


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button0.InteractedWithEvent.Subscribe(OnButton0)
        Button1.InteractedWithEvent.Subscribe(OnButton1)
        Button2.InteractedWithEvent.Subscribe(OnButton2)
        Button3.InteractedWithEvent.Subscribe(OnButton3)
        Button4.InteractedWithEvent.Subscribe(OnButton4)
        Button5.InteractedWithEvent.Subscribe(OnButton5)
        Button6.InteractedWithEvent.Subscribe(OnButton6)
        Button7.InteractedWithEvent.Subscribe(OnButton7)
        Button8.InteractedWithEvent.Subscribe(OnButton8)
        Button9.InteractedWithEvent.Subscribe(OnButton9)
        ButtonClear.InteractedWithEvent.Subscribe(OnClearPressed)
        ButtonEnter.InteractedWithEvent.Subscribe(OnEnterPressed)

    OnButton0(Agent: agent):void = OnButtonPressed(Agent, "0")
    OnButton1(Agent: agent):void = OnButtonPressed(Agent, "1")
    OnButton2(Agent: agent):void = OnButtonPressed(Agent, "2")
    OnButton3(Agent: agent):void = OnButtonPressed(Agent, "3")
    OnButton4(Agent: agent):void = OnButtonPressed(Agent, "4")
    OnButton5(Agent: agent):void = OnButtonPressed(Agent, "5")
    OnButton6(Agent: agent):void = OnButtonPressed(Agent, "6")
    OnButton7(Agent: agent):void = OnButtonPressed(Agent, "7")
    OnButton8(Agent: agent):void = OnButtonPressed(Agent, "8")
    OnButton9(Agent: agent):void = OnButtonPressed(Agent, "9")

    OnClearPressed(Agend: agent):void =
        PlayInputSound()
        UpdateAnswerBoard("")

    OnEnterPressed(Agent: agent):void =
        PlayInputSound()
        IsCorrect := IsCorrectInput(CurrentInput)
        if (IsCorrect?):
            Gatemover.Advance()
            GateSpeaker.Play()
            SoundEffectSpeaker.Play()
            spawn{ResetGate()}
        else:
            spawn{MonsterMover.FollowPlayer(Agent)}
        UpdateAnswerBoard("")

    ResetGate()<suspends>:void =
        Sleep(15.0)
        Gatemover.Reverse()


    IsCorrectInput<private>(Input: string):logic =
        if (Input = CorrectAnswer):
            return true
        else if (Input = "0"+CorrectAnswer):
            return true
        else if (Input = "00"+CorrectAnswer):
            return true
        else :
            return false


    OnButtonPressed(Agent: agent, Num: string):void =
        Print("{Num} is pressed")
        PlayInputSound()
        if (CurrentInput.Length > 2):
            return
        UpdateAnswerBoard(CurrentInput + Num)

    PlayInputSound():void =
        SoundEffectInput.Stop()
        SoundEffectInput.Play()

    UpdateAnswerBoard(NewVal: string): void =
        set CurrentInput = NewVal
        AnswerBoard.SetText(StringToMessage(CurrentInput))
        AnswerBoard.UpdateDisplay()


    StringToMessage<localizes>(value:string) : message = "{value}"  