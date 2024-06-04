local var0 = class("GuildOfficeLogPage", import("....base.BaseSubView"))
local var1 = {
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

function var0.Flag2Filter(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(var1) do
		local var1 = bit.lshift(1, iter0)

		if bit.band(arg1, var1) > 0 then
			for iter2, iter3 in ipairs(iter1) do
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.getUIName(arg0)
	return "GuildOfficeLogPage"
end

function var0.OnLoaded(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("frame/window/sliders/list/content"), arg0:findTF("frame/window/sliders/list/content/tpl"))

	setText(arg0:findTF("frame/window/top/bg/infomation/title"), i18n("guild_log_title"))

	arg0.btnAll = arg0:findTF("frame/window/sliders/filter/1")
	arg0.btns = {
		arg0:findTF("frame/window/sliders/filter/2"),
		arg0:findTF("frame/window/sliders/filter/3"),
		arg0:findTF("frame/window/sliders/filter/4")
	}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("frame/window/top/btnBack"), function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("frame"), function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.btnAll, function()
		arg0:SelectAll()
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.btns) do
		onButton(arg0, iter1, function()
			if arg0.allFlags ~= arg0.flags and bit.band(arg0.flags, bit.lshift(1, iter0)) > 0 then
				arg0:UnSelectFlag(iter0, iter1)
			else
				arg0:SelectFlag(iter0, iter1)
			end
		end, SFX_PANEL)
	end
end

function var0.SelectAll(arg0)
	arg0.flags = 0

	for iter0, iter1 in pairs(arg0.btns) do
		setActive(iter1:Find("sel"), false)

		arg0.flags = bit.bor(arg0.flags, bit.lshift(1, iter0))
	end

	setActive(arg0.btnAll:Find("sel"), true)
	arg0:Filter()
end

function var0.UnSelectFlag(arg0, arg1, arg2)
	setActive(arg2:Find("sel"), false)

	local var0 = bit.bxor(arg0.flags, bit.lshift(1, arg1))

	if var0 == 0 then
		arg0:SelectAll()
	else
		arg0.flags = var0

		arg0:Filter()
	end
end

function var0.SelectFlag(arg0, arg1, arg2)
	local var0 = arg0.flags

	local function var1()
		setActive(arg2:Find("sel"), true)
		setActive(arg0.btnAll:Find("sel"), false)

		arg0.flags = bit.bor(arg0.flags, bit.lshift(1, arg1))

		arg0:Filter()
	end

	if var0 ~= arg0.allFlags and arg0.allFlags == bit.bor(arg0.flags, bit.lshift(1, arg1)) then
		arg0:SelectAll()
	elseif var0 == arg0.allFlags then
		arg0.flags = 0

		var1()
	else
		var1()
	end
end

function var0.Show(arg0, arg1)
	arg0.guild = arg1

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
	triggerButton(arg0.btnAll)

	arg0.allFlags = arg0.flags
end

function var0.Filter(arg0)
	local var0 = arg0.guild:getCapitalLogs()

	arg0.displays = {}

	local var1 = arg0:Flag2Filter(arg0.flags)

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsSameType(var1) then
			table.insert(arg0.displays, iter1)
		end
	end

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displays[arg1 + 1]

			setText(arg2, var0:getText())
		end
	end)
	arg0.uilist:align(#arg0.displays)
end

function var0.Close(arg0)
	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0:Close()
end

return var0
