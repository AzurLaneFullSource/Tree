ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = class("BattleAirStrikeIconView")

var0.Battle.BattleAirStrikeIconView = var2
var2.__name = "BattleAirStrikeIconView"
var2.DEFAULT_ICON_NAME = "99shijianbao"

function var2.Ctor(arg0, arg1)
	arg0._iconList = {}

	arg0:ConfigIconSkin(arg1)
end

function var2.ConfigIconSkin(arg0, arg1)
	arg0._iconTpl = arg1
	arg0._iconContainer = arg1.parent
end

function var2.AppendIcon(arg0, arg1, arg2)
	local var0 = cloneTplTo(arg0._iconTpl, arg0._iconContainer).gameObject
	local var1 = var0.transform:Find("FighterIcon")

	var0:SetActive(true)
	arg0:setIconNumber(var1, arg2.totalNumber)

	local var2 = var1.GetAircraftTmpDataFromID(arg2.templateID).icon or var2.DEFAULT_ICON_NAME
	local var3 = var0.Battle.BattleResourceManager.GetInstance():GetAircraftIcon(var2)

	setImageSprite(var1, var3)

	arg0._iconList[arg1] = var0
end

function var2.RemoveIcon(arg0, arg1, arg2)
	local var0 = arg0._iconList[arg1]

	if not var0 then
		return
	end

	if arg2.totalNumber <= 0 then
		Object.Destroy(var0)

		arg0._iconList[arg1] = nil
	else
		arg0:setIconNumber(var0.transform:Find("FighterIcon"), arg2.totalNumber)
	end
end

function var2.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._iconList) do
		Object.Destroy(iter1)
	end

	arg0._iconList = nil
end

function var2.setIconNumber(arg0, arg1, arg2)
	arg1.transform:Find("FighterNum"):GetComponent(typeof(Text)).text = "X" .. arg2
end
