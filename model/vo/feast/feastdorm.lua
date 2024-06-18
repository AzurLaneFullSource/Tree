local var0_0 = class("FeastDorm", import("model.vo.NewBackYard.Dorm"))

var0_0.OP_RANDOM_SHIPS = 0
var0_0.OP_ENTER = 1
var0_0.OP_MAKE_TICKET = 2
var0_0.OP_GIVE_TICKET = 3
var0_0.OP_GIVE_GIFT = 4
var0_0.OP_INTERACTION = 5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.refreshTime = arg2_1.refresh_time
	arg0_1.invitedFeastShips = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.special_roles) do
		local var0_1 = InvitedFeastShip.New(iter1_1)

		var0_1:SetInvitationState(iter1_1.state)
		var0_1:SetGiftState(iter1_1.gift)

		arg0_1.invitedFeastShips[iter1_1.tid] = var0_1
	end

	arg0_1.feastShips = {}

	for iter2_1, iter3_1 in ipairs(arg2_1.party_roles) do
		local var1_1 = FeastShip.New(iter3_1)
		local var2_1 = arg0_1.invitedFeastShips[iter3_1.tid]

		if var2_1 then
			var1_1:SetSkinId(var2_1:GetSkinId())
		end

		arg0_1.feastShips[iter3_1.tid] = var1_1
	end
end

function var0_0.GetInvitedFeastShips(arg0_2)
	return arg0_2.invitedFeastShips
end

function var0_0.GetInvitedFeastShipList(arg0_3)
	local var0_3 = arg0_3:GetInvitedFeastShips()
	local var1_3 = {}

	for iter0_3, iter1_3 in pairs(var0_3) do
		table.insert(var1_3, iter1_3)
	end

	table.sort(var1_3, function(arg0_4, arg1_4)
		return arg0_4.configId < arg1_4.configId
	end)

	return var1_3
end

function var0_0.GetInvitedFeastShip(arg0_5, arg1_5)
	return arg0_5.invitedFeastShips[arg1_5]
end

function var0_0.GetFeastShipList(arg0_6)
	return arg0_6.feastShips
end

function var0_0.GetFeastShip(arg0_7, arg1_7)
	return arg0_7.feastShips[arg1_7]
end

function var0_0.RemoveShip(arg0_8, arg1_8)
	arg0_8.feastShips[arg1_8] = nil
end

function var0_0.AddShip(arg0_9, arg1_9)
	arg0_9.feastShips[arg1_9.tid] = arg1_9
end

function var0_0.SetRefreshTime(arg0_10, arg1_10)
	arg0_10.refreshTime = arg1_10
end

function var0_0.ShouldRandomShips(arg0_11)
	local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_11 > arg0_11.refreshTime and pg.TimeMgr.GetInstance():DiffDay(arg0_11.refreshTime, var0_11) > 0
end

function var0_0.GetMapSize(arg0_12)
	local var0_12 = 0
	local var1_12 = 0
	local var2_12 = BackYardConst.MAX_FEAST_MAP_SIZE
	local var3_12 = var2_12.x
	local var4_12 = var2_12.y

	return Vector4(var0_12, var1_12, var3_12, var4_12)
end

function var0_0.GetPutFurnitureList(arg0_13, arg1_13)
	local var0_13 = {}
	local var1_13 = require("GameCfg.backyardTheme.theme_feast")
	local var2_13 = FeastThemeTemplate.New({
		id = -1,
		furniture_put_list = var1_13.furnitures or {}
	}, 1, arg0_13:GetMapSize())
	local var3_13 = var2_13 and var2_13:GetAllFurniture() or {}

	for iter0_13, iter1_13 in pairs(var3_13) do
		table.insert(var0_13, iter1_13)
	end

	table.sort(var0_13, BackyardThemeFurniture._LoadWeight)

	return var0_13
end

function var0_0.GetPutShipList(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.feastShips) do
		table.insert(var0_14, iter1_14)
	end

	return var0_14
end

return var0_0
