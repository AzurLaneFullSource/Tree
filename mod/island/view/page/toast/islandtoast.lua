local var0_0 = class("IslandToast", import("view.base.BaseSubView"))

var0_0.TYPE_COMMON = 1
var0_0.TYPE_STATE = 2

function var0_0.getUIName(arg0_1)
	return "IslandToastUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.container = arg0_2._tf:Find("content")
	arg0_2.tpl = arg0_2._tf:Find("new")
	arg0_2.hideTime = 3
end

function var0_0.OnInit(arg0_3)
	arg0_3.tasks = {}
	arg0_3.pools = {}
end

function var0_0.Show(arg0_4, arg1_4)
	var0_0.super.Show(arg0_4)
	table.insert(arg0_4.tasks, arg1_4)
	arg0_4:SetUp()
end

function var0_0.SetUp(arg0_5)
	if #arg0_5.tasks == 1 then
		arg0_5:NextOne()
	end
end

function var0_0.NewTpl(arg0_6)
	local var0_6

	if #arg0_6.pools == 0 then
		var0_6 = cloneTplTo(arg0_6.tpl, arg0_6.container)
	else
		var0_6 = table.remove(arg0_6.pools, #arg0_6.pools)

		setParent(var0_6, arg0_6.container)
	end

	setActive(var0_6, true)

	return var0_6
end

function var0_0.ReturnTpl(arg0_7, arg1_7)
	setActive(arg1_7, false)
	table.insert(arg0_7.pools, arg1_7)
end

function var0_0.NextOne(arg0_8)
	if #arg0_8.tasks <= 0 then
		arg0_8:Hide()

		return
	end

	local var0_8 = arg0_8.tasks[1]
	local var1_8 = arg0_8:NewTpl()

	setActive(var1_8, true)
	setText(var1_8:Find("Text"), var0_8.content)

	local var2_8 = var0_8.type or var0_0.TYPE_COMMON

	var1_8:Find("icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandUI_atlas", "notice_icon_" .. var2_8)

	arg0_8:AddTimer(var1_8)
end

function var0_0.AddTimer(arg0_9, arg1_9)
	arg0_9.timer = Timer.New(function()
		arg0_9.timer:Stop()
		arg0_9:ReturnTpl(arg1_9)
		table.remove(arg0_9.tasks, 1)
		arg0_9:NextOne()
	end, arg0_9.hideTime, 1)

	arg0_9.timer:Start()
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

return var0_0
