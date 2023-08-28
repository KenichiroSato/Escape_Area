
using { /Fortnite.com/Devices }
using {/Fortnite.com/Characters}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
monster_device := class(creative_device):

    @editable var Monster : creative_prop = creative_prop{}
    @editable var MonsterMutator : mutator_zone_device = mutator_zone_device{}
    @editable var LaughSpeaker : audio_player_device = audio_player_device{}
    @editable Light: customizable_light_device = customizable_light_device{}
    var InitialPosition<private>: vector3 = vector3{X:=0.0, Y:= 0.0, Z:=0.0}
    var InitialRotation<private>: rotation = rotation{}
    var CurrentAgent<private>: ?agent = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        set InitialPosition = Monster.GetTransform().Translation
        set InitialRotation = Monster.GetTransform().Rotation
        MonsterMutator.AgentEntersEvent.Subscribe(OnPlayerCaptured)

    OnPlayerCaptured(Agent : agent) :void =
        if (CurrentAgent = false):
            return
        if (FortniteCharacter : fort_character = Agent.GetFortCharacter[]):
            MyCharacterHealth : float = FortniteCharacter.GetHealth()
            FortniteCharacter.Damage(MyCharacterHealth)
        if (Current:= CurrentAgent?, Current = Agent) {
            set CurrentAgent = false
            BackToInitialPosition()
        }

    BackToInitialPosition():void =
        Light.TurnOff()
        spawn{Monster.MoveTo(InitialPosition, InitialRotation, 1.0 )}
    
    FollowPlayer(Agent : agent)<suspends>:void=
        set CurrentAgent = option{Agent}
        var MoveSpeed :float = 0.1
        Light.TurnOn()
        LaughSpeaker.Play()
        loop:
            if (CurrentAgent = false):
                break
            if (PlayerCharacter := Agent.GetFortCharacter[]):
                PropLocation := Monster.GetTransform().Translation
                PlayerLocation := PlayerCharacter.GetTransform().Translation
                if (LookDirection := (PlayerLocation - PropLocation).MakeUnitVector[]):
                    Yaw := RadiansToDegrees(ArcTan(LookDirection.Y, LookDirection.X)) + 140.0
                    Pitch := 0.0 #RadiansToDegrees(ArcTan(LookDirection.Z, Sqrt((LookDirection.X * LookDirection.X) + (LookDirection.Y * LookDirection.Y))))
                    Roll := 0.0
                    NewRotation := MakeRotationFromYawPitchRollDegrees(Yaw, Pitch, Roll)
                    # Movement
                    LerpLocation := Lerp(PropLocation, PlayerLocation, MoveSpeed)
                    FinalLocation := vector3{X := LerpLocation.X, Y := LerpLocation.Y, Z := LerpLocation.Z}
                    Monster.MoveTo(FinalLocation, NewRotation, 0.5)
                    set MoveSpeed += 0.2
            Sleep(0.0)