local var0 = class("FeastDorm", import("model.vo.NewBackYard.Dorm"))

var0.OP_RANDOM_SHIPS = 0
var0.OP_ENTER = 1
var0.OP_MAKE_TICKET = 2
var0.OP_GIVE_TICKET = 3
var0.OP_GIVE_GIFT = 4
var0.OP_INTERACTION = 5

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.refreshTime = arg2.refresh_time
	arg0.invitedFeastShips = {}

	for iter0, iter1 in ipairs(arg2.special_roles) do
		local var0 = InvitedFeastShip.New(iter1)

		var0:SetInvitationState(iter1.state)
		var0:SetGiftState(iter1.gift)

		arg0.invitedFeastShips[iter1.tid] = var0
	end

	arg0.feastShips = {}

	for iter2, iter3 in ipairs(arg2.party_roles) do
		local var1 = FeastShip.New(iter3)
		local var2 = arg0.invitedFeastShips[iter3.tid]

		if var2 then
			var1:SetSkinId(var2:GetSkinId())
		end

		arg0.feastShips[iter3.tid] = var1
	end
end

function var0.GetInvitedFeastShips(arg0)
	return arg0.invitedFeastShips
end

function var0.GetInvitedFeastShipList(arg0)
	local var0 = arg0:GetInvitedFeastShips()
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var1, iter1)
	end

	table.sort(var1, function(arg0, arg1)
		return arg0.configId < arg1.configId
	end)

	return var1
end

function var0.GetInvitedFeastShip(arg0, arg1)
	return arg0.invitedFeastShips[arg1]
end

function var0.GetFeastShipList(arg0)
	return arg0.feastShips
end

function var0.GetFeastShip(arg0, arg1)
	return arg0.feastShips[arg1]
end

function var0.RemoveShip(arg0, arg1)
	arg0.feastShips[arg1] = nil
end

function var0.AddShip(arg0, arg1)
	arg0.feastShips[arg1.tid] = arg1
end

function var0.SetRefreshTime(arg0, arg1)
	arg0.refreshTime = arg1
end

function var0.ShouldRandomShips(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0 > arg0.refreshTime and pg.TimeMgr.GetInstance():DiffDay(arg0.refreshTime, var0) > 0
end

function var0.GetMapSize(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = BackYardConst.MAX_FEAST_MAP_SIZE
	local var3 = var2.x
	local var4 = var2.y

	return Vector4(var0, var1, var3, var4)
end

function var0.GetPutFurnitureList(arg0, arg1)
	local var0 = {}
	local var1 = require("GameCfg.backyardTheme.theme_feast")
	local var2 = FeastThemeTemplate.New({
		id = -1,
		furniture_put_list = var1.furnitures or {}
	}, 1, arg0:GetMapSize())
	local var3 = var2 and var2:GetAllFurniture() or {}

	for iter0, iter1 in pairs(var3) do
		table.insert(var0, iter1)
	end

	table.sort(var0, BackyardThemeFurniture._LoadWeight)

	return var0
end

function var0.GetPutShipList(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.feastShips) do
		table.insert(var0, iter1)
	end

	return var0
end

return var0
