local var0_0 = class("AtelierCompositeConfirmView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	setActive(arg0_1._go, false)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_3)
	return
end

function var0_0.SetContextData(arg0_4, arg1_4)
	arg0_4.contextData = arg1_4
end

function var0_0.SetActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6:findTF("BG"), function()
		arg0_6:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6:findTF("Window/Cancel"), function()
		arg0_6:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
end

local var1_0 = 41
local var2_0 = 5

function var0_0.ShowCompositeConfirmWindow(arg0_9, arg1_9)
	setActive(arg0_9._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)

	local var0_9 = 1
	local var1_9 = {}
	local var2_9 = {}

	_.each(arg1_9, function(arg0_10)
		local var0_10 = arg0_10.Instance:GetConfigID()

		table.insert(var1_9, {
			key = arg0_10.Data:GetConfigID(),
			value = var0_10
		})

		var2_9[var0_10] = (var2_9[var0_10] or 0) + 1
	end)
	onButton(arg0_9, arg0_9:findTF("Window/Confirm"), function()
		arg0_9._parentClass:emit(GAME.COMPOSITE_ATELIER_RECIPE, var1_9, var0_9)
		arg0_9._parentClass:PlaySoundEffect(arg0_9._parentClass.soundStr.compositeConfirm)
	end, SFX_PANEL)

	local var3_9 = arg0_9.activity:GetFormulas()[arg0_9.contextData.formulaId]
	local var4_9 = var3_9:GetMaxLimit() ~= 1
	local var5_9 = var3_9:GetMaxLimit() > 0 and var3_9:GetMaxLimit() - var3_9:GetUsedCount() or 10000
	local var6_9 = arg0_9.activity:GetItems()

	for iter0_9, iter1_9 in pairs(var2_9) do
		local var7_9 = var6_9[iter0_9] and var6_9[iter0_9].count or 0

		var5_9 = math.min(var5_9, math.floor(var7_9 / iter1_9))
	end

	local var8_9 = var5_9
	local var9_9 = {
		1,
		var4_9 and var8_9 or 1
	}
	local var10_9 = Drop.New({
		type = var3_9:GetProduction()[1],
		id = var3_9:GetProduction()[2]
	})

	arg0_9._parentClass:UpdateRyzaDrop(arg0_9:findTF("Window/Icon"), var10_9)

	local var11_9 = arg0_9:findTF("Window/Counters")
	local var12_9 = var10_9:getConfig("name")

	setActive(var11_9, var4_9)

	if var4_9 then
		setAnchoredPosition(arg0_9:findTF("Window/Icon"), {
			y = var1_0
		})

		local function var13_9()
			setText(arg0_9:findTF("Number", var11_9), var0_9)
			setText(arg0_9:findTF("Window/Text"), i18n("ryza_composite_confirm", var12_9, var0_9))
		end

		var13_9()
		onButton(arg0_9, arg0_9:findTF("Plus", var11_9), function()
			local var0_13 = var0_9

			var0_9 = var0_9 + 1
			var0_9 = math.clamp(var0_9, var9_9[1], var9_9[2])

			if var0_13 == var0_9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_9()
		end)
		onButton(arg0_9, arg0_9:findTF("Minus", var11_9), function()
			var0_9 = var0_9 - 1
			var0_9 = math.clamp(var0_9, var9_9[1], var9_9[2])

			var13_9()
		end)
		onButton(arg0_9, arg0_9:findTF("Plus10", var11_9), function()
			local var0_15 = var0_9

			var0_9 = var0_9 + 10
			var0_9 = math.clamp(var0_9, var9_9[1], var9_9[2])

			if var0_15 == var0_9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_9()
		end)
		onButton(arg0_9, arg0_9:findTF("Minus10", var11_9), function()
			var0_9 = var0_9 - 10
			var0_9 = math.clamp(var0_9, var9_9[1], var9_9[2])

			var13_9()
		end)
	else
		setAnchoredPosition(arg0_9:findTF("Window/Icon"), {
			y = var2_0
		})
		setText(arg0_9:findTF("Window/Text"), i18n("ryza_composite_confirm_single", var12_9, var0_9))
	end
end

function var0_0.HideCompositeConfirmWindow(arg0_17)
	if not isActive(arg0_17._go) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf, arg0_17._parentClass._tf)
	setActive(arg0_17._go, false)

	return true
end

function var0_0.willExit(arg0_18)
	arg0_18:detach()
end

return var0_0
