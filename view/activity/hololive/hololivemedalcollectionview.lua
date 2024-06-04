local var0 = class("HololiveMedalCollectionView", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "HololiveMedalCollectionUI"
end

function var0.init(arg0)
	arg0:InitData()
	arg0:FindUI()
	arg0:AddListener()
end

function var0.didEnter(arg0)
	arg0:UpdateView()
end

function var0.InitData(arg0)
	local var0 = getProxy(ActivityProxy)

	arg0.taskProxy = getProxy(TaskProxy)
	arg0.actMedal = var0:getActivityById(ActivityConst.HOLOLIVE_MEDAL_COLLECTION)
	arg0.allIDList = arg0.actMedal:getConfig("config_data")
	arg0.taskGroup = pg.activity_template[ActivityConst.HOLOLIVE_MEDAL_COLLECTION_TASK].config_data
	arg0.activatableIDList = arg0.actMedal.data1_list
	arg0.activeIDList = arg0.actMedal.data2_list
end

local var1 = {
	"mio",
	"fubuki",
	"matsuri",
	"sora",
	"shion",
	"aqua",
	"ayame",
	"purer",
	"tnt"
}
local var2 = {
	1,
	2,
	3,
	6,
	9,
	8,
	7,
	4,
	5
}

function var0.FindUI(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.top = arg0:findTF("top")
	arg0.backBtn = arg0:findTF("back", arg0.top)
	arg0.helpBtn = arg0:findTF("help", arg0.top)
	arg0.progressText = arg0:findTF("middle/board/progress")
	arg0.taskScroll = arg0:findTF("middle/board/Scroll View")
	arg0.taskScrollBar = arg0:findTF("middle/board/Scrollbar")
	arg0.taskListItems = CustomIndexLayer.Clone2Full(arg0.taskScroll:Find("Content"), #arg0.taskGroup)
	arg0.medalListItems = CustomIndexLayer.Clone2Full(arg0:findTF("middle/console/grid"), 9)
	arg0.medalImg = arg0:findTF("middle/console/slot"):GetComponent(typeof(Image))
	arg0.medalGet = arg0:findTF("middle/console/get")
	arg0.medalGot = arg0:findTF("middle/console/got")

	for iter0 = 1, #arg0.taskGroup do
		local var0 = LoadSprite("ui/HololiveMedalCollectionUI_atlas", var1[iter0])
		local var1 = arg0.taskListItems[iter0]:Find("icon"):GetComponent(typeof(Image))

		var1.sprite = var0
		var1.enabled = true

		local var2 = arg0.medalListItems[var2[iter0]]:Find("icon"):GetComponent(typeof(Image))

		var2.sprite = var0
		var2.enabled = true
	end

	arg0.materialGray = LoadAny("ui/HololiveMedalCollectionUI_atlas", "gray.mat")
end

function var0.AddListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_dalaozhang.tip
		})
	end, SFX_PANEL)

	local var0 = arg0:findTF("middle/board/arrow")

	onScroll(arg0, arg0.taskScroll, function(arg0)
		setActive(var0, arg0.y > 0.001)
	end)
	onButton(arg0, arg0.medalGet, function()
		arg0:GetFinal()
	end, SFX_PANEL)
end

function var0.DataSetting(arg0)
	if #arg0.activatableIDList > 0 then
		local var0 = 1
		local var1

		while #arg0.activatableIDList >= 1 do
			local var2 = arg0.activatableIDList[var0]

			if not table.contains(arg0.activeIDList, var2) then
				var1 = var2

				break
			end

			var0 = var0 + 1
		end

		if var1 then
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var1,
				actId = ActivityConst.HOLOLIVE_MEDAL_COLLECTION
			})

			return true
		end
	end
end

function var0.UpdateView(arg0)
	arg0:InitData()

	if arg0:DataSetting() then
		return
	end

	local var0 = #arg0.activeIDList == #arg0.allIDList and arg0.actMedal.data1 ~= 1
	local var1 = arg0.actMedal.data1 == 1
	local var2 = 0

	for iter0 = 1, #arg0.taskGroup do
		local var3 = arg0.taskListItems[iter0]
		local var4 = arg0.taskGroup[iter0]
		local var5 = arg0.taskProxy:getTaskVO(var4)
		local var6 = arg0:findTF("btn_go", var3)
		local var7 = arg0:findTF("btn_get", var3)
		local var8 = arg0:findTF("btn_got", var3)
		local var9 = table.contains(arg0.activeIDList, arg0.allIDList[iter0])
		local var10
		local var11 = 0

		if var5 then
			local var12 = var5:getProgress()
			local var13 = var5:getConfig("target_num")
			local var14 = var5:getConfig("desc")
			local var15 = string.gsub(var14, "$1", var12)
			local var16 = string.gsub(var15, "$2", var13)

			setText(arg0:findTF("desc", var3), var16)

			var11 = var5:getTaskStatus()
			var10 = var11 == 2 and arg0.materialGray or nil

			onButton(arg0, var6, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var5)
			end, SFX_PANEL)
			onButton(arg0, var7, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var5)
			end, SFX_PANEL)
		else
			local var17 = pg.task_data_template[var4].target_num
			local var18 = var9 and var17 or 0
			local var19 = pg.task_data_template[var4].desc
			local var20 = string.gsub(var19, "$1", var18)
			local var21 = string.gsub(var20, "$2", var17)

			setText(arg0:findTF("desc", var3), var21)

			var11 = var9 and 2 or 0
			var10 = arg0.materialGray

			onButton(arg0, var6, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end, SFX_PANEL)
		end

		setActive(var6, var11 == 0)
		setActive(var7, var11 == 1)
		setActive(var8, var11 == 2)

		var3:GetComponent(typeof(Image)).material = var10
		var3:Find("icon"):GetComponent(typeof(Image)).material = var10

		local var22 = arg0.medalListItems[var2[iter0]]:Find("icon"):GetComponent(typeof(Image))

		var22.enabled = var9
		var22.material = var1 and arg0.materialGray or nil
		var2 = var2 + (var11 == 2 and 1 or 0)
	end

	setText(arg0.progressText, var2 .. "/9")

	arg0.medalImg.material = not var0 and not var1 and arg0.materialGray

	setActive(arg0.medalGet, var0)
	setActive(arg0.medalGot, var1)
end

function var0.GetFinal(arg0)
	if #arg0.activeIDList == #arg0.allIDList and arg0.actMedal.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.HOLOLIVE_MEDAL_COLLECTION
		})
	end
end

function var0.PlayStory(arg0, arg1)
	local var0 = arg0.actMedal:getConfig("config_client").story

	if var0 then
		pg.NewStoryMgr.GetInstance():Play(var0, arg1)
	else
		arg1()
	end
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy)
	local var1 = getProxy(TaskProxy)
	local var2 = var0:getActivityById(ActivityConst.HOLOLIVE_MEDAL_COLLECTION)

	if var2 and not var2:isEnd() then
		local var3 = var2:getConfig("config_data")
		local var4 = pg.activity_template[ActivityConst.HOLOLIVE_MEDAL_COLLECTION_TASK].config_data
		local var5 = var2.data1_list
		local var6 = var2.data2_list

		for iter0, iter1 in ipairs(var4) do
			local var7 = var4[iter0]
			local var8 = var1:getTaskVO(var7)

			if var8 and var8:getTaskStatus() == 1 then
				return true
			end
		end

		for iter2, iter3 in ipairs(var5) do
			if not table.contains(var6, iter3) then
				return true
			end
		end

		if #var6 == #var3 and var2.data1 ~= 1 then
			return true
		end
	end
end

return var0
