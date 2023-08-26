local QBCore = exports['qb-core']:GetCoreObject()
local ActiveMission = 0

RegisterServerEvent('AttackTransport:akceptujto')
AddEventHandler('AttackTransport:akceptujto', function()
	local copsOnDuty = 0
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	local accountMoney = 0
	accountMoney = xPlayer.PlayerData.money["bank"]
	if ActiveMission == 0 then
		if accountMoney < Config.ActivationCost then
			TriggerClientEvent('QBCore:Notify', _source, "You need " .. Config.Currency .. "" ..Config.ActivationCost.. " in the bank to accept the mission")
		else
			for k, v in pairs(QBCore.Functions.GetPlayers()) do
				local Player = QBCore.Functions.GetPlayer(v)
				if Player ~= nil then
					if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
						copsOnDuty = copsOnDuty + 1
					end
				end
			end
			if copsOnDuty >= Config.ActivePolice then
				TriggerClientEvent("AttackTransport:Pozwolwykonac", _source)
				xPlayer.Functions.RemoveMoney('bank', Config.ActivationCost, "armored-truck")
				OdpalTimer()
			else
				TriggerClientEvent('QBCore:Notify', _source, 'Need at least '..Config.ActivePolice.. ' police to activate the mission.')
			end
		end
	else
		TriggerClientEvent('QBCore:Notify', _source, 'Someone is already carrying out this mission')
	end
end)

RegisterServerEvent('qb-armoredtruckheist:server:callCops')
AddEventHandler('qb-armoredtruckheist:server:callCops', function(streetLabel, coords)
    local place = "Armored Truck"
    local msg = "The Alarm has been activated from a "..place.. " at " ..streetLabel
    TriggerClientEvent("qb-armoredtruckheist:client:robberyCall", -1, streetLabel, coords)
end)

function OdpalTimer()
	ActiveMission = 1
	Wait(Config.ResetTimer*1000)
	ActiveMission = 0
	TriggerClientEvent('AttackTransport:CleanUp', -1)
end

RegisterServerEvent('AttackTransport:zawiadompsy')
AddEventHandler('AttackTransport:zawiadompsy', function(x ,y, z)
    TriggerClientEvent('AttackTransport:InfoForLspd', -1, x, y, z)
end)

RegisterServerEvent('AttackTransport:graczZrobilnapad')
AddEventHandler('AttackTransport:graczZrobilnapad', function(moneyCalc)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
--[[ 	local bags = math.random(1,5)
	local info = {
		worth = math.random(cashA, cashB)
	} ]]
	local rewardCash = math.random(5000,15000)
	--xPlayer.Functions.AddItem('markedbills', bags, false, info)
	--TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['markedbills'], "add")
	xPlayer.Functions.AddMoney("cash", rewardCash)
	TriggerClientEvent('QBCore:Notify', _source, 'You took '..rewardCash..' cash from the vehicle!')
	TriggerEvent("qb-log:server:CreateLog", "robbery", "Truck ROB", "green", "**"..GetPlayerName(source) .. "** has robbed $"..rewardCash.." from the truck.")
	
	local chance = math.random(1, 100)


	if chance >= 70 then
	local goldAmount = 8
	xPlayer.Functions.AddItem('goldbar', goldAmount)
	TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['goldbar'], "add")
	TriggerEvent("qb-log:server:CreateLog", "robbery", "Truck ROB", "green", "**"..GetPlayerName(source) .. "** has robbed $"..goldAmount.." goldbars from the truck.")
	end

Wait(2500)
end)