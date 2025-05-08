local var0_0 = class("IslandVisitorAgency", import(".IslandBaseAgency"))

var0_0.PLAYER_ADD = "IslandVisitorAgency:PLAYER_ADD"
var0_0.PLAYER_EXIT = "IslandVisitorAgency:PLAYER_EXIT"
var0_0.CHANGE_PLAYER_DRESS = "IslandVisitorAgency:CHANGE_DRESS"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.playerList = {}
end

function var0_0.SetPlayerList(arg0_2, arg1_2)
	arg0_2.playerList = arg1_2
end

function var0_0.GetPlayerList(arg0_3)
	return arg0_3.playerList
end

function var0_0.DeletePlayer(arg0_4, arg1_4)
	arg0_4.playerList[arg1_4] = nil

	arg0_4:DispatchEvent(var0_0.PLAYER_EXIT, {
		id = arg1_4
	})
end

function var0_0.AddPlayer(arg0_5, arg1_5)
	arg0_5.playerList[arg1_5.id] = arg1_5

	arg0_5:DispatchEvent(var0_0.PLAYER_ADD, {
		player = arg1_5
	})
end

function var0_0.ChangeDress(arg0_6, arg1_6)
	arg0_6:ChangePlayerDressData(arg1_6)
	arg0_6:DispatchEvent(var0_0.CHANGE_PLAYER_DRESS, arg1_6)
end

function var0_0.ChangePlayerDressData(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs(arg0_7.playerList) do
		if iter1_7:IsSelf() then
			for iter2_7, iter3_7 in pairs(arg1_7) do
				iter1_7:ChangeDressUpByType(iter2_7, iter3_7.currentItemId)
			end
		end
	end
end

function var0_0.GetPlayerDressData(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.playerList) do
		if iter1_8:IsSelf() then
			return iter1_8:GetDressupData()
		end
	end

	return {}
end

return var0_0
