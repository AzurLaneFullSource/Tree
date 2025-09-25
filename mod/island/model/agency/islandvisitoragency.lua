local var0_0 = class("IslandVisitorAgency", import(".IslandBaseAgency"))

var0_0.PLAYER_ADD = "IslandVisitorAgency:PLAYER_ADD"
var0_0.PLAYER_EXIT = "IslandVisitorAgency:PLAYER_EXIT"
var0_0.CHANGE_PLAYER_DRESS = "IslandVisitorAgency:CHANGE_DRESS"
var0_0.VISITOR_ADD = "IslandVisitorAgency:VISITOR_ADD"
var0_0.VISITOR_EXIT = "IslandVisitorAgency:VISITOR_EXIT"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.playerList = {}
end

function var0_0.SetPlayerList(arg0_2, arg1_2)
	arg0_2.playerList = arg1_2
end

function var0_0.GetPlayerList(arg0_3)
	return arg0_3.playerList
end

function var0_0.GetPlayer(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.playerList) do
		if iter1_4:IsSelf() then
			return iter1_4
		end
	end

	return nil
end

function var0_0.DeletePlayer(arg0_5, arg1_5)
	arg0_5.playerList[arg1_5] = nil

	arg0_5:DispatchEvent(var0_0.PLAYER_EXIT, {
		id = arg1_5
	})
end

function var0_0.AddPlayer(arg0_6, arg1_6)
	arg0_6.playerList[arg1_6.id] = arg1_6

	arg0_6:DispatchEvent(var0_0.PLAYER_ADD, {
		player = arg1_6
	})
end

function var0_0.GetPlayer(arg0_7, arg1_7)
	return arg0_7.playerList[arg1_7]
end

function var0_0.InitMapVisitorList(arg0_8, arg1_8)
	arg0_8.mapVisitorList = {}

	for iter0_8, iter1_8 in pairs(arg0_8.playerList) do
		if iter1_8:IsInMap(arg1_8) or iter1_8:IsSelf() then
			arg0_8.mapVisitorList[iter1_8.id] = iter1_8
		end
	end
end

function var0_0.SetMapVisitorList(arg0_9, arg1_9)
	arg0_9.mapVisitorList = arg1_9
end

function var0_0.GetMapVisitorList(arg0_10)
	return arg0_10.mapVisitorList
end

function var0_0.AddMapVisitor(arg0_11, arg1_11)
	arg0_11.mapVisitorList[arg1_11.id] = arg1_11

	arg0_11:DispatchEvent(var0_0.VISITOR_ADD, {
		player = arg1_11
	})
end

function var0_0.DeleteMapVisitor(arg0_12, arg1_12)
	arg0_12.mapVisitorList[arg1_12] = nil

	arg0_12:DispatchEvent(var0_0.VISITOR_EXIT, {
		id = arg1_12
	})
end

function var0_0.ChangeDress(arg0_13, arg1_13)
	arg0_13:ChangePlayerDressData(arg1_13)
	arg0_13:DispatchEvent(var0_0.CHANGE_PLAYER_DRESS, arg1_13)
end

function var0_0.ChangePlayerDressData(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(arg0_14.playerList) do
		if iter1_14:IsSelf() then
			for iter2_14, iter3_14 in pairs(arg1_14) do
				iter1_14:ChangeDressUpByType(iter2_14, iter3_14.currentItemId)
			end
		end
	end
end

function var0_0.GetPlayerDressData(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.playerList) do
		if iter1_15:IsSelf() then
			return iter1_15:GetDressupData()
		end
	end

	return {}
end

function var0_0.GetVisitorCnt(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in pairs(arg0_16.playerList) do
		if not iter1_16:IsSelf() then
			var0_16 = var0_16 + 1
		end
	end

	return var0_16
end

return var0_0
