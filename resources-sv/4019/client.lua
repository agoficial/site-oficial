local x,y = guiGetScreenSize()
local screenW, screenH = guiGetScreenSize()
local resW, resH = 1365, 767
local xe, ye =  (screenW/resW), (screenH/resH)
local fonts = dxCreateFont("shared/1.otf", 17)
local font = dxCreateFont("shared/1.otf", 9)
local fonto = dxCreateFont("shared/1.otf", 12)
local speedX = 170
local speedY = 105
local speedometr = 0

local probegX = 287
local probegY = 61

local fuelX = 117
local fuelY = 72

local driveDistance
addEventHandler("onClientRender", root, 
	function ()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	if isPedInVehicle(getLocalPlayer()) then 
		--setElementData(veh, "fuel", getElementData(veh, "maxFuel"))
		if not driveDistance then lastTick = getTickCount() driveDistance = getElementData ( veh, "probeg" ) or 0 end
			local speed = around(getElementSpeed(veh), 0).." КМ/Ч" --around(getElementSpeed(localPlayer.vehicle), 0)
			local probeg = math.ceil(getElementData(veh, "probeg")).." КМ" or "0 КМ"
			local fuel = "Бензин: "..math.ceil(getElementData(veh, "fuel")).." л." or "1 л."
			local maxFuel = getElementData(veh, "maxFuel") or "100"
			local vida = getElementData(veh, "fuel") or "0"
			--setElementData(veh, "speed", speed)
			dxDrawImage( x - 371, y-170, 377, 181, "shared/fon.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
   			dxDrawText(speed,  x-speedX,y-speedY,x-speedX, y-speedY, tocolor(255, 255, 255, 255), 1, fonts, "center", "center", false, true, true, false, false)
   			dxDrawText(probeg,  x-probegX,y-probegY,x-probegX,y-probegY, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, true, true, false, false)
   			dxDrawText(fuel,  x-fuelX,y-fuelY,x-fuelX,y-fuelY, tocolor(255, 255, 255, 255), 1, fonto, "center", "center", false, true, true, false, false)
   			dxDrawRectangle(x-195,y-61,155/maxFuel*vida,ye*2, tocolor(242, 116, 116, 255), true)
			if getVehicleEngineState(veh) == true then
				dxDrawImage( x - 337, y-44,25, 25, "shared/engine.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end
			if getVehicleOverrideLights (veh) == 2 then
				dxDrawImage( x - 310, y-42,22, 20, "shared/lights.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end
			if isVehicleLocked(veh) then
				dxDrawImage( x - 286, y-42,22, 21, "shared/lock.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end
			if getElementHealth(veh) <= 500 then
				dxDrawImage( x - 263, y-42,22, 22, "shared/hp.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end

			-- Пробег
		local neux, neuy, neuz = getElementPosition(veh)
		if not altx or not alty or not altz then
		altx, alty, altz=getElementPosition(veh)
		end
		local driveTotal = getDistanceBetweenPoints3D(neux,neuy,neuz,altx,alty,altz)
		driveTotal = driveTotal/1000
		altx,alty,altz=neux,neuy,neuz
		driveDistance = math.round(driveDistance+driveTotal,3)
		setElementData ( veh, "probeg", driveDistance )

		if lastTick+5000 < getTickCount() then
			lastTick = getTickCount()
			setElementData ( veh, "probeg", driveDistance )
		end
		end
	end
)

addEventHandler("onClientVehicleEnter", getRootElement(), 
		function()
			speedometr = 1
		end
	)
	addEventHandler("onClientVehicleExit", getRootElement(), 
		function()
			speedometr = 0
		end
	)

addEventHandler("onClientPlayerVehicleEnter",getRootElement(),function(veh,seat)
	if source == localPlayer then
		altx, alty, altz=getElementPosition(veh)
		lastTick = getTickCount()
		setElementData(veh, "probeg", getElementData(veh, "probeg") or 0)
		driveDistance = getElementData ( veh, "probeg" )
		--outputChatBox ("distance on enter "..tostring(driveDistance).." "..tostring(getElementData ( veh, "probeg" )))
	end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer,
	function (vehicle, seat)
		if seat == 0 then
			setElementData ( vehicle, "probeg", driveDistance )
			driveDistance = nil
		end
	end)

addEventHandler("onClientPlayerWasted",getLocalPlayer(),function ()
	local veh = getPedOccupiedVehicle(getLocalPlayer()) 
	if not veh and getVehicleOccupant ( veh ) ~= localPlayer then return true end
	setElementData ( source, "probeg", driveDistance )
	driveDistance = nil
end)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getElementSpeed(element, k)
	local speedx, speedy, speedz = getElementVelocity(element)
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	if k == "kmh" or k == nil or k == 1 then return around(actualspeed * 180, 5)
	elseif k == "mps" or k == 2 then return around(actualspeed * 50, 5)
	elseif k == "mph" or k == 3 then return around(actualspeed * 111.847, 5) end
end

function around(fst, snd)
     local mid = math.pow(10,snd)
     return math.floor((fst*mid)+0.5)/mid
end