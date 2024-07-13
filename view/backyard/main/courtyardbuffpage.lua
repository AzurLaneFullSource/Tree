local var0_0 = class("CourtYardBuffPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CourtYardBuffListPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/list/content"), arg0_2:findTF("frame/list/content/tpl"))
	arg0_2.totalExp = arg0_2:findTF("frame/subtitle/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/title"), i18n("courtyard_label_exp_addition"))
	setText(arg0_2:findTF("frame/subtitle"), i18n("courtyard_label_total_exp_addition"))

	arg0_2.timers = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)
	arg0_6:Flush(arg1_6)

	arg0_6.list = arg1_6
end

function var0_0.Flush(arg0_7, arg1_7)
	local var0_7 = 0
	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		if iter1_7:getLeftTime() > 0 then
			table.insert(var1_7, iter1_7)
		end
	end

	arg0_7.uiItemList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var1_7[arg1_8 + 1]
			local var1_8 = {
				count = 0,
				type = DROP_TYPE_BUFF,
				id = var0_8.id
			}

			updateDrop(arg2_8:Find("award"), var1_8)
			setText(arg2_8:Find("Text"), var0_8:getConfig("desc"))
			arg0_7:AddTimer(arg2_8:Find("time"), var0_8)

			local var2_8 = var0_8:getConfig("benefit_effect")

			var0_7 = var0_7 + tonumber(var2_8)
		end
	end)
	arg0_7.uiItemList:align(#var1_7)

	arg0_7.totalExp.text = var0_7 .. "%"
end

function var0_0.AddTimer(arg0_9, arg1_9, arg2_9)
	arg0_9:RemoveTimer(arg2_9.id)

	local var0_9 = Timer.New(function()
		local var0_10 = arg2_9:getLeftTime()

		if var0_10 > 0 then
			local var1_10 = pg.TimeMgr.GetInstance():DescCDTime(var0_10)
			local var2_10 = var0_10 <= 600 and setColorStr(var1_10, COLOR_RED) or setColorStr(var1_10, "#72bc42")

			setText(arg1_9, var2_10)
		else
			arg0_9:RemoveTimer(arg2_9.id)
			arg0_9:Flush(arg0_9.list)
		end
	end, 1, -1)

	var0_9.func()
	var0_9:Start()

	arg0_9.timers[arg2_9.id] = var0_9
end

function var0_0.RemoveTimer(arg0_11, arg1_11)
	if arg0_11.timers[arg1_11] then
		arg0_11.timers[arg1_11]:Stop()

		arg0_11.timers[arg1_11] = nil
	end
end

function var0_0.RemoveAllTimer(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.timers or {}) do
		iter1_12:Stop()
	end

	arg0_12.timers = {}
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:RemoveAllTimer()
end

return var0_0
