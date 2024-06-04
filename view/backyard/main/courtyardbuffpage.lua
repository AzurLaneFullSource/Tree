local var0 = class("CourtYardBuffPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CourtYardBuffListPanel"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.uiItemList = UIItemList.New(arg0:findTF("frame/list/content"), arg0:findTF("frame/list/content/tpl"))
	arg0.totalExp = arg0:findTF("frame/subtitle/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/title"), i18n("courtyard_label_exp_addition"))
	setText(arg0:findTF("frame/subtitle"), i18n("courtyard_label_total_exp_addition"))

	arg0.timers = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:Flush(arg1)

	arg0.list = arg1
end

function var0.Flush(arg0, arg1)
	local var0 = 0
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		if iter1:getLeftTime() > 0 then
			table.insert(var1, iter1)
		end
	end

	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1 = {
				count = 0,
				type = DROP_TYPE_BUFF,
				id = var0.id
			}

			updateDrop(arg2:Find("award"), var1)
			setText(arg2:Find("Text"), var0:getConfig("desc"))
			arg0:AddTimer(arg2:Find("time"), var0)

			local var2 = var0:getConfig("benefit_effect")

			var0 = var0 + tonumber(var2)
		end
	end)
	arg0.uiItemList:align(#var1)

	arg0.totalExp.text = var0 .. "%"
end

function var0.AddTimer(arg0, arg1, arg2)
	arg0:RemoveTimer(arg2.id)

	local var0 = Timer.New(function()
		local var0 = arg2:getLeftTime()

		if var0 > 0 then
			local var1 = pg.TimeMgr.GetInstance():DescCDTime(var0)
			local var2 = var0 <= 600 and setColorStr(var1, COLOR_RED) or setColorStr(var1, "#72bc42")

			setText(arg1, var2)
		else
			arg0:RemoveTimer(arg2.id)
			arg0:Flush(arg0.list)
		end
	end, 1, -1)

	var0.func()
	var0:Start()

	arg0.timers[arg2.id] = var0
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.RemoveAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers or {}) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.OnDestroy(arg0)
	arg0:RemoveAllTimer()
end

return var0
