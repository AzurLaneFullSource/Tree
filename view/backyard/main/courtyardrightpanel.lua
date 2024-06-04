local var0 = class("CourtYardRightPanel", import(".CourtYardBasePanel"))

function var0.GetUIName(arg0)
	return "main/rightPanel"
end

function var0.init(arg0)
	arg0.buffBtn = arg0._tf:Find("buff")
	arg0.oneKeyBtn = arg0._tf:Find("onekey")
	arg0.buffPage = CourtYardBuffPage.New(arg0._tf.parent.parent, arg0.parent)
end

function var0.GenBuffData(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(BuffHelper.GetBackYardPlayerBuffs()) do
		if iter1:isActivate() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.OnRegister(arg0)
	onButton(arg0, arg0.buffBtn, function()
		local var0 = arg0.buffList or arg0:GenBuffData()

		if #var0 > 0 then
			arg0.buffPage:ExecuteAction("Show", var0)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.oneKeyBtn, function()
		arg0:emit(CourtYardMediator.ONE_KEY)
	end, SFX_PANEL)
end

function var0.OnVisitRegister(arg0)
	setActive(arg0._tf, false)
end

function var0.OnFlush(arg0, arg1)
	arg1 = arg1 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_LEVEL, BackYardConst.DORM_UPDATE_TYPE_USEFOOD, BackYardConst.DORM_UPDATE_TYPE_SHIP)

	local var0 = arg0.dorm

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_USEFOOD) > 0 and arg0:IsInner() then
		arg0.buffList = arg0:GenBuffData()

		setActive(arg0.buffBtn, #arg0.buffList > 0)
	end

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_SHIP) > 0 then
		setActive(arg0.oneKeyBtn, var0:AnyShipExistIntimacyOrMoney())
	end
end

function var0.GetMoveX(arg0)
	return {
		{
			arg0._tf,
			1
		}
	}
end

function var0.OnDispose(arg0)
	if arg0.buffPage then
		arg0.buffPage:Destroy()

		arg0.buffPage = nil
	end
end

return var0
