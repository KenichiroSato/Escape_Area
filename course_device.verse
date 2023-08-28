
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
course_device := class(creative_device):

    @editable ShutterDevices : []prop_mover_device = array{}
    @editable Teleporter: teleporter_device = teleporter_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Teleporter.EnterEvent.Subscribe(OnTeleported)

    OnTeleported(Agent: agent):void=
        Print("OnTeleported")
        for(Index : int = 0..ShutterDevices.Length - 1 ):
            if(Shutter := ShutterDevices[Index]):
        #       Shutter.Reverse()