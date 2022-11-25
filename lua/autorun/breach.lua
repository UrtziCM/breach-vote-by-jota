AddCSLuaFile()
breachJotaIsActive = false

scpJobs = {
        "/SCP173",
        "/SCP096",
        "/SCP682",
        "/SCP106",
        "/SCP1048",
        "/SCP939",
        "/SCP966"
}

hook.Add( "PlayerSay", "IniciarBrechaJota", function( ply, text )
        if ply:IsAdmin() == true and breachJotaIsActive == false then
                if ( string.lower( text ) == "/brechaseguridad" ) then
                        PrintMessage(HUD_PRINTTALK, "Todos los empleados parecen nerviosos... Algo se avecina.")
                        getPlayerForScp()
                        return ""
                end
        end
end )

hook.Add( "PlayerSay", "VoteSCPWant", function( ply, text )
        if ( string.lower( text ) == "/voteyes" ) and searchingForPlayer == true and ply == randomPlayerForScp then      
                breachJotaIsActive = true
                searchingForPlayer = false
                ply:Say( table.Random(scpJobs))
                timer.Create("KillSCPAfterTimeToPlay", 1200 , 1 ,  function()
                        if randomPlayerForScp:Alive() and breachJotaIsActive == true then
                                randomPlayerForScp:Kill()
                        end
                        PrintMessage(HUD_PRINTTALK, "Brecha contenida.")
                        breachJotaIsActive = false
                end)
                return ""
        end
end )

hook.Add( "PlayerSay", "VoteSCPWantNegative", function( ply, text )
        if ( string.lower( text ) == "/voteno" ) and searchingForPlayer == true and ply == randomPlayerForScp then      
                getPlayerForScp()
                return ""
        end
end )

hook.Add( "PlayerDeath" , "DidScpDie" , function( victim )
        if victim == randomPlayerForScp then  
                timer.Simple( 10 , function() 
                        breachJotaIsActive = false
                        PrintMessage(HUD_PRINTTALK, "Brecha contenida.")
                        timer.Remove("KillSCPAfterTimeToPlay")
                end )
        end
end )
hook.Add( "PlayerSpawn" , "DidScpRespawn" , function()
        timer.Simple( 2 , function() 
        randomPlayerForScp:Say( "/prisionero")
        randomPlayerForScp = nil
        end )
end )

function getPlayerForScp() 
        allPlayerList = player.GetAll()
        randomPlayerForScp = table.Random(allPlayerList)
        randomPlayerForScp:ChatPrint( "Quieres ser parte de la brecha como SCP? Escribe /voteyes para aceptar y /voteno para rechazar." )
        searchingForPlayer = true
end

concommand.Add("brechajota_check" , function()
        print(breachJotaIsActive)
        print(randomPlayerForScp)
        print(searchingForPlayer)
        print(timeToPlay)
end)
concommand.Add("brechajota_help" , function()
        print("------------------------------")
        print("/brechaseguridad")
        print("/voteyes")
        print("/voteno")
        print("------------------------------")
end)
