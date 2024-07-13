local var0_0 = class("GuildOfficeLogPage", import("....base.BaseSubView"))
local var1_0 = {
	{
		GuildConst.TYPE_SUPPLY,
		GuildConst.START_BATTLE,
		GuildConst.TECHNOLOGY
	},
	{
		GuildConst.TYPE_DONATE,
		GuildConst.WEEKLY_TASK
	},
	{
		GuildConst.TECHNOLOGY_OVER,
		GuildConst.SWITCH_TOGGLE
	}
}

function var0_0.Flag2Filter(arg0_1, arg1_1)
	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_0) do
		local var1_1 = bit.lshift(1, iter0_1)

		if bit.band(arg1_1, var1_1) > 0 then
			for iter2_1, iter3_1 in ipairs(iter1_1) do
				table.insert(var0_1, iter3_1)
			end
		end
	end

	return var0_1
end

function var0_0.getUIName(arg0_2)
	return "GuildOfficeLogPage"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.uilist = UIItemList.New(arg0_3:findTF("frame/window/sliders/list/content"), arg0_3:findTF("frame/window/sliders/list/content/tpl"))

	setText(arg0_3:findTF("frame/window/top/bg/infomation/title"), i18n("guild_log_title"))

	arg0_3.btnAll = arg0_3:findTF("frame/window/sliders/filter/1")
	arg0_3.btns = {
		arg0_3:findTF("frame/window/sliders/filter/2"),
		arg0_3:findTF("frame/window/sliders/filter/3"),
		arg0_3:findTF("frame/window/sliders/filter/4")
	}
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("frame/window/top/btnBack"), function()
		arg0_4:Close()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("frame"), function()
		arg0_4:Close()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnAll, function()
		arg0_4:SelectAll()
	end, SFX_PANEL)

	for iter0_4, iter1_4 in ipairs(arg0_4.btns) do
		onButton(arg0_4, iter1_4, function()
			if arg0_4.allFlags ~= arg0_4.flags and bit.band(arg0_4.flags, bit.lshift(1, iter0_4)) > 0 then
				arg0_4:UnSelectFlag(iter0_4, iter1_4)
			else
				arg0_4:SelectFlag(iter0_4, iter1_4)
			end
		end, SFX_PANEL)
	end
end

function var0_0.SelectAll(arg0_9)
	arg0_9.flags = 0

	for iter0_9, iter1_9 in pairs(arg0_9.btns) do
		setActive(iter1_9:Find("sel"), false)

		arg0_9.flags = bit.bor(arg0_9.flags, bit.lshift(1, iter0_9))
	end

	setActive(arg0_9.btnAll:Find("sel"), true)
	arg0_9:Filter()
end

function var0_0.UnSelectFlag(arg0_10, arg1_10, arg2_10)
	setActive(arg2_10:Find("sel"), false)

	local var0_10 = bit.bxor(arg0_10.flags, bit.lshift(1, arg1_10))

	if var0_10 == 0 then
		arg0_10:SelectAll()
	else
		arg0_10.flags = var0_10

		arg0_10:Filter()
	end
end

function var0_0.SelectFlag(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.flags

	local function var1_11()
		setActive(arg2_11:Find("sel"), true)
		setActive(arg0_11.btnAll:Find("sel"), false)

		arg0_11.flags = bit.bor(arg0_11.flags, bit.lshift(1, arg1_11))

		arg0_11:Filter()
	end

	if var0_11 ~= arg0_11.allFlags and arg0_11.allFlags == bit.bor(arg0_11.flags, bit.lshift(1, arg1_11)) then
		arg0_11:SelectAll()
	elseif var0_11 == arg0_11.allFlags then
		arg0_11.flags = 0

		var1_11()
	else
		var1_11()
	end
end

function var0_0.Show(arg0_13, arg1_13)
	arg0_13.guild = arg1_13

	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
	setActive(arg0_13._tf, true)
	triggerButton(arg0_13.btnAll)

	arg0_13.allFlags = arg0_13.flags
end

function var0_0.Filter(arg0_14)
	local var0_14 = arg0_14.guild:getCapitalLogs()

	arg0_14.displays = {}

	local var1_14 = arg0_14:Flag2Filter(arg0_14.flags)

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if iter1_14:IsSameType(var1_14) then
			table.insert(arg0_14.displays, iter1_14)
		end
	end

	arg0_14.uilist:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_14.displays[arg1_15 + 1]

			setText(arg2_15, var0_15:getText())
		end
	end)
	arg0_14.uilist:align(#arg0_14.displays)
end

function var0_0.Close(arg0_16)
	setActive(arg0_16._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, arg0_16._parentTf)
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:Close()
end

return var0_0
