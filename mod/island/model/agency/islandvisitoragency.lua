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

function var0_0.GetPlayer(arg0_6, arg1_6)
	return arg0_6.playerList[arg1_6]
end

function var0_0.InitMapVisitorList(arg0_7, arg1_7)
	arg0_7.mapVisitorList = {}

	for iter0_7, iter1_7 in pairs(arg0_7.playerList) do
		if iter1_7:IsInMap(arg1_7) or iter1_7:IsSelf() then
			arg0_7.mapVisitorList[iter1_7.id] = iter1_7
		end
	end
end

function var0_0.SetMapVisitorList(arg0_8, arg1_8)
	arg0_8.mapVisitorList = arg1_8
end

function var0_0.GetMapVisitorList(arg0_9)
	return arg0_9.mapVisitorList
end

function var0_0.AddMapVisitor(arg0_10, arg1_10)
	arg0_10.mapVisitorList[arg1_10.id] = arg1_10

	arg0_10:DispatchEvent(var0_0.VISITOR_ADD, {
		player = arg1_10
	})
end

function var0_0.DeleteMapVisitor(arg0_11, arg1_11)
	arg0_11.mapVisitorList[arg1_11] = nil

	arg0_11:DispatchEvent(var0_0.VISITOR_EXIT, {
		id = arg1_11
	})
end

function var0_0.ChangeDress(arg0_12, arg1_12)
	arg0_12:ChangePlayerDressData(arg1_12)
	arg0_12:DispatchEvent(var0_0.CHANGE_PLAYER_DRESS, arg1_12)
end

function var0_0.ChangePlayerDressData(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.playerList) do
		if iter1_13:IsSelf() then
			for iter2_13, iter3_13 in pairs(arg1_13) do
				iter1_13:ChangeDressUpByType(iter2_13, iter3_13.currentItemId)
			end
		end
	end
end

function var0_0.GetPlayerDressData(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.playerList) do
		if iter1_14:IsSelf() then
			return iter1_14:GetDressupData()
		end
	end

	return {}
end

function var0_0.GetVisitorCnt(arg0_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in pairs(arg0_15.playerList) do
		if not iter1_15:IsSelf() then
			var0_15 = var0_15 + 1
		end
	end

	return var0_15
end

return var0_0
