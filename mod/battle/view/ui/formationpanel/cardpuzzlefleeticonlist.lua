ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleConfig
local var3 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleFleetIconList = class("CardPuzzleFleetIconList")

local var4 = var0.Battle.CardPuzzleFleetIconList

var4.__name = "CardPuzzleFleetIconList"

function var4.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var4.SetCardPuzzleComponent(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._info = arg1
	arg0._attrManager = arg0._info:GetAttrManager()
	arg0._buffManager = arg0._info:GetBuffManager()

	arg0._info:RegisterEventListener(arg0, var3.UPDATE_FLEET_ATTR, arg0.onUpdateFleetAttr)
end

function var4.init(arg0)
	arg0._buffIconList = {}
	arg0._attrIconList = {}
	arg0._tf = arg0._go.transform
	arg0._iconTpl = arg0._tf:Find("icon_tpl")
	arg0._iconContainer = arg0._tf:Find("icon_list")
end

function var4.AddBuffIcon(arg0, arg1)
	local var0 = cloneTplTo(arg0._iconTpl, arg0._iconContainer)
	local var1 = var0:Find("count_bg/count_label")
	local var2 = var0:Find("icon")
	local var3 = var0:Find("buff_duration"):GetComponent(typeof(Image))
	local var4 = {
		tf = var0,
		count = var1,
		durationIMG = var3,
		buffID = arg1
	}

	arg0._buffIconList[arg1] = var4

	arg0:updateBuffIcon(var4)
end

function var4.AddAttrIcon(arg0, arg1)
	local var0 = cloneTplTo(arg0._iconTpl, arg0._iconContainer)
	local var1 = var0:Find("count_bg/count_label")
	local var2 = var0:Find("icon")
	local var3 = {
		tf = var0,
		count = var1,
		attr = arg1
	}

	arg0._attrIconList[arg1] = var3

	arg0:updateAttrIcon(var3)
end

function var4.onUpdateFleetAttr(arg0, arg1)
	local var0 = arg1.Data.attrName

	if var2.FleetIconRegisterAttr[var0] then
		local var1 = arg0._attrIconList[var0]

		if var1 then
			arg0:updateAttrIcon(var1)
		else
			arg0:AddAttrIcon(var0)
		end
	end
end

function var4.updateAttrIcon(arg0, arg1)
	local var0 = arg1.count
	local var1 = arg1.attr
	local var2 = arg0._attrManager:GetCurrent(var1)

	setText(var0, var2)
end

function var4.updateBuffIcon(arg0, arg1)
	local var0 = arg1.buffID
	local var1 = arg0._buffManager:GetCardPuzzleBuff(var0)
	local var2 = arg1.count
	local var3 = var1:GetStack()

	setText(var2, var3)

	arg1.durationIMG.fillAmount = var1:GetDurationRate()
end

function var4.Update(arg0)
	local var0 = arg0._buffManager:GetCardPuzzleBuffList()

	for iter0, iter1 in pairs(var0) do
		if var2.FleetIconRegisterBuff[iter0] then
			local var1 = arg0._buffIconList[iter0]

			if var1 == nil then
				arg0:AddBuffIcon(iter0)
			else
				arg0:updateBuffIcon(var1)
			end
		end
	end
end

function var4.Dispose(arg0)
	arg0._buffIconList = nil
	arg0._attrIconList = nil
	arg0._tf = nil
	arg0._iconTpl = nil
	arg0._iconContainer = nil
end
