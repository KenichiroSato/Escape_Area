
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
setup_device := class(creative_device):

    @editable FlashlightGranter: item_granter_device = item_granter_device{}
    @editable SpawnDevices:[]player_spawner_device = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for(Index : int = 0..SpawnDevices.Length - 1 ):
            if(SpawnDevice := SpawnDevices[Index]):
                SpawnDevice.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnPlayerSpawned(Agent: agent):void=
        FlashlightGranter.GrantItem(Agent)
